import 'package:duolibras/Commons/Components/exerciseAppBarWidget.dart';
import 'package:duolibras/Commons/Components/baseScreen.dart';
import 'package:duolibras/Commons/Components/progressBar.dart';
import 'package:duolibras/Commons/Utils/Utils.dart';
import 'package:duolibras/MachineLearning/TFLite/tflite_helper.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/contentScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseMLScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/feedbackExerciseScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseMultiChoiceScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseWritingScreen.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ExercisesCategory.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'Screens/exerciseScreen.dart';

abstract class ExerciseFlowDelegate {
  void didFinishExercise(Exercise? exercise, FeedbackStatus? feedbackStatus);
  void didSelectAnswer();
  void handleFinishFLow(bool didComplete);
  void startNewExercisesLevel(List<Exercise> exercises);
  void restartLevel();
  void updateNumberOfLifes(int lifes);

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

  ExerciseFlow (this.exercises,this.module, this.sectionID) {
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

class _ExerciseFlowState extends State<ExerciseFlow> implements ExerciseFlowDelegate {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late PreferredSizeWidget? _appBar;
  var _exerciseProgress = 0.0;
  var isToShowAppBar = true;
  late ExerciseScreenDelegate? _currentPage;
  late var viewModel = locator<ExerciseViewModel>(param1: Tuple2(widget.exercises, widget.module), param2: this);

  @override
  String get sectionID => widget.sectionID;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBar = _buildFlowAppBar(this.context, widget._currentExercise.category == ExercisesCategory.content ? TabType.ContentBar : TabType.ExerciseBar);

    return WillPopScope(
      onWillPop: _isExitDesired,
      child: Scaffold(
        appBar: _appBar,
        body: Navigator(
          key: _navigatorKey,
          initialRoute: ExerciseFlow.getRouteNameBy(widget._currentExercise.category),
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }


  Route _onGenerateRoute(RouteSettings settings) {
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
        final arg = settings.arguments as Map<String, Object>;
        final feedBackStatus = arg["feedbackStatus"] as FeedbackStatus;
        page = FeedbackExerciseScreen(
            Tuple2(widget.exercises, widget.module), this);
        (page as FeedbackExerciseScreen).status = feedBackStatus;
        break;
      case ExerciseFlow.routeContentModulePage:
        page = ContentScreen(viewModel, _getContentsFromExercisesList());
        final ExerciseAppBarWidget? exerciseAppBar = Utils.tryCast(_appBar, fallback: null);
        if (exerciseAppBar != null) {
          if (exerciseAppBar.showContentTabBar != null) exerciseAppBar.showContentTabBar!(TabType.ContentBar);
        }
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
            _onSkipPressed
        )
        : null;
  }

  Future<bool> _isExitDesired() async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Tem certeza?'),
                content: const Text(
                    'Se você sair todo seu progesso vai ser perdido.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Sair'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Continuar'),
                  ),
                ],
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

    final ExerciseAppBarWidget? exerciseAppBar = Utils.tryCast(_appBar, fallback: null);
    if (exerciseAppBar != null) {
      if (exerciseAppBar.showContentTabBar != null) exerciseAppBar.showContentTabBar!(TabType.ExerciseBar);
    }
    // final index = widget.exercises.indexOf(widget._currentExercise);
    // if (widget.exercises.length > index + 1){
    //   final nextExercise = widget.exercises[index + 1];
    //   widget._currentExercise = nextExercise;
    // } else {
    //   didFinishExercise(null, FeedbackStatus.Success);
    //   return;
    // }

    // final ExerciseAppBarWidget? exerciseAppBar = Utils.tryCast(_appBar, fallback: null);
    // if (exerciseAppBar != null) {
    //   if (exerciseAppBar.showContentTabBar != null) exerciseAppBar.showContentTabBar!(TabType.ExerciseBar);
    // }
    // didFinishExercise(widget._currentExercise, null);
  }

  void _sortExercisesList() {
    widget.exercises.sort((a,b){
      return a.order.compareTo(b.order);
    });
  }

  List<Exercise> _getContentsFromExercisesList() {
    var contents = [widget._currentExercise];
    final currentIndex = widget.exercises.indexOf(widget._currentExercise);
    if (widget.exercises.length > currentIndex + 1){
      final nextExercise = widget.exercises[currentIndex + 1];
      if (nextExercise.category == ExercisesCategory.content){
        contents.add(nextExercise);
      }
    }

    widget._currentExercise = contents.last;
    return contents;
  }

  @override
  void updateNumberOfLifes(int lifes) {
    final ExerciseAppBarWidget? exerciseAppBar = Utils.tryCast(_appBar, fallback: null);
    if (exerciseAppBar != null) {
      if (exerciseAppBar.onUpdateLifes != null) exerciseAppBar.onUpdateLifes!(lifes);
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

    final ExerciseAppBarWidget? exerciseAppBar = Utils.tryCast(_appBar, fallback: null);
    if (exerciseAppBar != null) {
      _exerciseProgress += 1;
      if (exerciseAppBar.onUpdateProgress != null) exerciseAppBar.onUpdateProgress!(_exerciseProgress);
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

    _navigatorKey.currentState!.pushNamed(routeName);
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
      isToShowAppBar = true;
    });
    _navigatorKey.currentState!.pushNamed(route);
  }
}


