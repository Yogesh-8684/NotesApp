import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/Screens/showNote.dart';
import 'package:todo/DataBase/sqlFlite.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  // defining controller for Note field
  final note = TextEditingController();

  // creating widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            FutureBuilder(
              future: Sql(version: 1, table: 'notes').getRecords(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                //Adding check that if the snapshot has data in it and it is not empty (even if a blank row is there)
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final docs = snapshot.data!;

                  // Setting up date format
                  final date = DateFormat('dd/MM/yyyy hh:mm');

                  return Expanded(
                    // Using Gridview builder to build widget as per index basis on demand
                    child: GridView.builder(
                      itemBuilder: (context, i) => Card(
                        color: Colors.grey.shade700,
                        child: GestureDetector(
                          onTap: () {
                            // navigate to next screen to read note in full length
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ShowNote(
                                  subject: docs[i]['title'],
                                  date: date.format(
                                      DateTime.parse(docs[i]['clock'])));
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  date.format(DateTime.parse(docs[i]['clock'])),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Expanded(
                                  child: Text(
                                    docs[i]['title'],
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 5,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await Sql(
                                                    version: 1, table: 'notes')
                                                .deleteColumn(
                                                    '${snapshot.data![i]['id']}');
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemCount: docs.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12),
                    ),
                  );
                }

                // Widget to show when snapshot is empty
                return Expanded(
                  child: Column(
                    children: [
                      const Spacer(
                        flex: 1,
                      ),
                      Center(
                          child: Column(
                        children: [
                          Image.asset('images/empty.png'),
                          const Text(
                            'No notes found',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      )),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // FAB button to add notes
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showPopUp();
          },
          backgroundColor: Colors.grey.shade700,
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }

  // Custom dialog box to show Text field for new notes
  void showPopUp() {
    showDialog(
        context: (context),
        builder: (context) => Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: note,
                      maxLines: 13,
                      decoration: InputDecoration(
                        label: const Text(
                          'Add Note',
                          style: TextStyle(color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32)),
                      width: 200,
                      child: MaterialButton(
                        onPressed: () async {
                          if (note.text.isNotEmpty) {
                            await Sql(version: 1, table: 'notes')
                                .insertDatabase(
                              note.text,
                              '',
                              '${DateTime.now()}',
                            );
                            note.clear();
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Please write note to Continue'),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        color: Colors.grey.shade700,
                        child: const Text('Add',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
