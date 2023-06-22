import 'package:cloud_firestore/cloud_firestore.dart';

class Borrowers {
  final String name;
  final String surName;
  final Timestamp borrowDate;
  final Timestamp returnDate;

  final String photoUrl;

  Borrowers(
    this.name,
    this.borrowDate,
    this.surName,
    this.returnDate,
    this.photoUrl,
  );

  // object to map
  Map<String, dynamic> toJson() => {
        'name': name,
        'surName': surName,
        'borrowDate': borrowDate,
        'returnDate': returnDate,
        'photoUrl': photoUrl
      };

  //map to object

  factory Borrowers.fromJson(Map map) => Borrowers(
        map['name'],
        map['borrowDate'],
        map['surName'],
        map['returnDate'],
        map['photoUrl'],
      );
}
