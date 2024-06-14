import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/savings/firebase/firebase_connection_savings.dart';
import 'package:expense_wallet/pages/savings/models/savings_model.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/textfield_general.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SavingsDetails extends StatefulWidget {
  const SavingsDetails({Key? key, required this.savingModel}) : super(key: key);
  final SavingModel savingModel;
  @override
  State<SavingsDetails> createState() => _HomeGeneralState();
}

class _HomeGeneralState extends State<SavingsDetails> {

  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerNote = TextEditingController();

  final _regExp = RegExp(r'^\d+((\.|\,)\d{0,5})?$');
  late FilteringTextInputFormatter _inputFormatter;

  late SavingModel savingModel;

  @override
  void initState() {
    super.initState();
    _inputFormatter = FilteringTextInputFormatter.allow(_regExp);
    savingModel = widget.savingModel;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
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
            SizedBox(
              width: sizeW,
              height: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: sizeW,
                      child: listData(),
                    ),
                  ),
                  SizedBox(width: sizeW,height: sizeH * 0.03),
                ],
              ),
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
      leading: Container(),
      actions: [
        SizedBox(
          width: sizeW,
          child: Row(
            children: [
              Expanded(child: Text(widget.savingModel.title ?? '',textAlign: TextAlign.center,style: WalletStyles().stylePrimary(
                  size: sizeH * 0.03,color: WalletColors.primary,fontWeight: FontWeight.bold
              ))),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: sizeW * 0.05),
                  child: Icon(Icons.cancel_outlined,color: WalletColors.primary,size: sizeH * 0.03,),
                ),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget listData(){

    List<Widget> listW = [];

    return Column(
      children: [
        SizedBox(height: sizeH * 0.02,),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

              ],
            ),
          ),
        ),
        SizedBox(height: sizeH * 0.01,),
        SizedBox(
          width: sizeW,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: sizeW,
                  margin: EdgeInsets.only(right: sizeW * 0.01,left: sizeW * 0.02),
                  child: TextFieldGeneral(
                    textEditingController: controllerAmount,
                    hintText: 'Monto',
                    textInputType: TextInputType.number,
                    inputFormatters: [_inputFormatter],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: sizeW,
                  margin: EdgeInsets.only(left: sizeW * 0.01,right: sizeW * 0.02),
                  child: TextFieldGeneral(
                    textEditingController: controllerNote,
                    hintText: 'Nota (opcional)',
                    textInputType: TextInputType.text,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: sizeH * 0.01,),
        buttons(),
      ],
    );
  }

  Widget buttons(){
    return SizedBox(
      width: sizeW,
      child: Row(
        children: [
          SizedBox(width: sizeW * 0.02,),
          Expanded(child: cardButton(type: 1),),
          SizedBox(width: sizeW * 0.02,),
          Expanded(child: cardButton(type: 2),),
          SizedBox(width: sizeW * 0.02,),
          Expanded(child: cardButton(type: 3),),
          SizedBox(width: sizeW * 0.02,),
        ],
      ),
    );
  }

  Widget cardButton({required int type}){
    String title = 'Agregar';
    if(type == 2){ title = 'Tomar prestado'; }
    if(type == 3){ title = 'Retirar'; }

    return ButtonGeneral(
      title: title,
      backgroundColor: WalletColors.primary,
      textStyle: WalletStyles().stylePrimary(color: Colors.white,size: sizeH * 0.02),
      height: sizeH * 0.08,
      onPressed: () async {
        if(controllerAmount.text.isNotEmpty){

          String status = '';
          if(type == 1){ status = 'add'; }
          if(type == 2){ status = 'take'; }
          if(type == 3){ status = 'delete'; }

          SavingLineModel savingLineModel = SavingLineModel(
            id: (savingModel.lines.length + 1).toString(),
            title: '',
            amount: double.parse(controllerAmount.text),
            date: DateTime.now().toString(),
            note: controllerNote.text,
            status: status,
          );

          List<SavingLineModel> listData = savingModel.lines.isEmpty ? [] : savingModel.lines.map((e) => e).toList();
          listData.add(savingLineModel);

          if(await FirebaseConnectionSavings().editLine(data: widget.savingModel,listData: listData)){
            savingModel.lines.add(
                SavingLineModel(
                  id: (savingModel.lines.length + 1).toString(),
                  title: '',
                  amount: double.parse(controllerAmount.text),
                  date: DateTime.now().toString(),
                  note: controllerNote.text,
                  status: status,
                )
            );
            controllerAmount.text = '';
            controllerNote.text = '';
            setState(() {});
            showAlert(text: 'Agregado con exito');
            FocusScope.of(context).requestFocus(FocusNode());
          }else{
            showAlert(text: 'Problemas para enviar los datos.', isError: true);
          }
        }else{
          showAlert(text: 'Debe agregar un monto', isError: true);
        }
      },
    );
  }

}
