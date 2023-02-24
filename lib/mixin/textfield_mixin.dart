import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class TextFieldMixin {
  Widget textFieldWidget(
      {TextEditingController? controller,
      Color? cursorColor,
      TextInputAction? textInputAction,
      InputDecoration? decoration,
      TextInputType? keyboardType,
      Widget? prefixIcon,
      void Function()? onTap,
      Widget? suffixIcon,
        InputBorder? border,
      int? maxLines = 1,
        int? maxLength,
      String? prefixText,
        String? counterText,
      TextCapitalization textCapitalization = TextCapitalization.none,
      String? Function(String?)? validator,
        String? initialValue,
      bool readOnly = false,
        String? hintText,
      InputBorder? focusedBorder,
      String? labelText,
      TextStyle? labelStyle}) {
    return Container(
      padding: const EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        decoration:   InputDecoration(
            labelText: labelText,
            labelStyle: labelStyle,
            border: border,
            hintText: hintText,
            counterText: counterText,
            prefixText: prefixText,
            prefixIcon: prefixIcon
        ),
        readOnly: readOnly,
        validator: validator,
        keyboardType: keyboardType,
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
      ),
    );
  }

  Widget textFieldBook(
      {TextEditingController? controller,
        Color? cursorColor,
        TextInputAction? textInputAction,
        InputDecoration? decoration,
        TextInputType? keyboardType,
        Widget? prefixIcon,
        void Function()? onTap,
        Widget? suffixIcon,
        int? maxLines = 1,
        TextCapitalization textCapitalization = TextCapitalization.none,
        String? Function(String?)? validator,
        String? initialValue,
        bool readOnly = false,
        InputBorder? focusedBorder,
        String? labelText,
        TextStyle? labelStyle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: TextFormField(
        cursorColor: AppColor.appBlackColor,
        controller: controller,
        textInputAction: TextInputAction.next,
        initialValue: initialValue,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: prefixIcon,
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.appColor,
              )),
          labelStyle: const TextStyle(
            color: AppColor.appBlackColor,
          ),
          labelText: labelText,
        ),
      ),
    );
  }

}
