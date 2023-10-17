import 'package:flutter/material.dart';

import '../../utils/size_config.dart';

class PwError extends StatelessWidget {
  const PwError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset('assets/images/warning.png',
          height: proHeight(100),
          width: proHeight(100),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('비밀번호 오류!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ) ,
            ),
            SizedBox(height: proHeight(5),),
            Text('비밀번호를 다시 입력해주세요',
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
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('확인',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
