import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/pages/payment/provider/add_payment_provider.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/textfield_general.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {

  late AddPaymentProvider addPaymentProvider;
  late CategoriesProvider categoriesP;

  final _regExp = RegExp(r'^\d+((\.|\,)\d{0,5})?$');
  late FilteringTextInputFormatter _inputFormatter;

  @override
  void initState() {
    super.initState();
    _inputFormatter = FilteringTextInputFormatter.allow(_regExp);
  }

  @override
  Widget build(BuildContext context) {

    addPaymentProvider = Provider.of<AddPaymentProvider>(context);
    categoriesP = Provider.of<CategoriesProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: sizeW,
          margin: EdgeInsets.symmetric(horizontal: sizeW * 0.1),
          child: Text('Agregar Pago',textAlign: TextAlign.center,style: WalletStyles().stylePrimary(
            color: WalletColors.primary,size: sizeH * 0.05,fontWeight: FontWeight.bold
          )),
        ),
        SizedBox(height: sizeH * 0.03,),

        Container(
          width: sizeW,
          margin: EdgeInsets.symmetric(horizontal: sizeW * 0.1),
          child: TextFieldGeneral(
            textEditingController: addPaymentProvider.controllerAmount,
            hintText: 'Monto',
            textInputType: TextInputType.number,
            inputFormatters: [_inputFormatter],
          ),
        ),
        SizedBox(height: sizeH * 0.03,),
        categoriesP.loadDataInitial ?
        Center(child: circularProgressColors(widthContainer2: sizeH * 0.03,widthContainer1: sizeH * 0.03),) : listCategories(),
        SizedBox(height: sizeH * 0.03,),
        Container(
          width: sizeW,
          margin: EdgeInsets.symmetric(horizontal: sizeW * 0.1),
          child: TextFieldGeneral(
            textEditingController: addPaymentProvider.controllerTitle,
            hintText: 'Nota (opcional)',
          ),
        ),
        SizedBox(height: sizeH * 0.03,),
        addPaymentProvider.loadSaveAdd ?
        circularProgressColors(widthContainer1: sizeW * 0.3, widthContainer2: sizeW * 0.08) :
        ButtonGeneral(
          margin: EdgeInsets.only(right: sizeW * 0.02),
          width: sizeW * 0.3,
          height: sizeH * 0.045,
          title: 'Agregar',
          textStyle: WalletStyles().stylePrimary(size: sizeH * 0.018,color: Colors.white),
          onPressed: ()=> addPay(),
          backgroundColor: WalletColors.primary,
        ),
        SizedBox(height: sizeH * 0.05,),
      ],
    );
  }

  Widget listCategories(){
    return Container(
      width: sizeW,
      margin: EdgeInsets.symmetric(horizontal: sizeW * 0.1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categoriesP.listCategories.map((e){

            bool isSelected = ((addPaymentProvider.categoriesSelected != null)&&(addPaymentProvider.categoriesSelected!.id == e.id));

            return InkWell(
              child: Container(
                constraints: BoxConstraints(minWidth: sizeW * 0.1),
                margin: EdgeInsets.symmetric(horizontal: sizeW * 0.01),
                padding: EdgeInsets.symmetric(horizontal: sizeW * 0.02,vertical: sizeH * 0.01),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(e.name!),
              ),
              onTap: (){
                addPaymentProvider.categoriesSelected = e;
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future addPay() async{

    addPaymentProvider.loadSaveAdd = false;
    String error = '';

    if(addPaymentProvider.controllerAmount.text.isEmpty){
      error = 'Monto no puede estar vacio';
    }

    if(addPaymentProvider.categoriesSelected == null){
      error = 'Debe seleccionar una categoría';
    }

    if(error.isEmpty){
      bool? res = await alertTitle(title: 'Enviar pagos frecuentes', subTitle: 'Estas seguro que quieres enviar el pago frecuente');
      if(res != null && res){
        if(await addPaymentProvider.sendDataPay()){
          showAlert(text: 'Enviado con exito!');
          addPaymentProvider.initial();
        }else{
          showAlert(text: 'Problemas para enviar la información', isError: true);
        }
      }
    }else{
      showAlert(text: error, isError: true);
    }
    addPaymentProvider.loadSaveAdd = false;
  }
}
