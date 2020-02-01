part of 'shell_bloc.dart';

@immutable
abstract class ShellEvent {}

class ShellReloadStateEvent extends ShellEvent {}

class SetTestShellEvent extends ShellEvent {
  final String testLabel;

  SetTestShellEvent(this.testLabel);
}
