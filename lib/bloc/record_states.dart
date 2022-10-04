part of 'record_bloc.dart';

abstract class RecordState extends Equatable {
  const RecordState(this.duration, this.isRecording, this.isUploading);
  final int duration;
  final bool isRecording;
  final bool isUploading;

  @override
  List<Object> get props => [duration, isRecording, isUploading];
}

class RecordInitial extends RecordState {
  const RecordInitial(int duration, bool isRecording, bool isUploading)
      : super(3, false, false);

  @override
  String toString() => 'RecordInitial { duration: $duration }';
}

class RecordRecording extends RecordState {
  const RecordRecording(int duration, bool isRecording, bool isUploading)
      : super(5, true, false);

  @override
  String toString() => 'RecordRecording { duration: $duration }';
}

class RecordUploading extends RecordState {
  const RecordUploading(int duration, bool isRecording, bool isUploading)
      : super(0, false, true);

  @override
  String toString() => 'RecordUploading { duration: $duration }';
}

class RecordFinished extends RecordState {
  const RecordFinished(int duration, bool isRecording, bool isUploading)
      : super(0, false, false);

  @override
  String toString() => 'RecordFinished { duration: $duration }';
}
