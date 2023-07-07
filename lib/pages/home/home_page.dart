import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/home/widgets/button_type_home.dart';
import 'package:expense_wallet/pages/home/widgets/calendar_date_view.dart';
import 'package:expense_wallet/pages/home/widgets/drawer.dart';
import 'package:expense_wallet/pages/home/widgets/home.dart';
import 'package:expense_wallet/pages/home/widgets/home_general.dart';
import 'package:expense_wallet/pages/home/widgets/show_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {

    homeProvider = Provider.of<HomeProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        key: homeProvider.scaffoldKeyHome,
        endDrawer: const DrawerHome(),
        body: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.2,
                child: SizedBox(
                  width: sizeW,
                  child: Container(
                    margin: EdgeInsets.only(bottom: sizeH * 0.04),
                    height: sizeH * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.asset(WalletImage.logoRemoveBg).image,
                            fit: BoxFit.fitHeight
                        )
                    ),
                  ),
                ),
              ),
            ),
            homeProvider.typeHomePrimary ? const Home() : const HomeGeneral(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: ShowModalBottom(),
            )
          ],
        ),
      ),
    );
  }


  AppBar appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      actions: [
        const CalendarDate(),
        SizedBox(width: sizeW * 0.01,),
        const ButtonTypeHome(),
        const Spacer(),
        InkWell(
          child: Container(
            margin: EdgeInsets.only(right: sizeW * 0.05),
            child: Icon(Icons.menu,color: WalletColors.primary,size: sizeH * 0.03,),
          ),
          onTap: (){
            homeProvider.scaffoldKeyHome.currentState!.openEndDrawer();
          },
        ),
      ],
    );
  }
}
