import 'package:flutter/material.dart';
import 'package:grad/shared/models/trip_model.dart';
import 'package:intl/intl.dart';

class TripSummaryScreen extends StatelessWidget {
  final TripModel tripModel;
  const TripSummaryScreen({super.key, required this.tripModel});

  @override
  Widget build(BuildContext context) {
    final dateTimeFormatter = DateFormat('hh:mm a');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Trip ID: ${tripModel.id}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text('Bike ID: ${tripModel.bikeId}'),
                      const SizedBox(height: 10),
                      Text(
                        'Start Time: ${dateTimeFormatter.format(tripModel.startDateTime)}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'End Time: ${dateTimeFormatter.format(tripModel.endDateTime ?? DateTime.now())}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text('Price : ${tripModel.price} EGP'),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Continue'))
          ],
        ),
      ),
    );
  }
}
