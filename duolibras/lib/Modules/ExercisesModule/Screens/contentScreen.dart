import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseAppBarWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'exerciseScreen.dart';

class ContentScreen extends ExerciseStateful{

  final ExerciseViewModel _viewModel;
  final List<Exercise> _exercises;

  ContentScreen(this._viewModel, this._exercises);
  
  @override
  State<StatefulWidget> createState() => _ContentScreenState();
  
}

class _ContentScreenState extends State<ContentScreen> {
  final controller = PageController(viewportFraction: 1.0, keepPage: true);
  
  @override
  void initState() {
    super.initState();

    widget.handleNextExercise = () {
      _submitAnswer(this.context);
    };
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final appBarHeight = ExerciseAppBarWidget.appBarHeight;
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final containerHeight = mediaQuery.size.height - (appBarHeight + paddingTop);
    final containerSize = Size(mediaQuery.size.width, containerHeight);

    final pages = _buildPages(containerSize);
    return Scaffold(
      body: Container(
        height: containerHeight,
        color: Color.fromRGBO(234, 234, 234, 1),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              Container(
                height: containerSize.height * 0.85,
                child: PageView.builder(
                  controller: controller,
                  // itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
              _buildPageIndicator(),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages(Size containerSize) {
    return 
    List.generate(widget._exercises.length,
        (index) {
          final exercise = widget._exercises[index];
          return Container(
              child: 
                Column(
                  children: [
                    _buildTitleText(exercise),
                    SizedBox(height: 15),
                    _buildAnswerText(exercise, containerSize),
                    SizedBox(height: 15),
                    _buildDescriptionText(exercise, containerSize),
                    SizedBox(height: 15),
                    _buildImage(exercise, containerSize)
                  ],
                )
          );
        }
    );
  }

  Widget _buildTitleText(Exercise exercise) {
    final title = exercise.title;
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: constraint.maxWidth * 0.89,
        child:  Center(
          child: Text(
            title?.replaceAll(new RegExp('_n'), '\n') ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontFamily: "Nunito", fontWeight: FontWeight.w700),
          ),
        )
      );
    });
  }

  Widget _buildAnswerText(Exercise exercise, Size containerSize) {
    final answer = exercise.correctAnswer;
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: containerSize.width * 0.62,
        height: containerSize.height * 0.14,
        child:  Center(
          child: Text(
            answer,
            style: TextStyle(fontSize: 24, fontFamily: "Nunito", fontWeight: FontWeight.w700),
          ),
        ),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(20))),
      );
    });
  }

  Widget _buildDescriptionText(Exercise exercise, Size containerSize) {
    final description = exercise.description ?? "";
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: containerSize.width * 0.62,
        height: containerSize.height * 0.14,
        child:  Center(
          child: Text(
            description,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontFamily: "Nunito", fontWeight: FontWeight.w700),
          ),
        ),
      );
    });
  }

    Widget _buildImage(Exercise exercise, Size containerSize) {
    return Center(
      child: Container(
          width: containerSize.width * 0.62,
          height: containerSize.height * 0.35,
          decoration: 
          BoxDecoration(color: Colors.white, 
            border: Border.all(width: 5, color: Color.fromRGBO(147, 202, 250, 1)), 
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Image.network(exercise.mediaUrl)), 
    );
    
  }

  Widget _buildPageIndicator() {
    return 
    SmoothPageIndicator(  
      controller: controller,  // PageController  
      count:  widget._exercises.length,  
      effect:  WormEffect(
        dotColor: Color.fromRGBO(196, 196, 196, 1),
        activeDotColor: Color.fromRGBO(73, 130, 246, 1)),  // your preferred effect  
      onDotClicked: (index){  
         controller.jumpToPage(index);   
      }  
   );  
  }

  void _submitAnswer(BuildContext ctx) {
    widget._viewModel.didSubmitTextAnswer("", widget._exercises.last.id, this.context);
  }
}

