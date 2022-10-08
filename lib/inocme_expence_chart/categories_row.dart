import 'package:flutter/material.dart';
import 'package:money_mate/inocme_expence_chart/pie_chart.dart';

class CategoriesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (var category in kCategories)
            ExpenseCategory(
                text: category.name, index: kCategories.indexOf(category))
        ],
      ),
    );
  }
}

class ExpenseCategory extends StatelessWidget {
  const ExpenseCategory({
    required this.index,
    required this.text,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  kNeumorphicColors.elementAt(index % kNeumorphicColors.length),
            ),
          ),
          SizedBox(width: 20),
          Text(
            text.capitalize(),
            style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
