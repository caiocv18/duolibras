import 'dart:async';
import 'dart:ui';

import 'package:duolibras/Commons/Components/baseScreen.dart';
import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/sectionPage.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/trailPath.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:flutter/material.dart';

abstract class LearningViewModelProtocol {
  List<String> sectionsIDs = [];
  Stream<List<Section>>? sections;
  Stream<WrapperSectionPage>? pages;
  late Map<Color, int> colorForModules;
  bool hasMore = true;
  int numberOfSectionsForRequest = 4;
  int currentPage = 0;
  bool firstFetch = true;

  Future<void> fetchSections(BuildContext context);
}

class LearningScreen extends StatefulWidget {
  static String routeName = "/LearningScreen";
  final LearningViewModel _viewModel;
  LearningScreen(this._viewModel);

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>with SingleTickerProviderStateMixin {
  final pathScrollController = ScrollController();
  final listViewScrollController = ScrollController();

  late Animation<double> animation;
  late AnimationController animationController;
  Path mainPath = Path();
  var index = 0;
  var isLoadingPath = true;
  late var customPath = CustomPaint(
                    painter: TrailPath(mainPath, animationController,
                        widget._viewModel.colorForModules, index),
                    size: new Size(428, 212 * widget._viewModel.wrapperSectionPage.total.toDouble()));

  @override
  initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    listViewScrollController.addListener(() {
      pathScrollController.jumpTo(listViewScrollController.offset);
    });

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    animation.addListener(() {
      setState(() {
        if (animation.isCompleted) {
          animationController.stop();
          // index += 1;
          // animationController.forward(from: 0.0);
        }
      });
    });

    Future.delayed(Duration(milliseconds: 800)).then((value) => {
      setState(() {
        isLoadingPath = false;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return  BaseScreen<LearningViewModel>(
        onModelReady: (viewModel) => {viewModel.fetchSections(context)},
        builder: (_, viewModel, __) => LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight,
                  color: Color.fromRGBO(234, 234, 234, 1),
                      child: 
                      Center(
                          child: viewModel.state == ScreenState.Loading ? 
                          CircularProgressIndicator() : Container(child: _buildContentWidgets(constraints.maxHeight, viewModel))
                      )
                  );  
              }
          ),
    );
  }

  Widget _buildContentWidgets(double maxHeight, LearningViewModel viewModel) {
    maxHeight -= 20;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 850),
      opacity: isLoadingPath ? 0.0 : 1.0,
      child: Column(
        children: [
          SizedBox(height: 20),
          Stack(children: [
            _buildBackground(maxHeight),
            _buildTrail(maxHeight, viewModel)
          ]),
        ],
      ),
    );
  }

Widget _buildBackground(double maxHeight) {
  return  Container(
            height: maxHeight,
            // width: double.infinity,
            child: SingleChildScrollView(
                controller: pathScrollController,
                scrollDirection: Axis.vertical,
                child: customPath,
                )
        );
}

Widget _buildTrail(double maxHeight, LearningViewModel viewModel) {
  final pagesTotal = viewModel.wrapperSectionPage.total;
  var rowAlignment = MainAxisAlignment.end;

  return Container(
      height: maxHeight,
      child: ListView.builder(
          controller: listViewScrollController,
          padding: EdgeInsets.only(bottom: 10),
          itemCount: pagesTotal,
          itemBuilder: (ctx, index) {
            if (index == pagesTotal - 1 && widget._viewModel.hasMore) {
              widget._viewModel.fetchSections(ctx);
            }

            if (index == pagesTotal) {
              if (viewModel.state == ScreenState.Loading)
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
            
            final module = viewModel.wrapperSectionPage.moduleAtIndex(index);
            rowAlignment = rowAlignment == MainAxisAlignment.end
                ? MainAxisAlignment.start
                : MainAxisAlignment.end;
            return ModuleWidget(
                  module,
                  viewModel.wrapperSectionPage.sectionAtIndex(index)?.id ?? "",
                  widget._viewModel as ModuleViewModel,
                  rowAlignment,
                  handleFinishExercise,
                  index == 0
                      ? true
                      : viewModel.wrapperSectionPage.isModuleAvaiable(
                          viewModel.wrapperSectionPage.sectionAtIndex(index)?.id ?? "",
                          module.id,
                          ctx
                        )
              );
          })
  );
}

  void handleFinishExercise() {
    setState(() {
      // index = 0;
    });
    // Future.delayed(Duration(seconds: 1)).then((value) {
    //   animationController.forward(from: 0.0);
    // });
  }

  void _handleCompletedLogin(bool? shouldUpdateView) {
    if (shouldUpdateView == null) return;

    if (shouldUpdateView) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

}
