import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/screens/about_us.dart';
import 'package:remuse_builder/screens/all_premium_access_page.dart';
import 'package:remuse_builder/screens/apps_store.dart';
import 'package:remuse_builder/screens/feedback.dart';
import 'package:remuse_builder/screens/more_apps.dart';
import 'package:remuse_builder/screens/privacy_policy.dart';
import 'package:remuse_builder/screens/rate_us.dart';
import 'package:remuse_builder/screens/share_us.dart';
import 'package:remuse_builder/screens/tutorial_video.dart';
import 'package:remuse_builder/screens/user_guide.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool status = false;

  // initPrefernce() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('stringValue', "abc");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kAppBarColor,
        centerTitle: true,
        title: AppButtons().kTextNormal(title: 'Build CV Resume Creator', fontSize: 20, fontWeight: FontWeight.bold, fontColor: AppColors.kWhite),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppButtons().kTextNormal(title: AppStrings.kMyAccount, fontSize: 15, fontWeight: FontWeight.w400, fontColor: AppColors.kDarkGrey),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kPremium);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const AllPremiumAccess()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kPremium, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                    color: AppColors.kLightWhite,
                    border: Border.all(
                      color: const Color(0xFFD9D9D9),
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          offset: Offset(0, 3)),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      AppButtons().kTextNormal(title: AppStrings.kNotification, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                      const Spacer(),
                      Switch(
                        value: status,
                        onChanged: (value) {
                          setState(() {
                            status = value;
                            print(status);
                          });
                        },
                        activeTrackColor: AppColors.kGreyBlue,
                        activeColor: AppColors.kNavyBlue,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                AppStrings.kHotUse,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kDarkGrey),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kGuide);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const UserGuidePage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kGuide, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kTutorial);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const TutorialVideoPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kTutorial, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              AppButtons().kTextNormal(title: AppStrings.kSupport, fontSize: 15, fontWeight: FontWeight.w400, fontColor: AppColors.kDarkGrey),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kRate);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const RateUsPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kRate, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kFeedback);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const FeedbackPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kFeedback, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              AppButtons().kTextNormal(title: AppStrings.kMoreAbout, fontSize: 15, fontWeight: FontWeight.w400, fontColor: AppColors.kDarkGrey),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kAbout);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutUsPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kAbout, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kShare);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ShareUsPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kShare, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kMoreApp);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const MoreAppsPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kMoreApp, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print(AppStrings.kPrivacy);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrivacyPolicyPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.kLightWhite,
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppButtons().kTextNormal(title: AppStrings.kPrivacy, fontSize: 17, fontWeight: FontWeight.normal, fontColor: AppColors.kBlack),
                        const Spacer(),
                        const Icon(Icons.chevron_right,color: AppColors.kGrey,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              AppButtons().kTextNormal(title: AppStrings.kFollow, fontSize: 15, fontWeight: FontWeight.w400, fontColor: AppColors.kDarkGrey),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                    color: AppColors.kLightWhite,
                    border: Border.all(
                      color: const Color(0xFFD9D9D9),
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          offset: Offset(0, 3)),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/images/whatsapp.png',width: 50,height: 50,),
                      Image.asset('assets/images/gmail.png',width: 50,height: 50,),
                      Image.asset('assets/images/facebook.png',width: 50,height: 50,),
                      Image.asset('assets/images/instagram.png',width: 50,height: 50,),
                      // FaIcon(FontAwesomeIcons.whatsapp,size: 40,),
                      // FaIcon(FontAwesomeIcons.envelope,size: 40,),
                      // FaIcon(FontAwesomeIcons.facebook,size: 40,),
                      // FaIcon(FontAwesomeIcons.instagram,size: 40,),
                      // Icon(FaIcon(FontAwesomeIcons.arrowLeft),color: AppColors.kGrey,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
