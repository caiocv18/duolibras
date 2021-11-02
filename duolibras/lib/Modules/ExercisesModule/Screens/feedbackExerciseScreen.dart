import 'package:duolibras/Commons/Components/baseScreen.dart';
import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'exerciseScreen.dart';

enum FeedbackStatus { Failed, Success }

class FeedbackExerciseScreen extends ExerciseStateful {
  final Tuple2<List<Exercise>, Module> exercisesAndModule;
  final ExerciseFlowDelegate delegate;

  //  Function(bool)? handleFinishFLow;
  late FeedbackStatus status;

  FeedbackExerciseScreen(this.exercisesAndModule, this.delegate);

  @override
  State<FeedbackExerciseScreen> createState() => _FeedbackExerciseScreenState();
}

class _FeedbackExerciseScreenState extends State<FeedbackExerciseScreen> {
  var hasMoreExercises = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
            bottom: false,
            child: LayoutBuilder(builder: (ctx, constraint) {
              return Stack(
                alignment: AlignmentDirectional.center,
                children: 
                [
                  Container(
                      height: constraint.maxHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              Constants.imageAssets.background_home),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SingleChildScrollView(child: 
                    _buildBody(Size(constraint.maxWidth, constraint.maxHeight), context)
                  )
                ],
              );
            })
          ));
  }

  Widget _createButtons(
      ExerciseViewModel viewModel, BuildContext ctx, Size containerSize) {
    final titleButton = widget.status == FeedbackStatus.Success
        ? "Tentar próximo nível"
        : "Tentar novamente";

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
              widget.status == FeedbackStatus.Success
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
    final msg = widget.status == FeedbackStatus.Success
        ? (hasMoreExercises
            ? "Parabéns! Você completou o módulo!"
            : "Parabéns, você já é um experte nesse assunto!")
        : "Oh não, vamos práticar um pouco?";

    final imageName = widget.status == FeedbackStatus.Success
        ? Constants.imageAssets.happyFeedback : Constants.imageAssets.sadFace;
        
    return BaseScreen<ExerciseViewModel>(
      parameters: Tuple2(widget.exercisesAndModule, widget.delegate),
      onModelReady: (model) {
        model.hasMoreExercises(context).then((value) {
          setState(() {
            hasMoreExercises = value;
          });
        });
      },
      builder: (_, viewModel, __) => 
      Container(
        width: double.infinity,
        child: viewModel.state == ScreenState.Loading
            ? _createLoadingWidget()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: containerSize.width * 0.95,
                      child: QuestionWidget(msg)),
                  SizedBox(height: containerSize.height * 0.05),
                  Container(
                      height: containerSize.height * 0.35,
                      width: containerSize.width * 0.54,
                      child:
                          Image.asset(imageName)),
                  SizedBox(height: containerSize.height * 0.05),
                  _createButtons(viewModel, ctx, containerSize),
                  SizedBox(height: containerSize.height * 0.05),
                ],
              ),
      ),
    );
  }

}
