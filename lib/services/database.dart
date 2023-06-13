import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  final String? _uid;
  final CollectionReference _brewCollection =
      FirebaseFirestore.instance.collection('brews');

  DatabaseService({String? uid}) : _uid = uid;

  List<Brew?> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map(
          (doc) => doc.data() != null
              ? Brew(
                  name: (doc.data() as Map)['name'],
                  sugars: (doc.data() as Map)['sugars'],
                  strength: (doc.data() as Map)['strength'],
                )
              : null,
        )
        .toList();
  }

  Stream<List<Brew?>> get brews {
    return _brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: _uid!,
      name: (snapshot.data() as Map)['name'],
      sugars: (snapshot.data() as Map)['sugars'],
      strength: (snapshot.data() as Map)['strength'],
    );
  }

  Stream<UserData> get userData {
    return _brewCollection.doc(_uid).snapshots().map(userDataFromSnapshot);
  }

  Future updateUserData(String name, String sugars, int strength) async {
    try {
      return await _brewCollection.doc(_uid).set({
        'name': name,
        'sugars': sugars,
        'strength': strength,
      });
    } catch (error) {
      return ErrorDescription(error.toString());
    }
  }
}
