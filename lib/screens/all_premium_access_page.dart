import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/screens/apps_store.dart';

class AllPremiumAccess extends StatefulWidget {
  const AllPremiumAccess({Key? key}) : super(key: key);

  @override
  State<AllPremiumAccess> createState() => _AllPremiumAccessState();
}

class _AllPremiumAccessState extends State<AllPremiumAccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kAppBarColor,
        // centerTitle: true,
        title: AppButtons().kTextNormal(title: AppStrings.kPremium, fontSize: 20, fontWeight: FontWeight.bold, fontColor: AppColors.kWhite),
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
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  AppColors.kLightGreen,
                  Color(0xFFC4F3E2)
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.x,
                        size: 30,
                        color: AppColors.kWhite,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppButtons().kTextBold(title: AppStrings.kUnlockFeatures, fontSize: 35, fontWeight: FontWeight.w700, fontColor: AppColors.kWhite),
                  AppButtons().kTextNormal(title: AppStrings.kTemplatesGraphics, fontSize: 16, fontWeight: FontWeight.w400, fontColor: AppColors.kWhite),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 350,
            child: Center(
              child: Container(
                width: 300,
                height: 100,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        AppColors.kLightGreen,
                        Color(0xFFA8E4E4)
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.crown,
                        size: 30,
                        color: AppColors.kWhite,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: [
                          AppButtons().kTextNormal(title: AppStrings.kLifetime, fontSize: 13, fontWeight: FontWeight.w400, fontColor: AppColors.kWhite),
                          AppButtons().kTextNormal(title: AppStrings.kBuy, fontSize: 30, fontWeight: FontWeight.w700, fontColor: AppColors.kWhite),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
