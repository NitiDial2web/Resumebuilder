import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as document;

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remuse_builder/common/AppButtons.dart';
import 'package:remuse_builder/common/AppColors.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/screens/apps_store.dart';
import 'package:remuse_builder/screens/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
// import 'package:html2md/html2md.dart' as html2md;
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_upload/webview_flutter.dart';
import 'package:html/parser.dart' show parse;
import 'package:webcontent_converter/webcontent_converter.dart';

final webViewKey = GlobalKey<_HomePageState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _token;
  late String _deviceType;
  late FirebaseMessaging messaging;
  late SharedPreferences preferences;
  // late final WebViewController _controller;
  late InAppWebViewController _controller;
  final GlobalKey webViewKey = GlobalKey();
  bool _innerpage = false;

  Uint8List? bytes;
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  // late bool result;
  bool connectionStatus = true;
  late String generatedPdfFilePath;

  // final Completer<WebViewController> _controller =
  // Completer<WebViewController>();
  final pw.Document pdf = pw.Document();

  PickedFile? _imageFile;

  Future check() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionStatus = true;
      }
    } on SocketException catch (_) {
      connectionStatus = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _token = '';
    _deviceType = '';
    SharedPreferences.getInstance().then((value) async {
      await Firebase.initializeApp();
      print('nidhi');
      messaging = FirebaseMessaging.instance;

      preferences = value;
      messaging.getToken().then((value) async {
        print('Firebase registration token $value');
        _token = value.toString();
        print('_token:$_token');
        await preferences.setString(AppStrings.kPrefDeviceToken, _token);
        if (Platform.isAndroid) {
          await preferences.setString(AppStrings.kPrefDeviceType, 'Android');
        }
        if (Platform.isIOS) {
          await preferences.setString(AppStrings.kPrefDeviceType, 'Ios');
        }
        print(
            'login device token is ${preferences.getString(AppStrings.kPrefDeviceToken)}');
      });
    });

    if (Platform.isAndroid) {
      // WebView.platform = SurfaceAndroidWebView();
    }
    FlutterDownloader.registerCallback(downloadCallback);
    // internet();
    // #docregion platform_features
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     final WebViewController controller =
//     WebViewController.fromPlatformCreationParams(params);
//     // #enddocregion platform_features
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             print('''
// Page resource error: $error
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//           ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               debugPrint('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             debugPrint('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..loadRequest(Uri.parse('https://youtube.com'));
//
//     // #docregion platform_features
//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
    // #enddocregion platform_features

    // _controller = controller;
  }

  // Future<void> deviceRegistration() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   try {
  //     if (Platform.isAndroid) {
  //       var info = await deviceInfo.androidInfo;
  //       print(info);
  //       setState(() {
  //         _deviceType = 'Android';
  //       });
  //
  //       var response =
  //       await http.post(Uri.parse(AppStrings.kDeviceRegiUrl), body: {
  //         'device_token':
  //         await preferences.getString(AppStrings.kPrefDeviceToken),
  //         'device_type': _deviceType,
  //         'language': 'En',
  //       });
  //       print(response.statusCode);
  //       if (response.statusCode == 200) {
  //         if (response.body.isNotEmpty) {
  //           print('android nidhi');
  //           var data = json.decode(response.body);
  //           var _usersData = data['data'];
  //           print('_deviceDetails:$_usersData');
  //           await preferences.setString(AppStrings.kPrefDeviceToken,
  //               _usersData[0][AppStrings.kPrefDeviceToken].toString());
  //           await preferences.setString(AppStrings.kPrefDeviceType,
  //               _usersData[0][AppStrings.kPrefDeviceType].toString());
  //         }
  //       }
  //
  //       //UUID for Android
  //     } else if (Platform.isIOS) {
  //       var data = await deviceInfo.iosInfo;
  //       setState(() {
  //         _deviceType = 'Ios';
  //         _token = data.identifierForVendor!;
  //       }); //UUID for iOS
  //       var response =
  //       await http.post(Uri.parse(AppStrings.kDeviceRegiUrl), body: {
  //         'device_token':
  //         await preferences.getString(AppStrings.kPrefDeviceToken),
  //         'device_type': _deviceType,
  //         'language': 'En',
  //       });
  //       var data1 = json.decode(response.body);
  //       var _usersData = data1['data'];
  //       //print(_usersData);
  //       await preferences.setString(AppStrings.kPrefDeviceToken,
  //           _usersData[0][AppStrings.kPrefDeviceToken].toString());
  //       await preferences.setString(AppStrings.kPrefDeviceType,
  //           _usersData[0][AppStrings.kPrefDeviceType].toString());
  //     }
  //   } on PlatformException {
  //     print('Failed to get platform version');
  //   }
  // }

  Future<void> generateExampleDocument() async {
    print('generateExampleDocument');

    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // print('path:$appDocDir');
    // final targetPath = 'example_resume/';
    // final targetFileName = "example-pdf";
    //
    // final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, targetPath, targetFileName);
    // generatedPdfFilePath = generatedPdfFile.path;
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  // Future<bool> internet() async{
  //   result = await InternetConnectionChecker().hasConnection;
  //   return result;
  // }

  Future<bool> checkPermission() async {
    print('checkPermission');
    // PermissionStatus permission = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.storage);
    Permission permission = await Permission.storage;
    if (permission != PermissionStatus.granted) {
      // Map<Permission, PermissionStatus> permissions =
      var permissions = (await Permission.storage.request());
      print('permissions.isGranted:${permissions.isGranted}');
      // await PermissionHandler()
      //     .requestPermissions([PermissionGroup.storage]);
      if (permissions.isGranted) {
        // if (permissions[Permission.storage] == PermissionStatus.granted) {
        return true;
      }
      print('permissions:${permissions}');
    }
    print('permission: ${permission}');
    return false;
  }

  convert(String cfData, String name) async {
    // Name is File Name that you want to give the file
    var targetPath = await _localPath;
    var targetFileName = name;
    // var document =
    //     parse('<body>Hello world! <a href="www.html5rocks.com">HTML5 rocks!');
    // print(document.outerHtml);
    // print('niti');
    // print('${html2md.convert(cfData)}');
    // html2md.convert(cfData);
    var bytes = await WebcontentConverter.contentToImage(content: cfData);
    if (bytes.length > 0) {
      saveImage(bytes);
    }
    else{
      print('else');
    }
    // final controller = ScreenshotController();
    // Uint8List bytes = await controller.captureFromWidget(
    //     MediaQuery(
    //         data: const MediaQueryData(),
    //         child: Html(
    //             shrinkWrap: true,
    //             data: cfData
    //         )
    //     )
    // );
    // File file = await File('$targetPath/$targetFileName.png').create();
    // file.writeAsBytesSync(bytes);
    // return file;
    // var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
    //     cfData, targetPath!, targetFileName);
    // print(generatedPdfFile);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(generatedPdfFile.toString()),
    // ));
  }

  Future<String?> get _localPath async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationSupportDirectory();
      } else {
        // if platform is android
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      print("Can-not get download folder path");
    }
    return directory?.path;
  }

  Future<void> _pickImage(ImageSource source) async {
    PickedFile? selected = await ImagePicker.platform.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });

    print("close");
    print('_imageFile:${_imageFile!.path.toString()}');
    if (_imageFile == null) {
      print("close in");
      // flutterWebviewPlugin.show();
    }
  }

  String cfData = """<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">

<head>
	<title></title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<br />
	<style type="text/css">
		p {
			margin: 0;
			padding: 0;
		}

		.ft10 {
			font-size: 14px;
			font-family: Times;
			color: #ffffff;
		}

		.ft11 {
			font-size: 102px;
			font-family: Times;
			color: #604d41;
		}

		.ft12 {
			font-size: 24px;
			font-family: Times;
			color: #000000;
		}

		.ft13 {
			font-size: 27px;
			font-family: Times;
			color: #41342d;
		}

		.ft14 {
			font-size: 15px;
			font-family: Times;
			color: #604d41;
		}

		.ft15 {
			font-size: 15px;
			font-family: Times;
			color: #957866;
		}

		.ft16 {
			font-size: 15px;
			font-family: Times;
			color: #604d41;
		}

		.ft17 {
			font-size: 15px;
			line-height: 26px;
			font-family: Times;
			color: #604d41;
		}

		#drop-zone {
			object-fit: cover;
			width: 393px;
			height: 383px;
			display: none;
			border-bottom-left-radius: 328px;
			border-bottom-right-radius: 329px;
			top:0px;
			left:35px;
			display: flex;
			justify-content: center;
			align-items: center;
		}

		.img_dd {
			/* object-fit: cover; */
			width: 393px;
			height: 383px;
			display: none;
			border-bottom-left-radius: 328px;
			border-bottom-right-radius: 329px;
			text-decoration: none;
		}
	</style>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
</head>

<body bgcolor="#A0A0A0" vlink="blue" link="blue" id="main" style="margin-top: 10px;">
		<div id="main1" style="box-sizing: border-box;margin-left: 0px;">
			<div id="myeditablediv" style="position:absolute;width:892px;height:100px;z-index:99;">

				<p style="position:absolute;top:396px;left:634px;white-space:nowrap" class="ft10">
					123&#160;Anywhere&#160;St.,&#160;Any&#160;City</p>
				<div id="drop-zone" style="position:absolute;white-space:wrap">
					<img src="" alt="" class="img_dd" style="object-fit: cover;">
					<p style="display: none;">Drop file or click to upload</p>
					<input type="file" id="myfile" hidden>
				</div>
			</div>
			<div id="myeditablediv1" style="position:relative;width:892px;height:1263px;">
				<img width="892" height="1263" src="https://www.linkpicture.com/q/Account1.png" alt="background image" style="position:absolute;"/>
				<p style="position:absolute;top:104px;left:480px;white-space:nowrap" class="ft11">Hannah</p>
				<p style="position:absolute;top:199px;left:478px;white-space:nowrap" class="ft11">Morales</p>
				<p style="position:absolute;top:326px;left:491px;white-space:nowrap" class="ft12">
					A&#160;c&#160;c&#160;o&#160;u&#160;n&#160;t&#160;i&#160;n&#160;g&#160;&#160;&#160;M&#160;a&#160;n&#160;a&#160;g&#160;e&#160;r
				</p>
				<p style="position:absolute;top:395px;left:327px;white-space:nowrap" class="ft10">
					hello@reallygreatsite.com
				</p>
				<p style="position:absolute;top:395px;left:78px;white-space:nowrap" class="ft10">+123-456-7890&#160;</p>
				<p style="position:absolute;top:674px;left:43px;white-space:nowrap" class="ft13">
					W&#160;O&#160;R&#160;K&#160;&#160;&#160;E&#160;X&#160;P&#160;E&#160;R&#160;I&#160;E&#160;N&#160;C&#160;E
				</p>
				<p style="position:absolute;top:796px;left:66px;white-space:nowrap" class="ft17">
					Review&#160;&#160;financial&#160;&#160;statements&#160;&#160;for&#160;&#160;accuracy<br />and&#160;legal&#160;compliance<br />Enter&#160;&#160;accounting&#160;&#160;related&#160;&#160;information&#160;&#160;into<br />business&#160;logs
				</p>
				<p style="position:absolute;top:730px;left:43px;white-space:nowrap" class="ft15">
					<b>Staff&#160;Accountant</b>
				</p>
				<p style="position:absolute;top:460px;left:43px;white-space:nowrap" class="ft13">
					E&#160;D&#160;U&#160;C&#160;A&#160;T&#160;I&#160;O&#160;N&#160;&#160;</p>
				<p style="position:absolute;top:506px;left:73px;white-space:nowrap" class="ft15">
					<b>Larana&#160;High&#160;School&#160;(2010&#160;-&#160;2013)</b>
				</p>
				<p style="position:absolute;top:620px;left:97px;white-space:nowrap" class="ft14">GPA&#160;:&#160;3.82
				</p>
				<p style="position:absolute;top:552px;left:73px;white-space:nowrap" class="ft15">
					<b>Fauget&#160;University&#160;(2013&#160;-&#160;2017)</b>
				</p>
				<p style="position:absolute;top:590px;left:74px;white-space:nowrap" class="ft16">
					<i>Bachelor&#160;of&#160;Accounting</i>
				</p>
				<p style="position:absolute;top:759px;left:43px;white-space:nowrap" class="ft16">
					<i>Thynk&#160;Unlimited&#160;(2017&#160;-&#160;2020)</i>
				</p>
				<p style="position:absolute;top:981px;left:66px;white-space:nowrap" class="ft17">
					Plan,&#160;&#160;implement&#160;&#160;and&#160;&#160;supervise&#160;&#160;the<br />company’s&#160;financial&#160;strategy<br />Manage&#160;&#160;the&#160;&#160;company’s&#160;&#160;financial&#160;&#160;accounts,<br />payrolls,&#160;&#160;budget,&#160;&#160;cash&#160;&#160;receipts&#160;&#160;and<br />financial&#160;assets<br />Handle&#160;&#160;the&#160;&#160;company’s&#160;&#160;transactions&#160;&#160;and<br />debts&#160;and&#160;do&#160;cash&#160;flow&#160;forecasting
				</p>
				<p style="position:absolute;top:916px;left:43px;white-space:nowrap" class="ft15">
					<b>Accounting&#160;Manager</b>
				</p>
				<p style="position:absolute;top:945px;left:43px;white-space:nowrap" class="ft16">
					<i>Aldenaire&#160;&amp;&#160;Partners&#160;(2020&#160;-&#160;2022)</i>
				</p>
				<p style="position:absolute;top:785px;left:587px;white-space:nowrap" class="ft17">
					Financial&#160;reporting<br />Payroll&#160;&#160;accounting&#160;&#160;and&#160;&#160;tax<br />computation<br />Standard&#160;&#160;cost&#160;&#160;analyst&#160;&#160;and<br />system&#160;automation
				</p>
				<p style="position:absolute;top:1004px;left:594px;white-space:nowrap" class="ft17">
					Won&#160;Accounting&#160;Competition<br />2012</p>
				<p style="position:absolute;top:959px;left:563px;white-space:nowrap" class="ft13">
					A&#160;W&#160;A&#160;R&#160;D&#160;S</p>
				<p style="position:absolute;top:730px;left:563px;white-space:nowrap" class="ft13">
					S&#160;K&#160;I&#160;L&#160;L
				</p>
				<p style="position:absolute;top:557px;left:563px;white-space:nowrap" class="ft17">
					Oversees&#160;&#160;preparation&#160;&#160;of&#160;&#160;business<br />activity&#160;</p>
				<p style="position:absolute;top:584px;left:674px;white-space:nowrap" class="ft14">reports,&#160;</p>
				<p style="position:absolute;top:584px;left:789px;white-space:nowrap" class="ft14">financial</p>
				<p style="position:absolute;top:611px;left:563px;white-space:nowrap" class="ft17">
					forecasts,&#160;&#160;and&#160;&#160;annual&#160;&#160;budgets.<br />Oversees&#160;</p>
				<p style="position:absolute;top:638px;left:669px;white-space:nowrap" class="ft14">the&#160;</p>
				<p style="position:absolute;top:638px;left:725px;white-space:nowrap" class="ft14">production&#160;</p>
				<p style="position:absolute;top:638px;left:845px;white-space:nowrap" class="ft14">of</p>
				<p style="position:absolute;top:665px;left:563px;white-space:nowrap" class="ft17">
					periodic&#160;&#160;financial&#160;&#160;reports&#160;&#160;and<br />much&#160;more.</p>
				<p style="position:absolute;top:514px;left:563px;white-space:nowrap" class="ft13">
					P&#160;R&#160;O&#160;F&#160;I&#160;L&#160;E</p>
			</div>
		</div>
	<div id="editor"></div>
	<center>
		<p>
			<button onclick="generatePDF()" id="btn_pdf">generate PDF</button>
		</p>
	</center>
	<script type="text/javascript">
		tinymce.init({
			selector: '#myeditablediv1',
			inline: true
		});
	</script>
	<script>
		const dropZone = document.querySelector('#drop-zone');
		const inputElement = document.querySelector('input');
		const img = document.querySelector('img');
		let p = document.querySelector('p')

		inputElement.addEventListener('change', function (e) {
			const clickFile = this.files[0];
			if (clickFile) {
				img.style = "display:block;";
				p.style = 'display: none';
				const reader = new FileReader();
				reader.readAsDataURL(clickFile);
				reader.onloadend = function () {
					const result = reader.result;
					let src = this.result;
					img.src = src;
					img.alt = clickFile.name
				}
			}
		})
		dropZone.addEventListener('click', () => inputElement.click());
		dropZone.addEventListener('dragover', (e) => {
			e.preventDefault();
		});
		dropZone.addEventListener('drop', (e) => {
			e.preventDefault();
			img.style = "display:block;";
			let file = e.dataTransfer.files[0];

			const reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onloadend = function () {
				e.preventDefault()
				p.style = 'display: none';
				let src = this.result;
				img.src = src;
				img.alt = file.name
			}
		});
	</script>
	<script type="text/javascript">

		document.getElementById("btn_pdf").style.display = "block";
		window.jsPDF = window.jspdf.jsPDF;
    window.flutter_injector.get('ImagePicker').invokeMethod('pickImage', reader.result);

		// Convert HTML content to PDF
		function generatePDF() {
			var doc = new jsPDF();
			document.getElementById("main").style.marginleft = 0;
			document.getElementById("main").style.objectFit = "cover";
			document.getElementById("main").style.top = 0;
			document.getElementById("myeditablediv").style.zIndex = "99";
			document.getElementById("btn_pdf").style.display = "none";

			// Source HTMLElement or a string containing HTML.
			var elementHTML = document.querySelector("#main");
			doc.html(elementHTML, {
				callback: function (doc) {
					// Save the PDF
					// document.getElementById("myeditablediv").style.zIndex = "99";
					doc.save('document-html.pdf');
				},
				margin: [-50, 0, 0, -10],
				
				// autoPaging: 'text',
				x: 0,
				y: 0,
				width: 158, //target width in the PDF document
				windowWidth: 675 //window width in CSS pixels
			});
			
		}
	</script>
</body>

</html>
""";

  // Future<void> _createPdf() async {
  //   final WebViewController webViewController = await _controller.future;
  //
  //   // Get the HTML content of the WebView
  //   final String html = await webViewController.evaluateJavascript('document.documentElement.outerHTML');
  //
  //   // Generate a PDF file
  //   final pw.Document pdf = pw.Document();
  //   final pw.Widget htmlWidget = pw.HtmlWidget(data: html);
  //   pdf.addPage(pw.Page(build: (pw.Context context) {
  //     return htmlWidget;
  //   }));
  //   final bytes = await pdf.save();
  //
  //   // Save the PDF file to device storage
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/example.pdf');
  //   await file.writeAsBytes(bytes);
  //
  //   // Open the PDF file with the default PDF viewer
  //   await OpenFile.open(file.path);
  // }

  Future saveImage(Uint8List bytes) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/example.png');
      await file.writeAsBytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    // print('url testing:${_controller.evaluateJavascript(source: "window.document.URL;")}');
    // var appBarColor = AppColors.kAppBarColor;
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          print('niti');
          _controller.goBack();
          setState(() {
            _innerpage = !_innerpage;
          });
          return false;
        } else {
          print('niti else');
          return true;
        }
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.kAppBarColor,
            centerTitle: true,
            title: AppButtons().kTextNormal(
                title: 'Build CV Resume Creator',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.kWhite),
            leading: IconButton(
              icon: const Icon(Icons.settings, size: 25),
              color: AppColors.koffWhite,
              onPressed: () {
                print('settings clicked');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
            ),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  text: "FEATURED",
                ),
                Tab(
                  text: "CATEGORIES",
                ),
                Tab(
                  text: "MY DESIGN",
                ),
              ],
            ),
            actions: [
              // (_controller.evaluateJavascript(source: "window.document.URL;") == "https://qswappweb.com/resumebuilder/public/featured")
              (!_innerpage)
              ?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
              :Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: () async {
                    print('Download');
                    print(
                        'url:${await _controller.evaluateJavascript(source: "window.document.URL;")}');
                    print(
                        'niti hello${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}');
                    String html = await _controller.evaluateJavascript(
                        source: "window.document.body.innerHTML;");
                    print(html);
                    // final bytes = await controller.captureFromWidget(Material(child: document.Document.html(html) as Widget));

                    // setState(() {
                    //   this.bytes = bytes;
                    // });
                    // saveImage(bytes);
                    convert(html,
                        "File Name${DateTime.now().toString().split(' ').first}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}");
                    // var targetPath2 = await _localPath;
                    // File pdfFile() {
                    //   if (Platform.isIOS) {
                    //     return File(targetPath2.toString() +
                    //         "/" +
                    //         "File Name333" +
                    //         '.pdf'); // for ios
                    //   } else {
                    //     print("aaaaa " + targetPath2.toString());
                    //     // File('storage/emulated/0/Download/' + cfData + '.pdf')
                    //     return File(targetPath2.toString() +
                    //         "/" +
                    //         "File Name" +
                    //         '.doc'); // for android
                    //   }
                    // }
                    //
                    // SfPdfViewer.file(pdfFile());
                    // generateExampleDocument();
                    print('download_successfull..//:');
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AppsStorePage()));
                  },
                  child: Icon(Icons.download),
                ),
              )
            ],
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics( ),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    future: check(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      print('connectionStatus: $connectionStatus');
                      return Expanded(
                        flex: 1,
                        child: (connectionStatus == true)
                            // ? WebView(
                            //     // key: webViewKey,
                            //     initialUrl: 'https://qswappweb.com/resumebuilder/public/featured',
                            //     javascriptMode: JavascriptMode.unrestricted,
                            //     onWebResourceError: (WebResourceError error) {
                            //       print("WebresourceError occured!");
                            //       // setState(() {
                            //       //   appBarColor = Colors.red;
                            //       //
                            //       // });
                            //     },
                            //     gestureNavigationEnabled: true,
                            //     gestureRecognizers: Set()
                            //       ..add(Factory<VerticalDragGestureRecognizer>(() =>
                            //           VerticalDragGestureRecognizer()
                            //             ..onDown =
                            //                 (DragDownDetails dragDownDetails) {
                            //               _controller.getScrollY().then((value) {
                            //                 if (value == 0 &&
                            //                     dragDownDetails
                            //                             .globalPosition.direction <
                            //                         1) {
                            //                   _controller.reload();
                            //                 }
                            //               });
                            //             }))
                            //       ..add(Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer())),
                            //     onWebViewCreated:
                            //         (WebViewController webViewController) {
                            //       _controller = webViewController;
                            //     },
                            //   )
                            // ?WebView(
                            //   initialUrl: 'https://qswappweb.com/resumebuilder/public/featured',
                            //   onWebViewCreated: (WebViewController webViewController) {
                            //     // _controller.complete(webViewController);
                            //     _controller = webViewController;
                            //   },
                            //   javascriptMode: JavascriptMode.unrestricted,
                            // )
//                     ?InAppWebView(
//                       key: webViewKey,
//                       initialData: InAppWebViewInitialData(data: """
// <!DOCTYPE html>
// <html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">
//
// <head>
// 	<title></title>
//
// 	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
// 	<br />
// 	<style type="text/css">
// 		p {
// 			margin: 0;
// 			padding: 0;
// 		}
//
// 		.ft10 {
// 			font-size: 14px;
// 			font-family: Times;
// 			color: #ffffff;
// 		}
//
// 		.ft11 {
// 			font-size: 102px;
// 			font-family: Times;
// 			color: #604d41;
// 		}
//
// 		.ft12 {
// 			font-size: 24px;
// 			font-family: Times;
// 			color: #000000;
// 		}
//
// 		.ft13 {
// 			font-size: 27px;
// 			font-family: Times;
// 			color: #41342d;
// 		}
//
// 		.ft14 {
// 			font-size: 15px;
// 			font-family: Times;
// 			color: #604d41;
// 		}
//
// 		.ft15 {
// 			font-size: 15px;
// 			font-family: Times;
// 			color: #957866;
// 		}
//
// 		.ft16 {
// 			font-size: 15px;
// 			font-family: Times;
// 			color: #604d41;
// 		}
//
// 		.ft17 {
// 			font-size: 15px;
// 			line-height: 26px;
// 			font-family: Times;
// 			color: #604d41;
// 		}
//
// 		#drop-zone {
// 			object-fit: cover;
// 			width: 393px;
// 			height: 383px;
// 			display: none;
// 			border-bottom-left-radius: 328px;
// 			border-bottom-right-radius: 329px;
// 			top:0px;
// 			left:35px;
// 			display: flex;
// 			justify-content: center;
// 			align-items: center;
// 		}
//
// 		.img_dd {
// 			/* object-fit: cover; */
// 			width: 393px;
// 			height: 383px;
// 			display: none;
// 			border-bottom-left-radius: 328px;
// 			border-bottom-right-radius: 329px;
// 			text-decoration: none;
// 		}
// 	</style>
// 	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
// 	<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
// 	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
// 	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
// </head>
//
// <body bgcolor="#A0A0A0" vlink="blue" link="blue" id="main" style="margin-top: 200px;">
// 		<div id="main1" style="box-sizing: border-box;margin-left: 37px;">
// 			<div id="myeditablediv" style="position:absolute;width:892px;height:100px;z-index:99;">
//
// 				<p style="position:absolute;top:396px;left:634px;white-space:nowrap" class="ft10">
// 					123&#160;Anywhere&#160;St.,&#160;Any&#160;City</p>
// 				<div id="drop-zone" style="position:absolute;white-space:wrap">
// 					<img src="" alt="" class="img_dd" style="object-fit: cover;">
// 					<p style="display: none;">Drop file or click to upload</p>
// 					<input type="file" id="myfile" hidden>
// 				</div>
// 			</div>
// 			<div id="myeditablediv1" style="position:relative;width:892px;height:1263px;">
// 				<img width="892" height="1263" src="https://www.linkpicture.com/q/Account1.png" alt="background image" style="position:absolute;"/>
// 				<p style="position:absolute;top:104px;left:480px;white-space:nowrap" class="ft11">Hannah</p>
// 				<p style="position:absolute;top:199px;left:478px;white-space:nowrap" class="ft11">Morales</p>
// 				<p style="position:absolute;top:326px;left:491px;white-space:nowrap" class="ft12">
// 					A&#160;c&#160;c&#160;o&#160;u&#160;n&#160;t&#160;i&#160;n&#160;g&#160;&#160;&#160;M&#160;a&#160;n&#160;a&#160;g&#160;e&#160;r
// 				</p>
// 				<p style="position:absolute;top:395px;left:327px;white-space:nowrap" class="ft10">
// 					hello@reallygreatsite.com
// 				</p>
// 				<p style="position:absolute;top:395px;left:78px;white-space:nowrap" class="ft10">+123-456-7890&#160;</p>
// 				<p style="position:absolute;top:674px;left:43px;white-space:nowrap" class="ft13">
// 					W&#160;O&#160;R&#160;K&#160;&#160;&#160;E&#160;X&#160;P&#160;E&#160;R&#160;I&#160;E&#160;N&#160;C&#160;E
// 				</p>
// 				<p style="position:absolute;top:796px;left:66px;white-space:nowrap" class="ft17">
// 					Review&#160;&#160;financial&#160;&#160;statements&#160;&#160;for&#160;&#160;accuracy<br />and&#160;legal&#160;compliance<br />Enter&#160;&#160;accounting&#160;&#160;related&#160;&#160;information&#160;&#160;into<br />business&#160;logs
// 				</p>
// 				<p style="position:absolute;top:730px;left:43px;white-space:nowrap" class="ft15">
// 					<b>Staff&#160;Accountant</b>
// 				</p>
// 				<p style="position:absolute;top:460px;left:43px;white-space:nowrap" class="ft13">
// 					E&#160;D&#160;U&#160;C&#160;A&#160;T&#160;I&#160;O&#160;N&#160;&#160;</p>
// 				<p style="position:absolute;top:506px;left:73px;white-space:nowrap" class="ft15">
// 					<b>Larana&#160;High&#160;School&#160;(2010&#160;-&#160;2013)</b>
// 				</p>
// 				<p style="position:absolute;top:620px;left:97px;white-space:nowrap" class="ft14">GPA&#160;:&#160;3.82
// 				</p>
// 				<p style="position:absolute;top:552px;left:73px;white-space:nowrap" class="ft15">
// 					<b>Fauget&#160;University&#160;(2013&#160;-&#160;2017)</b>
// 				</p>
// 				<p style="position:absolute;top:590px;left:74px;white-space:nowrap" class="ft16">
// 					<i>Bachelor&#160;of&#160;Accounting</i>
// 				</p>
// 				<p style="position:absolute;top:759px;left:43px;white-space:nowrap" class="ft16">
// 					<i>Thynk&#160;Unlimited&#160;(2017&#160;-&#160;2020)</i>
// 				</p>
// 				<p style="position:absolute;top:981px;left:66px;white-space:nowrap" class="ft17">
// 					Plan,&#160;&#160;implement&#160;&#160;and&#160;&#160;supervise&#160;&#160;the<br />company’s&#160;financial&#160;strategy<br />Manage&#160;&#160;the&#160;&#160;company’s&#160;&#160;financial&#160;&#160;accounts,<br />payrolls,&#160;&#160;budget,&#160;&#160;cash&#160;&#160;receipts&#160;&#160;and<br />financial&#160;assets<br />Handle&#160;&#160;the&#160;&#160;company’s&#160;&#160;transactions&#160;&#160;and<br />debts&#160;and&#160;do&#160;cash&#160;flow&#160;forecasting
// 				</p>
// 				<p style="position:absolute;top:916px;left:43px;white-space:nowrap" class="ft15">
// 					<b>Accounting&#160;Manager</b>
// 				</p>
// 				<p style="position:absolute;top:945px;left:43px;white-space:nowrap" class="ft16">
// 					<i>Aldenaire&#160;&amp;&#160;Partners&#160;(2020&#160;-&#160;2022)</i>
// 				</p>
// 				<p style="position:absolute;top:785px;left:587px;white-space:nowrap" class="ft17">
// 					Financial&#160;reporting<br />Payroll&#160;&#160;accounting&#160;&#160;and&#160;&#160;tax<br />computation<br />Standard&#160;&#160;cost&#160;&#160;analyst&#160;&#160;and<br />system&#160;automation
// 				</p>
// 				<p style="position:absolute;top:1004px;left:594px;white-space:nowrap" class="ft17">
// 					Won&#160;Accounting&#160;Competition<br />2012</p>
// 				<p style="position:absolute;top:959px;left:563px;white-space:nowrap" class="ft13">
// 					A&#160;W&#160;A&#160;R&#160;D&#160;S</p>
// 				<p style="position:absolute;top:730px;left:563px;white-space:nowrap" class="ft13">
// 					S&#160;K&#160;I&#160;L&#160;L
// 				</p>
// 				<p style="position:absolute;top:557px;left:563px;white-space:nowrap" class="ft17">
// 					Oversees&#160;&#160;preparation&#160;&#160;of&#160;&#160;business<br />activity&#160;</p>
// 				<p style="position:absolute;top:584px;left:674px;white-space:nowrap" class="ft14">reports,&#160;</p>
// 				<p style="position:absolute;top:584px;left:789px;white-space:nowrap" class="ft14">financial</p>
// 				<p style="position:absolute;top:611px;left:563px;white-space:nowrap" class="ft17">
// 					forecasts,&#160;&#160;and&#160;&#160;annual&#160;&#160;budgets.<br />Oversees&#160;</p>
// 				<p style="position:absolute;top:638px;left:669px;white-space:nowrap" class="ft14">the&#160;</p>
// 				<p style="position:absolute;top:638px;left:725px;white-space:nowrap" class="ft14">production&#160;</p>
// 				<p style="position:absolute;top:638px;left:845px;white-space:nowrap" class="ft14">of</p>
// 				<p style="position:absolute;top:665px;left:563px;white-space:nowrap" class="ft17">
// 					periodic&#160;&#160;financial&#160;&#160;reports&#160;&#160;and<br />much&#160;more.</p>
// 				<p style="position:absolute;top:514px;left:563px;white-space:nowrap" class="ft13">
// 					P&#160;R&#160;O&#160;F&#160;I&#160;L&#160;E</p>
// 			</div>
// 		</div>
// 	<div id="editor"></div>
// 	<center>
// 		<p>
// 			<button onclick="generatePDF()" id="btn_pdf">generate PDF</button>
// 		</p>
// 	</center>
// 	<script type="text/javascript">
// 		tinymce.init({
// 			selector: '#myeditablediv1',
// 			inline: true
// 		});
// 	</script>
// 	<script>
// 		const dropZone = document.querySelector('#drop-zone');
// 		const inputElement = document.querySelector('input');
// 		const img = document.querySelector('img');
// 		let p = document.querySelector('p')
//
// 		inputElement.addEventListener('change', function (e) {
// 			const clickFile = this.files[0];
// 			if (clickFile) {
// 				img.style = "display:block;";
// 				p.style = 'display: none';
// 				const reader = new FileReader();
// 				reader.readAsDataURL(clickFile);
// 				reader.onloadend = function () {
// 					const result = reader.result;
// 					let src = this.result;
// 					img.src = src;
// 					img.alt = clickFile.name
// 				}
// 			}
// 		})
// 		dropZone.addEventListener('click', () => inputElement.click());
// 		dropZone.addEventListener('dragover', (e) => {
// 			e.preventDefault();
// 		});
// 		dropZone.addEventListener('drop', (e) => {
// 			e.preventDefault();
// 			img.style = "display:block;";
// 			let file = e.dataTransfer.files[0];
//
// 			const reader = new FileReader();
// 			reader.readAsDataURL(file);
// 			reader.onloadend = function () {
// 				e.preventDefault()
// 				p.style = 'display: none';
// 				let src = this.result;
// 				img.src = src;
// 				img.alt = file.name
// 			}
// 		});
// 	</script>
// 	<script type="text/javascript">
//
// 		document.getElementById("btn_pdf").style.display = "block";
// 		window.jsPDF = window.jspdf.jsPDF;
// 		window.flutter_injector.get('ImagePicker').invokeMethod('pickImage', reader.result);
// 		// Convert HTML content to PDF
// 		function generatePDF() {
// 			var doc = new jsPDF();
// 			document.getElementById("main").style.marginleft = 0;
// 			document.getElementById("main").style.objectFit = "cover";
// 			document.getElementById("main").style.top = 0;
// 			document.getElementById("myeditablediv").style.zIndex = "99";
// 			document.getElementById("btn_pdf").style.display = "none";
//
// 			// Source HTMLElement or a string containing HTML.
// 			var elementHTML = document.querySelector("#main");
// 			doc.html(elementHTML, {
// 				callback: function (doc) {
// 					// Save the PDF
// 					// document.getElementById("myeditablediv").style.zIndex = "99";
// 					doc.save('document-html.pdf');
// 				},
// 				margin: [-50, 0, 0, -10],
//
// 				// autoPaging: 'text',
// 				x: 0,
// 				y: 0,
// 				width: 158, //target width in the PDF document
// 				windowWidth: 675 //window width in CSS pixels
// 			});
//
// 		}
// 	</script>
// </body>
//
// </html>
//                 """),
//     onLoadStop: (controller, url) async {
//                         print('onload');
//                         print(_controller.webStorage.sessionStorage.webStorageType.toString());
//                         if(await _controller.evaluateJavascript(source: "window.document.URL;") != "https://qswappweb.com/resumebuilder/public/featured"){
//                           print('if onload');
//                               // var result = await controller.evaluateJavascript(
//                               //     source: "1 + 1");
//                               // print(result.runtimeType); // int
//                               // print(result); //2
//                           var result = _controller.evaluateJavascript(source: '''
//   var fileInput = document.createElement('input');
//   fileInput.type = 'file';
//   fileInput.accept = 'image/*';
//   fileInput.onchange = () => {
//     var file = fileInput.files[0];
//     var reader = new FileReader();
//     reader.readAsDataURL(file);
//     reader.onload = () => {
//       window.flutter_injector.get('ImagePicker').invokeMethod('pickImage', reader.result);
//     };
//   };
//   fileInput.click();
// ''');
//                           print(result.toString());
//                           print(result);
//                         }
//                       else{
//                         print('else onload');
//                         }
//                         },
//                       onWebViewCreated: (controller) {
//                         _controller = controller;
//                         // _pickImage(ImageSource.gallery);
//                       },
//                     )
                            ? InAppWebView(
                                initialUrlRequest: URLRequest(
                                    url: Uri.parse(
                                        'https://qswappweb.com/resumebuilder/public/featured')),
                                // initialHeaders: {},
                                initialOptions: InAppWebViewGroupOptions(
                                  crossPlatform: InAppWebViewOptions(
                                      // debuggingEnabled: true,
                                      useOnDownloadStart: true,
                                      allowFileAccessFromFileURLs: true,
                                      allowUniversalAccessFromFileURLs: true),
                                  android: AndroidInAppWebViewOptions(
                                    useHybridComposition: true,
                                  ),
                                ),
                                // gestureNavigationEnabled: true,
                                gestureRecognizers: Set()
                                  ..add(Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer()
                                        ..onDown =
                                            (DragDownDetails dragDownDetails) {
                                          _controller
                                              .getScrollY()
                                              .then((value) {
                                            if (value == 0 &&
                                                dragDownDetails.globalPosition
                                                        .direction <
                                                    1) {
                                              _controller.reload();
                                            }
                                          });
                                        }))
                                  ..add(Factory<LongPressGestureRecognizer>(
                                      () => LongPressGestureRecognizer())),
                                onWebViewCreated:
                                    (InAppWebViewController webViewController) {
                                  _controller = webViewController;
                                },
                      onLoadStop: (controller, url) async {
                        if(await _controller.evaluateJavascript(source: "window.document.URL;") != "https://qswappweb.com/resumebuilder/public/featured"){
                             setState(() {
                               _innerpage = !_innerpage;
                             });
                              // var result = await controller.evaluateJavascript(
                              //     source: "1 + 1");
                              // print(result.runtimeType); // int
                              // print(result); //2
//                           var result = _controller.evaluateJavascript(source: '''
//   var fileInput = document.createElement('input');
//   fileInput.type = 'file';
//   fileInput.accept = 'image/*';
//   fileInput.onchange = () => {
//     var file = fileInput.files[0];
//     var reader = new FileReader();
//     reader.readAsDataURL(file);
//     reader.onload = () => {
//       window.flutter_injector.get('ImagePicker').invokeMethod('pickImage', reader.result);
//     };
//   };
//   fileInput.click();
// ''');
//                           print(result.toString());
//                           print(result);
                        }
                      },
                                // onWebViewCreated: (InAppWebViewController controller) {
                                //   webView = controller;
                                // },
                                // onLoadStart: (InAppWebViewController controller, String url) {
                                //
                                // },
                                // onLoadStop: (InAppWebViewController controller, String url) {
                                //
                                // },
                                // onLoadStop: (controller, url) async {
                                //   var html = await controller.evaluateJavascript(
                                //       source: "window.document.getElementsByTagName('head')[0].outerHTML;");
                                //   //   source: "window.document.body.innerText;");
                                //   print("==========start================");
                                //   // catchtext = html;
                                //   print(':$html}');
                                //
                                // },

                                // onPageCommitVisible: (con,uri){
                                //   print("url ${uri.toString()}");
                                //   con.goBack();
                                // },
                                // onDownloadStartRequest: (controller, url) async {
                                //   print('Permission.storage.status:${await Permission.storage.status}');
                                //   // await checkPermission();
                                //   // print(await checkPermission());
                                //   print("onDownloadStart $url");
                                //   if(await Permission.storage.request().isGranted){
                                //     print('if true');
                                //         final taskId = await FlutterDownloader.enqueue(
                                //           url: 'https:\/\/qswappweb.com\/resumebuilder\/public\/uploads\/user_guide_image\/63b3eed2d1cef.png',
                                //               // 'https://qswappweb.com/resumebuilder/public/featured',
                                //           saveInPublicStorage: true,
                                //           savedDir:
                                //               (await getExternalStorageDirectory())!.path,
                                //           showNotification: true,
                                //           fileName: "Flamingo Order Details",
                                //           // show download progress in status bar (for Android)
                                //           openFileFromNotification:
                                //               true, // click on notification to open downloaded file (for Android)
                                //         );
                                //         print('taskId:$taskId');
                                //       }
                                //   else{
                                //     print('else false');
                                //     checkPermission();
                                //   }
                                //     },
                              )
                            : Center(
                                child: Text(" no internet"),
                              ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    future: check(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      print('connectionStatus: $connectionStatus');
                      return Expanded(
                        flex: 1,
                        child: (connectionStatus == true)
                            // ? WebView(
                            //     // key: webViewKey,
                            //     initialUrl: 'https://qswappweb.com/resumebuilder/public/featured',
                            //     javascriptMode: JavascriptMode.unrestricted,
                            //     onWebResourceError: (WebResourceError error) {
                            //       print("WebresourceError occured!");
                            //       // setState(() {
                            //       //   appBarColor = Colors.red;
                            //       //
                            //       // });
                            //     },
                            //     gestureNavigationEnabled: true,
                            //     gestureRecognizers: Set()
                            //       ..add(Factory<VerticalDragGestureRecognizer>(() =>
                            //           VerticalDragGestureRecognizer()
                            //             ..onDown =
                            //                 (DragDownDetails dragDownDetails) {
                            //               _controller.getScrollY().then((value) {
                            //                 if (value == 0 &&
                            //                     dragDownDetails
                            //                             .globalPosition.direction <
                            //                         1) {
                            //                   _controller.reload();
                            //                 }
                            //               });
                            //             }))
                            //       ..add(Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer())),
                            //     onWebViewCreated:
                            //         (WebViewController webViewController) {
                            //       _controller = webViewController;
                            //     },
                            //   )
                            // ?WebView(
                            //   initialUrl: 'https://qswappweb.com/resumebuilder/public/featured',
                            //   onWebViewCreated: (WebViewController webViewController) {
                            //     // _controller.complete(webViewController);
                            //     _controller = webViewController;
                            //   },
                            //   javascriptMode: JavascriptMode.unrestricted,
                            // )
//                     ?InAppWebView(
//                       key: webViewKey,
//                       initialData: InAppWebViewInitialData(data: """
// <!DOCTYPE html>
// <html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">
//
// <head>
// 	<title></title>
//
// 	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
// 	<br />
// 	<style type="text/css">
// 		p {
// 			margin: 0;
// 			padding: 0;
// 		}
//
// 		.ft10 {
// 			font-size: 14px;
// 			font-family: Times;
// 			color: #ffffff;
// 		}
//
// 		.ft11 {
// 			font-size: 102px;
// 			font-family: Times;
// 			color: #604d41;
// 		}
//
// 		.ft12 {
// 			font-size: 24px;
// 			font-family: Times;
// 			color: #000000;
// 		}
//
// 		.ft13 {
// 			font-size: 27px;
// 			font-family: Times;
// 			color: #41342d;
// 		}
//
// 		.ft14 {
// 			font-size: 15px;
// 			font-family: Times;
// 			color: #604d41;
// 		}
//
// 		.ft15 {
// 			font-size: 15px;
// 			font-family: Times;
// 			color: #957866;
// 		}
//
// 		.ft16 {
// 			font-size: 15px;
// 			font-family: Times;
// 			color: #604d41;
// 		}
//
// 		.ft17 {
// 			font-size: 15px;
// 			line-height: 26px;
// 			font-family: Times;
// 			color: #604d41;
// 		}
//
// 		#drop-zone {
// 			object-fit: cover;
// 			width: 393px;
// 			height: 383px;
// 			display: none;
// 			border-bottom-left-radius: 328px;
// 			border-bottom-right-radius: 329px;
// 			top:0px;
// 			left:35px;
// 			display: flex;
// 			justify-content: center;
// 			align-items: center;
// 		}
//
// 		.img_dd {
// 			/* object-fit: cover; */
// 			width: 393px;
// 			height: 383px;
// 			display: none;
// 			border-bottom-left-radius: 328px;
// 			border-bottom-right-radius: 329px;
// 			text-decoration: none;
// 		}
// 	</style>
// 	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
// 	<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
// 	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
// 	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
// </head>
//
// <body bgcolor="#A0A0A0" vlink="blue" link="blue" id="main" style="margin-top: 200px;">
// 		<div id="main1" style="box-sizing: border-box;margin-left: 37px;">
// 			<div id="myeditablediv" style="position:absolute;width:892px;height:100px;z-index:99;">
//
// 				<p style="position:absolute;top:396px;left:634px;white-space:nowrap" class="ft10">
// 					123&#160;Anywhere&#160;St.,&#160;Any&#160;City</p>
// 				<div id="drop-zone" style="position:absolute;white-space:wrap">
// 					<img src="" alt="" class="img_dd" style="object-fit: cover;">
// 					<p style="display: none;">Drop file or click to upload</p>
// 					<input type="file" id="myfile" hidden>
// 				</div>
// 			</div>
// 			<div id="myeditablediv1" style="position:relative;width:892px;height:1263px;">
// 				<img width="892" height="1263" src="https://www.linkpicture.com/q/Account1.png" alt="background image" style="position:absolute;"/>
// 				<p style="position:absolute;top:104px;left:480px;white-space:nowrap" class="ft11">Hannah</p>
// 				<p style="position:absolute;top:199px;left:478px;white-space:nowrap" class="ft11">Morales</p>
// 				<p style="position:absolute;top:326px;left:491px;white-space:nowrap" class="ft12">
// 					A&#160;c&#160;c&#160;o&#160;u&#160;n&#160;t&#160;i&#160;n&#160;g&#160;&#160;&#160;M&#160;a&#160;n&#160;a&#160;g&#160;e&#160;r
// 				</p>
// 				<p style="position:absolute;top:395px;left:327px;white-space:nowrap" class="ft10">
// 					hello@reallygreatsite.com
// 				</p>
// 				<p style="position:absolute;top:395px;left:78px;white-space:nowrap" class="ft10">+123-456-7890&#160;</p>
// 				<p style="position:absolute;top:674px;left:43px;white-space:nowrap" class="ft13">
// 					W&#160;O&#160;R&#160;K&#160;&#160;&#160;E&#160;X&#160;P&#160;E&#160;R&#160;I&#160;E&#160;N&#160;C&#160;E
// 				</p>
// 				<p style="position:absolute;top:796px;left:66px;white-space:nowrap" class="ft17">
// 					Review&#160;&#160;financial&#160;&#160;statements&#160;&#160;for&#160;&#160;accuracy<br />and&#160;legal&#160;compliance<br />Enter&#160;&#160;accounting&#160;&#160;related&#160;&#160;information&#160;&#160;into<br />business&#160;logs
// 				</p>
// 				<p style="position:absolute;top:730px;left:43px;white-space:nowrap" class="ft15">
// 					<b>Staff&#160;Accountant</b>
// 				</p>
// 				<p style="position:absolute;top:460px;left:43px;white-space:nowrap" class="ft13">
// 					E&#160;D&#160;U&#160;C&#160;A&#160;T&#160;I&#160;O&#160;N&#160;&#160;</p>
// 				<p style="position:absolute;top:506px;left:73px;white-space:nowrap" class="ft15">
// 					<b>Larana&#160;High&#160;School&#160;(2010&#160;-&#160;2013)</b>
// 				</p>
// 				<p style="position:absolute;top:620px;left:97px;white-space:nowrap" class="ft14">GPA&#160;:&#160;3.82
// 				</p>
// 				<p style="position:absolute;top:552px;left:73px;white-space:nowrap" class="ft15">
// 					<b>Fauget&#160;University&#160;(2013&#160;-&#160;2017)</b>
// 				</p>
// 				<p style="position:absolute;top:590px;left:74px;white-space:nowrap" class="ft16">
// 					<i>Bachelor&#160;of&#160;Accounting</i>
// 				</p>
// 				<p style="position:absolute;top:759px;left:43px;white-space:nowrap" class="ft16">
// 					<i>Thynk&#160;Unlimited&#160;(2017&#160;-&#160;2020)</i>
// 				</p>
// 				<p style="position:absolute;top:981px;left:66px;white-space:nowrap" class="ft17">
// 					Plan,&#160;&#160;implement&#160;&#160;and&#160;&#160;supervise&#160;&#160;the<br />company’s&#160;financial&#160;strategy<br />Manage&#160;&#160;the&#160;&#160;company’s&#160;&#160;financial&#160;&#160;accounts,<br />payrolls,&#160;&#160;budget,&#160;&#160;cash&#160;&#160;receipts&#160;&#160;and<br />financial&#160;assets<br />Handle&#160;&#160;the&#160;&#160;company’s&#160;&#160;transactions&#160;&#160;and<br />debts&#160;and&#160;do&#160;cash&#160;flow&#160;forecasting
// 				</p>
// 				<p style="position:absolute;top:916px;left:43px;white-space:nowrap" class="ft15">
// 					<b>Accounting&#160;Manager</b>
// 				</p>
// 				<p style="position:absolute;top:945px;left:43px;white-space:nowrap" class="ft16">
// 					<i>Aldenaire&#160;&amp;&#160;Partners&#160;(2020&#160;-&#160;2022)</i>
// 				</p>
// 				<p style="position:absolute;top:785px;left:587px;white-space:nowrap" class="ft17">
// 					Financial&#160;reporting<br />Payroll&#160;&#160;accounting&#160;&#160;and&#160;&#160;tax<br />computation<br />Standard&#160;&#160;cost&#160;&#160;analyst&#160;&#160;and<br />system&#160;automation
// 				</p>
// 				<p style="position:absolute;top:1004px;left:594px;white-space:nowrap" class="ft17">
// 					Won&#160;Accounting&#160;Competition<br />2012</p>
// 				<p style="position:absolute;top:959px;left:563px;white-space:nowrap" class="ft13">
// 					A&#160;W&#160;A&#160;R&#160;D&#160;S</p>
// 				<p style="position:absolute;top:730px;left:563px;white-space:nowrap" class="ft13">
// 					S&#160;K&#160;I&#160;L&#160;L
// 				</p>
// 				<p style="position:absolute;top:557px;left:563px;white-space:nowrap" class="ft17">
// 					Oversees&#160;&#160;preparation&#160;&#160;of&#160;&#160;business<br />activity&#160;</p>
// 				<p style="position:absolute;top:584px;left:674px;white-space:nowrap" class="ft14">reports,&#160;</p>
// 				<p style="position:absolute;top:584px;left:789px;white-space:nowrap" class="ft14">financial</p>
// 				<p style="position:absolute;top:611px;left:563px;white-space:nowrap" class="ft17">
// 					forecasts,&#160;&#160;and&#160;&#160;annual&#160;&#160;budgets.<br />Oversees&#160;</p>
// 				<p style="position:absolute;top:638px;left:669px;white-space:nowrap" class="ft14">the&#160;</p>
// 				<p style="position:absolute;top:638px;left:725px;white-space:nowrap" class="ft14">production&#160;</p>
// 				<p style="position:absolute;top:638px;left:845px;white-space:nowrap" class="ft14">of</p>
// 				<p style="position:absolute;top:665px;left:563px;white-space:nowrap" class="ft17">
// 					periodic&#160;&#160;financial&#160;&#160;reports&#160;&#160;and<br />much&#160;more.</p>
// 				<p style="position:absolute;top:514px;left:563px;white-space:nowrap" class="ft13">
// 					P&#160;R&#160;O&#160;F&#160;I&#160;L&#160;E</p>
// 			</div>
// 		</div>
// 	<div id="editor"></div>
// 	<center>
// 		<p>
// 			<button onclick="generatePDF()" id="btn_pdf">generate PDF</button>
// 		</p>
// 	</center>
// 	<script type="text/javascript">
// 		tinymce.init({
// 			selector: '#myeditablediv1',
// 			inline: true
// 		});
// 	</script>
// 	<script>
// 		const dropZone = document.querySelector('#drop-zone');
// 		const inputElement = document.querySelector('input');
// 		const img = document.querySelector('img');
// 		let p = document.querySelector('p')
//
// 		inputElement.addEventListener('change', function (e) {
// 			const clickFile = this.files[0];
// 			if (clickFile) {
// 				img.style = "display:block;";
// 				p.style = 'display: none';
// 				const reader = new FileReader();
// 				reader.readAsDataURL(clickFile);
// 				reader.onloadend = function () {
// 					const result = reader.result;
// 					let src = this.result;
// 					img.src = src;
// 					img.alt = clickFile.name
// 				}
// 			}
// 		})
// 		dropZone.addEventListener('click', () => inputElement.click());
// 		dropZone.addEventListener('dragover', (e) => {
// 			e.preventDefault();
// 		});
// 		dropZone.addEventListener('drop', (e) => {
// 			e.preventDefault();
// 			img.style = "display:block;";
// 			let file = e.dataTransfer.files[0];
//
// 			const reader = new FileReader();
// 			reader.readAsDataURL(file);
// 			reader.onloadend = function () {
// 				e.preventDefault()
// 				p.style = 'display: none';
// 				let src = this.result;
// 				img.src = src;
// 				img.alt = file.name
// 			}
// 		});
// 	</script>
// 	<script type="text/javascript">
//
// 		document.getElementById("btn_pdf").style.display = "block";
// 		window.jsPDF = window.jspdf.jsPDF;
// 		window.flutter_injector.get('ImagePicker').invokeMethod('pickImage', reader.result);
// 		// Convert HTML content to PDF
// 		function generatePDF() {
// 			var doc = new jsPDF();
// 			document.getElementById("main").style.marginleft = 0;
// 			document.getElementById("main").style.objectFit = "cover";
// 			document.getElementById("main").style.top = 0;
// 			document.getElementById("myeditablediv").style.zIndex = "99";
// 			document.getElementById("btn_pdf").style.display = "none";
//
// 			// Source HTMLElement or a string containing HTML.
// 			var elementHTML = document.querySelector("#main");
// 			doc.html(elementHTML, {
// 				callback: function (doc) {
// 					// Save the PDF
// 					// document.getElementById("myeditablediv").style.zIndex = "99";
// 					doc.save('document-html.pdf');
// 				},
// 				margin: [-50, 0, 0, -10],
//
// 				// autoPaging: 'text',
// 				x: 0,
// 				y: 0,
// 				width: 158, //target width in the PDF document
// 				windowWidth: 675 //window width in CSS pixels
// 			});
//
// 		}
// 	</script>
// </body>
//
// </html>
//                 """),
//     onLoadStop: (controller, url) async {
//                         print('onload');
//                         print(_controller.webStorage.sessionStorage.webStorageType.toString());
//                         if(await _controller.evaluateJavascript(source: "window.document.URL;") != "https://qswappweb.com/resumebuilder/public/featured"){
//                           print('if onload');
//                               // var result = await controller.evaluateJavascript(
//                               //     source: "1 + 1");
//                               // print(result.runtimeType); // int
//                               // print(result); //2
//                           var result = _controller.evaluateJavascript(source: '''
//   var fileInput = document.createElement('input');
//   fileInput.type = 'file';
//   fileInput.accept = 'image/*';
//   fileInput.onchange = () => {
//     var file = fileInput.files[0];
//     var reader = new FileReader();
//     reader.readAsDataURL(file);
//     reader.onload = () => {
//       window.flutter_injector.get('ImagePicker').invokeMethod('pickImage', reader.result);
//     };
//   };
//   fileInput.click();
// ''');
//                           print(result.toString());
//                           print(result);
//                         }
//                       else{
//                         print('else onload');
//                         }
//                         },
//                       onWebViewCreated: (controller) {
//                         _controller = controller;
//                         // _pickImage(ImageSource.gallery);
//                       },
//                     )
                            ? InAppWebView(
                                initialUrlRequest: URLRequest(
                                    url: Uri.parse(
                                        'https://qswappweb.com/resumebuilder/public/categories')),
                                // initialHeaders: {},
                                initialOptions: InAppWebViewGroupOptions(
                                  crossPlatform: InAppWebViewOptions(
                                      // debuggingEnabled: true,
                                      useOnDownloadStart: true,
                                      allowFileAccessFromFileURLs: true,
                                      allowUniversalAccessFromFileURLs: true),
                                  android: AndroidInAppWebViewOptions(
                                    useHybridComposition: true,
                                  ),
                                ),
                                // gestureNavigationEnabled: true,
                                gestureRecognizers: Set()
                                  ..add(Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer()
                                        ..onDown =
                                            (DragDownDetails dragDownDetails) {
                                          _controller
                                              .getScrollY()
                                              .then((value) {
                                            if (value == 0 &&
                                                dragDownDetails.globalPosition
                                                        .direction <
                                                    1) {
                                              _controller.reload();
                                            }
                                          });
                                        }))
                                  ..add(Factory<LongPressGestureRecognizer>(
                                      () => LongPressGestureRecognizer())),
                                onWebViewCreated:
                                    (InAppWebViewController webViewController) {
                                  _controller = webViewController;
                                },
//                       onLoadStop: (controller, url) async {
//                         if(await _controller.evaluateJavascript(source: "window.document.URL;") != "https://qswappweb.com/resumebuilder/public/featured"){
//                               var result = await controller.evaluateJavascript(
//                                   source: "1 + 1");
//                               print(result.runtimeType); // int
//                               print(result); //2
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
//                         }
//                       },
                                // onWebViewCreated: (InAppWebViewController controller) {
                                //   webView = controller;
                                // },
                                // onLoadStart: (InAppWebViewController controller, String url) {
                                //
                                // },
                                // onLoadStop: (InAppWebViewController controller, String url) {
                                //
                                // },
                                // onLoadStop: (controller, url) async {
                                //   var html = await controller.evaluateJavascript(
                                //       source: "window.document.getElementsByTagName('head')[0].outerHTML;");
                                //   //   source: "window.document.body.innerText;");
                                //   print("==========start================");
                                //   // catchtext = html;
                                //   print(':$html}');
                                //
                                // },

                                // onPageCommitVisible: (con,uri){
                                //   print("url ${uri.toString()}");
                                //   con.goBack();
                                // },
                                // onDownloadStartRequest: (controller, url) async {
                                //   print('Permission.storage.status:${await Permission.storage.status}');
                                //   // await checkPermission();
                                //   // print(await checkPermission());
                                //   print("onDownloadStart $url");
                                //   if(await Permission.storage.request().isGranted){
                                //     print('if true');
                                //         final taskId = await FlutterDownloader.enqueue(
                                //           url: 'https:\/\/qswappweb.com\/resumebuilder\/public\/uploads\/user_guide_image\/63b3eed2d1cef.png',
                                //               // 'https://qswappweb.com/resumebuilder/public/featured',
                                //           saveInPublicStorage: true,
                                //           savedDir:
                                //               (await getExternalStorageDirectory())!.path,
                                //           showNotification: true,
                                //           fileName: "Flamingo Order Details",
                                //           // show download progress in status bar (for Android)
                                //           openFileFromNotification:
                                //               true, // click on notification to open downloaded file (for Android)
                                //         );
                                //         print('taskId:$taskId');
                                //       }
                                //   else{
                                //     print('else false');
                                //     checkPermission();
                                //   }
                                //     },
                              )
                            : Center(
                                child: Text(" no internet"),
                              ),
                      );
                    },
                  ),
                ],
              ),
              const Center(
                child: Text("My Design"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
