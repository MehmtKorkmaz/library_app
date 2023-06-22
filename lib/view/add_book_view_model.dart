import 'dart:ffi';

import 'package:databasedemo/models/book_model.dart';
import 'package:databasedemo/services/calculator.dart';
import 'package:databasedemo/services/database.dart';
import 'package:flutter/material.dart';

class AddBookViewModel extends ChangeNotifier {
  Database _database = Database();
  static const String _collectionPath = 'books';

  Future<void> addNewBook(
      String bookName, String authorName, DateTime publishDate) async {
    Book newBook = Book(DateTime.now().toIso8601String(), bookName, authorName,
        Calculator.datetimeToTimestamp(publishDate),  borrows: []);

    await _database.setBookData(_collectionPath, newBook.toMap());
  }
}
