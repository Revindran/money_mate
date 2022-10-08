import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_mate/controllers/category_controller.dart';

class Categories extends StatelessWidget {
  final _controller = Get.put<CatController>(CatController());

  Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 1.1,
      height: Get.height / 5,
      child: GridView.builder(
        itemCount: _controller.catList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {},
            child: Text(_controller.catList[index].title),
          );
        },
      ),
    );
  }
}
