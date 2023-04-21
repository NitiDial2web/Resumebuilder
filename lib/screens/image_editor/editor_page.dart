import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;
// import 'dart:html' as html;
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
// import 'package:webview_flutter/webview_flutter.dart';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html_to_pdf/file_utils.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:remuse_builder/main.dart';
import 'package:remuse_builder/screens/image_editor/effects.dart';
import 'package:remuse_builder/screens/image_editor/text_info.dart';
import 'package:remuse_builder/screens/image_editor/utils.dart';
import 'package:remuse_builder/screens/image_editor/image_text.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
class EditorPage extends StatefulWidget {
  final File? imageBg;

  const EditorPage({Key? key, this.imageBg}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>
    with AutomaticKeepAliveClientMixin<EditorPage> {
  File? image;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  List<TextInfo> texts = [];
  int currentIndex = 0;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  late InAppWebViewController _controller;

  // late WebViewController _controller;
  String uri = "https://visitmysite.in/pixie/index.html";
  ReceivePort _port = ReceivePort();
  String url = "";
  double progress = 0;
  late File _imageFile;

  // bool isStoragePermission = true;
  // bool isVideosPermission = true;
  // bool isPhotosPermission = true;
  // final pdf = pw.Document();
  // WebViewPlusController? _controller;
  // @override
  // void initState(){
  //   super.initState();
  //   initPref();
  // }
  // void initPref() async{
  //   prefs = await SharedPreferences.getInstance();
  // }
  // Future<File?> cropimage({required File imagefile}) async {
  //   CroppedFile? croppedimage =
  //       await ImageCropper().cropImage(sourcePath: imagefile.path);
  //   if (croppedimage == null) return null;
  //   return File(croppedimage.path);
  // }
  //
  // saveToGallery(BuildContext context) {
  //   if (texts.isNotEmpty) {
  //     screenshotController.capture().then((Uint8List? image) {
  //       saveImage(image!);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Image saved to gallery.'),
  //         ),
  //       );
  //     }).catchError((err) => print(err));
  //   }
  // }
  //
  // saveImage(Uint8List bytes) async {
  //   final time = DateTime.now()
  //       .toIso8601String()
  //       .replaceAll('.', '-')
  //       .replaceAll(':', '-');
  //   final name = "screenshot_$time";
  //   await requestPermission(Permission.storage);
  //   await ImageGallerySaver.saveImage(bytes, name: name);
  // }
  //
  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //
  //     if (image == null) return;
  //
  //     File? imageTemp = File(image.path);
  //     // imageTemp = await cropimage(imagefile: imageTemp);
  //
  //     setState(() => this.image = imageTemp);
  //
  //     // Navigator.pop(context);
  //   } on PlatformException {
  //     // ignore: avoid_print
  //     // print('Failed to pick image: $e');
  //   }
  // }
  //
  // Future pickImage2() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //
  //     if (image == null) return;
  //
  //     File? imageTemp = File(image.path);
  //     // imageTemp = await cropimage(imagefile: imageTemp);
  //
  //     setState(() => this.image = imageTemp);
  //
  //     Navigator.pop(context);
  //   } on PlatformException {
  //     // ignore: avoid_print
  //     // print('Failed to pick image: $e');
  //   }
  // }
  //
  // Future pickImageC() async {
  //   try {
  //     final XFile? image =
  //         await ImagePicker().pickImage(source: ImageSource.camera);
  //
  //     if (image == null) return;
  //
  //     final imageTemp = File(image.path);
  //
  //     setState(() => this.image = imageTemp);
  //     // ignore: empty_catches
  //   } on PlatformException {}
  // }
  //
  // Future pickImageC2() async {
  //   try {
  //     final XFile? image =
  //         await ImagePicker().pickImage(source: ImageSource.camera);
  //
  //     if (image == null) return;
  //
  //     final imageTemp = File(image.path);
  //
  //     setState(() => this.image = imageTemp);
  //     Navigator.pop(context);
  //     // ignore: empty_catches
  //   } on PlatformException {}
  // }
  //
  // editText2(BuildContext context, int index) {
  //   setState(() {
  //     texts.removeAt(index);
  //     texts.add(
  //       TextInfo(
  //         text: textEditingController.text,
  //         left: 150,
  //         top: 330,
  //         color: Colors.black,
  //         fontWeight: FontWeight.normal,
  //         fontStyle: FontStyle.normal,
  //         fontSize: 40,
  //         textAlign: TextAlign.center,
  //       ),
  //     );
  //     Navigator.of(context)
  //       // ..pop()
  //       ..pop();
  //   });
  // }
  //
  // addNewText2(BuildContext context) {
  //   setState(() {
  //     texts.add(
  //       TextInfo(
  //         text: textEditingController.text,
  //         left: 150,
  //         top: 330,
  //         color: Colors.black,
  //         fontWeight: FontWeight.normal,
  //         fontStyle: FontStyle.normal,
  //         fontSize: 40,
  //         textAlign: TextAlign.center,
  //       ),
  //     );
  //     Navigator.of(context)
  //       // ..pop()
  //       ..pop();
  //   });
  // }
  //
  // addNewDialog2(context, {edit = false, int? index}) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const Text(
  //         'Add New Text',
  //       ),
  //       content: TextField(
  //         controller: textEditingController,
  //         maxLines: 5,
  //         decoration: const InputDecoration(
  //           suffixIcon: Icon(
  //             Icons.edit,
  //           ),
  //           filled: true,
  //           hintText: 'Your Text Here..',
  //         ),
  //       ),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           style: ButtonStyle(
  //             backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
  //             textStyle: MaterialStateProperty.all<TextStyle>(
  //               const TextStyle(
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //           onPressed: () => Navigator.of(context)
  //             // ..pop()
  //             ..pop(),
  //           child: const Text('Back'),
  //         ),
  //         ElevatedButton(
  //           style: ButtonStyle(
  //             backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
  //             textStyle: MaterialStateProperty.all<TextStyle>(
  //               const TextStyle(
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //           onPressed: () =>
  //               (edit) ? editText2(context, index!) : addNewText2(context),
  //           child: const Text('Add Text'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // removeText(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const Text(
  //         'Are you sure you want to delete?',
  //       ),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           style: ButtonStyle(
  //             backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
  //             textStyle: MaterialStateProperty.all<TextStyle>(
  //               const TextStyle(
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //           onPressed: () => Navigator.of(context)
  //             // ..pop()
  //             ..pop(),
  //           child: const Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           style: ButtonStyle(
  //             backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
  //             textStyle: MaterialStateProperty.all<TextStyle>(
  //               const TextStyle(
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               texts.removeAt(currentIndex);
  //             });
  //             Navigator.of(context).pop();
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text(
  //                   'Text Deleted',
  //                   style: TextStyle(
  //                     fontSize: 16.0,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //           child: const Text('Delete'),
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   // );
  // }
  //
  // setCurrentIndex(BuildContext context, index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text(
  //         'Selected For Styling',
  //         style: TextStyle(
  //           fontSize: 16.0,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // increaseFontSize() {
  //   setState(() {
  //     texts[currentIndex].fontSize += 2;
  //   });
  // }
  //
  // decreaseFontSize() {
  //   setState(() {
  //     texts[currentIndex].fontSize -= 2;
  //   });
  // }
  //
  // changeTextColor(Color color) {
  //   setState(() {
  //     texts[currentIndex].color = color;
  //     Navigator.of(context)
  //       ..pop()
  //       ..pop();
  //   });
  // }
  //
  // Future<File?> _cropImage111({required File imagefile}) async {
  //   if (imagefile != null) {
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: imagefile.path,
  //       compressFormat: ImageCompressFormat.jpg,
  //       compressQuality: 100,
  //       uiSettings: [
  //         AndroidUiSettings(
  //             toolbarTitle: 'Cropper',
  //             toolbarColor: Colors.deepOrange,
  //             toolbarWidgetColor: Colors.white,
  //             initAspectRatio: CropAspectRatioPreset.original,
  //             lockAspectRatio: false),
  //         IOSUiSettings(
  //           title: 'Cropper',
  //         ),
  //         WebUiSettings(
  //           context: context,
  //           presentStyle: CropperPresentStyle.dialog,
  //           boundary: const CroppieBoundary(
  //             width: 520,
  //             height: 520,
  //           ),
  //           viewPort:
  //               const CroppieViewPort(width: 480, height: 480, type: 'circle'),
  //           enableExif: true,
  //           enableZoom: true,
  //           showZoomer: true,
  //         ),
  //       ],
  //     );
  //     if (croppedFile == null) return null;
  //     return File(croppedFile.path);
  //     // if (croppedFile != null) {
  //     //   setState(() {
  //     //     _croppedFile = croppedFile;
  //     //   });
  //     // }
  //   }
  //   return null;
  // }

  // convert(String cfData, String name) async {
  //   // Name is File Name that you want to give the file
  //   var targetPath = await _localPath;
  //   var targetFileName = name;
  //
  //   var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
  //       cfData, targetPath!, targetFileName);
  //   print('generatedPdfFile:$generatedPdfFile');
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(generatedPdfFile.toString()),
  //   ));
  // }

  Future<String?> get _localPath async {
    Directory? directory;
    String? downloadsPath;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationSupportDirectory();
        downloadsPath = await directory.path;
      } else {
        print('niti directory found');

        // if platform is android
        // directory = Directory('/storage/emulated/0/Download');
        // directory = await getDownloadsDirectory();
        downloadsPath = await AndroidPathProvider.downloadsPath;
        // directory = (await getExternalStorageDirectories(type: StorageDirectory.downloads))!.first;
        // directory = Directory('/Phone storage/Download');
        // print('directory:${directory!.path}');
        print('downloadsPath:$downloadsPath');
        if (!await directory!.exists()) {
          print('niti directory not found');
          directory = await getExternalStorageDirectory();
          downloadsPath = await directory!.path;
        }
      }
    } catch (err, stack) {
      print("Can-not get download folder path");
    }
    return downloadsPath;
  }

  @override
  void initState(){
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    // FlutterDownloader.initialize(
    //     debug: true // optional: set false to disable printing logs to console
    // );
    // _downloadListener();
  }

  Future<void> downloadFile(String url, [String? filename]) async {
    var hasStoragePermission = await Permission.storage.isGranted;
    final dir =
    await getApplicationDocumentsDirectory();
    print('dir:$dir');
//From path_provider package
    var _localPath = dir.path + filename!;
    final savedDir = Directory(_localPath);
    print('savedDir:$_localPath');
    if (!hasStoragePermission) {
      final status = await Permission.storage.request();
      hasStoragePermission = status.isGranted;
    }
    if (hasStoragePermission) {
      print('hasStoragePermission');
        await savedDir.create(recursive: true).then((value) async {
          print('download start');
          final taskId = await FlutterDownloader.enqueue(
              url: url,
              // headers: {},
              // optional: header send with url (auth token etc)
              savedDir: _localPath,
              showNotification: true,
              timeout: 300000,
              // saveInPublicStorage: true,
              fileName: filename);
          print('_taskid:$taskId');
        });

    }
  }

  // _downloadListener() {
  //   print('_downloadListener');
  //   IsolateNameServer.registerPortWithName(
  //       _port.sendPort, 'downloader_send_port');
  //   _port.listen((dynamic data) {
  //     String id = data[0];
  //     DownloadTaskStatus status = data[1];
  //     if (status.toString() == "DownloadTaskStatus(3)") {
  //       FlutterDownloader.open(taskId: id);
  //     }
  //   });
  //   FlutterDownloader.registerCallback(DownloadClass.callback);
  // }

   Future<void> _createPDF() async{
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawImage(PdfBitmap(await _readImageData('gmail.png')), Rect.zero);

    List<int> bytes = document.saveSync();
    document.dispose();

    // saveAndLaunchFile(bytes);
    saveAndlaunchPdf(bytes);
  }

  Future<void> saveAndlaunchPdf(List<int> bytes) async{
    final directory = await _localPath;

    // Create a new file in the directory with a unique name
    final file = File('${directory}/${DateTime.now().millisecondsSinceEpoch}.pdf');

    // Write the bytes to the file
    await file.writeAsBytes(bytes,flush: true);

    setState(() {
      _imageFile = file;
    });
    await _showProgressNotification();

    print('Image downloaded: ${_imageFile.path}');
    var snackBar = SnackBar(
      content: Text('File Downloaded: ${file.path}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // OpenFile
  }

  // Future<void> saveAndLaunchFile(
  //     List<int> bytes) async {
  //   print('saveAndLaunchFile');
  //   final directory = await _localPath;
  //
  //   // html.HtmlElement()
  //   // ..getNamespacedAttributes('data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
  //   // ..onClick;
  //   final code = html.AnchorElement(
  //       href:
  //       '${base64.encode(bytes)}')
  //     ..setAttribute('download', '${directory}/${DateTime.now().millisecondsSinceEpoch}.pdf')
  //     ..click();
  //   print('code: $code');
  //   print('saveAndLaunchFile: ${directory}/${DateTime.now().millisecondsSinceEpoch}.pdf');
  //   // return code;
  //
  // }


  // createPdf(String url) async {
  //   var base64 = url;
  //   var bytes = Base64Decoder().convert(url);
  //   // var bytes = base64Decode(base64);
  //   print('bytes: $bytes');
  //   print('bytes.buffer.asUint8List(): ${bytes.buffer.asUint8List()}');
  //   final output = await _localPath;
  //
  //   final netImage = await NetworkImage('https://www.nfet.net/nfet.jpg');
  //
  //   pdf.addPage(pw.Page(build: (pw.Context context) {
  //     return pw.Center(
  //       child: pw.Image(netImage as pw.ImageProvider),
  //     ); // Center
  //   })); // Page
  //   final file = File("${output}/example.pdf");
  //   // await file.writeAsBytes(bytes);
  //   await file.writeAsBytes(await pdf.save());
  //   print("niti path: ${output}/example.pdf");
  //   await OpenFilex.open(file.path);
  //   return file;
  // }

  Future<void> downloadImageFile(String url) async {
    List<int> imageBytes = base64Decode(url);

    // Get the document directory using path_provider package
    final directory = await _localPath;

    // Create a new file in the directory with a unique name
    final file = File('${directory}/${DateTime.now().millisecondsSinceEpoch}.png');

    // Write the bytes to the file
    await file.writeAsBytes(imageBytes);

    setState(() {
      _imageFile = file;
    });
    await _showProgressNotification();

    print('Image downloaded: ${_imageFile.path}');
    var snackBar = SnackBar(
      content: Text('File Downloaded: ${file.path}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Future<void> _convertImageToPDF() async {
  //   print('_convertImageToPDF');
  //    //Create the PDF document
  //   PdfDocument document = PdfDocument();
  //    //Add the page
  //   PdfPage page = document.pages.add();
  //    //Load the image
  //   final PdfImage image =
  //   PdfBitmap(await _readImageData('gmail.png'));
  //   //draw image to the first page
  //   page.graphics.drawImage(
  //   image, Rect.fromLTWH(0, 0, page.size.width, page.size.height));
  //   //Save the document
  //   List<int> bytes = await document.save();
  //   // Dispose the document
  //   // document.dispose();
  //   //Save the file and launch/download
  //   SaveFile.saveAndLaunchFile(bytes, 'output.pdf');
  //    }

  Future<Uint8List> _readImageData(String name) async {
    print('_readImageData');
    final ByteData data = await rootBundle.load('assets/images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

//   @override
//   Widget build(BuildContext context) {
//     print('image:$image');
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     backgroundColor: Colors.blue,
//     //     actions: <Widget>[
//     //       Padding(
//     //           padding: const EdgeInsets.only(right: 20.0),
//     //           child: GestureDetector(
//     //             onTap: () async {
//     //               print('crop');
//     //               // _cropImage111();
//     //               File? imageTemp = File(image!.path);
//     //               imageTemp = await _cropImage111(imagefile: imageTemp);
//     //
//     //               setState(() => image = imageTemp);
//     //             },
//     //             child: const Icon(
//     //               Icons.crop,
//     //               size: 26.0,
//     //             ),
//     //           )),
//     //       Padding(
//     //           padding: const EdgeInsets.only(right: 20.0),
//     //           child: GestureDetector(
//     //             onTap: () {
//     //               saveToGallery(context);
//     //             },
//     //             child: const Icon(
//     //               Icons.save,
//     //               size: 26.0,
//     //             ),
//     //           )),
//     //       Padding(
//     //           padding: const EdgeInsets.only(right: 10.0),
//     //           child: GestureDetector(
//     //             onTap: () {
//     //               showAlignedDialog(
//     //                   context: context,
//     //                   builder: _localDialogBuilder,
//     //                   followerAnchor: Alignment.topLeft,
//     //                   targetAnchor: Alignment.topRight,
//     //                   barrierColor: Colors.transparent,
//     //                   avoidOverflow: true);
//     //             },
//     //             child: const Icon(Icons.edit),
//     //           )),
//     //       Padding(
//     //           padding: const EdgeInsets.only(right: 15.0),
//     //           child: GestureDetector(
//     //             onTap: () {
//     //               showAlignedDialog(
//     //                   context: context,
//     //                   builder: _localDialogBuilder2,
//     //                   followerAnchor: Alignment.topLeft,
//     //                   targetAnchor: Alignment.topRight,
//     //                   barrierColor: Colors.transparent,
//     //                   avoidOverflow: true);
//     //             },
//     //             child: const Icon(Icons.more_vert),
//     //           )),
//     //     ],
//     //   ),
//     //   body: Screenshot(
//     //     controller: screenshotController,
//     //     child: SafeArea(
//     //       child: Container(
//     //         margin: const EdgeInsets.only(
//     //           top: 0.0,
//     //         ),
//     //         // width: MediaQuery.of(context).size.width,
//     //         // height: MediaQuery.of(context).size.height,
//     //         child: Stack(
//     //           children: [
//     //             Center(
//     //               child: image != null
//     //                   ? Image.file(
//     //                 image!,
//     //                 fit: BoxFit.fill,
//     //                 width: MediaQuery.of(context).size.width,
//     //                 height: MediaQuery.of(context).size.height,
//     //               )
//     //                   : Image.network(
//     //                 'https://static.wikia.nocookie.net/just-because/images/0/0c/NoImage_Available.png/revision/latest?cb=20170601005615',
//     //                 fit: BoxFit.fill,
//     //                 width: MediaQuery.of(context).size.width,
//     //                 height: MediaQuery.of(context).size.height,
//     //               ),
//     //             ),
//     //             for (int i = 0; i < texts.length; i++)
//     //               Positioned(
//     //                 left: texts[i].left,
//     //                 top: texts[i].top,
//     //                 child: GestureDetector(
//     //                   onLongPress: () {
//     //                     setState(() {
//     //                       currentIndex = i;
//     //                       removeText(context);
//     //                     });
//     //                   },
//     //                   onTap: () => setCurrentIndex(context, i),
//     //                   child: Draggable(
//     //                     feedback: Material(color:Colors.transparent,
//     //                         child: ImageText(textInfo: texts[i])),
//     //                     childWhenDragging: Container(),
//     //                     onDragEnd: (drag) {
//     //                       final renderBox =
//     //                       context.findRenderObject() as RenderBox;
//     //                       Offset off = renderBox.globalToLocal(drag.offset);
//     //                       setState(() {
//     //                         texts[i].top = off.dy - 96;
//     //                         texts[i].left = off.dx;
//     //                       });
//     //                     },
//     //                     child: ImageText(textInfo: texts[i]),
//     //                   ),
//     //                 ),
//     //               ),
//     //             creatorText.text.isNotEmpty
//     //                 ? Positioned(
//     //               left: 0,
//     //               bottom: 0,
//     //               child: Text(
//     //                 creatorText.text,
//     //                 style: TextStyle(
//     //                     fontSize: 0,
//     //                     fontWeight: FontWeight.bold,
//     //                     color: Colors.black.withOpacity(
//     //                       0.3,
//     //                     )),
//     //               ),
//     //             )
//     //                 : const SizedBox.shrink(),
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//     return WillPopScope(
//         onWillPop: () async {
//           print('back button11111 : ${await _controller.canGoBack()}');
//           if (await _controller.canGoBack()) {
//             print('niti');
//             _controller.goBack();
//             return true;
//           } else {
//             print('niti else');
//             return false;
//           }
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             title: const Text('title'),
//             leading: IconButton(
//                 onPressed: () async {
//                   print('back button : ${await _controller.canGoBack()}');
//                   if (1 == 1) {
//                     print('niti');
//                     // _controller.goBack();
//                     Navigator.pop(context);
//                     // return false;
//                   }
//                   // _controller.goBack();
//                 },
//                 icon: Icon(Icons.arrow_back)),
//             actions: [
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               //   child: GestureDetector(
//               //     onTap: () async {
//               //       print('dialog');
//               //       print('Download');
//               //       print(
//               //           'url:${await _controller.evaluateJavascript(source: "window.document.URL;")}');
//               //       print(
//               //           'niti hello${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}');
//               //       String html =
//               //       await _controller.evaluateJavascript(
//               //           source: "window.document.body.innerHTML;");
//               //       print(html);
//               //       convert(html,
//               //           "File Name${DateTime.now().toString().split(' ').first}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}");
//               //       var targetPath2 = await _localPath;
//               //       File pdfFile() {
//               //         if (Platform.isIOS) {
//               //           return File(targetPath2.toString() +
//               //               "/" +
//               //               "File Name333" +
//               //               '.pdf'); // for ios
//               //         } else {
//               //           print("aaaaa $targetPath2");
//               //           // File('storage/emulated/0/Download/' + cfData + '.pdf')
//               //           return File(targetPath2.toString() +
//               //               "/" +
//               //               "File Name" +
//               //               '.pdf'); // for android
//               //         }
//               //       }
//               //
//               //       SfPdfViewer.file(pdfFile());
//               //       // generateExampleDocument();
//               //       print('download_successfull..//:');
//               //       // downloadDialog();
//               //       // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AppsStorePage()));
//               //     },
//               //     child: const Icon(Icons.download),
//               //   ),
//               // )
//             ],
//           ),
//           body: InAppWebView(
//             initialUrlRequest: URLRequest(url: Uri.parse(
//                 // 'https://pixlr.com/x/')),
//                 // 'https://practice.geeksforgeeks.org/courses/complete-interview-preparation?source=google&medium=cpc&device=c&keyword=gfg&matchtype=b&campaignid=18447701680&adgroup=147691667674&gclid=Cj0KCQjwk7ugBhDIARIsAGuvgPZnBxRx5yX-Tu6g8tL2hfZCRp7rM3S49HN3TXNZzTOOaMi_d_8wReQaAnAvEALw_wcB')),
//                 'https://visitmysite.in/pixie/index.html')),
//     // 'https://proof.ovh.net/files/10Mb.dat')),
//             // 'https://visitmysite.in/visitingcard/public/visiting_card_html/${widget.categoryName}/${widget.image}.html')),
//             // initialHeaders: {},
//             initialOptions: InAppWebViewGroupOptions(
//               crossPlatform: InAppWebViewOptions(
//                   // debuggingEnabled: true,
//                   //   javaScriptEnabled: true,
//                   //   clearCache: false,
//                   useOnDownloadStart: true,
//                   useShouldOverrideUrlLoading: true,
//                   // useOnLoadResource: true,
//                   allowFileAccessFromFileURLs: true,
//                   allowUniversalAccessFromFileURLs: true),
//               android: AndroidInAppWebViewOptions(
//                 useHybridComposition: true,
//               ),
//             ),
//             // gestureNavigationEnabled: true,
//             gestureRecognizers: Set()
//               ..add(Factory<VerticalDragGestureRecognizer>(
//                   () => VerticalDragGestureRecognizer()
//                     ..onUpdate = (DragUpdateDetails dragDownDetails) {
//                       _controller.getScrollY().then((value) {
//                         print('reload option');
//                         if (value == 0 &&
//                             dragDownDetails.globalPosition.direction < 1) {
//                           print('reloading');
//                           _controller.reload();
//                         }
//                       });
//                     }))
//               ..add(Factory<LongPressGestureRecognizer>(
//                   () => LongPressGestureRecognizer())),
//             onWebViewCreated: (InAppWebViewController webViewController) async {
//               _controller = webViewController;
//               // try {
//               //   // get the access token
//               //   final token = await getToken();
//               //
//               //   // get the CookieManager instance
//               //   CookieManager cookieManager = CookieManager.instance();
//               //
//               //   // set the access token
//               //   await cookieManager.setCookie(
//               //       url: 'https://visitmysite.in/pixie/index.html',
//               //       name: "accessToken",
//               //       value: token,
//               //       isSecure: true,
//               //       isHttpOnly: false,
//               //       sameSite: HTTPCookieSameSitePolicy.NONE
//               //   );
//               //
//               //   // then load your initial URL here
//               //   // await _webViewController.loadUrl(url: widget.url);
//               // } catch (e) {
//               //   print(e.toString());
//               // }
//               // _controller.clearCache();
//               // await _controller.evaluateJavascript(source: "window.document.URL;");
//               // print('web page: ${_controller.evaluateJavascript(source: "window.document.URL;")}');
//             },
//             onLoadStop: (InAppWebViewController controller, Uri? url) async {
//               // setState(() {
//               //   this.url = url.toString();
//               // });
//               await controller.evaluateJavascript(
//                   source:
//                       "window.localStorage.setItem('Item 1', 'localStorage value! hiii')");
//               // await controller.evaluateJavascript(source: "alert(window.localStorage.getItem('Item 1'))");
//               await controller.evaluateJavascript(
//                   source:
//                       "window.sessionStorage.setItem('Item 2', 'sessionStorage value! hiii')");
//             },
//             shouldOverrideUrlLoading: (controller, navigationAction) async {
//               if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
//                 // final shouldPerformDownload =
//                 //     navigationAction.shouldPerformDownload ?? false;
//                 final url = navigationAction.request.url;
//                 if ( url != null) {
//                   await downloadFile(url.toString());
//                   return NavigationActionPolicy.ALLOW;
//                 }
//               }
//               return NavigationActionPolicy.ALLOW;
//             },
//             onDownloadStart: (controller, url) async {
//               print("onDownloadStart $url");
//               final taskId = await FlutterDownloader.enqueue(
//                 url: url.path,
//                 savedDir: (await getExternalStorageDirectory())!.path,
//                 showNotification: true, // show download progress in status bar (for Android)
//                 openFileFromNotification: true, // click on notification to open downloaded file (for Android)
//               );
//             },
//             // onDownloadStart: (controller, downloadStartRequest) async {
//             //   await downloadFile(downloadStartRequest.path,
//             //       'niti_demo_name');
//             //   // try {
//             //   //   print("onDownloadStart ${url}");
//             //   //   // print('path : ${(await getExternalStorageDirectory())!.path}');
//             //   //   var hasStoragePermission = await Permission.storage.isGranted;
//             //   //   if (!hasStoragePermission) {
//             //   //     final status = await Permission.storage.request();
//             //   //     hasStoragePermission = status.isGranted;
//             //   //   }
//             //   //   if (hasStoragePermission) {
//             //   //     print('try iff');
//             //   //     final directory = await getExternalStorageDirectory();
//             //   //     final downloadDirectory = Directory('${directory}/Download');
//             //   //     print('downloadDirectory:${downloadDirectory.path}');
//             //   //
//             //   //     if (!await downloadDirectory.exists()) {
//             //   //       await downloadDirectory.create(recursive: true);
//             //   //     }
//             //   //
//             //   //     // void _launchURL_files() async =>
//             //   //     //     await canLaunch(url.path) ? await launch(url.path) : throw 'Could not launch ${url.path}';
//             //   //     // _launchURL_files();
//             //   //      await FlutterDownloader.enqueue(
//             //   //         url: url.path,
//             //   //         // headers: {},
//             //   //         // optional: header send with url (auth token etc)
//             //   //         showNotification: true,
//             //   //         openFileFromNotification: true,
//             //   //         // savedDir: (await getExternalStorageDirectory())!.path,
//             //   //         savedDir: downloadDirectory.path,
//             //   //         // savedDir: await _localPath.toString(),
//             //   //         saveInPublicStorage: true,
//             //   //         fileName:
//             //   //             'VisitingCard${DateTime.now().toString().split(' ').first}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}');
//             //   //   }
//             //   // } catch (e) {
//             //   //   print("error in download au news:: $e");
//             //   // }
//             // },
//             // onDownloadStartRequest: (controller, url) async {
//             //   print("onDownloadStart $url");
//             //   final taskId = await FlutterDownloader.enqueue(
//             //     url: url.toString(),
//             //     savedDir: (await getExternalStorageDirectory())!.path,
//             //     showNotification: true, // show download progress in status bar (for Android)
//             //     openFileFromNotification: true, // click on notification to open downloaded file (for Android)
//             //   );
//             // },
// //                       onLoadStop: (controller, url) async {
// //                         if(await _controller.evaluateJavascript(source: "window.document.URL;") != "https://qswappweb.com/resumebuilder/public/featured"){
// //                               // var result = await controller.evaluateJavascript(
// //                               //     source: "1 + 1");
// //                               // print(result.runtimeType); // int
// //                               // print(result); //2
// //                           var result = _controller.evaluateJavascript(source: '''
// //   var fileInput = document.createElement('input');
// //   fileInput.type = 'file';
// //   fileInput.accept = 'image/*';
// //   fileInput.onchange = () => {
// //     var file = fileInput.files[0];
// //     var reader = new FileReader();
// //     reader.readAsDataURL(file);
// //     reader.onload = () => {
// //       window.flutter_injector.get('ImagePicker').invokeMethod('pickImage', reader.result);
// //     };
// //   };
// //   fileInput.click();
// // ''');
// //                           print(result.toString());
// //                           print(result);
// //                         }
// //                       },
//             // onWebViewCreated: (InAppWebViewController controller) {
//             //   webView = controller;
//             // },
//             // onLoadStart: (InAppWebViewController controller, String url) {
//             //
//             // },
//             // onLoadStop: (InAppWebViewController controller, String url) {
//             //
//             // },
//             // onLoadStop: (controller, url) async {
//             //   var html = await controller.evaluateJavascript(
//             //       source: "window.document.getElementsByTagName('head')[0].outerHTML;");
//             //   //   source: "window.document.body.innerText;");
//             //   print("==========start================");
//             //   // catchtext = html;
//             //   print(':$html}');
//             //
//             // },
//
//             // onPageCommitVisible: (con,uri){
//             //   print("url ${uri.toString()}");
//             //   con.goBack();
//             // },
//             // onDownloadStartRequest: (controller, url) async {
//             //   print('Permission.storage.status:${await Permission.storage.status}');
//             //   // await checkPermission();
//             //   // print(await checkPermission());
//             //   print("onDownloadStart $url");
//             //   if(await Permission.storage.request().isGranted){
//             //     print('if true');
//             //         final taskId = await FlutterDownloader.enqueue(
//             //           url: 'https:\/\/qswappweb.com\/resumebuilder\/public\/uploads\/user_guide_image\/63b3eed2d1cef.png',
//             //               // 'https://qswappweb.com/resumebuilder/public/featured',
//             //           saveInPublicStorage: true,
//             //           savedDir:
//             //               (await getExternalStorageDirectory())!.path,
//             //           showNotification: true,
//             //           fileName: "Flamingo Order Details",
//             //           // show download progress in status bar (for Android)
//             //           openFileFromNotification:
//             //               true, // click on notification to open downloaded file (for Android)
//             //         );
//             //         print('taskId:$taskId');
//             //       }
//             //   else{
//             //     print('else false');
//             //     checkPermission();
//             //   }
//             //     },
//           ),
//           //     body: WebViewPlus(
//           //       initialUrl: 'https://visitmysite.in/pixie/index.html',
//           //       javascriptMode: JavascriptMode.unrestricted,
//           //       // javascriptChannels: null,
//           // onPageFinished: (String url) {
//           //     print('Page finished loading: $url');
//           //     // setState(() {
//           //     //   isLoading = false;
//           //     // });
//           //   },
//           //       onWebViewCreated: (InAppWebViewController webViewController) async{
//           //         _controller = webViewController;
//           //         // _controller!.loadUrl('https://visitmysite.in/pixie/index.html');
//           //         // var localStorageValue = await _controller!.webViewController.loadFile('Phone/Download/IMG_2305.jpg');
//           //         // var localStorageValue = await _controller.runJavascriptReturningResult('window.localStorage.getItem("image")');
//           //         print('localStorageValue:');
//           //         // _controller.settings()
//           //         //     .setDomStorageEnabled(true);
//           //         // WebView webView = (WebView) findViewById(R.id.webView);
//           //         // WebSettings webSettings = webView.getSettings();
//           //         // webSettings.setJavaScriptEnabled(true);
//           //         // webSettings.setDomStorageEnabled(true);
//           //         // webview.getsettings().setdomstorageenabled(true)
//           //         // await _controller.runJavascriptReturningResult( "window.localStorage.setItem('key', 'localStorage value!')");
//           //         // await _controller.runJavascriptReturningResult( "alert(window.localStorage.getItem('key'))");
//           //         // await _controller.runJavascript(
//           //         //     'sessionStorage.setItem("userCode", "000"); sessionStorage.setItem("role", "40");');
//           //       },
//           //     )
//         ));
//     // body: WebView(
//     //   key: UniqueKey(),
//     //   // initialUrl:'https://freshly.luckistore.in/api/privacy_policy',
//     //   initialUrl: 'https://visitmysite.in/pixie/index.html',
//     //   // initialUrl: 'https://visitmysite.in/visitingcard/public/featured',
//     //   javascriptMode: JavascriptMode.unrestricted,
//     //   onPageFinished: (String url) {
//     //     print('Page finished loading: $url');
//     //     // setState(() {
//     //     //   isLoading = false;
//     //     // });
//     //   },
//     //   onWebViewCreated: (WebViewController webViewController) async{
//     //     _controller = webViewController;
//     //     var localStorageValue = await _controller.runJavascriptReturningResult('window.localStorage.getItem("image")');
//     //     print('localStorageValue:$localStorageValue');
//     //     // _controller.settings()
//     //     //     .setDomStorageEnabled(true);
//     //     // WebView webView = (WebView) findViewById(R.id.webView);
//     //     // WebSettings webSettings = webView.getSettings();
//     //     // webSettings.setJavaScriptEnabled(true);
//     //     // webSettings.setDomStorageEnabled(true);
//     //     // webview.getsettings().setdomstorageenabled(true)
//     //     // await _controller.runJavascriptReturningResult( "window.localStorage.setItem('key', 'localStorage value!')");
//     //     // await _controller.runJavascriptReturningResult( "alert(window.localStorage.getItem('key'))");
//     //     // await _controller.runJavascript(
//     //     //     'sessionStorage.setItem("userCode", "000"); sessionStorage.setItem("role", "40");');
//     //   },
//     //   // gestureNavigationEnabled: true,
//     //   // gestureRecognizers: Set()
//     //   //   ..add(Factory<VerticalDragGestureRecognizer>(() =>
//     //   //   VerticalDragGestureRecognizer()
//     //   //     ..onDown =
//     //   //         (DragDownDetails dragDownDetails) {
//     //   //       _controller.getScrollY().then((value) {
//     //   //         if (value == 0 &&
//     //   //             dragDownDetails
//     //   //                 .globalPosition.direction <
//     //   //                 1) {
//     //   //           _controller.reload();
//     //   //         }
//     //   //       });
//     //   //     }))
//     //   //   ..add(Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer())),
//     //   onWebResourceError: (WebResourceError error) {
//     //     print("WebresourceError occured!");
//     //     // setState(() {
//     //     //   appBarColor = Colors.red;
//     //     //
//     //     // });
//     //   },
//     //   // gestureNavigationEnabled: true,
//     //   // gestureRecognizers: Set()
//     //   //   ..add(Factory<VerticalDragGestureRecognizer>(
//     //   //       () => VerticalDragGestureRecognizer()
//     //   //         ..onDown = (DragDownDetails dragDownDetails) {
//     //   //           _controller.getScrollY().then((value) {
//     //   //             if (value == 0 &&
//     //   //                 dragDownDetails.globalPosition.direction < 1) {
//     //   //               _controller.reload();
//     //   //             }
//     //   //           });
//     //   //         }))
//     //   //   ..add(Factory<LongPressGestureRecognizer>(
//     //   //       () => LongPressGestureRecognizer())),
//     // ));
//     // );
//     // ignore: unnecessary_cast
//   }

  Future<void> _showProgressNotification() async {
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('progress channel', 'progress channel',
            channelDescription: 'progress channel description',
            channelShowBadge: false,
            importance: Importance.high,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'Resume Builder',
            'File Download',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  checkPermision() async{
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      // Here just ask for the permission for the first time
      await Permission.storage.request();

      // I noticed that sometimes popup won't show after user press deny
      // so I do the check once again but now go straight to appSettings
      if (permissionStatus.isDenied) {
        await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      // Here open app settings for user to manually enable permission in case
      // where permission was permanently denied
      await openAppSettings();
    } else {
      print('checkPermision else');
      // Do stuff that require permission here
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print('back button11111 : ${await _controller.canGoBack()}');
          if (await _controller.canGoBack()) {
            print('niti');
            _controller.goBack();
            return true;
          } else {
            print('niti else');
            return false;
          }
        },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Editor'),
            leading: IconButton(
                onPressed: () async {
                  print('back button : ${await _controller.canGoBack()}');
                  if (1 == 1) {
                    print('niti');
                    // _controller.goBack();
                    Navigator.pop(context);
                    // return false;
                  }
                  // _controller.goBack();
                },
                icon: Icon(Icons.arrow_back)),
            actions: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: GestureDetector(
              //     onTap: () async {
              //       print('dialog');
              //       print('Download');
              //       print(
              //           'url:${await _controller.evaluateJavascript(source: "window.document.URL;")}');
              //       print(
              //           'niti hello${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}');
              //       String html =
              //       await _controller.evaluateJavascript(
              //           source: "window.document.body.innerHTML;");
              //       print(html);
              //       convert(html,
              //           "File Name${DateTime.now().toString().split(' ').first}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}");
              //       var targetPath2 = await _localPath;
              //       File pdfFile() {
              //         if (Platform.isIOS) {
              //           return File(targetPath2.toString() +
              //               "/" +
              //               "File Name333" +
              //               '.pdf'); // for ios
              //         } else {
              //           print("aaaaa $targetPath2");
              //           // File('storage/emulated/0/Download/' + cfData + '.pdf')
              //           return File(targetPath2.toString() +
              //               "/" +
              //               "File Name" +
              //               '.pdf'); // for android
              //         }
              //       }
              //
              //       SfPdfViewer.file(pdfFile());
              //       // generateExampleDocument();
              //       print('download_successfull..//:');
              //       // downloadDialog();
              //       // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AppsStorePage()));
              //     },
              //     child: const Icon(Icons.download),
              //   ),
              // )
            ],
          ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text("CURRENT URL\n${ (url.length > 50) ? url.substring(0, 50) + "..." : url }"),
              ),
              (progress != 1.0) ? LinearProgressIndicator(value: progress) : Container(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)
                  ),
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        // url: Uri.parse('https://visitmysite.in/pixie/index.html')
                        url: Uri.parse('https://visitmysite.in/editor/index.html')
                        // url: Uri.parse("https://codepen.io/AaradhyaThakkar/pen/eYLXOMo?editors=0010")
                    ),
                    // initialHeaders: {
                    //
                    // },
                    //   initialOptions: ChromeSafariBrowserClassOptions(
                    //       android: AndroidChromeCustomTabsOptions(
                    //           shareState: CustomTabsShareState.SHARE_STATE_OFF),
                    //       ios: IOSSafariOptions(barCollapsingEnabled: true))
    initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  // debuggingEnabled: true,
                  //   javaScriptEnabled: true,
                  //   clearCache: false,
                  useOnDownloadStart: true,
                  useShouldOverrideUrlLoading: true,
                  // useOnLoadResource: true,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
            ),
                    onWebViewCreated: (InAppWebViewController controller) async{
                      _controller = controller;
                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                      print('androidInfo.version.sdkInt: ${androidInfo.version.sdkInt}');
                      print('isVideosPermission: $isVideosPermission');
                      print('isPhotosPermission: $isPhotosPermission');
                      print('isStoragePermission: $isStoragePermission');
                    },
                    onLoadResource: (controller, load){
                      controller.getUrl();
                      print('url get; ${controller.getUrl()}');
                      // LoadedResource(url: controller.getUrl())
                    },
    onDownloadStartRequest: (controller, url) async {
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // if (androidInfo.version.sdkInt >= 33) {
      //   isVideosPermission = await Permission.videos.status.isGranted;
      //   isPhotosPermission = await Permission.photos.status.isGranted;
      // } else {
      //   isStoragePermission = await Permission.storage.status.isGranted;
      // }
      // var imageBytes = File(await).readAsBytesSync();
                      // await _controller.goForward();
      // print('Permission.storage.status:${await Permission.storage.status}');
              print('Permission.storage.status:${await isStoragePermission}');
              // await checkPermission();
              // print(await checkPermission());
              print("onDownloadStart ${url.url}");
              print('url:${url.url.path}');
              // await WebImageDownloader.downloadImageFromWeb('https://picsum.photos/200');
    // if(await Permission.storage.request().isGranted){
              if(isStoragePermission && isVideosPermission && isPhotosPermission){
                print('if true');
                String base64Image = url.url.path.split(",").last;
                print('base64Image: $base64Image');
                // List<int> binaryPdf = base64.decode(base64Image);
                // final directory = await _localPath;
                //
                // // Create a new file in the directory with a unique name
                // final file = File('${directory}/${DateTime.now().millisecondsSinceEpoch}.pdf');
                // file.writeAsBytesSync(binaryPdf);
               await downloadImageFile(base64Image);
                // _createPDF();
                // _convertImageToPDF();
                // createPdf(base64Image);
                // downloadImageFile('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');
                    // final taskId = await FlutterDownloader.enqueue(
                    //   url: 'https:\/\/qswappweb.com\/resumebuilder\/public\/uploads\/user_guide_image\/63b3eed2d1cef.png',
                    //       // 'https://qswappweb.com/resumebuilder/public/featured',
                    //   saveInPublicStorage: true,
                    //   savedDir:
                    //       (await getExternalStorageDirectory())!.path,
                    //   showNotification: true,
                    //   fileName: "Flamingo Order Details",
                    //   // show download progress in status bar (for Android)
                    //   openFileFromNotification:
                    //       true, // click on notification to open downloaded file (for Android)
                    // );
                    // print('taskId:$taskId');
                  }
              else{
                print('else false');
                checkPermision();
                // checkPermission();
              }
                },
                    onLoadStart: (InAppWebViewController controller, url) {
                      print("started $url");
                      setState(() {
                        this.url = url.toString();
                      });
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress/100;
                      });
                    },
                  ),
                ),
              ),
              // ButtonBar(
              //   alignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     ElevatedButton(
              //       child: Icon(Icons.arrow_back),
              //       onPressed: () {
              //         if (_controller != null) {
              //           _controller.goBack();
              //         }
              //       },
              //     ),
              //     ElevatedButton(
              //       child: Icon(Icons.arrow_forward),
              //       onPressed: () {
              //         if (_controller != null) {
              //           _controller.goForward();
              //         }
              //       },
              //     ),
              //     ElevatedButton(
              //       child: Icon(Icons.refresh),
              //       onPressed: () {
              //         if (_controller != null) {
              //           _controller.reload();
              //         }
              //       },
              //     ),
              //   ],
              // ),
            ].where((Object o) => o != null).toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}

class SaveFile {
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    print('saveAndLaunchFile');
    // html.HtmlElement()
    // ..getNamespacedAttributes('data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    // ..onClick;
    html.AnchorElement(
        href:
        'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', fileName)
      ..click();
  }
}
