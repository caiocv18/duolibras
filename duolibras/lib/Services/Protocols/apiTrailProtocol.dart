import 'package:duolibras/Services/Models/trail.dart';

abstract class APITrailProtocol {
  Future<Trail> getTrail();
}
