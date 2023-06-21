import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldGeneral extends StatefulWidget {
  final int maxLines;
  final double radius;
  final double sizeHeight;
  final double sizeBorder;
  final String? placeHolder;
  final String? initialValue;
  final String hintText;
  final bool obscure;
  final bool autoCorrect;
  final bool autoValidate;
  final bool enable;
  final bool autofocus;
  final bool activeErrorText;
  final IconData? icon;
  final Color borderColor;
  final TextEditingController? textEditingController;
  final TextInputType textInputType;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextStyle labelStyle;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry padding;
  final TextCapitalization textCapitalization;
  final Color colorBack;
  final TextInputAction? textInputAction;
  final BoxConstraints? constraints;
  final List<TextInputFormatter> inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry contentPadding;
  final BoxConstraints? suffixIconConstraints,prefixIconConstraints;

  const TextFieldGeneral({
    Key? key,
    this.initialValue,
    this.placeHolder,
    this.icon,
    this.borderColor = Colors.grey,
    this.textEditingController,
    this.onChanged,
    this.textInputType = TextInputType.name,
    this.autoCorrect = true,
    this.obscure = false,
    this.autoValidate = false,
    this.maxLines = 1,
    this.focusNode,
    this.onTap,
    this.onFieldSubmitted,
    this.sizeHeight = 0,
    this.textAlign = TextAlign.left,
    this.labelStyle = const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
    this.boxShadow,
    this.sizeBorder = 1.5,
    this.suffixIcon,
    this.prefixIcon,
    this.enable = true,
    this.padding = const EdgeInsets.only(left: 5),
    this.textCapitalization = TextCapitalization.sentences,
    this.hintText = '',
    this.colorBack = Colors.white,
    this.autofocus = false,
    this.textInputAction,
    this.constraints,
    this.radius = 5.0,
    this.inputFormatters = const [],
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    this.activeErrorText = true,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
  }) : super(key: key);

  @override
  State<TextFieldGeneral> createState() => _TextFieldGeneralState();
}

class _TextFieldGeneralState extends State<TextFieldGeneral> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      constraints: widget.constraints,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: widget.colorBack,
        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
        border: Border.all(
          width: widget.sizeBorder,
          color: widget.borderColor,
        ),
        boxShadow: widget.boxShadow,
      ),
      child: TextFormField(
        controller: widget.textEditingController,
        initialValue: widget.initialValue,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,
        style: widget.labelStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        obscureText: widget.obscure,
        enabled: widget.enable,
        onChanged: widget.onChanged,
        autocorrect: widget.autoCorrect,
        keyboardType: widget.textInputType,
        focusNode: widget.focusNode,
        textCapitalization: widget.textCapitalization,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            filled: true,
            fillColor: widget.colorBack,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
              borderSide: const BorderSide(
                width: 0.0,
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
              borderSide: const BorderSide(
                width: 0.0,
                color: Colors.transparent,
              ),
            ),
            suffixIcon: widget.suffixIcon,
            labelText: widget.placeHolder,
            labelStyle: widget.labelStyle,
            errorStyle: widget.labelStyle,
            hintText: widget.hintText,
            hintStyle: widget.labelStyle,
            prefixIconConstraints: widget.prefixIconConstraints,
            prefixIcon: widget.prefixIcon,
            suffixIconConstraints: widget.suffixIconConstraints,
            contentPadding: widget.contentPadding
        ),
      ),
    );
  }
}