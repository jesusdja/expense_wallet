import 'package:expense_wallet/initial_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> alertTitle({required String title, String? subTitle}) async{
  bool res = await showDialog(
      context: contextHome,
      builder: ( context ) {
        return AlertDialog(
          title: Text(title),
          content: Text(subTitle ?? ''),
          actions: <Widget>[
            CupertinoButton(
              child: const Text('Aceptar'),
              onPressed: ()  {
                Navigator.of(context).pop(true);
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
            CupertinoButton(
              child: const Text('Cancelar'),
              onPressed: ()  {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      }
  );
  return res;
}