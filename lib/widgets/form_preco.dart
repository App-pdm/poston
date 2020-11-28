import 'package:flutter/material.dart';

class FormPreco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 174),
          decoration: BoxDecoration(
            color: Color(0xFFF9F9F9),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -4),
                blurRadius: 30,
                color: Color.fromRGBO(0, 0, 0, 0.8),
              ),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34), topRight: Radius.circular(34)),
          ),
        ),
      ],
    );
  }
}
