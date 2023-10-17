import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:app_v2/utils/size_config.dart';

import 'components/borrowing_card.dart';
import 'components/delivering_card.dart';
import 'components/returning_card.dart';


class BorrowingBody extends StatefulWidget {
  const BorrowingBody({Key? key,
  }) : super(key: key);

  @override
  _BorrowingBodyState createState() => _BorrowingBodyState();
}


class _BorrowingBodyState extends State<BorrowingBody> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  List<String> status = ['입금 확인중','배송 중'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '대여 내역',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20
              ),
            ),
            leading: IconButton(
              onPressed: (){
                context.beamToNamed('/home', data: {'index' : 3});
              },
              icon: Icon(Icons.west_outlined),
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Column(
                  children: [
                    Text(
                      '배송중',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: proHeight(5)),
                    Text(
                      context.currentBeamLocation.state.data['delivering'].length.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: proHeight(7)),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: proHeight(5),),
                    Text(
                      '대여중',
                      style: TextStyle(
                        color: Color(0xFF15CD5D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: proHeight(5)),
                    Text(
                      context.currentBeamLocation.state.data['borrowing'].length.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: proHeight(7)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '반납 완료',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: proHeight(5)),
                    Text(
                      context.currentBeamLocation.state.data['returning'].length.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: proHeight(7)),
                  ],
                ),
              ],
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              //대여중 화면
              //배송중 화면
              Padding(
                padding: EdgeInsets.only(right: proWidth(3)),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: context.currentBeamLocation.state.data['delivering'].length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      //mainAxisExtent: 300,
                      childAspectRatio: (0.54),
                    ),
                    itemBuilder: (BuildContext ctx, index){
                      return DeliveringCard(
                        orderId: context.currentBeamLocation.state.data['delivering'][index]['orderId'],
                        payStatus: context.currentBeamLocation.state.data['delivering'][index]['payStatus'],
                        productId: context.currentBeamLocation.state.data['delivering'][index]['productId'],
                        rentalRequestId: context.currentBeamLocation.state.data['delivering'][index]['rentalRequestId'],
                        imageUrl: context.currentBeamLocation.state.data['delivering'][index]['imageUrl'],
                        brandName: context.currentBeamLocation.state.data['delivering'][index]['brandName'],
                        productName: context.currentBeamLocation.state.data['delivering'][index]['productName'],
                        size: context.currentBeamLocation.state.data['delivering'][index]['size'],
                        mappingSize: context.currentBeamLocation.state.data['delivering'][index]['mappingSize'],
                        rentalDuration: context.currentBeamLocation.state.data['delivering'][index]['rentalDuration'],
                        rentalStatus: context.currentBeamLocation.state.data['delivering'][index]['rentalStatus'],
                      );
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: proWidth(3)),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: context.currentBeamLocation.state.data['borrowing'].length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      //mainAxisExtent: 300,
                      childAspectRatio: (0.54),
                    ),
                    itemBuilder: (BuildContext ctx, index){
                      return BorrowingCard(
                        orderId: context.currentBeamLocation.state.data['borrowing'][index]['orderId'],
                        productId: context.currentBeamLocation.state.data['borrowing'][index]['productId'],
                        rentalRequestId: context.currentBeamLocation.state.data['borrowing'][index]['rentalRequestId'],
                        imageUrl: context.currentBeamLocation.state.data['borrowing'][index]['imageUrl'],
                        brandName: context.currentBeamLocation.state.data['borrowing'][index]['brandName'],
                        productName: context.currentBeamLocation.state.data['borrowing'][index]['productName'],
                        size: context.currentBeamLocation.state.data['borrowing'][index]['size'],
                        mappingSize: context.currentBeamLocation.state.data['borrowing'][index]['mappingSize'],
                        rentalDuration: context.currentBeamLocation.state.data['borrowing'][index]['rentalDuration'],
                        returnDate: context.currentBeamLocation.state.data['borrowing'][index]['returnDate'],
                        rentalStatus: context.currentBeamLocation.state.data['borrowing'][index]['rentalStatus'],
                      );
                    }
                ),
              ),
              //반납완료 화면
              Padding(
                padding: EdgeInsets.only(right: proWidth(3)),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: context.currentBeamLocation.state.data['returning'].length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (0.5),
                    ),
                    itemBuilder: (BuildContext ctx, index){
                      return ReturningCard(
                        orderId: context.currentBeamLocation.state.data['returning'][index]['orderId'],
                        productId: context.currentBeamLocation.state.data['returning'][index]['productId'],
                        rentalRequestId: context.currentBeamLocation.state.data['returning'][index]['rentalRequestId'],
                        imageUrl: context.currentBeamLocation.state.data['returning'][index]['imageUrl'],
                        brandName: context.currentBeamLocation.state.data['returning'][index]['brandName'],
                        productName: context.currentBeamLocation.state.data['returning'][index]['productName'],
                        size: context.currentBeamLocation.state.data['returning'][index]['size'],
                        mappingSize: context.currentBeamLocation.state.data['returning'][index]['mappingSize'],
                        rentalDuration: context.currentBeamLocation.state.data['returning'][index]['rentalDuration'],
                        returnDate: context.currentBeamLocation.state.data['returning'][index]['returnDate'],
                        rentalStatus: context.currentBeamLocation.state.data['returning'][index]['rentalStatus'],
                        reviewId: context.currentBeamLocation.state.data['returning'][index]['reviewId'],
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}