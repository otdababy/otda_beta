import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

class PayComplete extends StatelessWidget {
  const PayComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset('assets/images/배송택배박스.png',
          height: proHeight(100),
          width: proHeight(100),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('결제가 완료됐습니다!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ) ,
            ),
            SizedBox(height: proHeight(5),),
            Text('이제 배송 후 절차를 안내드리겠습니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff4E4E4E),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
            backgroundColor: Colors.black,
          ),
          onPressed: () {},
          child: Text('다음',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0,20,0,20)),
      ],
    );
  }
}
