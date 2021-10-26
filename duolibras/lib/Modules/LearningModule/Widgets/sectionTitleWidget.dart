
import 'package:duolibras/Services/Models/section.dart';
import 'package:flutter/material.dart';

class SectionTitleWidget extends StatefulWidget {
  final ScrollController _scrollController;
  final List<Section> _allSections;
  final Map<int, int> _modulesForSections;

  SectionTitleWidget(this._scrollController, this._allSections, this._modulesForSections);

  @override
  State<StatefulWidget> createState() {
    return _SectionTitleWidgetState();
  }

}

class _SectionTitleWidgetState extends State<SectionTitleWidget> {
  late var currentSection = "";

  @override
  void initState() {
    super.initState();

    widget._scrollController.addListener(() {
      final offset = widget._scrollController.offset;

      var totalSectionOffset = 0;

      for (var i = 0; i < widget._allSections.length; i++) {
        final sectionSize = widget._modulesForSections[i];
        if (sectionSize == null) {return;}
        final maxSectionOffset = (sectionSize * 200) + totalSectionOffset;
        if (offset < maxSectionOffset) {
          setState(() {
            currentSection = widget._allSections[i].title;
          });
          break;
        } else {
          totalSectionOffset = maxSectionOffset;
        }
      }
    });

    Future.delayed(Duration(milliseconds: 1000)).then((value) => {
        setState(() {
          try {
            currentSection = widget._allSections.first.title;
          } catch (e) {
            currentSection = "";
          }
        })
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(currentSection,
        style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontFamily: "Nunito",
        fontWeight: FontWeight.w600)),
      );
  }

}