import 'package:flutter/material.dart';
import '../../utils/size_config.dart';

class DeletePopup extends StatelessWidget {
  const DeletePopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('회원 탈퇴를 진행하시겠습니까?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ) ,
            ),
            SizedBox(height: proHeight(5),),
            Text('회원님의 모든 정보가 영구적으로 삭제됩니다',
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
                child: Text('예',
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
                child: Text('아니요',
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
