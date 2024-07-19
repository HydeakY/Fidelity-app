import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final double? height;
  final double? width;
  final Function() onPress;
  final BorderRadius? borderRadius;
  final RoundedRectangleBorder? shape;

  CustomButton(
      {super.key,
      required this.text,
      required this.bgColor,
      required this.textColor,
      onPress,
      required double fontSize,
      this.height,
      this.width,
      this.borderRadius,
      this.shape})
      : onPress = onPress ?? (() {});
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
          backgroundColor: bgColor,
          padding: const EdgeInsets.all(15.0),
        ),
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}