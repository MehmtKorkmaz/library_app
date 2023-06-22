import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:databasedemo/services/database.dart';
import 'package:flutter/widgets.dart';

import '../models/book_model.dart';

class BooksViewModel extends ChangeNotifier {
  static const String _collectionPath = 'books';
  // this class contains bookview's class information

  Database _database = Database();

  getBookList() {
    const String booksRef = 'books';

    // stream<QuerySnapshot> --> stream<List<DocumentSnapshot>> --> stream<List<Book>>
    Stream<List<DocumentSnapshot>> streamListDocument = _database
        .getBookListFromApi(booksRef)
        .map((querySnapshot) => querySnapshot.docs);

    // Stream<List<DocumentSnapshot>> --> Stream<List<Book>>

    var streamListBook = streamListDocument.map((listOfDocSnapshot) =>
        listOfDocSnapshot
            .map((docSnap) => Book.fromMap(docSnap.data() as Map))
            .toList());
    return streamListBook;
  }

  Future<void> deleteBook(Book book) async {
    await _database.deleteDocument(referencePath: _collectionPath, id: book.id);
  }
}
