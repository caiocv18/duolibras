import 'package:duolibras/Services/Models/sectionProgress.dart';

abstract class APISectionProgressProtocol {
  Future<List<SectionProgress>> getSectionsProgress();
  Future<bool> postSectionProgress(SectionProgress sectionProgress);
}
