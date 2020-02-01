import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testbed/bloc/shell_bloc.dart';
import 'package:testbed/src/widget_test.dart';

import '../test_bed.dart';

class TestBedApp extends StatefulWidget {
  final List<WidgetTest> Function() tests;
  final ThemeData theme;
  ShellBloc bloc = ShellBloc();

  TestBedApp({Key key, this.tests, this.theme}) : super(key: key);

  @override
  _TestBedAppState createState() => _TestBedAppState();
}

class _TestBedAppState extends State<TestBedApp> {
  @override
  Widget build(BuildContext context) {
    List<WidgetTest> tests = widget.tests();

    return MaterialApp(
      title: 'Flutter Testbed',
      theme: widget.theme,
      home: BlocProvider<ShellBloc>(
          builder: (BuildContext context) =>
              widget.bloc..add(ShellReloadStateEvent()),
          child: Scaffold(
            appBar: AppBar(title: Text("Flutter Testbed")),
            drawer: Drawer(
                child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    "Widgets",
                    style: Theme.of(context).primaryTextTheme.headline6,
                  ),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                ),
                ...tests
                    .map((test) => ListTile(
                        title: Text(test.label),
                        onTap: () {
                          widget.bloc.add(SetTestShellEvent(test.label));
                        }))
                    .toList()
              ],
            )),
            body: Padding(
              padding: EdgeInsets.all(12.0),
              child: BlocBuilder<ShellBloc, ShellState>(
                builder: (BuildContext context, state) {
                  if (state is ShellTestSelected) {
                    var test = tests.firstWhere(
                        (element) => element.label == state.testLabel);

                    if (test?.child != null) {
                      return test.child;
                    }

                    return Center(
                        child: Text(
                      "Could not find test ${state.testLabel}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ));
                  }

                  return Center(
                      child: Text(
                    "Select a test from the sidebar",
                    style: Theme.of(context).textTheme.subtitle2,
                  ));
                },
              ),
            ),
          )),
    );
  }
}
