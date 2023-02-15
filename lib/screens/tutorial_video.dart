import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/models/demo_model.dart';
import 'package:remuse_builder/models/tutorial_video.dart';
import 'package:remuse_builder/screens/apps_store.dart';

class TutorialVideoPage extends StatefulWidget {
  const TutorialVideoPage({Key? key}) : super(key: key);

  @override
  State<TutorialVideoPage> createState() => _TutorialVideoPageState();
}

class _TutorialVideoPageState extends State<TutorialVideoPage> {
  List<String> _videos = [];

  @override
  void initState() {
    super.initState();
    tutorialVideo();
  }

  Future<GetVideoModel?> tutorialVideo() async {
    // preferences = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        Uri.parse(AppStrings.kGetVideoUrl),
        // body: {"users_id": preferences.getString(AppStrings.kPrefUserIdKey)}
      );

      var responseData = jsonDecode(response.body);
      print('response apps  $responseData');
      print('response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        if (responseData['success'] == 1) {
          var _usersData = responseData['data'];
          for (int i = 0; i < _usersData.length; i++) {
            _videos.add(_usersData[i]['video']);
          }
          print('_videos :$_videos');
          return GetVideoModel.fromJson(responseData);
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
        title: AppButtons().kTextNormal(
            title: AppStrings.kTutorial,
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
      body: FutureBuilder<GetVideoModel?>(
          future: tutorialVideo(),
          builder: (BuildContext context,AsyncSnapshot<GetVideoModel?> snapshot) {
            print('niti1111:${snapshot.data!.data.first.video}');
            // print('snapshot.connectionState:${snapshot.connectionState}');
            // if(snapshot.connectionState == ConnectionState.done){
              if (!snapshot.hasData) {
                print('if condition');
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {
                print('else condition');
                return ListView.builder(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 170,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    snapshot.data!.data[index].video),
                                fit: BoxFit.fill),
                            color: AppColors.kGrey,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 3)),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text('${snapshot.data!.data[index].video}'),
                      ),
                    );
                  },
                );
              }
            // }
            // else{
            //   return Center(
            //     child: CircularProgressIndicator(color: Colors.red,),
            //   );
            // }
          }),
      // body: ListView.builder(
      //     itemCount: _videos.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Padding(
      //         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      //         child: Container(
      //           width: MediaQuery.of(context).size.width,
      //           height: 170,
      //           decoration: BoxDecoration(
      //               image: DecorationImage(
      //                   image:
      //                   NetworkImage('${_videos[index]}'),
      //                   fit: BoxFit.fill),
      //               color: AppColors.kGrey,
      //               boxShadow: [
      //                 BoxShadow(
      //                     color: Colors.grey,
      //                     blurRadius: 5.0,
      //                     offset: Offset(0, 3)),
      //               ],
      //               borderRadius: BorderRadius.all(Radius.circular(30))),
      //           child: Text('${_videos[index]}'),
      //         ),
      //       );
      //     }),
    );
  }
}
