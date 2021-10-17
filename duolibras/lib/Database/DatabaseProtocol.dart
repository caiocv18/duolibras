import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Models/sectionProgress.dart';

abstract class DatabaseProtocol {
  Future<User> getUser();
  Future<void> saveUser(User user);
  Future<void> updateUser(User user);
  Future<List<SectionProgress>> getModulesProgress();
  Future<void> saveSectionProgress(SectionProgress sectionProgress);
  Future<void> cleanDatabase();
}
