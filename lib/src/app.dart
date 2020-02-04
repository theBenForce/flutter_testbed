import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testbed/bloc/shell_bloc.dart';
import 'package:testbed/src/widget_test.dart';

import '../test_bed.dart';

const DRAWER_BREAK = 1000;

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

  Widget createTestItems(BuildContext context, {bool closeDrawer = true}) {
    List<WidgetTest> tests = widget.tests;
    return BlocBuilder<ShellBloc, ShellState>(
        builder: (BuildContext context, state) {
      var selectedLabel = "";
      if (state is ShellTestSelected) {
        selectedLabel = state.testLabel;
      }

      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Search", suffixIcon: Icon(Icons.search)),
              controller: searchQueryController,
            ),
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
                          if (closeDrawer) Navigator.of(context).pop();
                          BlocProvider.of<ShellBloc>(context)
                              .add(SetTestShellEvent(test.label));
                        });
                  })),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List<WidgetTest> tests = widget.tests;
    TextTheme primaryTextTheme = theme.primaryTextTheme;

    return MaterialApp(
        title: 'Flutter Testbed',
        theme: widget.theme,
        home: BlocProvider<ShellBloc>(
          create: (BuildContext context) =>
              widget.bloc..add(ShellReloadStateEvent()),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Scaffold(
              appBar: AppBar(title: Text("Flutter Testbed")),
              drawer: constraints.maxWidth < DRAWER_BREAK
                  ? Drawer(child: Builder(builder: this.createTestItems))
                  : null,
              body: BlocBuilder<ShellBloc, ShellState>(
                  builder: (BuildContext context, state) {
                ThemeData theme = Theme.of(context);
                Widget content;
                if (state is ShellTestSelected) {
                  var test = tests.firstWhere(
                      (element) => element.label == state.testLabel);

                  if (test != null) {
                    content = Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            test,
                          ],
                        ));
                  } else {
                    content = Center(
                        child: Text(
                      "Could not find test ${state.testLabel}",
                      style: theme.textTheme.display1,
                    ));
                  }
                } else {
                  content = Center(
                      child: Text(
                    "Select a test from the sidebar",
                    style: theme.textTheme.display1,
                  ));
                }

                if (constraints.maxWidth >= DRAWER_BREAK) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Builder(
                          builder: (BuildContext) =>
                              this.createTestItems(context, closeDrawer: false),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).dividerColor))),
                        width: 300,
                      ),
                      Expanded(child: content)
                    ],
                  );
                }
                return content;
              }),
            );
          }),
        ));
  }
}
