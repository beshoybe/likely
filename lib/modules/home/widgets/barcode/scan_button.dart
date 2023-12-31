import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad/modules/home/provider/home_provider.dart';
import 'package:grad/modules/home/widgets/trip_header.dart';
import 'package:grad/shared/extensions.dart';
import 'package:grad/shared/strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanBarCodeButton extends ConsumerWidget {
  const ScanBarCodeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeProvider.notifier);
    ref.watch(homeProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (provider.tripModel != null) const TripHeader(),
        Container(
          padding: EdgeInsets.only(
              bottom: context.radius(1),
              right: context.radius(1),
              left: context.radius(1)),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radius(0.5)),
              ),
            ),
            onPressed: () async {
              if (provider.tripModel != null) {
                final image = await pickImage();
                if (image != null) {
                  await provider.uploadImage(image);
                }
                return;
              }
              final res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));

              if (!context.mounted) {
                return;
              }
              if (!res.toString().contains('bikeId')) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invalid QR Code'),
                ));
                return;
              }
              final r =
                  await unlockBike(res.toString().split(':').last, context);
              if (!context.mounted) {
                return;
              }
              if (r == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invalid QR Code'),
                ));
              } else if (r) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Bike unlocked'),
                ));
                ref
                    .read(homeProvider.notifier)
                    .startTrip(res.toString().split(':').last);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Bike is already unlocked'),
                ));
              }
            },
            child: Text(provider.tripModel != null
                ? 'End Ride'
                : AppStrings.scanBarcodeText),
          ),
        ),
      ],
    );
  }

  Future<bool?> unlockBike(String bikeId, BuildContext context) async {
    final data = await FirebaseDatabase.instance.ref('/$bikeId').get();

    final first = data.value as Map?;
    if (first == null) {
      return null;
    }
    if (first['LOCKED'] == true) {
      FirebaseDatabase.instance.ref('/$bikeId').update({'LOCKED': false});
      return true;
    } else {
      return false;
    }
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}
