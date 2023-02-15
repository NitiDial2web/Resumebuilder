import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/models/demo_model.dart';
import 'package:remuse_builder/models/get_user_guide.dart';
import 'package:remuse_builder/screens/apps_store.dart';

class UserGuidePage extends StatefulWidget {
  const UserGuidePage({Key? key}) : super(key: key);

  @override
  State<UserGuidePage> createState() => _UserGuidePageState();
}

class _UserGuidePageState extends State<UserGuidePage> {
  int currentPos = 0;
  List<int> list = [1, 2, 3, 4, 5];
  List<String> _images = [];

  @override
  void initState(){
    super.initState();
    getUsers();
  }

  Future<GetUserGuideModel?> getUsers() async {
      // preferences = await SharedPreferences.getInstance();
      try {
        final response = await http.get(Uri.parse(AppStrings.kGetUserGuideUrl),
            // body: {"users_id": preferences.getString(AppStrings.kPrefUserIdKey)}
        );

        // var responseData = jsonDecode(response.body);
        var responseData = json.decode(response.body);
        print('response images  $responseData');
        print('response.statusCode:${response.statusCode}');
        if (response.statusCode == 200) {
          print("test1");
          if (responseData['success'] == 1) {
            var _usersData = responseData['data'];
            print('_usersData:$_usersData');
            print(responseData['data'].length);
            setState(() {
              for(int i = 0; i<_usersData.length;i++){
                _images.add(_usersData[i]['image']);
              }
              print('_images :$_images');
            });
            print('niti');
            print(_usersData);
            return GetUserGuideModel.fromJson(responseData);
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
      // return null;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kAppBarColor,
        // centerTitle: true,
        title: AppButtons().kTextNormal(title: AppStrings.kGuide, fontSize: 20, fontWeight: FontWeight.bold, fontColor: AppColors.kWhite),
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 70,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 0.5,
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    scrollDirection: Axis.horizontal,
                    autoPlay: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPos = index;
                      });
                    }),
                items: _images
                    .map((item) => Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 40, bottom: 20),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  item),
                              fit: BoxFit.fill),
                          color: AppColors.kGrey,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                offset: Offset(0, 3)),
                          ],
                          borderRadius: const BorderRadius.all(
                              Radius.circular(30))),
                      // child: Text(item.toString()),
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _images.map((url) {
                int index = _images.indexOf(url);
                return Container(
                  width: (currentPos == index) ? 15 : 10,
                  height: (currentPos == index) ? 15 : 10,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPos == index
                        ? AppColors.kLightGreen
                        : AppColors.kLightGrey,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
