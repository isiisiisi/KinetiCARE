import 'package:flutter/material.dart';

class MyDropdown extends FormField<String> {
  final String hintText;
  final List<String> items;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final BorderSide? enabledBorderSide;
  final BorderSide? focusedBorderSide;
  final ImageProvider? prefixIcon;
  final ValueChanged<String?>? onChanged;

  MyDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.padding,
    this.contentPadding,
    this.fillColor,
    this.hintStyle,
    this.enabledBorderSide,
    this.focusedBorderSide,
    this.prefixIcon,
    this.onChanged,
    super.onSaved,
    super.validator,
    bool autovalidate = false,
  }) : super(
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<String> state) {
            return Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fillColor ?? const Color(0xFFD8D8D8),
                  hintText: hintText,
                  hintStyle: hintStyle ??
                      const TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
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
                      ? Opacity(opacity: 0.5, child: Image(image: prefixIcon))
                      : null,
                  errorText: state.errorText,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: state.value,
                    isDense: true,
                    onChanged: (String? newValue) {
                      state.didChange(newValue);
                      if (onChanged != null) {
                        onChanged(newValue);
                      }
                    },
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(hintText),
                  ),
                ),
              ),
            );
          },
        );
}
