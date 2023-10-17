import 'package:app_v2/screens/community/components/article/write_article_page.dart';
import 'package:app_v2/screens/input/input_screen.dart';
import 'package:app_v2/screens/login/forgot_id.dart';
import 'package:app_v2/screens/payment/payment_complete.dart';
import 'package:app_v2/screens/profile/borrowing/borrowing_body.dart';
import 'package:app_v2/screens/home/items_page.dart';
import 'package:app_v2/screens/clothing/clothing_page.dart';
import 'package:app_v2/screens/profile/webview/%EC%9D%B4%EC%9A%A9%EC%95%BD%EA%B4%80.dart';
import 'package:app_v2/screens/reviews/review_write_page.dart';

//Closet Page
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:app_v2/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:app_v2/states/category_notifier.dart';
import '../screens/home.dart';
import '../screens/community/community_body.dart';
import '../screens/community/components/article/article_page.dart';
import '../screens/home/components/categories/newin_page.dart';
import '../screens/home/components/categories/trending_page.dart';
import '../screens/login/components/signup/signup_birth.dart';
import '../screens/login/components/signup/signup_brand.dart';
import '../screens/login/components/signup/signup_gender.dart';
import '../screens/login/components/signup/signup_name.dart';
import '../screens/login/components/signup/signup_nickname.dart';
import '../screens/login/components/signup/signup_phone.dart';
import '../screens/login/components/signup/signup_pw.dart';
import '../screens/login/components/signup/signup_size.dart';
import '../screens/login/components/signup/signup_veri.dart';
import '../screens/login/found_id.dart';
import '../screens/login/components/login/login.dart';
import '../screens/login/login_page.dart';
import '../screens/login/new_pw.dart';
import '../screens/login/signup_body.dart';
import '../screens/notification/notification_page.dart';
import '../screens/payment/payment_page.dart';
import '../screens/payment/receipt_page.dart';
import '../screens/profile/coupon/coupon_page.dart';
import '../screens/profile/profile_edit_page.dart';
import '../screens/profile/webview/교환정책.dart';
import '../screens/profile/webview/반납안내.dart';
import '../screens/profile/webview/패널티정책.dart';
import '../screens/reviews/reviews_page/reviews_page.dart';
import '../screens/reviews/specific_review_page.dart';
import '../screens/search/search_screen.dart';
import '../screens/sell/sell_page.dart';
import '../screens/shoppingcart/shopping_cart_page.dart';
import '../screens/profile/closet_page.dart';
//비머 홈로케이션 클래스 생성(인스턴스)
class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state){
    return [BeamPage(child: HomeScreen(), key: ValueKey('home_screen'))];
  }

  @override
  List get pathBlueprints => ['/'];
}

class InputLocation extends BeamLocation {

  //Product product = context.currentBeamLocation.state.data['product'];
  @override
  Widget builder(BuildContext context, Widget navigator) {
    return ChangeNotifierProvider.value(
        value: categoryNotifier,
        child: super.builder(context, navigator));
  }

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state){
    return [
      ...HomeLocation().buildPages(context, state),
      if(state.pathBlueprintSegments.contains('input'))
      BeamPage(
        child: InputScreen(),
        key: ValueKey('input')

      ),
      if(state.pathBlueprintSegments.contains('log'))
        BeamPage(
            child: Login(),
            key: ValueKey('log')

        ),
      if(state.pathBlueprintSegments.contains('signup_name'))
        BeamPage(
            child: SignNamePage(),
            key: ValueKey('signup_name')

        ),
      if(state.pathBlueprintSegments.contains('signup_birth'))
        BeamPage(
            child: SignBirthPage(),
            key: ValueKey('signup_birth')
        ),
      if(state.pathBlueprintSegments.contains('signup_phone'))
        BeamPage(
            child: SignPhonePage(),
            key: ValueKey('signup_phone')
        ),
      if(state.pathBlueprintSegments.contains('signup_veri'))
        BeamPage(
            child: SignVeriPage(),
            key: ValueKey('signup_veri')
        ),
      if(state.pathBlueprintSegments.contains('signup_nickname'))
        BeamPage(
            child: SignNicknamePage(),
            key: ValueKey('signup_nickname')
        ),
      if(state.pathBlueprintSegments.contains('signup_pw'))
        BeamPage(
            child: SignPwPage(),
            key: ValueKey('signup_pw')
        ),
      if(state.pathBlueprintSegments.contains('signup_brand'))
        BeamPage(
            child: SignBrandPage(),
            key: ValueKey('signup_brand')
        ),
      if(state.pathBlueprintSegments.contains('signup_gender'))
        BeamPage(
            child: SignGenderPage(),
            key: ValueKey('signup_gender')
        ),
      if(state.pathBlueprintSegments.contains('signup_size'))
        BeamPage(
            child: SignSizePage(),
            key: ValueKey('signup_size')
        ),
      if(state.pathBlueprintSegments.contains('borrowing'))
        BeamPage(
            child: BorrowingBody(),
            key: ValueKey('borrowing')

        ),
      if(state.pathBlueprintSegments.contains('items'))
      BeamPage(
          child: ItemsPage(),
          key: ValueKey('items')

      ),
      if(state.pathBlueprintSegments.contains('clothing_page'))
        BeamPage(
            child: ClothingPage(),
            key: ValueKey('clothing_page')
        ),
      if(state.pathBlueprintSegments.contains('closet_page'))
        BeamPage(
            child: ClosetPage(),
            key: ValueKey('closet_page')
        ),
      if(state.pathBlueprintSegments.contains('shopping_cart'))
        BeamPage(
            child: ShoppingCartPage(),
            key: ValueKey('shopping_cart')
        ),
      if(state.pathBlueprintSegments.contains('search'))
        BeamPage(
            child: SearchPage(),
            key: ValueKey('search')
        ),
      if(state.pathBlueprintSegments.contains('newin_page'))
        BeamPage(
            child: NewInPage(),
            key: ValueKey('newin_page')
        ),
      if(state.pathBlueprintSegments.contains('specific_review'))
        BeamPage(
            child: SpecificReviewPage(),
            key: ValueKey('specific_review')
        ),
      if(state.pathBlueprintSegments.contains('reviews'))
        BeamPage(
            child: ReviewsPage(),
            key: ValueKey('reviews')
        ),
      if(state.pathBlueprintSegments.contains('write_review'))
        BeamPage(
            child: ReviewWritePage(),
            key: ValueKey('write_review')
        ),
      if(state.pathBlueprintSegments.contains('forgot_id'))
        BeamPage(
            child: ForgotIdPage(),
            key: ValueKey('forgot_id')
        ),
      if(state.pathBlueprintSegments.contains('login'))
        BeamPage(
            child: LoginPage(),
            key: ValueKey('login')
        ),
      if(state.pathBlueprintSegments.contains('found_id'))
        BeamPage(
            child: FoundIdPage(),
            key: ValueKey('found_id')
        ),
      if(state.pathBlueprintSegments.contains('new_pw'))
        BeamPage(
            child: NewPwPage(),
            key: ValueKey('new_pw')
        ),
      if(state.pathBlueprintSegments.contains('article_page'))
        BeamPage(
            child: ArticlePage(),
            key: ValueKey('article_page')
        ),
      if(state.pathBlueprintSegments.contains('community'))
        BeamPage(
            child: CommunityBody(),
            key: ValueKey('community')
        ),
      if(state.pathBlueprintSegments.contains('write_article'))
        BeamPage(
            child: WriteArticlePage(),
            key: ValueKey('write_article')
        ),
      if(state.pathBlueprintSegments.contains('notification'))
        BeamPage(
            child: NotificationPage(),
            key: ValueKey('notification')
        ),
      if(state.pathBlueprintSegments.contains('receipt'))
        BeamPage(
            child: ReceiptPage(),
            key: ValueKey('receipt')
        ),
      if(state.pathBlueprintSegments.contains('coupon'))
        BeamPage(
            child: CouponPage(),
            key: ValueKey('coupon')
        ),
      if(state.pathBlueprintSegments.contains('profile_edit'))
        BeamPage(
            child: ProfileEditPage(),
            key: ValueKey('profile_edit')
        ),
      if(state.pathBlueprintSegments.contains('payment'))
        BeamPage(
            child: PaymentPage(),
            key: ValueKey('payment')
        ),
      if(state.pathBlueprintSegments.contains('trending'))
        BeamPage(
            child: TrendingPage(),
            key: ValueKey('trending')
        ),
      if(state.pathBlueprintSegments.contains('home'))
        BeamPage(
            child: Home(),
            key: ValueKey('home')
        ),
      if(state.pathBlueprintSegments.contains('policy'))
        BeamPage(
            child: UsePolicy(),
            key: ValueKey('policy')
        ),
      if(state.pathBlueprintSegments.contains('penalty'))
        BeamPage(
            child: Penalty(),
            key: ValueKey('penalty')
        ),
      if(state.pathBlueprintSegments.contains('return'))
        BeamPage(
            child: Return(),
            key: ValueKey('return')
        ),
      if(state.pathBlueprintSegments.contains('privacy'))
        BeamPage(
            child: Privacy(),
            key: ValueKey('privacy')
        ),
      if(state.pathBlueprintSegments.contains('payment_complete'))
        BeamPage(
            child: PaymentComplete(),
            key: ValueKey('payment_complete')
        ),
      if(state.pathBlueprintSegments.contains('sell_page'))
        BeamPage(
            child: SellPage(),
            key: ValueKey('sell_page')
        ),
    ];
  }

  @override
  List get pathBlueprints => ['/input','/log',
    '/signup_name','/signup_birth','/signup_phone','/signup_veri','/signup_nickname','/signup_pw','/signup_brand','/signup_gender','/signup_size','/borrowing',
  '/items','/clothing_page','closet_page','/shopping_cart','/search','/newin_page','/specific_review','/reviews','/write_review','/forgot_id','/login'
  '/found_id','new_pw','/article_page','/community','/write_article','/notification','/receipt'
  '/coupon','profile_edit','/payment','/trending','/home','/policy','/penalty','/return','/privacy','/payment_complete','/sell_page'];

}