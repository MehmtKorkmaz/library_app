import 'dart:io';

import 'package:databasedemo/models/borrowers_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/book_model.dart';
import '../services/calculator.dart';
import 'borrow_view_model.dart';

class BorrowView extends StatefulWidget {
  const BorrowView({super.key, required this.book});
  final Book book;

  @override
  State<BorrowView> createState() => _BorrowViewState();
}

class _BorrowViewState extends State<BorrowView> {
  @override
  Widget build(BuildContext context) {
    List<Borrowers> borrowList = widget.book.borrows!;
    return ChangeNotifierProvider<BorrowViewModel>(
        create: (context) => BorrowViewModel(),
        builder: (context, _) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  var newBorrowInfo = await showModalBottomSheet<Borrowers>(
                      backgroundColor: Colors.deepPurple[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      builder: (BuildContext context) {
                        return const BorrowSignPage();
                      },
                      context: context);
                  if (newBorrowInfo != null) {
                    setState(() {
                      borrowList.add(newBorrowInfo);
                    });
                    context
                        .read<BorrowViewModel>()
                        .updateBook(book: widget.book, borrowList: borrowList);
                  }
                },
                child: const Icon(Icons.add),
              ),
              backgroundColor: Colors.blueGrey[100],
              appBar: AppBar(
                title: Text('${widget.book.bookName} '),
              ),
              body: ListView.builder(
                  itemCount: borrowList.length,
                  itemBuilder: (context, index) {
                    return Flexible(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png'),
                                ),
                                title: Text(
                                    ' ${borrowList[index].name} ${borrowList[index].surName}'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ));
  }
}

class BorrowSignPage extends StatefulWidget {
  const BorrowSignPage({super.key});

  @override
  State<BorrowSignPage> createState() => _BorrowSignPageState();
}

class _BorrowSignPageState extends State<BorrowSignPage> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController surnameCtr = TextEditingController();
  TextEditingController borrowDateCtr = TextEditingController();
  TextEditingController returnDateCtr = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? _image;
  String photoUrl =
      'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png';
  Future<void> imageFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });

    if (_image != null) {
      photoUrl = await uploadImage(_image!);
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String path = '${DateTime.now().millisecondsSinceEpoch}';

    TaskSnapshot uploadTask = await FirebaseStorage.instance
        .ref()
        .child('photos')
        .child(path)
        .putFile(_image!);
    String uploadedImageUrl = await uploadTask.ref.getDownloadURL();
    return uploadedImageUrl;
  }

  @override
  void dispose() {
    nameCtr.dispose();
    surnameCtr.dispose();
    borrowDateCtr.dispose();
    returnDateCtr.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? borrowSelectedDate;
    DateTime? returnSelectedDate;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -10,
                        child: IconButton(
                            onPressed: imageFromGallery,
                            icon: Icon(
                              Icons.photo_camera_rounded,
                              color: Colors.grey.shade300,
                              size: 30,
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                          height: height * 0.05,
                          width: width * 0.5,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name can't be empty";
                              } else {}
                            },
                            controller: nameCtr,
                            decoration: const InputDecoration(
                                hintText: 'Name',
                                icon: Icon(Icons.person_2_outlined)),
                          )),
                      SizedBox(
                          height: height * 0.1,
                          width: width * 0.5,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Surname can't be empty";
                              } else {}
                            },
                            controller: surnameCtr,
                            decoration: const InputDecoration(
                                hintText: 'Surname',
                                icon: Icon(Icons.person_2_outlined)),
                          ))
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: height * 0.1,
                    width: width * 0.4,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Borrow date can't be empty";
                        } else {}
                      },
                      controller: borrowDateCtr,
                      onTap: () async {
                        borrowSelectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(-1000),
                            lastDate: DateTime.now());
                        if (borrowSelectedDate == null) {
                        } else {
                          borrowDateCtr.text =
                              Calculator.dateTimeToString(borrowSelectedDate!);
                        }
                        ;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Borrow Date',
                          icon: Icon(Icons.calendar_month)),
                    )),
                SizedBox(
                    height: height * 0.1,
                    width: width * 0.4,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Return date can't be empty";
                        } else {}
                      },
                      controller: returnDateCtr,
                      onTap: () async {
                        returnSelectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(-1000),
                            lastDate: DateTime.now());
                        if (returnSelectedDate == null) {
                        } else {
                          returnDateCtr.text =
                              Calculator.dateTimeToString(returnSelectedDate!);
                        }
                        ;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Return Date',
                          icon: Icon(Icons.calendar_month)),
                    ))
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Borrowers newBorrowInfo = Borrowers(
                        nameCtr.text,
                        Calculator.datetimeToTimestamp(borrowSelectedDate!),
                        surnameCtr.text,
                        Calculator.datetimeToTimestamp(returnSelectedDate!),
                        photoUrl);

                    Navigator.pop(context, newBorrowInfo);
                  }
                },
                child: const Icon(Icons.save))
          ],
        ),
      ),
    );
  }
}
