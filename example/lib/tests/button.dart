import 'package:flutter/material.dart';
import 'package:testbed/test_bed.dart';

class ButtonTest extends WidgetTest {
  @override
  List<Widget> get testContent => [
        RaisedButton(
          onPressed: () {},
          child: Text("A Test Button with new Text"),
        )
      ];
}
