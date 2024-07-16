import 'package:flutter/material.dart';
import 'package:kineticare/components/my_label.dart';

class MyDateField extends FormField<DateTime> {
  final TextEditingController controller;
  final String hintText;
  final ImageProvider? prefixIcon;
  final ImageProvider? suffixIcon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final BorderSide? enabledBorderSide;
  final BorderSide? focusedBorderSide;
  final String labelText;

  MyDateField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.padding,
    this.contentPadding,
    this.fillColor,
    this.hintStyle,
    this.enabledBorderSide,
    this.focusedBorderSide,
    super.onSaved,
    super.validator,
    bool autovalidate = false,
  }) : super(
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<DateTime> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: const Alignment(-1.2, 0.0),
                    child: MyLabel(labelText: labelText)),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: state.context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      state.didChange(picked);
                      controller.text =
                          "${picked.month}/${picked.day}/${picked.year}";
                    }
                  },
                  child: AbsorbPointer(
                    child: Padding(
                      padding: padding ??
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: fillColor ?? const Color(0xFFD8D8D8),
                          hintText: hintText,
                          hintStyle: hintStyle ??
                              const TextStyle(
                                  color: Color.fromRGBO(158, 158, 158, 1)),
                          contentPadding: contentPadding ??
                              const EdgeInsets.symmetric(
                                  vertical: 25.0, horizontal: 25),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: enabledBorderSide ??
                                const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: focusedBorderSide ??
                                const BorderSide(
                                    color: Color.fromARGB(255, 182, 182, 182)),
                          ),
                          prefixIcon: prefixIcon != null
                              ? Opacity(
                                  opacity: 0.5, child: Image(image: prefixIcon))
                              : null,
                          suffixIcon: suffixIcon != null
                              ? Opacity(
                                  opacity: 0.5, child: Image(image: suffixIcon))
                              : null,
                          errorText: state.errorText,
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
}
