part of 'shell_bloc.dart';

@immutable
abstract class ShellState extends Equatable {}

class ShellInitial extends ShellState {
  @override
  List<Object> get props => [];
}

class ShellTestSelected extends ShellState {
  final String testLabel;

  ShellTestSelected(this.testLabel);
  @override
  List<Object> get props => [testLabel];
}
