// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/services.dart';
// // import 'package:path_provider_ex/path_provider_ex.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:external_path/external_path.dart';
// class DemoPage extends StatefulWidget {
//   DemoPage({Key? key}) : super(key: key);
// @override
// State<DemoPage> createState() => _DemoPageState();
// }
// class _DemoPageState extends State<DemoPage> {
//   @override
//   void initState() {
//     super.initState();
//     getPermission();
//     getMobileStorageInfo();
//   }
//   int _counter = 0;
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   Future download2(Dio dio, String url, String savePath) async {
//     try {
//       Response response = await dio.get(
//         url,
//         onReceiveProgress: showDownloadProgress,
//         //Received data with List<int>
//         options: Options(
//             responseType: ResponseType.bytes,
//             followRedirects: false,
//             validateStatus: (status) {
//               return status! < 500;
//             }),
//       );
//       print(response.headers);
//       File file = File(savePath);
//       var raf = file.openSync(mode: FileMode.write);
//       // response.data is List<int> type
//       raf.writeFromSync(response.data);
//       await raf.close();
//     } catch (e) {
//       print(e);
//     }
//   }
//   late List<String> storageInfo;
//   Future<List<String>> getMobileStorageInfo() async {
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       storageInfo = await ExternalPath.getExternalStorageDirectories();
//       // storageInfo = await PathProviderEx.getStorageInfo();
//       print('getMobileStorageInfo : ${storageInfo.toList()}');
//     } on PlatformException {}
//     return storageInfo;
//   }
//   getPermission() async {
//     if (await Permission.contacts.request().isGranted) {
//       // Either the permission was already granted before or the user just granted it.
//     } else {
// // You can request multiple permissions at once.
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.storage,
//       ].request();
//       print('getPermission else : ${statuses[Permission.storage]}');
//     }
//   }
//
//   void showDownloadProgress(received, total) {
//     if (total != -1) {
//       print((received / total * 100).toStringAsFixed(0) + "%");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(''),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton.icon(
//                 onPressed: () async {
//                   String fullPath =
//                       '$storageInfo/Download/boo2.pdf';
//                   // String fullPath;
//
//                   print('full path ${fullPath}');
//                   final imgUrl =
//                       "https://api.aseztak.com/storage/invoice/ORD-5F606C9A927B4.pdf";
//                   var dio = Dio();
//
//                   download2(dio, imgUrl, fullPath);
//                 },
//                 icon: Icon(
//                   Icons.file_download,
//                   color: Colors.white,
//                 ),
//                 // color: Colors.green,
//                 // textColor: Colors.white,
//                 label: Text('Dowload Invoice')),
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               // style: Theme.of(context).textTheme.display1,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }