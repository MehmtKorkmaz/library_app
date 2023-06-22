import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:databasedemo/models/book_model.dart';
import 'package:databasedemo/models/borrowers_model.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

// it takes book stream from FirebaseFirestore
  Stream<QuerySnapshot> getBookListFromApi(String referencePath) {
    return _firestore.collection(referencePath).snapshots();
  }

// delete data from Firestore

  Future<void> deleteDocument({String? referencePath, String? id}) async {
    await _firestore.collection(referencePath!).doc(id).delete();
  }

// add and update data in Firestore

  Future<void> setBookData(
      String collectionPath, Map<String, dynamic> bookAsMap) async {
    await _firestore
        .collection(collectionPath)
        .doc(Book.fromMap(bookAsMap).id)
        .set(bookAsMap);
  }
}
