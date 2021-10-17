import 'package:duolibras/Network/Protocols/APIExerciseProtocol.dart';
import 'package:duolibras/Network/Protocols/APIModuleProgressProtocol.dart';
import 'package:duolibras/Network/Protocols/APIModuleProtocol.dart';
import 'package:duolibras/Network/Protocols/APISectionProtocol.dart';
import 'package:duolibras/Network/Protocols/APIStorageProtocol.dart';
import 'package:duolibras/Network/Protocols/APITrailProtocol.dart';
import 'package:duolibras/Network/Protocols/APIUserProtocol.dart';

abstract class ServicesProtocol extends APIExerciseProtocol
    with
        APIModuleProtocol,
        APISectionProtocol,
        APITrailProtocol,
        APIUserProtocol,
        APISectionProgressProtocol,
        APIStorageProtocol {}
