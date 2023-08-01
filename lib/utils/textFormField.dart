import 'package:flutter/material.dart';
import 'package:ocr_riidl/utils/styleConstants.dart';
import '../utils/appTools.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    required BuildContext context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .03,
              right: MediaQuery.of(context).size.width * .03),
          child: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: hexToColor('#f5f5ff').withOpacity(0.5),
                selectionColor: hexToColor('#f5f5ff'),
                selectionHandleColor: hexToColor('#f5f5ff'),
              ),
            ),
            child: TextFormField(
              scrollPhysics: ScrollPhysics(),
              cursorColor: hexToColor('#f5f5ff').withOpacity(0.5),
              textInputAction: TextInputAction.next,
              controller: controller,
              //onSaved: (val) => controller.text = val!,
              keyboardType: keyboardType,
              scrollController: ScrollController(),
              style: kGoogleStyleTexts.copyWith(
                  fontWeight: FontWeight.w400,
                  color: hexToColor("#f5f5f4"),
                  fontSize: 15.0),
              maxLines: 20,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(
                    color: hexToColor("#aaaaaa"),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: hexToColor("#f4f4f2"))),
                //fillColor: const Color.fromARGB(30, 173, 205, 219),
                filled: true,
                hintText: hintText,
                hintStyle: kGoogleStyleTexts.copyWith(
                    color: hexToColor("#ffffff"),
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
