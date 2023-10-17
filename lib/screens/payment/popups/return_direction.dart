import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

class ReturnDirection extends StatelessWidget {
  const ReturnDirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset('assets/images/문앞택배.png',
          height: proHeight(100),
          width: proHeight(100),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('반납일 전날 밤, 문 앞에 둬주세요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ) ,
            ),
            SizedBox(height: proHeight(5),),
            Text('배송됐던 박스에 큰 글씨로 "옷다"를 적은 후 문 앞에 둬주세요',
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
                child: Text('완료',
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
