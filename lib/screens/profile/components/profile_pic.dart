import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatefulWidget {
  ProfilePic({
    Key? key,
    required this.nickName,
    required this.profileImageUrl,
    required this.number,
  }) : super(key: key);

  final String nickName;
  final String profileImageUrl;
  final String number;

  @override
  _ProfilePicState createState() => _ProfilePicState(number: number,nickName: nickName, profileImageUrl: profileImageUrl);
}


class _ProfilePicState extends State<ProfilePic> {
  _ProfilePicState({
    Key? key,
    required this.nickName,
    required this.profileImageUrl,
    required this.number,
  });

  final String nickName;
  final String profileImageUrl;
  final String number;


  void moveEdit() {
    context.beamToNamed('/profile_edit', data: {'nickName': nickName,
    'profileImageUrl': profileImageUrl, 'number':number});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl,),
            maxRadius: proWidth(50),
          ),
          SizedBox(width: proWidth(30)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                  ),
                ),
                SizedBox(height: proHeight(10)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: proHeight(30),
                        color: Colors.white,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.black,
                              side: BorderSide(width: 1, color: Colors.black),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: (){
                              //편집화면으로 이동
                              moveEdit();
                            },
                            child: Text(
                                '프로필 편집',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ),
                      ),
                    ),
                  ],
                )
              ]
            ),
          )
        ]
      ),
    );
  }
}