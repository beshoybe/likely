import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad/modules/home/provider/home_provider.dart';
import 'package:grad/modules/home/provider/home_states.dart';
import 'package:grad/modules/home/screens/trip_summary_screen.dart';
import 'package:grad/modules/home/widgets/drawer.dart';
import 'package:grad/modules/home/widgets/header.dart';
import 'package:grad/modules/home/widgets/barcode/scan_button.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeProvider.notifier);
    ref.watch(homeProvider);
    ref.listen(homeProvider, (previous, next) {
      if (next is TripEndedState) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TripSummaryScreen(tripModel: next.tripModel)));
      }
    });
    return Scaffold(
      drawer: const HomeDrawer(),
      body: Stack(
        children: [
          Center(
              child: MapWidget(
            onMapCreated: provider.onMapCreated,
            onMapLoadedListener: (mapLoadedEventData) => provider.onMapLoaded(),
            resourceOptions: ResourceOptions(
                accessToken:
                    'pk.eyJ1IjoiYmVzaG95YmUiLCJhIjoiY2xodHF2OWMzMGpxZDNrbzFjNGhxanlxbyJ9.tDbg5LbuZiNGhKpowLznQg'),
          )),
          const SafeArea(child: HomeHeader()),
          const Align(
            alignment: Alignment.bottomCenter,
            child: ScanBarCodeButton(),
          )
        ],
      ),
    );
  }
}
