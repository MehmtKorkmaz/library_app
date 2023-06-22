import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:databasedemo/models/borrowers_model.dart';

class Book {
  final String id;
  final String bookName;
  final String authorName;
  final Timestamp publishDate;
  final List<Borrowers>? borrows;

  Book(this.id, this.bookName, this.authorName, this.publishDate, {this.borrows});

  // Map to Object
  factory Book.fromMap(Map map) {
    var borrowsListAsMap = map['borrows'] as List;
    List<Borrowers> borrows = borrowsListAsMap
        .map(
          (borrowAsMap) => Borrowers.fromJson(borrowAsMap),
        )
        .toList();
  
    return Book(map['id'], map['bookName'], map['authorName'],
        map['publishDate'], borrows: borrows);
  }

  // Object to Map

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> borrows =
        this.borrows!.map((borrowInfo) => borrowInfo.toJson()).toList();
    return {
      'id': id,
      'bookName': bookName,
      'authorName': authorName,
      'publishDate': publishDate,
      'borrows': borrows
    };
  }
}
