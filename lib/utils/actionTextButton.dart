import 'package:flutter/material.dart';
import 'package:ocr_riidl/utils/styleConstants.dart';
import '../utils/appTools.dart';

class ActionTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final BuildContext context;
  final String textToClick;
  final double fontSize;

  const ActionTextButton({
    super.key,
    required this.onPressed,
    required this.context,
    required this.textToClick,
    required this.fontSize,
  });

  @override
  Widget build(context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            textToClick,
            style: kGoogleStyleTexts.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: hexToColor("#f5f5f2"),
            ),
          ),
        ),
      ),
    );
  }
}
