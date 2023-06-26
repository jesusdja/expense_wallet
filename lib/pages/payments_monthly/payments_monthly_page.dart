import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/payments_monthly_provider.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/textfield_general.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentsMonthlyPage extends StatefulWidget {
  const PaymentsMonthlyPage({Key? key}) : super(key: key);

  @override
  State<PaymentsMonthlyPage> createState() => _PaymentsMonthlyPageState();
}

class _PaymentsMonthlyPageState extends State<PaymentsMonthlyPage> {

  late PaymentsMonthlyProvider paymentsMonthlyProvider;
  late CategoriesProvider categoriesP;

  final _regExp = RegExp(r'^\d+((\.|\,)\d{0,5})?$');
  late FilteringTextInputFormatter _inputFormatter;

  @override
  void initState() {
    super.initState();

    _inputFormatter = FilteringTextInputFormatter.allow(_regExp);

    Future.delayed(const Duration(milliseconds: 200)).then((value){
      paymentsMonthlyProvider.initialDataAdd();
    });
  }

  @override
  Widget build(BuildContext context) {
    paymentsMonthlyProvider = Provider.of<PaymentsMonthlyProvider>(context);
    categoriesP = Provider.of<CategoriesProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: WalletColors.primary,
        ),
        body: categoriesP.loadDataInitial ?
        Center(child: circularProgressColors(),) :
        Column(
          children: [
            SizedBox(height: sizeH * 0.025),
            Expanded(
              child: Container(),
            ),
            cardAdd(),
          ],
        ),
      ),
    );
  }

  Widget cardAdd(){
    return SizedBox(
      width: sizeW,
      child: Column(
        children: [
          Container(
            width: sizeW,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: sizeH * 0.01,horizontal: sizeW * 0.02),
                    child: TextFieldGeneral(
                      textEditingController: paymentsMonthlyProvider.controllerTitle,
                      textInputType: TextInputType.text,
                      hintText: 'Titulo',
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: sizeW * 0.4,
                    height: sizeH * 0.06,
                    margin: EdgeInsets.only(right: sizeW * 0.02),
                    padding: EdgeInsets.symmetric(vertical: sizeH * 0.01,horizontal: sizeW * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(paymentsMonthlyProvider.datePayment == null ?
                      'Fecha del pago' : '${DateFormat('dd').format(paymentsMonthlyProvider.datePayment!)} DE CADA MES'),
                    ),
                  ),
                  onTap: (){
                    showDatePicker(
                        context: context,
                        initialDate: paymentsMonthlyProvider.datePayment ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1))
                        .then((value) {
                      if(value != null){
                        setState(() {
                          paymentsMonthlyProvider.datePayment = value;
                        });
                      }
                    });
                  },
                )
              ],
            ),
          ),
          listCategories(),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: sizeH * 0.01,horizontal: sizeW * 0.02),
                  child: TextFieldGeneral(
                    textEditingController: paymentsMonthlyProvider.controller,
                    textInputType: TextInputType.number,
                    inputFormatters: [_inputFormatter],
                    hintText: 'Monto',
                  ),
                ),
              ),
              paymentsMonthlyProvider.loadSaveAdd ?
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
        ],
      ),
    );
  }

  Widget listCategories(){
    return Container(
      width: sizeW,
      margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categoriesP.listCategories.map((e){

            bool isSelected = ((paymentsMonthlyProvider.categoriesSelected != null)&&(paymentsMonthlyProvider.categoriesSelected!.id == e.id));

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
                paymentsMonthlyProvider.categoriesSelected = e;
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future functionAdd() async {

    paymentsMonthlyProvider.loadSaveAdd = true;

    FocusScope.of(context).requestFocus(FocusNode());

    String error = '';

    if(paymentsMonthlyProvider.controller.text.isEmpty){
      error = 'Monto no puede estar vacio';
    }

    if(paymentsMonthlyProvider.controllerTitle.text.isEmpty){
      error = 'Título no puede estar vacio';
    }

    if(paymentsMonthlyProvider.categoriesSelected == null){
      error = 'Debe seleccionar una categoría';
    }

    if(paymentsMonthlyProvider.datePayment == null){
      error = 'Debe seleccionar una fecha';
    }

    if(error.isEmpty){
      bool? res = await alertTitle(title: 'Agregar pago mensual',subTitle: 'Se va agregar este pago a su listado');
      if(res != null && res){
        if(await paymentsMonthlyProvider.createPayment()){
          paymentsMonthlyProvider.initialDataAdd();
          showAlert(text: 'Creado con exito!');
        }else{
          showAlert(text: 'Problemas para enviar la información', isError: true);
        }
      }
    }else{
      showAlert(text: error, isError: true);
    }
    paymentsMonthlyProvider.loadSaveAdd = false;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }
    double value = double.parse(newValue.text);
    final formatter = NumberFormat('####,##', 'es_ES');
    String newText = formatter.format(value);
    var res = newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
    return res;
  }
}