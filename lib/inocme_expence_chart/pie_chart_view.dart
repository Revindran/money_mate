import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_mate/controllers/user_controller.dart';
import 'package:money_mate/inocme_expence_chart/pie_chart.dart';

class PieChartView extends StatelessWidget {

var c = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: LayoutBuilder(
        builder: (context, constraint) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 17,
                offset: Offset(-5, -5),
                color: Colors.white,
              ),
              BoxShadow(
                spreadRadius: -2,
                blurRadius: 10,
                offset: Offset(7, 7),
                color: Color.fromRGBO(146, 182, 216, 1),
              )
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: constraint.maxWidth * 0.6,
                  child: CustomPaint(
                    child: Center(),
                    foregroundPainter: PieChart(
                      width: constraint.maxWidth * 0.5,
                      categories: kCategories,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: constraint.maxWidth * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        offset: Offset(-1, -1),
                        color: Colors.white,
                      ),
                      BoxShadow(
                        spreadRadius: -2,
                        blurRadius: 10,
                        offset: Offset(5, 5),
                        color: Colors.black.withOpacity(0.5),
                      )
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Balance',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic),
                        ),
                        Text("₹ " +'${(c.totalIncome.value-c.totalExpanse.value)}',style: TextStyle(
                            color: Colors.green[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 16),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
