part of 'shell_bloc.dart';

@immutable
abstract class ShellState extends Equatable {
  @override
  List<Object> get props => [DateTime.now()];
}

class ShellInitial extends ShellState {}

class ShellTestSelected extends ShellState {
  final String testLabel;

  ShellTestSelected(this.testLabel);
}
