import 'package:duolibras/Commons/Components/baseScreen.dart';
import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Commons/ViewModel/ScreenState.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

enum FeedbackStatus { Failed, Success }

class FeedbackExerciseScreen extends StatefulWidget {
  final Tuple2<List<Exercise>, Module> exercisesAndModule;
  final ExerciseFlowDelegate delegate;

  //  Function(bool)? handleFinishFLow;

  FeedbackExerciseScreen(this.exercisesAndModule, this.delegate);

  @override
  State<FeedbackExerciseScreen> createState() => _FeedbackExerciseScreenState();
}

class _FeedbackExerciseScreenState extends State<FeedbackExerciseScreen> {
  FeedbackStatus status = FeedbackStatus.Success;

  // @override
  // initState() {
  //   locator<ExerciseViewModel>().hasMoreExercises();
  // }
  var hasMoreExercises = true;

  Widget _createButtons(
      ExerciseViewModel viewModel, BuildContext ctx, Size containerSize) {
    final titleButton = status == FeedbackStatus.Success
        ? "Tentar Próxima dificuldade"
        : "Tentara novamente";

    return Column(children: [
      if (hasMoreExercises) ...[
        Container(
          height: containerSize.height * 0.075,
          width: containerSize.width * 0.85,
          child: ExerciseButton(
            child: Center(
              child: Text(
                titleButton,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Gameplay',
                ),
              ),
            ),
            size: 25,
            color: HexColor.fromHex(
                "#93CAFA"), //Colors.white, //Color(0xFFCA3034),
            onPressed: () {
              status == FeedbackStatus.Success
                  ? viewModel.goToNextLevel(ctx)
                  : viewModel.tryModuleAgain();
            },
          ),
        ),
        SizedBox(height: containerSize.height * 0.05),
      ],
      Container(
        height: containerSize.height * 0.075,
        width: containerSize.width * 0.85,
        child: ExerciseButton(
          child: Center(
            child: Text(
              "Voltar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: 'Gameplay',
              ),
            ),
          ),
          size: 25,
          color:
              HexColor.fromHex("#93CAFA"), //Colors.white, //Color(0xFFCA3034),
          onPressed: () {
            viewModel.finishModuleFlow();
          },
        ),
      ),
    ]);
  }

  Widget _createLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody(Size containerSize, BuildContext ctx) {
    final msg = status == FeedbackStatus.Success
        ? (hasMoreExercises
            ? "Parabéns! Você completou o módulo!"
            : "Paranéns, você já é um experte nesse assunto!")
        : "Oh não, vamos práticar um pouco?";
    return BaseScreen<ExerciseViewModel>(
      parameters: Tuple2(widget.exercisesAndModule, widget.delegate),
      onModelReady: (model) {
        model.hasMoreExercises(context).then((value) {
          setState(() {
            hasMoreExercises = value;
          });
        });
      },
      builder: (_, viewModel, __) => Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(234, 234, 234, 1),
        child: SafeArea(
            child: viewModel.state == ScreenState.Loading
                ? _createLoadingWidget()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: containerSize.height * 0.08,
                          width: containerSize.width * 0.95,
                          child: QuestionWidget(msg)),
                      SizedBox(height: containerSize.height * 0.05),
                      Container(
                          height: containerSize.height * 0.35,
                          width: containerSize.width * 0.54,
                          child:
                              Image.asset("assets/images/moduleCompleted.png")),
                      SizedBox(height: containerSize.height * 0.05),
                      _createButtons(viewModel, ctx, containerSize),
                      SizedBox(height: containerSize.height * 0.05),
                    ],
                  )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    final containerHeight = _mediaQuery.size.height -
        AppBar().preferredSize.height -
        _mediaQuery.padding.top -
        _mediaQuery.padding.bottom;

    return Scaffold(
      body: _buildBody(Size(_mediaQuery.size.width, containerHeight), context),
    );
  }
}
