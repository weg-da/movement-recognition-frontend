part of 'record_bloc.dart';

/// Event being processed by [CounterBloc].
abstract class RecordEvent {}

/// Notifies bloc to increment state.
class RecordingStarted extends RecordEvent {}

/// Notifies bloc to decrement state.
class RecordingCanceled extends RecordEvent {}
