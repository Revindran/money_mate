import 'package:flutter/material.dart';

class InkWellOverlay extends StatelessWidget {
  const InkWellOverlay({
    required this.openContainer,
    required this.width,
    required this.height,
    required this.child,
  });

  final VoidCallback openContainer;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
}