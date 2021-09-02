import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseMultiChoiceScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseWritingScreen.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ExercisesCategory.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExerciseFlow extends StatefulWidget {
  // static ExerciseFlow of(BuildContext context) {
  //   return context.findAncestorStateOfType<_ExerciseFlowState>()!;
  // }

  static const routePrefixExerciseFlow = '/exercise/';
  static const routeStartExerciseFlow = "/exercise/multi_choice";
  static const routeExerciseMultiChoicePage = 'multi_choice';
  static const routeExerciseWritingPage = 'writing';

  late final List<Exercise> exercises;

  final moduleID;

  ExerciseFlow({
    Key? key,
    required this.setupPageRoute,
    required this.exercises,
    required this.moduleID,
  }) : super(key: key);

  final String setupPageRoute;
  Exercise? _exercise;
  @override
  _ExerciseFlowState createState() => _ExerciseFlowState();
}

class _ExerciseFlowState extends State<ExerciseFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late ExerciseViewModel _viewModel =
      ExerciseViewModel(widget.exercises, widget.moduleID, _didFinishExercise);

  var _exerciseProgress = 0.0;
  var _totalPoints = 0.0;
  @override
  void initState() {
    super.initState();
    widget._exercise = widget.exercises.first;
  }

  void _didFinishExercise(Exercise? exercise) {
    setState(() {
      _exerciseProgress = _viewModel.exerciseProgressValue;
      _totalPoints = _viewModel.totalPoints;
    });

    if (exercise == null) {
      _exitSetup(true);
      return;
    }

    widget._exercise = exercise;

    String routeName =
        widget._exercise!.category == ExercisesCategory.multipleChoices
            ? ExerciseFlow.routeExerciseMultiChoicePage
            : ExerciseFlow.routeExerciseWritingPage;

    _navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<bool> _isExitDesired() async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                    'If you exit the exercise, your progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Leave'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Stay'),
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

  void _exitSetup(bool? completed) {
    Navigator.of(context).pop(completed);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExitDesired,
      child: Scaffold(
        appBar: _buildFlowAppBar(),
        body: Navigator(
          key: _navigatorKey,
          initialRoute: widget.setupPageRoute,
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case ExerciseFlow.routeExerciseMultiChoicePage:
        page = ExerciseMultiChoiceScreen(widget._exercise!, _viewModel);
        break;
      case ExerciseFlow.routeExerciseWritingPage:
        page = ExerciseWritingScreen(widget._exercise!, _viewModel);
        break;
      // case routeDeviceSetupConnectingPage:
      //   page = WaitingPage(
      //     message: 'Connecting...',
      //     onWaitComplete: _onConnectionEstablished,
      //   );
      //   break;
      // case routeDeviceSetupFinishedPage:
      //   page = FinishedPage(
      //     onFinishPressed: _exitSetup,
      //   );
      //   break;
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  PreferredSizeWidget _buildFlowAppBar() {
    return AppBar(
        leading: IconButton(
          onPressed: _onExitPressed,
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text('Exercise'),
        actions: [
          FlatButton(
            textColor: Colors.white,
            onPressed: () {},
            child: Text("$_totalPoints"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        bottom: MyLinearProgressIndicator(
          backgroundColor: Colors.grey,
          value: _exerciseProgress,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ));
  }
}

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  final double _kMyLinearProgressIndicatorHeight = 12.0;

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size(double.infinity, _kMyLinearProgressIndicatorHeight);

  MyLinearProgressIndicator({
    required double value,
    required Color backgroundColor,
    required Animation<Color> valueColor,
  }) : super(
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        );
}
