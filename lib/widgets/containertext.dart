import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String text;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final bool obscureText;

  CustomContainer(
      {this.text,
      this.keyboardType,
      this.validator,
      this.onSaved,
      this.onChanged,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 8,
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: TextFormField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(
              color: Color(0xFF9B9B9B),
              fontSize: 11,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.w500,
              height: 1,
            ),
            hintText: text,
            hintStyle: TextStyle(
              color: Color(0xFF9B9B9B),
              fontSize: 14,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.w500,
              height: 1.4285,
            ),
            errorBorder: InputBorder.none,
            errorStyle: TextStyle(),
            border: InputBorder.none,
          ),
          onSaved: onSaved,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
