import 'package:flutter/material.dart';
import 'package:testbed/test_bed.dart';

class ChipTests extends MultiStateWidgetTest {
  @override
  List<Widget> get testContent => [
        Chip(
          label: Text("A simple chip"),
        ),
        Chip(
          deleteIcon: Icon(Icons.delete),
          label: Text("Deletable Chip"),
          avatar: Icon(Icons.person),
        )
      ];
}
