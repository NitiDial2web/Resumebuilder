import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/models/share_us.dart';
import 'package:remuse_builder/screens/apps_store.dart';

class ShareUsPage extends StatefulWidget {
  const ShareUsPage({Key? key}) : super(key: key);

  @override
  State<ShareUsPage> createState() => _ShareUsPageState();
}

class _ShareUsPageState extends State<ShareUsPage> {
  String whatsapp = '';
  String facebook = '';
  String twitter = '';
  String gmail = '';
  String insta = '';
  String linkedIn = '';
  String pInterest = '';

  final FlutterShareMe flutterShareMe = FlutterShareMe();

  shareOnInstagram() async {
    String? result = await FlutterSocialContentShare.share(
        type: ShareType.instagramWithImageUrl,
        url: insta,
        imageUrl:
            "https://post.healthline.com/wp-content/uploads/2020/09/healthy-eating-ingredients-732x549-thumbnail-732x549.jpg");
    print(result); 
  }

  shareWatsapp() async {
    // String? result = await FlutterSocialContentShare.shareOnWhatsapp(
    //     whatsapp, "Text appears here");
    // print(result);
    flutterShareMe.shareWhatsAppPersonalMessage(message: "Text appears here", phoneNumber: whatsapp);
  }

  shareTwitter() async {
    flutterShareMe.shareToTwitter(
        url: twitter,
        // url: 'https://pub.dev/packages/flutter_share_me',
        msg:
            'Flutter share is great!!\n Check out full example at https://pub.dev/packages/flutter_share_me');
    // String? result = await FlutterSocialContentShare.shareOnWhatsapp(
    //     "xxxxxx", "Text appears here");
    // print(result);
  }

  shareOnFacebook() async {
    String? result = await FlutterSocialContentShare.share(
        type: ShareType.facebookWithoutImage,
        // url: "https://www.apple.com",
        url: facebook,
        quote: "captions");
    print(result);
  }

  shareEmail() async {
    String? result = await FlutterSocialContentShare.shareOnEmail(
        recipients: ["xxxx.xxx@gmail.com"],
        subject: "Subject appears here",
        body: "Body appears here",
        isHTML: true); //default isHTML: False
    print(result);
  }

  Future<GetShareUsModel?> getShareUs() async {
    // preferences = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        Uri.parse(AppStrings.kGetShareUsUrl),
        // body: {"users_id": preferences.getString(AppStrings.kPrefUserIdKey)}
      );

      var responseData = jsonDecode(response.body);
      print('response images  $responseData');
      print('response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        if (responseData['success'] == 1) {
          var _usersData = responseData['data'];
          setState(() {
            whatsapp = _usersData[0]['whats_app'];
            facebook = _usersData[0]['facebook'];
            insta = _usersData[0]['instagram'];
            twitter = _usersData[0]['twitter'];
            linkedIn = _usersData[0]['linked_in'];
            pInterest = _usersData[0]['pinterest'];
          });
          print(whatsapp);
          return GetShareUsModel.fromJson(responseData);
        } else {
          print("else responseData['status'] :${responseData['status']}");
          // AppCommon.showToast(responseData["message"]);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (exception) {
      print('exception getHomeImages $exception');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getShareUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kAppBarColor,
        // centerTitle: true,
        title: AppButtons().kTextNormal(
            title: AppStrings.kShare,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontColor: AppColors.kWhite),
        leading: IconButton(
          icon: const Icon(Icons.settings, size: 25),
          color: AppColors.koffWhite,
          onPressed: () {
            print('settings clicked');
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                print('Ads');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppsStorePage()));
              },
              child: Image.asset(
                'assets/images/Web_Advertising.png',
                width: 25,
                height: 25,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 330,
              height: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[AppColors.kLightGreen, AppColors.kWhite],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        offset: Offset(0, 3)),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              print('whatsapp');
                              shareWatsapp();
                            },
                            child: Image.asset(
                              'assets/images/whatsapp.png',
                              width: 50,
                              height: 50,
                            )),
                        GestureDetector(
                          onTap: () {
                            print('gmail');
                            shareEmail();
                          },
                          child: Image.asset(
                            'assets/images/gmail.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('facebook');
                            shareOnFacebook();
                          },
                          child: Image.asset(
                            'assets/images/facebook.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('insta');
                            shareOnInstagram();
                          },
                          child: Image.asset(
                            'assets/images/instagram.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        // FaIcon(FontAwesomeIcons.whatsapp,size: 40,),
                        // FaIcon(FontAwesomeIcons.envelope,size: 40,),
                        // FaIcon(FontAwesomeIcons.facebook,size: 40,),
                        // FaIcon(FontAwesomeIcons.instagram,size: 40,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/linkedin.png',
                          width: 50,
                          height: 50,
                        ),
                        Image.asset(
                          'assets/images/youtube1.png',
                          width: 50,
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('twitter');
                            shareTwitter();
                          },
                          child: Image.asset(
                            'assets/images/twitter.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Image.asset(
                          'assets/images/tik-tok1.png',
                          width: 50,
                          height: 50,
                        ),
                        // FaIcon(FontAwesomeIcons.linkedin,size: 40,),
                        // FaIcon(FontAwesomeIcons.youtube,size: 40,),
                        // FaIcon(FontAwesomeIcons.twitter,size: 40,),
                        // FaIcon(FontAwesomeIcons.tiktok,size: 40,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
