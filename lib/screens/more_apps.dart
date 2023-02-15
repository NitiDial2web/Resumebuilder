import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/models/more_apps.dart';
import 'package:remuse_builder/screens/apps_store.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreAppsPage extends StatefulWidget {
  const MoreAppsPage({Key? key}) : super(key: key);

  @override
  State<MoreAppsPage> createState() => _MoreAppsPageState();
}

class _MoreAppsPageState extends State<MoreAppsPage> {
  _launchDeveloperPage() async {
    const url =
        'https://play.google.com/store/apps/developer?id=4647998716943242763';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<GetMoreAppsModel?> getMoreApps() async {
    // preferences = await SharedPreferences.getInstance();
    try {
      final response = await http.post(Uri.parse(AppStrings.kGetShareUsUrl),
        // body: {"users_id": preferences.getString(AppStrings.kPrefUserIdKey)}
      );

      var responseData = jsonDecode(response.body);
      print('response images  $responseData');
      print('response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          var _usersData = responseData['data'];
          setState(() {
            // _subscriptionStatus = _usersData[0]['subscription_status'];
            // _subscriptionExpired = _usersData[0]['subscription_expired'];
            // _subscriptionType = _usersData[0]['subscription_type'];
          });
          // print(_subscriptionStatus);
          return GetMoreAppsModel.fromJson(responseData);
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
  void initState(){
    super.initState();
    getMoreApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kAppBarColor,
        // centerTitle: true,
        title: AppButtons().kTextNormal(
            title: AppStrings.kMoreApp,
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
      body: Center(
        // child: FaIcon(FontAwesomeIcons.googlePlay,size: 200,),
        child: GestureDetector(
          onTap: (){
            print('play store');
            _launchDeveloperPage();
          },
            child: Image.asset(
          'assets/images/google-play.png',
          width: 250,
          height: 250,
        )),
      ),
    );
  }
}
