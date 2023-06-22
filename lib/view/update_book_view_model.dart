import 'package:databasedemo/models/book_model.dart';
import 'package:databasedemo/services/calculator.dart';
import 'package:databasedemo/services/database.dart';
import 'package:flutter/material.dart';

class UpdateBookViewModel extends ChangeNotifier {
  Database _database = Database();
  String _collectionPath = 'books';

  Future<void> updateBook(String bookName, String authorName,
      DateTime publishDate, Book book) async {
    Book newBook = Book(book.id, bookName, authorName,
        Calculator.datetimeToTimestamp(publishDate),
        borrows: book.borrows);

    await _database.setBookData(_collectionPath, newBook.toMap());
  }
}
