import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Firebase/FirebaseErrors.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/Trail.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/User.dart' as myUser;
import 'package:duolibras/Network/Protocols/ServicesProtocol.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService extends ServicesProtocol {
  final firestoreInstance = FirebaseFirestore.instance;

//Internal Methods
  DocumentReference<Map<String, dynamic>> _getUserFromFirebase() {
    var firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw FirebaseErrors.UserNotFound;
    }
    SharedFeatures.instance.isLoggedIn = true;
    return firestoreInstance
        .collection(Constants.firebaseService.usersCollection)
        .doc(firebaseUser.uid);
  }

  DocumentReference<Map<String, dynamic>> _getTrailFromFirebase() {
    return firestoreInstance
        .collection(Constants.firebaseService.trailsCollection)
        .doc("pwL7CCbNNThasG5tRASF");
  }

  Future<List<Section>> _getSectionsFromFirebase() async {
    var completer = Completer<List<Section>>();

    _getTrailFromFirebase()
        .collection(Constants.firebaseService.sectionsCollection)
        .get()
        .then((value) => {
              completer.complete(value.docs
                  .map((e) => Section.fromMap(e.data(), e.id))
                  .toList())
            });

    return completer.future;
  }

  Future<List<Module>> _getModulesFromFirebase(String sectionId) async {
    var completer = Completer<List<Module>>();

    _getTrailFromFirebase()
        .collection(Constants.firebaseService.sectionsCollection)
        .doc(sectionId)
        .collection(Constants.firebaseService.modulesCollecion)
        .get()
        .then((value) => {
              completer.complete(value.docs
                  .map((e) => Module.fromMap(e.data(), e.id))
                  .toList())
            });

    return completer.future;
  }

  Future<List<Exercise>> _getExercisesFromFirebase(
      String sectionId, String moduleId) async {
    var completer = Completer<List<Exercise>>();

    _getTrailFromFirebase()
        .collection(Constants.firebaseService.sectionsCollection)
        .doc(sectionId)
        .collection(Constants.firebaseService.modulesCollecion)
        .doc(moduleId)
        .collection(Constants.firebaseService.exercisesCollection)
        .get()
        .then((value) => {
              completer.complete(value.docs
                  .map((e) => Exercise.fromMap(e.data(), e.id))
                  .toList())
            });

    return completer.future;
  }

  Future<List<ModuleProgress>> _getModuleProgressFromFirebase() {
    var completer = Completer<List<ModuleProgress>>();

    _getUserFromFirebase()
        .collection(Constants.firebaseService.moduleProgressCollection)
        .get()
        .then((response) => {
              completer.complete(response.docs
                  .map((e) => ModuleProgress.fromMap(e.data(), e.id))
                  .toList())
            });

    return completer.future;
  }

  // Future<bool> _postModuleProgressInFirebase(
  //     List<ModuleProgress> moduleProgress) {
  //   var completer = Completer<bool>();
  //   final userDocument = _getUserFromFirebase();

  //   moduleProgress.forEach((progress) {
  //     userDocument
  //         .collection(Constants.firebaseService.moduleProgressCollection).
  //         .set(progress.toMap(), SetOptions(merge: true))
  //         .then((_) => {
  //               if (progress == moduleProgress.last) {completer.complete(true)}
  //             });
  //   });

  //   return completer.future;
  // }

  Future<bool> _postModuleProgressInFirebase(
      ModuleProgress moduleProgress) async {
    var completer = Completer<bool>();
    final userDocument = _getUserFromFirebase();

    userDocument
        .collection(Constants.firebaseService.moduleProgressCollection)
        .doc(moduleProgress.id)
        .set(moduleProgress.toMap(), SetOptions(merge: true))
        .then((_) => {completer.complete(true)});

    return completer.future;
  }

  Future<myUser.User> _postUserInFirebase(myUser.User user) {
    var completer = Completer<myUser.User>();

    firestoreInstance
        .collection(Constants.firebaseService.usersCollection)
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true))
        .then((_) => {
              this.getUser().then((user) {
                completer.complete(user);
              })
            });

    return completer.future;
  }

//Public methods
  @override
  Future<myUser.User> getUser() async {
    var completer = Completer<myUser.User>();

    _getUserFromFirebase().get().then((response) {
      if (response.data() == null) {
        completer.completeError(FirebaseErrors.UserNotFound);
      }
      completer.complete(myUser.User.fromMap(response.data()!, response.id));
    });

    return completer.future;
  }

  @override
  Future<myUser.User> postUser(myUser.User user) async {
    return _postUserInFirebase(user);
  }

  @override
  Future<Trail> getTrail() async {
    var completer = Completer<Trail>();

    _getTrailFromFirebase().get().then((response) {
      if (response.data() == null) {
        completer.completeError(FirebaseErrors.TrailNotFound);
      }
      completer.complete(Trail.fromMap(response.data()!, response.id));
    });

    return completer.future;
  }

  @override
  Future<List<Section>> getSectionsFromTrail() async {
    return _getSectionsFromFirebase();
  }

  @override
  Future<List<Module>> getModulesFromSectionId(String sectionId) async {
    return _getModulesFromFirebase(sectionId);
  }

  @override
  Future<List<Exercise>> getExercisesFromModuleId(
      String? sectionId, String moduleId) async {
    if (sectionId == null) {
      throw FirebaseErrors.SectionNotFound;
    }

    return _getExercisesFromFirebase(sectionId, moduleId);
  }

  @override
  Future<List<ModuleProgress>> getModulesProgress() async {
    return _getModuleProgressFromFirebase();
  }

  @override
  Future<bool> postModuleProgress(ModuleProgress moduleProgress) async {
    return _postModuleProgressInFirebase(moduleProgress);
  }
}
