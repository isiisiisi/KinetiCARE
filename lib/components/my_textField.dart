import 'package:flutter/material.dart';

class MyTextField extends FormField<String> {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final ImageProvider? prefixIcon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final BorderSide? enabledBorderSide;
  final BorderSide? focusedBorderSide;
  final ImageProvider? suffixIcon;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
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
          builder: (FormFieldState<String> state) {
            return Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fillColor ?? const Color(0xFFD8D8D8),
                  hintText: hintText,
                  hintStyle: hintStyle ??
                      const TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                  contentPadding: contentPadding ??
                      const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
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
                  suffixIcon: suffixIcon != null
                      ? Opacity(opacity: 0.5, child: Image(image: suffixIcon))
                      : null,
                ),
              ),
            );
          },
        );
}






// import 'package:flutter/material.dart';

// class MyTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final bool obscureText;
//   final ImageProvider? prefixIcon;
//   final EdgeInsetsGeometry padding;
//   final EdgeInsetsGeometry contentPadding;
//   final Color fillColor;
//   final TextStyle hintStyle;
//   final BorderSide enabledBorderSide;
//   final BorderSide focusedBorderSide;

//   const MyTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.obscureText,
//     this.prefixIcon,
//     this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
//     this.contentPadding =
//         const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25),
//     this.fillColor = const Color(0xFFD8D8D8),
//     this.hintStyle = const TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
//     this.enabledBorderSide = const BorderSide(color: Colors.white),
//     this.focusedBorderSide =
//         const BorderSide(color: Color.fromARGB(255, 182, 182, 182)),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: padding,
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: fillColor,
//           hintText: hintText,
//           hintStyle: hintStyle,
//           contentPadding: contentPadding,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             borderSide: enabledBorderSide,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             borderSide: focusedBorderSide,
//           ),
//           prefixIcon: prefixIcon != null
//               ? Opacity(opacity: 0.5, child: Image(image: prefixIcon!))
//               : null,
//         ),
//       ),
//     );
//   }
// }
