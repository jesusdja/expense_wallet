import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/home/widgets/drawer.dart';
import 'package:expense_wallet/pages/home/widgets/show_modal_bottom_sheet.dart';
import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarDate extends StatefulWidget {
  const CalendarDate({Key? key}) : super(key: key);

  @override
  State<CalendarDate> createState() => _CalendarDateState();
}

class _CalendarDateState extends State<CalendarDate> {

  late HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {

    homeProvider = Provider.of<HomeProvider>(context);

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        margin: EdgeInsets.only(left: sizeW * 0.02,top: sizeH * 0.01,bottom: sizeH * 0.01),
        decoration: BoxDecoration(
          color: WalletColors.primary,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(homeProvider.dateSelected),
        ),
      ),
      onTapDown: (details) {
        _showPopUpMenu(details.globalPosition);
      }
    );
  }

  _showPopUpMenu(Offset offset) async {
    final screenSize = MediaQuery.of(context).size;
    double left = offset.dx;
    double top = offset.dy;
    double right = screenSize.width - offset.dx;
    double bottom = screenSize.height - offset.dy;

    String? item = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: homeProvider.listDate.map((String menuItemType) =>
      PopupMenuItem<String>(
        value: menuItemType,
        child: Text(menuItemType),
      )).toList(),
    );

    if (item != null) {
      homeProvider.dateSelected = item;
    }
  }

}


