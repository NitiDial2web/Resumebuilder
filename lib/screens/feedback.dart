import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/screens/apps_store.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _feedback = TextEditingController();

  // Future sendFeedback() async {
  //   print(
  //       'preferences.getString(AppStrings.kPrefUserIdKey):${preferences.getString(AppStrings.kPrefUserIdKey).toString()}');
  //   var response = await http.post(Uri.parse(AppStrings.kcreateJournal), body: {
  //     "journal_title": _titleController.text,
  //     "journal_description": _journalController.text,
  //     "user_id": preferences.getString(AppStrings.kPrefUserIdKey).toString(),
  //     "created_at": _dateTime,
  //     "journal_emoji": _emojiValue
  //   });
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   var data = json.decode(response.body);
  //   if (data["status"] == true) {
  //     var _usersData = data['data'];
  //     print(_usersData);
  //     _titleController.clear();
  //     _journalController.clear();
  //     AppCommon.showToast(data["message"]);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Journals(),
  //       ),
  //     );
  //   } else {
  //     AppCommon.showToast(data["message"]);
  //   }
  // }

  // Future<Fruit> sendFeedback(
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kAppBarColor,
        // centerTitle: true,
        title: AppButtons().kTextNormal(
            title: AppStrings.kFeedback,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // FaIcon(FontAwesomeIcons.)
                const Icon(
                  Icons.note_alt_outlined,
                  size: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppButtons().kTextNormal(title: AppStrings.kFeedback, fontSize: 25, fontWeight: FontWeight.w400, fontColor: AppColors.kBlack),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _feedback,
                    minLines: 8,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      // labelText: 'Enter text',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                AppButtons().kElevatedButton(title: AppStrings.kSubmit)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
