import 'package:duolibras/Network/Models/Trail.dart';

abstract class APITrailProtocol {
  Future<Trail> getTrailFromId(String trailId);
}
