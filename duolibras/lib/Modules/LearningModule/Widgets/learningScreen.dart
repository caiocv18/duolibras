import 'dart:async';

import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionWidget.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:flutter/material.dart';

abstract class LearningViewModelProtocol {
  List<String> sectionsIDs = [];
  Stream<List<Section>>? sections;
  bool hasMore = true;
  int numberOfSectionsForRequest = 4;
  int currentPage = 0;
  bool error = false;
  bool loading = false;
  bool firstFetch = true;

  Future<void> fetchSections();
}

class LearningScreen extends StatefulWidget {
  static String routeName = "/LearningScreen";

  final LearningViewModelProtocol _viewModel;

  LearningScreen(this._viewModel);

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final bottomNavigationBar = BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Container()),
      BottomNavigationBarItem(icon: Icon(Icons.score), title: Container())
    ],
  );

  final PreferredSizeWidget appBar = AppBarWidget();

  List<Section> sections = [];

  @override
  initState() {
    widget._viewModel.sections!.listen((newSections) {
      setState(() {
        this.sections = newSections;
      });
    });
  }

  Widget _buildBody() {
    final _mediaQuery = MediaQuery.of(context);

    if (sections.isEmpty) {
      if (widget._viewModel.firstFetch) {
        widget._viewModel.firstFetch = false;
        widget._viewModel.loading = true;
        widget._viewModel.fetchSections();
      }

      if (widget._viewModel.loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (widget._viewModel.error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              widget._viewModel.loading = true;
              widget._viewModel.error = false;
              widget._viewModel.fetchSections();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading Sections, tap to try agin"),
          ),
        ));
      }
    } else {
      return Center(
        child: Column(
          children: [
            Container(
                height: _mediaQuery.size.height -
                    (kBottomNavigationBarHeight +
                        _mediaQuery.padding.bottom +
                        appBar.preferredSize.height +
                        _mediaQuery.padding.top),
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    itemCount:
                        sections.length + (widget._viewModel.hasMore ? 1 : 0),
                    itemBuilder: (ctx, index) {
                      if (index == sections.length - 1 &&
                          widget._viewModel.hasMore) {
                        widget._viewModel.fetchSections();
                      }

                      if (index == sections.length) {
                        if (widget._viewModel.error) {
                          return Center(
                              child: InkWell(
                            onTap: () {
                              setState(() {
                                widget._viewModel.loading = true;
                                widget._viewModel.error = false;
                                widget._viewModel.fetchSections();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  "Error while loading sections, tap to try agin"),
                            ),
                          ));
                        } else {
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ));
                        }
                      }
                      final section = sections[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: SectionWidget(
                            section, widget._viewModel as SectionsViewModel),
                      );
                    })),
          ],
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Duolibras"),
          actions: [IconButton(icon: Icon(Icons.person), onPressed: () => {})],
        ),
        bottomNavigationBar: bottomNavigationBar,
        body: _buildBody());
  }
}
