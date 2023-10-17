import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

class NoLaundry extends StatelessWidget {
  const NoLaundry({Key? key}) : super(key: key);

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
            Text('따로 세탁은 하지 말아주세요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ) ,
            ),
            SizedBox(height: proHeight(5),),
            Text('세탁으로 인한 손상 시 손상액이 청구 될 수 있습니다',
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text('이전',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
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
            ],
          ),
        ),

      ],
    );
  }
}
