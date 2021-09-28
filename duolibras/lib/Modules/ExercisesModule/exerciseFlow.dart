import 'package:duolibras/Commons/Components/progressBar.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseMLScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseMultiChoiceScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseWritingScreen.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ExercisesCategory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ExerciseFlow extends StatefulWidget {
  // static ExerciseFlow of(BuildContext context) {
  //   return context.findAncestorStateOfType<_ExerciseFlowState>()!;
  // }

  static const routePrefixExerciseFlow = '/exercise/';
  static const routeStartExerciseFlow = "/exercise/multi_choice";
  static const routeExerciseMultiChoicePage = 'multi_choice';
  static const routeExerciseWritingPage = 'writing';
  static const routeExerciseML = 'ml';

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
      default:
        return "";
    }
  }
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

    String routeName;

    switch (widget._exercise!.category) {
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
      default:
        _didFinishExercise(null);
        return;
    }

    _navigatorKey.currentState!.pushNamed(routeName);
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

  void _exitSetup(bool? completed) {
    Navigator.of(context).pop(completed);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExitDesired,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // extendBody: true,
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
      case ExerciseFlow.routeExerciseML:
        page = ExerciseMLScreen(widget._exercise!, _viewModel);
        break;
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
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
        foregroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 100,
        leadingWidth: 0.0,
        title: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                  onPressed: () => _onExitPressed(),
                  child: Text("Desistir",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white))))),
              SizedBox(
                height: 25,
              ),
              Center(
                child: Container(
                  height: 20,
                  width: 350,
                  child: ProgressBar(
                      max: widget.exercises.length.toDouble(),
                      current: _exerciseProgress),
                ),
              ),
            ],
          ),
        ));
  }
}

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  final double _kMyLinearProgressIndicatorHeight = 20.0;

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
