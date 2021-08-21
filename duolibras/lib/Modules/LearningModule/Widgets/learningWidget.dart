import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionWidget.dart';
import 'package:flutter/material.dart';

class LearningWidget extends StatelessWidget {
  final sectionsTitle = ["Profissões", "Verbos", "Comida"];
  final numOfModules = [2, 3, 4];

  final bottomNavigationBar = BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Container()),
      BottomNavigationBarItem(icon: Icon(Icons.score), title: Container())
    ],
  );

  final appBar = AppBar(
    title: Text("Duolibras"),
    actions: [IconButton(icon: Icon(Icons.person), onPressed: () => {})],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Duolibras"),
          actions: [IconButton(icon: Icon(Icons.person), onPressed: () => {})],
        ),
        bottomNavigationBar: bottomNavigationBar,
        body: Center(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height -
                      (kBottomNavigationBarHeight +
                          MediaQuery.of(context).padding.bottom +
                          appBar.preferredSize.height +
                          MediaQuery.of(context).padding.top),
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      itemCount: 3,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SectionWidget(
                              sectionsTitle[index], numOfModules[index]),
                        );
                      })),
            ],
          ),
        ));
  }
}
