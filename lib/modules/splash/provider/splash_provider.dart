import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grad/modules/splash/provider/splash_states.dart';

final splashProvider = StateNotifierProvider<SplashProvider, SplashStates>(
  (ref) => SplashProvider(),
);

class SplashProvider extends StateNotifier<SplashStates> {
  SplashProvider() : super(SplashInitialState()) {
    init();
  }

  Future<void> init() async {
    state = SplashLoadingState();
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      state = NeedLocationPermissionState();
    } else {
      checkAuthenticated();
    }
  }

  Future<void> checkAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = SplashUnAuthenticatedState();
    } else {
      state = SplashAuthenticatedState();
    }
  }

  Future<void> checkLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      state = LocationPermissionDeniedState();
    } else if (permission == LocationPermission.deniedForever) {
      state = LocationPermissionDeniedForeverState();
    } else {
      state = LocationPermissionApprovedState();
      checkAuthenticated();
    }
  }
}
