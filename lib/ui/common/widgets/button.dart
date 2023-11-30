import 'package:flutter/material.dart';

import '../shared/styles.dart';

class Button extends StatelessWidget {
  const Button({
    required this.name,
    required this.onTap,
    this.height,
    this.width,
    this.buttoncolor,
    super.key,
  });
  final String name;
  final double? height;
  final double? width;
  final Color? buttoncolor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: defaultPadding8,
        child: Container(
          width: width ?? 250,
          height: height ?? 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: buttoncolor ?? appChambray,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              )),
          child: Padding(
            padding: zeroPadding,
            child: Text(
              name,
              style: fontFamilyRegular.size18.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
