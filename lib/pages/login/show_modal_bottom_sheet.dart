import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:flutter/material.dart';

class ShowModalBottom extends StatefulWidget {
  const ShowModalBottom({Key? key}) : super(key: key);

  @override
  State<ShowModalBottom> createState() => _ShowModalBottomState();
}

class _ShowModalBottomState extends State<ShowModalBottom> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: sizeW,
        height: sizeH * 0.05,
        decoration: const BoxDecoration(
          color: WalletColors.color_829ae3,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),topLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(0.0),topRight: Radius.circular(15.0),
          ),
        ),
        child: Center(
          child: Text('Agregar pago',style: WalletStyles().stylePrimary(
              size: sizeH * 0.023,color: Colors.white,fontWeight: FontWeight.bold
          ),textAlign: TextAlign.center),
        ),
      ),
      onTap: (){
        showModalBottomSheet(
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            enableDrag: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            builder: (context) {
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: sizeH * 0.7,
                  decoration: const BoxDecoration(
                    color: WalletColors.color_829ae3,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),topLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(0.0),topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [],
                  ),
                ),
              );
            });
      },
    );
  }
}
