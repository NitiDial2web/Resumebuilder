import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/models/demo_model.dart';
import 'package:remuse_builder/models/get_privacy_policy.dart';
import 'package:remuse_builder/screens/apps_store.dart';
import 'package:http/http.dart' as http;

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String _description = '';

  @override
  void initState(){
    super.initState();
    privacy();
  }

  Future<GetPrivacyPolicy?> privacy() async {
      // preferences = await SharedPreferences.getInstance();
      try {
        final response = await http.get(Uri.parse(AppStrings.kGetPrivacyPolicyUrl),
            // body: {"users_id": preferences.getString(AppStrings.kPrefUserIdKey)}
        );

        var responseData = jsonDecode(response.body);
        print('response images  $responseData');
        print('response.statusCode:${response.statusCode}');
        if (response.statusCode == 200) {
          if (responseData['success'] == 1) {
            var _usersData = responseData['data'];
            print(_usersData);
            setState(() {
              _description = _usersData[0]['description'];
              // _subscriptionExpired = _usersData[0]['subscription_expired'];
              // _subscriptionType = _usersData[0]['subscription_type'];
            });
            print('_description:$_description');
            return GetPrivacyPolicy.fromJson(responseData);
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

  // Future<List<AutoGenerate>?> privacy() async {
  //   print('privacy');
  //   try {
  //     // var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
  //     var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
  //     var data = json.decode(response.body);
  //     print('DATA11: $data');
  //     print('response.statusCode${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       print('DATA: $data');
  //       // List<AutoGenerate> _model = userModelFromJson(response.body);
  //       // return _model;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kAppBarColor,
        // centerTitle: true,
        title: AppButtons().kTextNormal(
            title: AppStrings.kPrivacy,
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
              onTap: (){
                print('Ads');
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AppsStorePage()));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              AppButtons().kTextBold(
                  title: AppStrings.kPrivacy,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontColor: AppColors.kBlack),
              const SizedBox(
                height: 15,
              ),
              AppButtons().kTextNormal(
                  title:
                      _description,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontColor: AppColors.kBlack)
            ],
          ),
        ),
      ),
    );
  }
}
