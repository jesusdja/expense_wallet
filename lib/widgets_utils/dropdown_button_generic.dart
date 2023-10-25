import 'package:flutter/material.dart';

class DropdownGeneric extends StatelessWidget {

  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final TextStyle? textStyle;
  final double iconSize;
  final Widget? icon;
  final Color borderColor;
  final double sizeH;
  final FocusNode? focusNode;
  final double sizeHeight;
  final double radius;
  final Color backColor;
  final Widget hint;
  final Color iconEnabledColor;
  final Color dropdownColor;
  final double  itemHeight;
  final double  menuMaxHeight;
  final EdgeInsets padding;

  const DropdownGeneric({
    Key? key,
    required this.items,
    required this.value,
    this.hint = const Text(''),
    this.onChanged,
    this.textStyle,
    this.iconSize = 35,
    this.icon,
    this.borderColor = Colors.grey,
    this.sizeH = 20,
    this.focusNode,
    this.sizeHeight = 0,
    this.onTap,
    this.radius = 5.0,
    this.backColor = Colors.white,
    this.iconEnabledColor = Colors.grey,
    this.dropdownColor = Colors.white,
    this.itemHeight = 100,
    this.menuMaxHeight = 100,
    this.padding = const EdgeInsets.only(left: 15),
    

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight == 0 ? sizeH * 0.045 : sizeHeight,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: backColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(
          width: 1.0,
          color: borderColor,
        ),
      ),
      padding: padding,
      child: Align(
        alignment: Alignment.centerRight,
        child: DropdownButton<String>(
          dropdownColor: dropdownColor,
          hint: hint,
          onTap: onTap,
          focusNode: focusNode,
          isExpanded: true,
          value: value,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconEnabledColor,
          style: textStyle,
          underline: Container(color: Colors.transparent),
          onChanged: onChanged,
          items: items,
          menuMaxHeight: menuMaxHeight,
          itemHeight: itemHeight,
        ),
      ),
    );
  }
}
