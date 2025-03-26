import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSearch extends StatelessWidget {
  const CustomSearch({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    required this.isDigit,
    this.suffix,
    this.prefix,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.obscure = false,
    required this.onChanged,
  });

  final bool obscure;
  final bool isDigit;
  final bool readOnly;
  final TextInputType keyboardType;
  final String hintText;
  final Widget? prefix;
  final Widget? suffix;
  final void Function()? onTap;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String query) onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: isDigit
            ? [
          FilteringTextInputFormatter(
            RegExp("[0-9 .]"),
            allow: true,
          )
        ]
            : [],
        controller: controller,
        validator: validator,
        obscureText: obscure,
        readOnly: readOnly,
        onChanged: onChanged,
        keyboardType: isDigit ? TextInputType.number : keyboardType,
        decoration: InputDecoration(
       //   prefixIconColor: Colors.black,
          hintText: hintText,
          // hintStyle: AppStyles.textStyle12,
          suffixIcon: suffix, prefixIcon: prefix, alignLabelWithHint: true,
      //    suffixIconColor: Colors.grey[600],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
             //color: myColors.appbar,
            ),
          ),
          filled: true,
       //   fillColor: myColors.appbar,
          // contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
        // style: Theme.of(context)
        //     .textTheme
        //     .bodyMedium!
        //     .copyWith(color: Colors.black),
        onTapOutside: (focusNode) {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        onTap: onTap,
      ),
    );
  }
}