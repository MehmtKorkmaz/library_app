import 'package:databasedemo/models/book_model.dart';
import 'package:databasedemo/view/update_book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/calculator.dart';

class UpgradeView extends StatefulWidget {
  const UpgradeView({super.key, required this.book});
  final Book book;

  @override
  State<UpgradeView> createState() => _UpgradeViewState();
}

class _UpgradeViewState extends State<UpgradeView> {
  TextEditingController bookCtr = TextEditingController();
  TextEditingController authorCtr = TextEditingController();
  TextEditingController publishCtr = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var _selectedDate;
  @override
  void dispose() {
    bookCtr.dispose();
    authorCtr.dispose();
    publishCtr.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    bookCtr.text = widget.book.bookName;
    authorCtr.text = widget.book.authorName;
    publishCtr.text = Calculator.dateTimeToString(
        Calculator.datetimeFromTimestamp(widget.book.publishDate));
    return ChangeNotifierProvider<UpdateBookViewModel>(
      create: (_) => UpdateBookViewModel(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Add New Book'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: bookCtr,
                      decoration: const InputDecoration(
                          hintText: 'Book Name', icon: Icon(Icons.book)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Book Name Can't Be Empty";
                        } else
                          return null;
                      },
                    ),
                    TextFormField(
                      controller: authorCtr,
                      decoration: const InputDecoration(
                          hintText: 'Author Name', icon: Icon(Icons.edit)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Author Name Can't Be Empty";
                        } else
                          return null;
                      },
                    ),
                    TextFormField(
                      onTap: () async {
                        _selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(-1000),
                            lastDate: DateTime.now());
                        if (_selectedDate == null) {
                        } else {
                          publishCtr.text =
                              Calculator.dateTimeToString(_selectedDate);
                        }
                        ;
                      },
                      controller: publishCtr,
                      decoration: const InputDecoration(
                          hintText: 'Publish Date',
                          icon: Icon(Icons.date_range)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Publish Date Can't Be Empty";
                        } else
                          return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            await context
                                .read<UpdateBookViewModel>()
                                .updateBook(
                                    bookCtr.text,
                                    authorCtr.text,
                                    _selectedDate ??
                                        Calculator.datetimeFromTimestamp(
                                            widget.book.publishDate),
                                    widget.book);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
