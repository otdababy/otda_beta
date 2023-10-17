import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';

enum ProductTypeEnum {a,b}

class Pay extends StatefulWidget {
  const Pay({Key? key}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  ProductTypeEnum? _productTypeEnum;
  bool _ischecked1 = false;
  bool _ischecked2 = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: proHeight(5),),
        StatefulBuilder(
          builder: (context, _setState) =>CheckboxListTile(
            title: Text("만 14세 이상 결제 동의"),
            tileColor: Colors.white,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.only(left:proWidth(20),),
            value: _ischecked1,
            onChanged: (val){
              setState(() {
                _ischecked1 = val!;
              });
            },
          ),
        ),
        /*RadioListTile<ProductTypeEnum>(
          contentPadding: EdgeInsets.only(left:proWidth(20),),
          value: ProductTypeEnum.a,
          groupValue: _productTypeEnum,
          dense: true,
          tileColor: Colors.white,
          title: Text("만 14세 이상 결제 동의"),
          onChanged: (val){
            setState(() {
              _productTypeEnum = val;
            });
          },
        ),*/
        SizedBox(height: proHeight(5),),
        Container(
          width: proWidth(460),
          height: 1,
          color: Colors.grey.shade200,
        ),
        SizedBox(height: proHeight(5),),
        StatefulBuilder(
          builder: (context, _setState) =>CheckboxListTile(
            title: Text("주문내용 확인 및 결제 동의"),
            tileColor: Colors.white,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.only(left:proWidth(20),),
            value: _ischecked2,
            onChanged: (val){
              setState(() {
                _ischecked2 = val!;
              });
            },
        ),
        ),
        /*RadioListTile<ProductTypeEnum>(
          contentPadding: EdgeInsets.only(left:proWidth(20),),
          value: ProductTypeEnum.b,
          groupValue: _productTypeEnum,
          dense: true,
          tileColor: Colors.white,
          title: Text("주문내용 확인 및 결제 동의"),
          onChanged: (val){
            setState(() {
              _productTypeEnum = val;
            });
          },
        ),*/
        SizedBox(height: proHeight(5),),
        Container(
          width: proWidth(460),
          height: 1,
          color: Colors.grey.shade200,
        ),
        SizedBox(height: proHeight(15)),
        Center(
          child: Container(
            width: proWidth(340),
            height: proHeight(45),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                side: BorderSide(width: 1, color: Colors.black),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                backgroundColor: Colors.black,
              ),
              onPressed: (){
                context.beamToNamed('/pay');
              },
              child: Text(
                '결제하기',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: proHeight(15)),
      ],
    );
  }
}