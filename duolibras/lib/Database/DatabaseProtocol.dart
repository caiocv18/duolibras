import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Models/Trail.dart';
import 'package:duolibras/Network/Models/User.dart';

abstract class DatabaseProtocol {
  Future<User> getUser();
  Future<bool> saveUser(User user);
  Future<User> getTrail();
  Future<bool> saveTrail(Trail trail);
  Future<User> getSection();
  Future<bool> saveSection(Section section);
}
