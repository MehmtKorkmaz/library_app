import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:databasedemo/models/book_model.dart';
import 'package:databasedemo/view/ad_book_view.dart';
import 'package:databasedemo/view/books_view_model.dart';
import 'package:databasedemo/view/borrow_view.dart';
import 'package:databasedemo/view/update_book_view.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BooksViewModel>(
      create: (context) => BooksViewModel(),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          title: const Text('Book List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBookView()));
          },
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<List<Book>>(
                    stream: Provider.of<BooksViewModel>(context, listen: false)
                        .getBookList(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasError) {
                        print(asyncSnapshot.error);

                        return const Text('Error');
                      } else {
                        if (!asyncSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          List<Book> kitaplar = asyncSnapshot.data!;
                          return BuildListView(kitaplar: kitaplar);
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildListView extends StatefulWidget {
  const BuildListView({
    super.key,
    required this.kitaplar,
  });

  final List<Book> kitaplar;

  @override
  State<BuildListView> createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  bool isFiltering = false;
  List<Book> filteredList = [];
  @override
  Widget build(BuildContext context) {
    var fullList = widget.kitaplar;

    return Flexible(
      child: Column(
        children: [
          TextField(
            onChanged: (query) {
              if (query.isNotEmpty) {
                isFiltering = true;

                setState(() {
                  filteredList = fullList
                      .where((book) => book.bookName
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                });
              } else {
                WidgetsBinding.instance.focusManager.primaryFocus!.unfocus();
                setState(() {
                  isFiltering = false;
                });
              }
            },
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Search : Book Name',
                prefixIcon: const Icon(Icons.search)),
          ),
          const SizedBox(height: 5),
          Flexible(
              child: ListView.builder(
                  itemCount:
                      isFiltering ? filteredList.length : fullList.length,
                  itemBuilder: ((context, index) {
                    var list = isFiltering ? filteredList : fullList;
                    return Card(
                      elevation: 10,
                      child: Slidable(
                        startActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                              label: 'Borrowers',
                              backgroundColor: Colors.blueGrey.shade300,
                              icon: Icons.person_2_outlined,
                              onPressed: (_) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            BorrowView(book: list[index]))));
                              })
                        ]),
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                            onPressed: (_) {
                              Provider.of<BooksViewModel>(context,
                                      listen: false)
                                  .deleteBook(list[index]);
                            },
                            backgroundColor: Colors.red.shade300,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                          SlidableAction(
                            onPressed: (_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpgradeView(
                                          book: widget.kitaplar[index])));
                            },
                            backgroundColor: Colors.indigo.shade300,
                            foregroundColor: Colors.white,
                            icon: Icons.settings,
                            label: 'Update',
                          ),
                        ]),
                        child: ListTile(
                          title: Text(list[index].bookName),
                          subtitle: Text(list[index].authorName),
                        ),
                      ),
                    );
                  }))),
        ],
      ),
    );
  }
}
