import 'dart:async';

import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/trailPath.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:flutter/material.dart';

abstract class LearningViewModelProtocol {
  List<String> sectionsIDs = [];
  Stream<List<Section>>? sections;
  Stream<List<Module>>? modules;
  late Map<Color, int> colorForModules;
  bool hasMore = true;
  int numberOfSectionsForRequest = 4;
  int currentPage = 0;
  bool error = false;
  bool loading = false;
  bool firstFetch = true;

  Future<void> fetchSections();
  void disposeStreams();
}

class LearningScreen extends StatefulWidget {
  static String routeName = "/LearningScreen";

  final LearningViewModelProtocol _viewModel;

  LearningScreen(this._viewModel);

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with SingleTickerProviderStateMixin {
  final bottomNavigationBar = BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Container()),
      BottomNavigationBarItem(icon: Icon(Icons.score), title: Container())
    ],
  );

  final PreferredSizeWidget appBar = AppBarWidget();

  List<Section> sections = [];
  List<Module> modules = [];

  final pathScrollController = ScrollController();

  final listViewScrollController = ScrollController();

  late Animation<double> animation;
  late AnimationController animationController;
  Path mainPath = Path();
  var index = 0;

  @override
  initState() {
    widget._viewModel.sections!.asBroadcastStream().listen((newSections) {
      setState(() {
        this.sections = newSections;
      });
    });

    widget._viewModel.modules!.asBroadcastStream().listen((newModules) {
      setState(() {
        this.modules = newModules;
      });
    });

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    pathScrollController.addListener(() {
      listViewScrollController.jumpTo(pathScrollController.offset);
    });

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    animation.addListener(() {
      setState(() {
        if (animation.isCompleted) {
          print("Tweste");
          index += 1;
          animationController.forward(from: 0.0);
        }
      });
    });
  }

  @override
  void dispose() {
    widget._viewModel.disposeStreams();
    super.dispose();
  }

  Widget _buildBody() {
    final _mediaQuery = MediaQuery.of(context);
    if (modules.isEmpty) {
      if (widget._viewModel.firstFetch) {
        widget._viewModel.firstFetch = false;
        widget._viewModel.loading = true;
        widget._viewModel.fetchSections();
      }

      if (widget._viewModel.loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (widget._viewModel.error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              widget._viewModel.loading = true;
              widget._viewModel.error = false;
              widget._viewModel.fetchSections();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading Sections, tap to try agin"),
          ),
        ));
      }
    } else {
      final maxHeight = _mediaQuery.size.height -
          (kBottomNavigationBarHeight +
              _mediaQuery.padding.bottom +
              appBar.preferredSize.height +
              _mediaQuery.padding.top +
              85);
      return Center(
        child: Column(
          children: [_buildContentWidgets(maxHeight)],
        ),
      );
    }

    return Container();
  }

  Widget _buildContentWidgets(double maxHeight) {
    var rowAlignment = MainAxisAlignment.end;

    maxHeight -= 15;
    return Column(
      children: [
        SizedBox(height: 15),
        Stack(children: [
          Container(
              height: maxHeight,
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 10),
                  itemCount:
                      modules.length + (widget._viewModel.hasMore ? 1 : 0),
                  itemBuilder: (ctx, index) {
                    if (index == modules.length - 1 &&
                        widget._viewModel.hasMore) {
                      widget._viewModel.fetchSections();
                    }

                    if (index == modules.length) {
                      if (widget._viewModel.error) {
                        return Center(
                            child: InkWell(
                          onTap: () {
                            setState(() {
                              widget._viewModel.loading = true;
                              widget._viewModel.error = false;
                              widget._viewModel.fetchSections();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                                "Error while loading sections, tap to try agin"),
                          ),
                        ));
                      } else {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ));
                      }
                    }
                    final module = modules[index];
                    rowAlignment = rowAlignment == MainAxisAlignment.end
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end;
                    return MaduleWidget(module, "sectionID",
                        widget._viewModel as ModuleViewModel, rowAlignment);
                  })),
          // Container(
          //     height: maxHeight,
          //     // width: double.infinity,
          //     child: SingleChildScrollView(
          //         controller: pathScrollController,
          //         scrollDirection: Axis.vertical,
          //         child: new CustomPaint(
          //           painter: TrailPath(mainPath, animationController,
          //               widget._viewModel.colorForModules, index),
          //           size: new Size(428, 212 * modules.length.toDouble()),
          //         ))),
        ]),
      ],
    );
  }

  void _handleCompletedLogin(bool? shouldUpdateView) {
    if (shouldUpdateView == null) return;

    if (shouldUpdateView) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }
}
