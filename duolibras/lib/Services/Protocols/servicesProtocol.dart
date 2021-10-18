import 'package:duolibras/Services/Protocols/apiExerciseProtocol.dart';
import 'package:duolibras/Services/Protocols/apiModuleProgressProtocol.dart';
import 'package:duolibras/Services/Protocols/apiModuleProtocol.dart';
import 'package:duolibras/Services/Protocols/apiSectionProtocol.dart';
import 'package:duolibras/Services/Protocols/apiStorageProtocol.dart';
import 'package:duolibras/Services/Protocols/apiTrailProtocol.dart';
import 'package:duolibras/Services/Protocols/apiUserProtocol.dart';

abstract class ServicesProtocol extends APIExerciseProtocol
    with
        APIModuleProtocol,
        APISectionProtocol,
        APITrailProtocol,
        APIUserProtocol,
        APISectionProgressProtocol,
        APIStorageProtocol {}
