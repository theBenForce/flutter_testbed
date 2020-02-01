import 'package:flutter/widgets.dart';
import 'package:recase/recase.dart';

abstract class WidgetTest extends StatelessWidget {
  String get label => new ReCase(runtimeType.toString()).titleCase;

  Widget get testContent;

  @override
  Widget build(BuildContext context) {
    return testContent;
  }
}
