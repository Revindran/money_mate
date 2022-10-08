// Widget catHScrolls() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: const EdgeInsets.only(left: 20),
//         child: Text(
//           "Your Recent Categories",
//           style:
//           TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
//         ),
//       ),
//       _sizedBoxVertical(),
//       StreamBuilder<QuerySnapshot>(
//           stream: _firStore
//               .collection('Users')
//               .doc(email)
//               .collection('Transactions')
//               .orderBy("TimeStamp", descending: true)
//               .snapshots(),
//           // ignore: missing_return
//           builder: (BuildContext context,
//               AsyncSnapshot<QuerySnapshot> querySnapshot) {
//             if (querySnapshot.hasError) return Center(child: Text('Has Error'));
//             if (querySnapshot.connectionState == ConnectionState.waiting) {
//               CupertinoActivityIndicator();
//             }
//             if (querySnapshot.data == null) {
//               return Center(
//                 child: Text('Error:|'),
//               );
//             }
//             if (querySnapshot.data.size == 0) {
//               return Center(
//                 child: Text(
//                   'No Transactions Data Found!',
//                   style: TextStyle(
//                       color: Colors.grey[400], fontStyle: FontStyle.italic),
//                 ),
//               );
//             } else {
//               return Container(
//                 height: 150,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: const BouncingScrollPhysics(
//                       parent: AlwaysScrollableScrollPhysics()),
//                   shrinkWrap: true,
//                   itemCount: querySnapshot.data.docs.length,
//                   itemBuilder: (context, index) {
//                     final DocumentSnapshot myTransaction =
//                     querySnapshot.data.docs[index];
//                     return Row(
//                       children: [
//                         Container(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   padding: EdgeInsets.all(10),
//                                   height: Get.height / 11,
//                                   width: Get.width / 5,
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey[200],
//                                       borderRadius: BorderRadius.circular(100)),
//                                   child: Icon(Icons.shopping_basket_outlined),
//                                 ),
//                               ),
//                               Text(
//                                 myTransaction['Category'] ?? 'N/A',
//                                 style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 myTransaction['Amount'] ?? 'N/A',
//                                 style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               );
//             }
//           }),
//     ],
//   );
// }