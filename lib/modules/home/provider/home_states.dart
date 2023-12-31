import 'package:grad/shared/models/trip_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class CurrentTripLoadingState extends HomeStates {}

class TripStartedState extends HomeStates {}

class TripEndedState extends HomeStates {
  final TripModel tripModel;
  TripEndedState(this.tripModel);
}
