import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/textfield_general.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  late CategoriesProvider categoriesProvider;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then((value){
      categoriesProvider.initialDataAdd();
    });
  }

  @override
  Widget build(BuildContext context) {

    categoriesProvider = Provider.of<CategoriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: WalletColors.primary,
      ),
      body: categoriesProvider.loadDataInitialAdd ?
      Center(child: circularProgressColors(),) :
      Column(
        children: [
          cardAdd(),
        ],
      ),
    );
  }

  Widget cardAdd(){
    return SizedBox(
      width: sizeW,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: sizeH * 0.01,horizontal: sizeW * 0.02),
              child: TextFieldGeneral(
                textEditingController: categoriesProvider.controllerAdd,
              ),
            ),
          ),
          categoriesProvider.loadSaveAdd ?
          circularProgressColors(widthContainer1: sizeW * 0.3, widthContainer2: sizeW * 0.08) :
          ButtonGeneral(
            margin: EdgeInsets.only(right: sizeW * 0.02),
            width: sizeW * 0.3,
            height: sizeH * 0.06,
            title: 'Agregar',
            textStyle: WalletStyles().stylePrimary(size: sizeH * 0.02,color: Colors.white),
            onPressed: () => functionAdd(),
            backgroundColor: WalletColors.primary,
          )
        ],
      ),
    );
  }

  Future functionAdd() async {

    categoriesProvider.loadSaveAdd = true;

    String error = '';

    if(categoriesProvider.controllerAdd.text.isEmpty){
      error = 'Nombre no puede estar vacio';
    }

    if(error.isEmpty){
      bool? res = await alertTitle(title: 'Agregar categoría',subTitle: 'Se va agregar la categoría a su listado');
      if(res != null && res){
        if(await categoriesProvider.existsCategories()){
          if(await categoriesProvider.createCategories()){
            await categoriesProvider.initialDataAdd();
            showAlert(text: 'Creado con exito!');
          }else{
            showAlert(text: 'Problemas para enviar la información', isError: true);
          }
        }else{
          showAlert(text: 'Esta categoria ya existe', isError: true);
        }
      }
    }else{
      showAlert(text: error, isError: true);
    }
    categoriesProvider.loadSaveAdd = false;
  }
}
