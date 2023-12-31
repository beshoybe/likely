import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grad/modules/splash/provider/splash_provider.dart';
import 'package:grad/modules/splash/provider/splash_states.dart';
import 'package:grad/routes.dart';
import 'package:grad/shared/extensions.dart';
import 'package:grad/shared/images.dart';
import 'package:grad/shared/strings.dart';
import 'package:grad/shared/widgets/popup.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(splashProvider.notifier);
    ref.watch(splashProvider);
    ref.listen(splashProvider, (previous, next) {
      if (next is SplashAuthenticatedState) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (next is SplashUnAuthenticatedState) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      } else if (next is LocationPermissionApprovedState) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (next is LocationPermissionDeniedState) {
        CPopup(
            title: 'Location Permission',
            content:
                'You have to enable location permission to be able to use app',
            onPressed: () {
              provider.checkLocationPermission();
            }).show(context);
      } else if (next is LocationPermissionDeniedForeverState) {
        CPopup(
            title: 'Location Permission',
            content:
                'You have to enable location permission to be able to use app',
            onPressed: () {
              Geolocator.openLocationSettings();
            }).show(context);
      }
    });
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(context.radius(1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(context.radius(2)),
              child: Image.asset(AppImages.bike),
            ),
            Text(AppStrings.splashFirstText,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            SizedBox(height: context.heightPercent(1)),
            Text(AppStrings.splashSecondText,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary)),
            SizedBox(height: context.heightPercent(3)),
            (ref.watch(splashProvider) is SplashLoadingState)
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(context.radius(.5)),
                        ),
                      ),
                      onPressed: () {
                        provider.checkLocationPermission();
                      },
                      child: const Text(AppStrings.continueText),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
