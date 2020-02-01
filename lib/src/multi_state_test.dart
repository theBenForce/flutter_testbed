import 'package:flutter/widgets.dart';
import 'package:recase/recase.dart';
import 'package:testbed/src/widget_test.dart';

abstract class MultiStateWidgetTest extends WidgetTest {
  String get label =>
      new ReCase(runtimeType.toString()).titleCase + " (${testContent.length})";

  List<Widget> get testContent;

  @override
  Widget build(BuildContext context) {
    return Column(children: testContent);
  }
}
