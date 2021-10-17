import 'package:duolibras/Network/Models/sectionProgress.dart';

abstract class APISectionProgressProtocol {
  Future<List<SectionProgress>> getSectionsProgress();
  Future<bool> postSectionProgress(SectionProgress sectionProgress);
}
