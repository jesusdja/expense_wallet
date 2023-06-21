import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:flutter/material.dart';

class ButtonGeneral extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;
  final double radius;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final EdgeInsets margin;
  final EdgeInsets titlePadding;
  final Widget? icon;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

  const ButtonGeneral({
    Key? key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.height,
    this.width,
    this.textStyle,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.iconColor = WalletColors.primary,
    this.margin = const EdgeInsets.all(0.0),
    this.titlePadding = const EdgeInsets.all(0.0),
    this.radius = 5.0,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onPressed,
          child: Center(
            child: Padding(
              padding: titlePadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  icon ?? Container(),
                  Expanded(
                    child: Text(
                      title,
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
