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
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

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

class _LearningScreenState extends State<LearningScreen> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  var currentSectionIndex = 0;

  late String currentSection =
      widget._viewModel.allSections[currentSectionIndex].title;
  final mainPath = Path();
  var isLoadingPath = true;
  var isAnimating = true;
  late var customPath = CustomPaint(
      painter: TrailPath(
          mainPath, animationController, widget._viewModel.colorForModules, 1),
      size: new Size(
          428, 212 * widget._viewModel.wrapperSectionPage.total.toDouble()));
  final scrollController = ScrollController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
        animationBehavior: AnimationBehavior.normal);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    animation.addListener(() {
      setState(() {
        if (animation.isCompleted) {
          animationController.stop();
          isAnimating = false;
        }
      });
    });

    if (!widget._firstTime)  {
      setState(() {
        isLoadingPath = false;
      });
    }

    super.initState();
  }

  void setTrailPathIndex() {
    Future.delayed(Duration(milliseconds: 1200)).then((value) {
      if (!mounted) return;
      currentSectionIndex = Provider.of<UserModel>(this.context, listen: false)
          .user
          .trailSectionIndex;

      if (currentSectionIndex == User.initialTrailSectionIndex) {
        currentSectionIndex = 0;
      } else {
        if (currentSectionIndex == widget._viewModel.allSections.length) {
          animationController.duration = Duration(milliseconds: 150);
          animationController.forward().then((_) {
            animationController.duration = Duration(seconds: 2);
          });
          return;
        } else {
          currentSectionIndex = currentSectionIndex + 1;
        }
      }
      setState(() {
        isLoadingPath = false;
        widget._firstTime = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<LearningViewModel>(
        onModelReady: (viewModel) =>
            {viewModel.fetchSections(context).then((_) => setTrailPathIndex())},
        builder: (_, viewModel, __) => LayoutBuilder(
                builder: (BuildContext ctx, BoxConstraints constraints) {
              return Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Container(
                    height: constraints.maxHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage(Constants.imageAssets.background_home),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                      controller: scrollController,
                      child: _buildBody(
                          context, viewModel, constraints.maxHeight)),
                  SectionTitleWidget(scrollController, viewModel.allSections,
                      viewModel.sectionsForModules)
                ],
              );
            }));
  }

  Widget _buildBody(BuildContext scrollViewContext, LearningViewModel viewModel,
      double maxHeight) {
    return Center(
        child: viewModel.state == ScreenState.Loading
            ? null
            : Column(
                children: [
                  SizedBox(height: 20),
                  Stack(children: [
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
                        _buildPath(maxHeight),
                        _buildTrail(maxHeight, viewModel)
                      ]),
                  ]),
                ],
              ));
  }

  Widget _buildPath(double maxHeight) {
    return Container(
        color: Colors.transparent,
        height: maxHeight,
        child: CustomPaint(
            painter: TrailPath(mainPath, animationController,
                widget._viewModel.colorForModules, currentSectionIndex),
            size: new Size(428,
                212 * widget._viewModel.wrapperSectionPage.total.toDouble())));
  }

  Widget _buildBackgroundImages(LearningViewModel viewModel) {
    final pagesTotal = viewModel.wrapperSectionPage.total;
    int totalImages = 1;
    if (pagesTotal > 3) {
      totalImages = (pagesTotal / 3).round();
    }
    return Column(
        children: List.generate(totalImages, (index) {
      return Image(image: AssetImage(Constants.imageAssets.background_home));
    }));
  }

  Widget _buildTrail(double maxHeight, LearningViewModel viewModel) {
    final pagesTotal = viewModel.wrapperSectionPage.total;
    var rowAlignment = MainAxisAlignment.start;

    return Center(
      child: Container(
        color: Colors.transparent,
        child: Column(
            children: List.generate(pagesTotal, (index) {
          final widget = _buildListItem(
              this.context, pagesTotal, index, viewModel, rowAlignment);
          rowAlignment = rowAlignment == MainAxisAlignment.end
              ? MainAxisAlignment.start
              : MainAxisAlignment.end;
          return widget;
        })),
      ),
    );
  }

  Widget _buildListItem(BuildContext ctx, int pagesTotal, int index,
      LearningViewModel viewModel, MainAxisAlignment rowAlignment) {
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

    return Container(
      height: 200,
      width: double.infinity,
      child: ModuleWidget(
          module,
          viewModel.wrapperSectionPage.sectionAtIndex(index)?.id ?? "",
          widget._viewModel,
          rowAlignment,
          handleFinishExercise,
          index == 0
              ? true
              : viewModel.wrapperSectionPage.isModuleAvaiable(
                  viewModel.wrapperSectionPage.sectionAtIndex(index)?.id ?? "",
                  module.id,
                  ctx)),
    );
  }

  void handleFinishExercise() {
    final index = widget._viewModel.shouldAnimatedTrail(this.context);

    if (index != -1) {
      setState(() {
        isAnimating = true;
        currentSectionIndex = index;
      });

      Future.delayed(Duration(seconds: 1)).then((value) {
        animationController.forward(from: 0.0);
      });
    }
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
