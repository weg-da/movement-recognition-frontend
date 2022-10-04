import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'record_events.dart';
part 'record_states.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  static const int _duration = 60;
  Timer periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  RecordBloc() : super(const RecordInitial(_duration, false, false)) {
    // TODO: implement event handlers
  }
}
