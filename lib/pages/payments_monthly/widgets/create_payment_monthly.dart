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

class CardAdd extends StatefulWidget {
  const CardAdd({Key? key}) : super(key: key);

  @override
  State<CardAdd> createState() => _CardAddState();
}

class _CardAddState extends State<CardAdd> {

  late PaymentsMonthlyProvider paymentsMonthlyProvider;
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

    paymentsMonthlyProvider = Provider.of<PaymentsMonthlyProvider>(context);
    categoriesP = Provider.of<CategoriesProvider>(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        cardAdd(),
        paymentsMonthlyProvider.isEdit ? Positioned(
          top: -(sizeH * 0.02), // Ubicación del botón dentro del Stack
          right: (sizeH * 0.025),
          child: SizedBox(
            width: 40,height: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              child: const Icon(Icons.cancel_outlined,),
              onPressed: () {
                paymentsMonthlyProvider.initialDataAdd();
              },
            ),
          ),
        ) : Container(),
      ],
    );
  }

  Widget cardAdd(){
    return Container(
      width: sizeW,
      color: Colors.grey[200],
      child: Column(
        children: [
          Container(
            color: Colors.grey,
            height: 3, width: sizeW,
            margin: const EdgeInsets.only(bottom: 15),
          ),
          SizedBox(
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
                    selectedDate();
                    // showDatePicker(
                    //     context: context,
                    //     initialDate: paymentsMonthlyProvider.datePayment ?? DateTime.now(),
                    //     firstDate: DateTime.now(),
                    //     lastDate: DateTime(DateTime.now().year + 1))
                    //     .then((value) {
                    //   if(value != null){
                    //     setState(() {
                    //       paymentsMonthlyProvider.datePayment = value;
                    //     });
                    //   }
                    // });
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
                title: paymentsMonthlyProvider.isEdit ? 'Editar' : 'Agregar',
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

      String title = paymentsMonthlyProvider.isEdit ? 'Editar pago mensual' : 'Agregar pago mensual';
      String subTitle = paymentsMonthlyProvider.isEdit ? 'Se va a editar este pago de tu lista' : 'Se va agregar este pago a su listado';

      bool? res = await alertTitle(title: title,subTitle: subTitle);
      if(res != null && res){
        bool res = false;
        if(paymentsMonthlyProvider.isEdit){
          res = await paymentsMonthlyProvider.editPayment();
        }else{
          res = await paymentsMonthlyProvider.createPayment();
        }

        if(res){
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

  Future selectedDate() async {
    List<int> listInt = [];
    for(int x = 1; x < 32; x++){ listInt.add(x); }

    List<Widget> listW = [];
    for(int x = 0; x < listInt.length; x++) {
      listW.add(
        InkWell(
          onTap: (){
            Navigator.of(context).pop(listInt[x]);
          },
          child: Container(
            width: sizeW * 0.1,
            padding: const EdgeInsets.all(10),
            color: WalletColors.primary,
            child: Center(
              child: Text(listInt[x].toString(),style: WalletStyles().stylePrimary(size: sizeH * 0.02,color: Colors.white,fontWeight: FontWeight.bold)),
            ),
          ),
        )
      );
    }

    int? res = await showDialog(
        context: context,
        builder: ( context ) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  width: sizeW,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  margin: EdgeInsets.symmetric(horizontal: sizeW * 0.06),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: WalletColors.primary,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 5,
                    children: listW,
                  ),
                ),
              ),
            ),
          );
        }
    );
    if(res != null){
      setState(() {
        DateTime date = DateTime.now();
        paymentsMonthlyProvider.datePayment = DateTime.parse('${date.year}-${date.month}-$res');
      });
    }
  }
}


