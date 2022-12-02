import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecordList extends StatefulWidget {
  const RecordList({Key? key}) : super(key: key);

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '일기 리스트',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO
          },
          child: const Icon(Icons.add),
        ),
        body: RecordListWidget());
  }

  Widget showRecordList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      setState(() {
        // getRecordList();
        isLoading = false;
      });
      return const Text('done');
    }
  }

  void getRecordList() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('records').get();
    print(snapshot.docs);
    isLoading = false;
  }
}

class RecordListWidget extends StatelessWidget {
  const RecordListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('records')
          .where('user', isEqualTo: 'user1@example.com') // TODO
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return GridView.builder(
          itemCount: docs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridTile(
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      onTap: () {
                        print(docs[index].id); // TODO
                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.network(
                            'https://picsum.photos/200', // TODO
                            width: 200,
                            height: 200,
                          ),
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(docs[index]['date']),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            );
          },
        );
      },
    );
  }
}
