import 'package:databasedemo/models/borrowers_model.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../services/calculator.dart';
import '../services/database.dart';

class BorrowViewModel extends ChangeNotifier {
  final Database _database = Database();
  static const String _collectionPath = 'books';

  Future<void> updateBook(
      {required List<Borrowers> borrowList, required Book book}) async {
    Book newBook = Book(
        book.id, book.bookName, book.authorName, book.publishDate,
        borrows: borrowList);

    await _database.setBookData(_collectionPath, newBook.toMap());
  }
}
