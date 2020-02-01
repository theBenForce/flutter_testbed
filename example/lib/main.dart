import 'package:flutter/material.dart';
import 'package:test_app/tests/chips.dart';
import 'package:testbed/test_bed.dart';

import 'tests/button.dart';

void main() => runApp(TestBedApp(
    tests: [ButtonTest(), ChipTests()],
    theme: ThemeData(primaryColor: Colors.deepPurple)));
