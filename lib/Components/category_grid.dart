import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_mate/Screens/Pages/add_transactions.dart';
import 'package:money_mate/controllers/category_controller.dart';

class Categories extends StatelessWidget {
  final _controller = Get.put<CatController>(CatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.1,
      height: Get.height / 5,
      child: GridView.builder(
        itemCount: _controller.catList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {
            },
            child: Text(_controller.catList[index].title),
          );
        },
      ),
    );
  }
}
