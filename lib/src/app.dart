import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testbed/bloc/shell_bloc.dart';
import 'package:testbed/src/widget_test.dart';

import '../test_bed.dart';

class TestBedApp extends StatefulWidget {
  final List<WidgetTest> tests;
  final ThemeData theme;
  ShellBloc bloc = ShellBloc();

  TestBedApp({Key key, this.tests, this.theme}) : super(key: key);

  @override
  _TestBedAppState createState() => _TestBedAppState();
}

class _TestBedAppState extends State<TestBedApp> {
  TextEditingController searchQueryController = TextEditingController();
  String filter = "";

  @override
  void initState() {
    super.initState();

    searchQueryController.addListener(() =>
        setState(() => filter = searchQueryController.text.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    List<WidgetTest> tests = widget.tests;
    ThemeData theme = Theme.of(context);
    TextTheme primaryTextTheme = theme.primaryTextTheme;

    return MaterialApp(
      title: 'Flutter Testbed',
      theme: widget.theme,
      home: BlocProvider<ShellBloc>(
          create: (BuildContext context) =>
              widget.bloc..add(ShellReloadStateEvent()),
          child: Scaffold(
            appBar: AppBar(title: Text("Flutter Testbed")),
            drawer: BlocBuilder<ShellBloc, ShellState>(
              builder: (BuildContext context, state) {
                var selectedLabel = "";
                if (state is ShellTestSelected) {
                  selectedLabel = state.testLabel;
                }

                return Drawer(
                    child: Column(
                  children: <Widget>[
                    DrawerHeader(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Widgets",
                            style: primaryTextTheme.title,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                labelText: "Search",
                                suffixIcon: Icon(Icons.search)),
                            controller: searchQueryController,
                          )
                        ],
                      ),
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: tests.length,
                          itemBuilder: (BuildContext context, int index) {
                            var test = tests[index];

                            if (filter != null &&
                                filter.trim().length > 0 &&
                                !test.label.toLowerCase().contains(filter)) {
                              return Container();
                            }
                            return ListTile(
                                title: Text(test.label),
                                selected: test.label == selectedLabel,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  widget.bloc
                                      .add(SetTestShellEvent(test.label));
                                });
                          }),
                    )
                  ],
                ));
              },
            ),
            body: Padding(
              padding: EdgeInsets.all(12.0),
              child: BlocBuilder<ShellBloc, ShellState>(
                builder: (BuildContext context, state) {
                  if (state is ShellTestSelected) {
                    var test = tests.firstWhere(
                        (element) => element.label == state.testLabel);

                    if (test != null) {
                      return test;
                    }

                    return Center(
                        child: Text(
                      "Could not find test ${state.testLabel}",
                      style: theme.textTheme.display1,
                    ));
                  }

                  return Center(
                      child: Text(
                    "Select a test from the sidebar",
                    style: theme.textTheme.display1,
                  ));
                },
              ),
            ),
          )),
    );
  }
}
