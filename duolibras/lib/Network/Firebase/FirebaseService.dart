import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duolibras/Network/Firebase/FirebaseErrors.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/User.dart' as myUser;
import 'package:duolibras/Network/Protocols/ServicesProtocol.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService extends ServicesProtocol {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Future<List<Exercise>> getExercises() async {
    var completer = Completer<List<Exercise>>();

    firestoreInstance.collection("exercises").get().then((querysnapshot) {
      var exercises = List<Exercise>.empty();
      querysnapshot.docs.forEach((element) {
        exercises.add(Exercise.fromMap(element.data()));
      });
      completer.complete(exercises);
    });

    return completer.future;
  }

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
        .then((value) {
      if (value.data() == null) {
        completer.completeError(FirebaseErrors.UserNotFound);
      }
      completer.complete(myUser.User.fromMap(value.data()!));
    });

    return completer.future;
  }
}
