import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shell_event.dart';
part 'shell_state.dart';

const SELECTED_TEST = "selectedTest";

class ShellBloc extends Bloc<ShellEvent, ShellState> {
  @override
  ShellState get initialState => ShellInitial();

  @override
  Stream<ShellState> mapEventToState(
    ShellEvent event,
  ) async* {
    if (event is SetTestShellEvent) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString(SELECTED_TEST, event.testLabel);
      yield ShellTestSelected(event.testLabel);
    } else if (event is ShellReloadStateEvent) {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(SELECTED_TEST)) {
        yield ShellTestSelected(prefs.getString(SELECTED_TEST));
      } else {
        yield ShellInitial();
      }
    } else {
      yield ShellInitial();
    }
  }
}
