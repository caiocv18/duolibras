import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duolibras/Network/Firebase/FirebaseErrors.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/Trail.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/User.dart' as myUser;
import 'package:duolibras/Network/Protocols/ServicesProtocol.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService extends ServicesProtocol {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Future<myUser.User> getUser() async {
    var completer = Completer<myUser.User>();
    var firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      completer.completeError(FirebaseErrors.UserNotFound);
    }

    firestoreInstance
        .collection("users")
        .doc(firebaseUser!.uid)
        .get()
        .then((response) {
      if (response.data() == null) {
        completer.completeError(FirebaseErrors.UserNotFound);
      }
      completer.complete(myUser.User.fromMap(response.data()!, response.id));
    });

    return completer.future;
  }

  @override
  Future<Exercise> getExerciseFromId(String exerciseId) async {
    var completer = Completer<Exercise>();

    firestoreInstance
        .collection("exercises")
        .doc(exerciseId)
        .get()
        .then((response) {
      if (response.data() == null) {
        completer.completeError(FirebaseErrors.ExerciseNotFound);
      }
      completer.complete(Exercise.fromMap(response.data()!, response.id));
    });

    return completer.future;
  }

  @override
  Future<Module> getModuleFromId(String moduleId) {
    var completer = Completer<Module>();

    firestoreInstance
        .collection("modules")
        .doc(moduleId)
        .get()
        .then((response) {
      if (response.data() == null) {
        completer.completeError(FirebaseErrors.ModuleNotFound);
      }
      completer.complete(Module.fromMap(response.data()!, response.id));
    });

    return completer.future;
  }

  @override
  Future<Section> getSectionFromId(String sectionId) {
    var completer = Completer<Section>();

    firestoreInstance
        .collection("sections")
        .doc(sectionId)
        .get()
        .then((response) {
      if (response.data() == null) {
        completer.completeError(FirebaseErrors.SectionNotFound);
      }
      completer.complete(Section.fromMap(response.data()!, response.id));
    });

    return completer.future;
  }

  @override
  Future<Trail> getTrailFromId(String trailId) {
    var completer = Completer<Trail>();

    firestoreInstance.collection("trails").doc(trailId).get().then((response) {
      if (response.data() == null) {
        completer.completeError(FirebaseErrors.TrailNotFound);
      }
      completer.complete(Trail.fromMap(response.data()!, response.id));
    });

    return completer.future;
  }
}
