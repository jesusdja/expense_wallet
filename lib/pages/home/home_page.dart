import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/home/widgets/drawer.dart';
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
      ),
    );
  }


  AppBar appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      actions: [
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
