import 'package:duolibras/Commons/Components/customAlert.dart';
import 'package:duolibras/Commons/Components/exerciseAppBarWidget.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/contentScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseMLScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/feedbackExerciseScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseMultiChoiceScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseWritingScreen.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/exercisesCategory.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Screens/exerciseScreen.dart';

abstract class ExerciseFlowDelegate {
  void didFinishExercise(Exercise? exercise, FeedbackStatus? feedbackStatus);
  void didSelectAnswer();
  void handleFinishFLow(bool didComplete);
  void startNewExercisesLevel(List<Exercise> exercises);
  void restartLevel();
  void updateNumberOfLifes(int lifes);

  var exerciseProgressValue;
  var totalPoints;
  var lifes;
  String get sectionID;
}

// ignore: must_be_immutable
class ExerciseFlow extends StatefulWidget {
  static const routePrefixExerciseFlow = '/exercise/';
  static const routeStartExerciseFlow = "/exercise/multi_choice";
  static const routeExerciseMultiChoicePage = 'multi_choice';
  static const routeExerciseWritingPage = 'writing';
  static const routeExerciseML = 'ml';
  static const routeExerciseMLSpelling = 'mlSpelling';
  static const routeFeedbackModulePage = 'feedback_page';
  static const routeContentModulePage = 'content';

  List<Exercise> exercises;
  final Module module;
  final String sectionID;
  late Exercise _currentExercise;

  ExerciseFlow(this.exercises, this.module, this.sectionID) {
    _currentExercise = exercises.first;
  }

  @override
  _ExerciseFlowState createState() => _ExerciseFlowState();

  static String getRouteNameBy(ExercisesCategory exerciseCategory) {
    switch (exerciseCategory) {
      case ExercisesCategory.multipleChoicesText:
        return ExerciseFlow.routeExerciseMultiChoicePage;
      case ExercisesCategory.multipleChoicesImage:
        return ExerciseFlow.routeExerciseMultiChoicePage;
      case ExercisesCategory.writing:
        return ExerciseFlow.routeExerciseWritingPage;
      case ExercisesCategory.ml:
        return ExerciseFlow.routeExerciseML;
      case ExercisesCategory.mlSpelling:
        return ExerciseFlow.routeExerciseMLSpelling;
      case ExercisesCategory.content:
        return ExerciseFlow.routeContentModulePage;
      default:
        return "";
    }
  }
}

class _ExerciseFlowState extends State<ExerciseFlow>
    implements ExerciseFlowDelegate {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late PreferredSizeWidget? _appBar;
  var _exerciseProgress = 0.0;
  var isToShowAppBar = true;
  late ExerciseScreenDelegate? _currentPage;

  @override
  var exerciseProgressValue = 0;
  @override
  var lifes = 3;
  @override
  var totalPoints = 0;

  late var viewModel = locator<ExerciseViewModel>(
      param1: Tuple2(widget.exercises, widget.module), param2: this);

  @override
  String get sectionID => widget.sectionID;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBar = _buildFlowAppBar(
        this.context,
        widget._currentExercise.category == ExercisesCategory.content
            ? TabType.ContentBar
            : TabType.ExerciseBar);

    return WillPopScope(
      onWillPop: _isExitDesired,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar,
        body: Navigator(
          key: _navigatorKey,
          initialRoute:
              ExerciseFlow.getRouteNameBy(widget._currentExercise.category),
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    viewModel = locator<ExerciseViewModel>(
        param1: Tuple2(widget.exercises, widget.module), param2: this);
    late Widget page;
    switch (settings.name) {
      case ExerciseFlow.routeExerciseMultiChoicePage:
        page = ExerciseMultiChoiceScreen(widget._currentExercise, viewModel);
        break;
      case ExerciseFlow.routeExerciseWritingPage:
        page = ExerciseWritingScreen(widget._currentExercise, viewModel);
        break;
      case ExerciseFlow.routeExerciseML:
        page = ExerciseMLScreen(widget._currentExercise, viewModel, false);
        break;
      case ExerciseFlow.routeExerciseMLSpelling:
        page = ExerciseMLScreen(widget._currentExercise, viewModel, true);
        break;
      case ExerciseFlow.routeFeedbackModulePage:
        final arg = settings.arguments as Map<String, FeedbackStatus?>;
        final feedBackStatus = arg["feedbackStatus"] as FeedbackStatus;
        page = FeedbackExerciseScreen(
            Tuple2(widget.exercises, widget.module), this);
        (page as FeedbackExerciseScreen).status = feedBackStatus;
        break;
      case ExerciseFlow.routeContentModulePage:
        page = ContentScreen(viewModel, _getContentsFromExercisesList());
        final ExerciseAppBarWidget? exerciseAppBar =
            Utils.tryCast(_appBar, fallback: null);
        Future.delayed(Duration.zero, () async {
          if (exerciseAppBar != null) {
            if (exerciseAppBar.showContentTabBar != null)
              exerciseAppBar.showContentTabBar!(TabType.ContentBar);
          }
        });

        break;
    }

    _currentPage = Utils.tryCast(page, fallback: null);

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  PreferredSizeWidget? _buildFlowAppBar(BuildContext ctx, TabType tabType) {
    return isToShowAppBar
        ? ExerciseAppBarWidget(
            widget.exercises.length.toDouble(),
            MediaQuery.of(ctx).size,
            3,
            tabType,
            _onNextExercisePressed,
            _onExitPressed,
            _onSkipPressed)
        : null;
  }

  Future<bool> _isExitDesired() async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return CustomAlert(
                title: "Tem certeza que deseja sair?",
                customHeight: 223,
                titleWidth: 150,
                yesTitle: "Sim",
                noTitle: "Não",
                yesButton: () => Navigator.of(context).pop(true),
                noButton: () => Navigator.of(context).pop(false),
              );
            }) ??
        false;
  }

  Future<void> _onExitPressed() async {
    final isConfirmed = await _isExitDesired();
    if (isConfirmed && mounted) {
      _exitSetup(null);
    }
  }

  Future<void> _onNextExercisePressed() async {
    _currentPage?.goNextExercise();
  }

  Future<void> _onSkipPressed() async {
    _currentPage?.goNextExercise();

    final ExerciseAppBarWidget? exerciseAppBar =
        Utils.tryCast(_appBar, fallback: null);
    if (exerciseAppBar != null) {
      if (exerciseAppBar.showContentTabBar != null)
        exerciseAppBar.showContentTabBar!(TabType.ExerciseBar);
    }
  }

  void _sortExercisesList() {
    widget.exercises.sort((a, b) {
      return a.order.compareTo(b.order);
    });
  }

  List<Exercise> _getContentsFromExercisesList() {
    var contents = [widget._currentExercise];
    var currentIndex = widget.exercises.indexOf(widget._currentExercise);
    currentIndex += 1;
    if (currentIndex < widget.exercises.length) {
      var nextExercise = widget.exercises[currentIndex];
      while (currentIndex + 1 < widget.exercises.length &&
          nextExercise.category == ExercisesCategory.content) {
        contents.add(nextExercise);
        currentIndex += 1;
        nextExercise = widget.exercises[currentIndex];
      }
    }

    widget._currentExercise = contents.last;
    return contents;
  }

  @override
  void updateNumberOfLifes(int lifes) {
    final ExerciseAppBarWidget? exerciseAppBar =
        Utils.tryCast(_appBar, fallback: null);
    if (exerciseAppBar != null) {
      if (exerciseAppBar.onUpdateLifes != null)
        exerciseAppBar.onUpdateLifes!(lifes);
    }
  }

  void _exitSetup(bool? completed) {
    Navigator.of(context).pop(completed);
  }

  @override
  void didFinishExercise(Exercise? exercise, FeedbackStatus? feedbackStatus) {
    if (exercise == null) {
      setState(() {
        isToShowAppBar = false;
      });
      _navigatorKey.currentState!.pushNamed(
          ExerciseFlow.routeFeedbackModulePage,
          arguments: {"feedbackStatus": feedbackStatus});
      return;
    }

    final ExerciseAppBarWidget? exerciseAppBar =
        Utils.tryCast(_appBar, fallback: null);
    if (exerciseAppBar != null) {
      _exerciseProgress += 1;
      if (exerciseAppBar.onUpdateProgress != null)
        exerciseAppBar.onUpdateProgress!(_exerciseProgress);
    }

    widget._currentExercise = exercise;

    String routeName;

    switch (widget._currentExercise.category) {
      case ExercisesCategory.multipleChoicesImage:
        routeName = ExerciseFlow.routeExerciseMultiChoicePage;
        break;
      case ExercisesCategory.multipleChoicesText:
        routeName = ExerciseFlow.routeExerciseMultiChoicePage;
        break;
      case ExercisesCategory.writing:
        routeName = ExerciseFlow.routeExerciseWritingPage;
        break;
      case ExercisesCategory.ml:
        routeName = ExerciseFlow.routeExerciseML;
        break;
      case ExercisesCategory.mlSpelling:
        routeName = ExerciseFlow.routeExerciseMLSpelling;
        break;
      case ExercisesCategory.content:
        routeName = ExerciseFlow.routeContentModulePage;
        break;
      default:
        didFinishExercise(null, null);
        return;
    }

    _navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  @override
  void handleFinishFLow(bool didComplete) {
    _exitSetup(didComplete);
  }

  @override
  void didSelectAnswer() {
    final ExerciseAppBarWidget? exerciseAppBar =
        Utils.tryCast(_appBar, fallback: null);
    if (exerciseAppBar != null) {
      if (exerciseAppBar.showArrow != null) exerciseAppBar.showArrow!();
    }
  }

  @override
  void startNewExercisesLevel(List<Exercise> exercises) {
    widget.exercises = exercises;
    _sortExercisesList();
    widget._currentExercise = exercises.first;

    final route = ExerciseFlow.getRouteNameBy(widget._currentExercise.category);
    setState(() {
      _exerciseProgress = 0;
      isToShowAppBar = true;
    });
    _navigatorKey.currentState!.pushNamed(route);
  }

  @override
  void restartLevel() {
    widget._currentExercise = widget.exercises.first;

    final route = ExerciseFlow.getRouteNameBy(widget._currentExercise.category);
    setState(() {
      _exerciseProgress = 0;
      exerciseProgressValue = 0;
      totalPoints = 0;
      lifes = 3;
      isToShowAppBar = true;
    });
    _navigatorKey.currentState!.pushNamed(route);
  }
}
