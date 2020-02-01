import 'package:flutter/material.dart';
import 'package:testbed/test_bed.dart';

void main() => runApp(TestBedApp(
    tests: () => [
          WidgetTest(
              "Button",
              RaisedButton(
                onPressed: () {},
                child: Text("Something Else"),
              )),
          WidgetTest(
              "Chip",
              Chip(
                label: Text("A test Chip"),
              ))
        ],
    theme: ThemeData(primaryColor: Colors.deepPurple)));
