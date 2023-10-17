import 'package:app_v2/widget/expandablefab.dart';
import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:app_v2/classes/product/product.dart';
import 'clothing_body.dart';
import 'sliding_panel.dart';
import 'sliding_collapsed.dart';


class ClothingPage extends StatefulWidget {
  const ClothingPage({Key? key}) : super(key: key);

  @override
  _ClothingPageState createState() => _ClothingPageState();
}



class _ClothingPageState extends State<ClothingPage> {
/*
  const ClothingPage({
    Key? key,
    //required this.product
  }) : super(key: key);
*/
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                context.beamToNamed('/home',data: {'index':1});
              },
              icon: Icon(Icons.west_outlined),
            ),
          ),
          body: SlidingUpPanel(
            panel: SlidingPanel(context.currentBeamLocation.state.data['product']),
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            minHeight: MediaQuery.of(context).size.height * 0.15,
            body: Center(
              child: ClothingBody(product: context.currentBeamLocation.state.data['product']),
            ),
            //collapsed: SlidingCollapsed(),
          ),
        ),
      ),
    );
  }
}
