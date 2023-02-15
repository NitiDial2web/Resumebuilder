import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remuse_builder/common/AppColors.dart';

class AppButtons {
  Widget kElevatedButton({required String title}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kLightGreen,
          elevation: 2,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
        onPressed: () {
          print('submit');
        },
        child: SizedBox(
          width: 200,
          height: 50,
          // decoration: const BoxDecoration(
          //     color: AppColors.kLightGreen,
          //     borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.kWhite,
                  fontFamily: 'Inter-Regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
        ));
  }

  Widget kTextNormal({
    required String title,
    required double fontSize,
    required FontWeight fontWeight,
    required Color fontColor
  }) {
    return Text(title, style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Inter-Regular'
    ),);
  }

  Widget kTextBold({
    required String title,
    required double fontSize,
    required FontWeight fontWeight,
    required Color fontColor
  }) {
    return Text(title, style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Inter-Bold'
    ),);
  }
}