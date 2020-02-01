import 'package:flutter/material.dart';
import 'package:testbed/test_bed.dart';

import 'tests/button.dart';

void main() => runApp(TestBedApp(
    tests: [ButtonTest()], theme: ThemeData(primaryColor: Colors.deepPurple)));
