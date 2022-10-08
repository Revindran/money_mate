import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/inocme_expence_chart/categories_row.dart';
import 'package:money_mate/inocme_expence_chart/pie_chart_view.dart';

var storage = GetStorage();
final _firStore = FirebaseFirestore.instance;
var email = storage.read('email');

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Analytics',
          style:
              TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Income & Expenses',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 16),
                  ),
                  _sizedBoxVertical(),
                  SizedBox(
                    width: Get.width / 1.1,
                    height: Get.height / 5,
                    child: Row(
                      children: <Widget>[
                        PieChartView(),
                        const CategoriesRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _sizedBoxVertical(),
          _catHScrolls(),
          // Container(
          //   height: 100,
          //   child: AdWidget(
          //     key: UniqueKey(),
          //     ad: AdMobService.createBannerAd()..load(),
          //   ),
          // ),
        ],
      ),
    );
  }
}

Widget _sizedBoxVertical() {
  return const SizedBox(height: 20);
}

Widget _catHScrolls() {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Your Recent Categories",
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                fontSize: 16),
          ),
        ),
        _sizedBoxVertical(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firStore
                  .collection('Users')
                  .doc(email)
                  .collection('Transactions')
                  .orderBy("TimeStamp", descending: true)
                  .snapshots(),
              // ignore: missing_return
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if (querySnapshot.hasError) {
                  return const Center(child: Text('Has Error'));
                }
                if (querySnapshot.connectionState == ConnectionState.waiting) {
                  const CupertinoActivityIndicator();
                }
                if (querySnapshot.data == null) {
                  return const Center(
                    child: Text('Empty Category'),
                  );
                }
                if (querySnapshot.data!.size == 0) {
                  return _noTransactions();
                } else {
                  return SizedBox(
                    height: Get.height / 1.8,
                    child: GridView.builder(
                      itemCount: querySnapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot myTransaction =
                            querySnapshot.data!.docs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(100)),
                                child: Image(
                                  image: AssetImage(
                                      "assets/${myTransaction['Category'].toString().toLowerCase()}_icon.png"),
                                  width: 30,
                                  height: 30,
                                  color: null,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Text(
                              myTransaction['Category'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "₹ ${myTransaction['Amount']}",
                              style: TextStyle(
                                  color: myTransaction['Type'] == 'Income'
                                      ? Colors.green[500]
                                      : Colors.red[500],
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              }),
        ),
      ],
    ),
  );
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
