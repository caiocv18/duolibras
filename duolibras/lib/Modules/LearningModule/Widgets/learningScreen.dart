import 'dart:async';
import 'dart:ui';

import 'package:duolibras/Commons/Components/baseScreen.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/sectionPage.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionTitleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/trailPath.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

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
  var _firstTime = true;
  LearningScreen(this._viewModel);

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  var currentSectionIndex = 0;
  late String currentSection = widget._viewModel.allSections[currentSectionIndex].title;
  final mainPath = Path();
  var isLoadingPath = true;
  late var customPath = CustomPaint(
                    painter: TrailPath(mainPath, animationController,
                        widget._viewModel.colorForModules, 0),
                    size: new Size(428, 212 * widget._viewModel.wrapperSectionPage.total.toDouble()));
  final scrollController = ScrollController();

  @override
  initState() {
    super.initState();

    animationController = AnimationController(vsync: this, duration: Duration(seconds: 0), animationBehavior: AnimationBehavior.normal);
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

    if (widget._firstTime) {
      Future.delayed(Duration(milliseconds: 1200)).then((value) => {
        setState(() {
          isLoadingPath = false;
          widget._firstTime = false;
        })
      });
    } else {
      setState(() {
          isLoadingPath = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  BaseScreen<LearningViewModel>(
        onModelReady: (viewModel) => {viewModel.fetchSections(context)},
        builder: (_, viewModel, __) => 
          LayoutBuilder(builder: (BuildContext ctx, BoxConstraints constraints) {
              return Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                SingleChildScrollView(
                controller: scrollController,
                child: 
                  _buildBody(context, viewModel, constraints.maxHeight)
                ),
                SectionTitleWidget(scrollController, viewModel.allSections, viewModel.sectionsForModules)
                ],
              );
            })
          );
  }

  Widget _buildBody(BuildContext scrollViewContext, LearningViewModel viewModel, double maxHeight) {
  return Center(
      child: viewModel.state == ScreenState.Loading ? 
      CircularProgressIndicator() : 
      Column(
        children: [
          SizedBox(height: 20),
          Stack(children: [
            _buildBackgroundImages(viewModel),
            if (isLoadingPath)
              AnimatedOpacity(
                duration: Duration(milliseconds: 1200),
                opacity: isLoadingPath ? 0.0 : 1.0,
                child: Stack(children: [
                  RepaintBoundary(child: _buildPath(maxHeight)),
                  _buildTrail(maxHeight, viewModel)
                ]),
              )
            else 
              Stack(children: [
                RepaintBoundary(child: _buildPath(maxHeight)),
                _buildTrail(maxHeight, viewModel)
              ]),
          ]),
        ],
      )
    );
  }

  Widget _buildPath(double maxHeight) {
      return  Container(
          color: Colors.transparent,
          height: maxHeight,
          child: customPath
      );                   
  }

  Widget _buildBackgroundImages(LearningViewModel viewModel) {
    final pagesTotal = viewModel.wrapperSectionPage.total;
    int totalImages = 1;
    if (pagesTotal > 3){
      totalImages = (pagesTotal/3/2).round();
    }
    return Column(
            children: 
              List.generate(totalImages,(index){
                return Image(image: AssetImage(Constants.imageAssets.background_home));
              })
          );
  }

  Widget _buildTrail(double maxHeight, LearningViewModel viewModel) {
    final pagesTotal = viewModel.wrapperSectionPage.total;
    var rowAlignment = MainAxisAlignment.start;

    return Center(
      child: Container(
          color: Colors.transparent,
          child: 
           Column(
            children: 
              List.generate(pagesTotal,(index){
                final widget =  _buildListItem(this.context, pagesTotal, index, viewModel, rowAlignment);
                rowAlignment = rowAlignment == MainAxisAlignment.end
                ? MainAxisAlignment.start
                : MainAxisAlignment.end;
                return widget;
              })
          ),
      ),
    );

  }

  Widget _buildListItem(BuildContext ctx, int pagesTotal, int index, LearningViewModel viewModel, MainAxisAlignment rowAlignment) {
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

    return ModuleWidget(module,
      viewModel.wrapperSectionPage.sectionAtIndex(index)?.id ?? "",
      widget._viewModel,
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



