import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_mate/controllers/user_controller.dart';

class PieChart extends CustomPainter {
  PieChart({required this.categories, required this.width});

  final List<Category> categories;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 2;

    double total = 0;
    // Calculate total amount from each category
    for (var expense in categories) {
      total += expense.amount;
    }

    // The angle/radian at 12 o'clock
    double startRadian = -pi / 2;

    for (var index = 0; index < categories.length; index++) {
      final currentCategory = categories.elementAt(index);
      // Amount of length to paint is a percentage of the perimeter of a circle (2 x pi)
      final sweepRadian = currentCategory.amount / total * 2 * pi;
      // Used modulo/remainder to catch use case if there is more than 6 colours
      paint.color = kNeumorphicColors.elementAt(index % categories.length)!;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        false,
        paint,
      );
      // The new startRadian starts from where the previous sweepRadian.
      // Example, a circle perimeter is 10.
      // Category A takes a startRadian 0 and ends at sweepRadian 5.
      // Category B takes the startRadian where Category A left off, which is 5
      // and ends at sweepRadian 7.
      // Category C takes the startRadian where Category B left off, which is 7
      // and so on.
      startRadian += sweepRadian;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Category {
  Category(this.name, {required this.amount});

  final String name;
  final double amount;
}

var _controller = Get.find<UserController>();
double income = double.parse(_controller.totalIncome.value.toString());
double expanse = double.parse(_controller.totalExpanse.value.toString());

final kCategories = [
  Category('Income ??? $income', amount: income),
  Category('Expanse ??? $expanse', amount: expanse),
];

final kNeumorphicColors = [
  Colors.green[200],
  Colors.red[200],
];
