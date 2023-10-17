import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'community_body.dart';



class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommunityBody(),
    );
  }
}