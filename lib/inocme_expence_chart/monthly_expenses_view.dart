import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mate/inocme_expence_chart/pie_chart_view.dart';

import 'categories_row.dart';

class MontlyExpensesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Color.fromRGBO(193, 214, 233, 1),
      body: Column(
        children: <Widget>[
          // Spacer(),
          SizedBox(
            height: height * 0.43,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * 0.065),
                  Text(
                    'Income & Expenses',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 16),
                  ),
                  Container(
                    width: Get.width / 1.1,
                    height: Get.height / 5,
                    child: Row(
                      children: <Widget>[
                        PieChartView(),
                        CategoriesRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
