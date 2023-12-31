import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grad/modules/home/provider/home_states.dart';
import 'package:grad/shared/models/trip_model.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/src/geojson.dart' as p;

final homeProvider = StateNotifierProvider<HomeProvider, HomeStates>(
  (ref) => HomeProvider(),
);

class HomeProvider extends StateNotifier<HomeStates> {
  HomeProvider() : super(HomeInitialState());

  late MapboxMap mapController;
  final database = FirebaseDatabase.instance.ref();
  final fireStore = FirebaseFirestore.instance;
  TripModel? tripModel;
  Timer? timer;
  Duration timeCounter = const Duration();
  void onMapCreated(MapboxMap controller) {
    mapController = controller;
    mapController.location
        .updateSettings(LocationComponentSettings(enabled: true));
    goToCurrentLocation();
  }

  Future<void> goToCurrentLocation() async {
    final location = await Geolocator.getCurrentPosition();
    mapController.flyTo(
        CameraOptions(
            center: Point(
                    coordinates:
                        p.Position(location.longitude, location.latitude))
                .toJson(),
            zoom: 15),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  }

  void onMapLoaded() async {
    final res = await database.onValue.first;
    final data = res.snapshot.value as Map;
    mapController.annotations
        .createPointAnnotationManager()
        .then((value) async {
      final pointAnnotationManager = value;

      var options = <PointAnnotationOptions>[];
      final ByteData bytes = await rootBundle.load('assets/bike_logo.png');
      final Uint8List list = bytes.buffer.asUint8List();
      for (var item in data.entries) {
        if (item.value['LOCKED'] == true) {
          options.add(PointAnnotationOptions(
              geometry: Point(
                      coordinates:
                          p.Position(item.value['LNG'], item.value['LAT']))
                  .toJson(),
              image: list,
              iconSize: 0.5));
        }
      }

      pointAnnotationManager.createMulti(options);
    });
    await checkStartedTrip();
  }

  Future<void> startTrip(String bikeId) async {
    final model = TripModel(
      bikeId: bikeId,
      userId: FirebaseAuth.instance.currentUser!.uid,
      startLocation: 'Cairo',
      startDateTime: DateTime.now(),
      endDateTime: null,
      status: TripStatus.started,
      price: null,
    );
    final res = fireStore.collection('trips').doc();
    await res.set(model.toJson());
    final addedTrip = await fireStore.collection('trips').doc(res.id).get();
    print('addedTrip: ${addedTrip.data()}');
    tripModel = TripModel.fromJson(addedTrip.data() ?? {});
    tripModel?.id = res.id;
    timeCounter = DateTime.now().difference(tripModel!.startDateTime);
    startTimer();
    state = TripStartedState();
  }

  Future<void> checkStartedTrip() async {
    final res = await fireStore
        .collection('trips')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: 'started')
        .get();
    if (res.docs.isNotEmpty) {
      print('trip ${res.docs.first.data()}');
      tripModel = TripModel.fromJson(res.docs.first.data());
      tripModel?.id = res.docs.first.id;
      timeCounter = DateTime.now().difference(tripModel!.startDateTime);
      startTimer();
      state = TripStartedState();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeCounter += const Duration(seconds: 1);
      state = TripStartedState();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  Future<void> uploadImage(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final reference = storage.ref().child("${tripModel!.id!}.jpg");
    await reference.putFile(file);
    final downloadUrl = await reference.getDownloadURL();
    await fireStore
        .collection('trips')
        .doc(tripModel!.id)
        .update({'image': downloadUrl});
    await endTrip();
  }

  Future<void> endTrip() async {
    stopTimer();
    final price = timeCounter.inMinutes * 2;
    await fireStore.collection('trips').doc(tripModel!.id).update(
        {'status': 'ended', 'endDateTime': DateTime.now(), 'price': price});

    tripModel!.endDateTime = DateTime.now();
    tripModel!.price = price.toDouble();
    final newModel = tripModel!;
    tripModel = null;
    await fireStore.collection('users').doc(newModel.userId).update({
      'balance': FieldValue.increment(-newModel.price!),
    });

    state = TripEndedState(newModel);
  }

  Future<double> getUserBalance() {
    return fireStore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.data()!['balance'] as double);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
