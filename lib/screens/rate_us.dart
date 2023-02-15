import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/screens/apps_store.dart';

class RateUsPage extends StatefulWidget {
  const RateUsPage({Key? key}) : super(key: key);

  @override
  State<RateUsPage> createState() => _RateUsPageState();
}

class _RateUsPageState extends State<RateUsPage> {
  late final _ratingController;
  late double _rating;

  double _userRating = 3.0;
  int _ratingBarMode = 1;
  final double _initialRating = 0;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData? _selectedIcon;

  // Future<Fruit> sendRate(
  //     String title, int id, String imageUrl, int quantity) async {
  //   final http.Response response = await http.post(
  //     'url',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'title': title,
  //       'id': id.toString(),
  //       'imageUrl': imageUrl,
  //       'quantity': quantity.toString()
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     return Fruit.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load album');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kAppBarColor,
        // centerTitle: true,
        title: AppButtons().kTextNormal(title: AppStrings.kRate, fontSize: 20, fontWeight: FontWeight.bold, fontColor: AppColors.kWhite),
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
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[AppColors.kLightGreen, Color(0xFFA8E4E4)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.x,
                          size: 30,
                          color: AppColors.kWhite,
                        )
                      ],
                    ),
                    AppButtons().kTextNormal(title: AppStrings.kRate, fontSize: 40, fontWeight: FontWeight.w700, fontColor: AppColors.kWhite),
                    const Spacer(),
                    RatingBar.builder(
                      initialRating: _initialRating,
                      minRating: 1,
                      direction: _isVertical ? Axis.vertical : Axis.horizontal,
                      allowHalfRating: true,
                      unratedColor: AppColors.kWhite,
                      itemCount: 5,
                      itemSize: 50.0,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        _selectedIcon ?? Icons.star,
                        color: Colors.blue,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                      updateOnDrag: true,
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
