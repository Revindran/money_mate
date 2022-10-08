import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/Components/bottom_bar.dart';
import 'package:money_mate/Components/validator.dart';
import 'package:money_mate/controllers/category_controller.dart';

class AddTransactions extends StatefulWidget {
  @override
  _AddTransactionsState createState() => _AddTransactionsState();
}

late bool isLoading;

class _AddTransactionsState extends State<AddTransactions> {
  DateTime selectedDate = DateTime.now();
  var storage = GetStorage();
  var email;
  var isAlreadyAddedMoney;
  var isAlreadyAddedMoneyEmpty;
  late String itemSelected = "",
      sDate,
      selCategory,
      _dropMemoryDownValue;
  var selectedItem = 0;
  final _controller = Get.put<CatController>(CatController());
  final amountString = TextEditingController();
  final sofIncome = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _dropMemoryDownValue = "";
  }

  @override
  Widget build(BuildContext context) {
    email = storage.read('email');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Add New Transaction',
          style:
          TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
        ),
      ),
      body: Center(
        child: Container(
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery
                .of(context)
                .size
                .width / 1.1,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: amountString,
                    validator: Validator().amount,
                    decoration: InputDecoration(
                      labelText: 'Enter Amount',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[100] as Color,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: sofIncome,
                    validator: Validator().notEmpty,
                    decoration: InputDecoration(
                      labelText: 'Source',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[100] as Color,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100]),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 1.1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Transaction type",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          DropdownButton(
                            hint: _dropMemoryDownValue == null
                                ? Text('Select Transaction type',
                                style: TextStyle())
                                : Text(
                              _dropMemoryDownValue,
                              style: TextStyle(color: Colors.blue),
                            ),
                            isExpanded: true,
                            iconSize: 30.0,
                            style: TextStyle(color: Colors.blue),
                            items: [
                              'Income',
                              'Expanse',
                            ].map(
                                  (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                    () {
                                  _dropMemoryDownValue = val.toString();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => _catType(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100]),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            selectedItem == 0
                                ? "*Please Select Category Type"
                                : _controller.catList[selectedItem].title
                                .toString(),
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                            SizedBox(
                              width: 16,
                            ), // Refer step 3
                            Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  isLoading
                      ? Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                      : Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5.0)
                                  ]),
                              height: 50,
                              width: 50,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_sharp,
                                    size: 30,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          if (amountString.text == '' &&
                              sofIncome.text == '') {
                            Get.snackbar('Please Fill all the fields',
                                'Please Fill all the fields to continue',
                                snackPosition: SnackPosition.BOTTOM);
                          } else if (selectedItem == 0) {
                            Get.snackbar(
                                'Please select the Category type',
                                'Please select the Category type to continue',
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            addIncome();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      // initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _catType() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Select Category',
                      style: TextStyle(
                          color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: Get.width / 1.1,
                      height: Get.height / 2.5,
                      child: GridView.builder(
                        itemCount: _controller.catList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () =>
                            {
                              onChange(s: _controller.catList[index].index),
                              Get.back(),
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color:
                                      _controller.catList[selectedItem] ==
                                          _controller.catList[index]
                                          ? Colors.grey[200]
                                          : Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: _controller.catList[index].icon,
                                  ),
                                ),
                                Text(
                                  _controller.catList[index].title,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void onChange({required int s}) {
    setState(() {
      selectedItem = s;
    });
  }

  Future<void> addIncome() async {
    isLoading = true;
    Map<String, dynamic> data = {
      "Amount": amountString.text,
      "SOI": sofIncome.text,
      "SelectedDate": "${selectedDate.toLocal()}".split(' ')[0],
      "TimeStamp": DateTime.now(),
      "Category": _controller.catList[selectedItem].title.toString(),
      "Type": _dropMemoryDownValue,
    };
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .collection("Transactions")
          .add(data)
          .then((DocumentReference document) {
        print(document.id);
        addMoneyGraph(_dropMemoryDownValue);
      }).catchError((e) {
        print(e);
        Get.snackbar('Error', e.toString(),
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      isLoading = false;
      print(e);
      Get.snackbar('Error', e.toString(),
          duration: Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addMoneyGraph(String dropMemoryDownValue) async {
    Map<String, dynamic> data = {
      "Amount": int.parse(amountString.text),
      "SOI": sofIncome.text,
      "SelectedDate": "${selectedDate.toLocal()}".split(' ')[0],
      "TimeStamp": DateTime.now(),
      "Category": _controller.catList[selectedItem].title.toString(),
      "Type": dropMemoryDownValue,
    };
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("${dropMemoryDownValue}Graph")
        .doc(_controller.catList[selectedItem].title.toString())
        .set(data)
        .then((value) {
      Get.offAll(() =>
          BottomHomeBar(
            index: 0,
          ));
      Get.snackbar(
          'Added Successfully', 'Transaction Added Successfully',
          snackPosition: SnackPosition.TOP);
    });
  }
}
