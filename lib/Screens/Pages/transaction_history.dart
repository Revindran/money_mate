import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class TransactionHistory extends StatelessWidget {
  final storage = GetStorage();
  final _firStore = FirebaseFirestore.instance;

   TransactionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var email = storage.read('email');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'History',
          style:
              TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firStore
              .collection('Users')
              .doc(email)
              .collection('Transactions')
              .orderBy("TimeStamp", descending: true)
              .snapshots(),
          // ignore: missing_return
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {
            if (querySnapshot.hasError) return const Center(child: Text('Has Error'));
            if (querySnapshot.connectionState == ConnectionState.waiting) {
              const CupertinoActivityIndicator();
            }
            if (querySnapshot.data == null) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (querySnapshot.data!.size == 0) {
              return _noTransactions();
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                shrinkWrap: true,
                itemCount: querySnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot myTransaction =
                      querySnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: myTransaction['Type'] == 'Income'
                                ? Colors.green[50]
                                : Colors.red[50],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/${myTransaction['Category'].toString().toLowerCase()}_icon.png"),
                                  width: 30,
                                  height: 30,
                                  color: null,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(myTransaction['SOI'] ?? 'N/A'),
                                    Text(
                                        myTransaction['SelectedDate'] ?? 'N/A'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    myTransaction['Type'] == 'Income'
                                        ? Text(
                                            myTransaction['Amount'] ?? 'N/A',
                                            style:
                                                const TextStyle(color: Colors.green),
                                          )
                                        : Text(
                                            myTransaction['Amount'] ?? 'N/A',
                                            style: const TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Icon(
                                      CupertinoIcons.arrow_turn_down_right,
                                      color: Colors.grey[900],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

Widget _noTransactions() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Image(
        image: AssetImage('assets/empty_notes.png'),
      ),
      Text(
        'No Transactions Found in your History',
        style:
            TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      ),
    ],
  ));
}
