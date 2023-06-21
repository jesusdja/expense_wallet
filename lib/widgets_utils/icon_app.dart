import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:flutter/material.dart';

Widget iconApp({double? wid, double? hei}){
  return SizedBox(
    width: wid ?? sizeW,
    child: Container(
      height: hei ?? sizeH * 0.25,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(WalletImage.logoRemoveBg).image,
              fit: BoxFit.fitHeight
          )
      ),
    ),
  );
}