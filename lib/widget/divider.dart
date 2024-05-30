// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cookin/utils/colors.dart';
import 'package:flutter/material.dart';

class myDivider extends StatefulWidget {
  const myDivider({
    super.key,
    required this.text,
    required this.fontsize,
    required this.fontweight,
    required this.height,
    required this.flex,
  });

  final int flex;
  final double height;
  final  fontweight;
  final double fontsize;
  final String text;
  

  @override
  State<myDivider> createState() => _myDividerState();
}

class _myDividerState extends State<myDivider> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: widget.flex,
          child: Divider(
            color: AppColors.textColor,
            height: widget.height,
          ),
        ),
        Flexible(
          flex: widget.flex*2,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                  fontSize: widget.fontsize,
                  fontWeight: widget.fontweight,
                  color: AppColors.textColor),
            ),
          ),
        ),
        Expanded(
          flex: widget.flex,
          child: Divider(
            color: AppColors.textColor,
            height: widget.height,
          ),
        ),
      ],
    );
  }
}
