import 'package:duolibras/Network/Protocols/APIExercisesProtocol.dart';
import 'package:duolibras/Network/Protocols/APIUserProtocol.dart';

abstract class ServicesProtocol extends APIExercisesProtocol
    with APIUserProtocol {}
