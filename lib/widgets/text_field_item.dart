import 'package:flutter/material.dart';

class TextFieldItem extends StatelessWidget {
   TextFieldItem({
    super.key,
    required this.labelText,
    required this.iconData,
    this.onChanged,
    this.controller
    
  });
  final String labelText;
  final IconData iconData;
  final Function(String)? onChanged;
  bool? obscureText;
  TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller ,
      validator: (data) {
        if (data!.isEmpty) {
          return 'Field is required';
        }
      },
      

      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 16),
        labelText: labelText,
        prefixIcon: Icon(iconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
