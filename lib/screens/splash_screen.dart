import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:remuse_builder/screens/blank_page.dart';
import 'package:remuse_builder/screens/home_page.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {

  @override
  void initState(){
    super.initState();
    execute(InternetConnectionChecker());

    // Create customized instance which can be registered via dependency injection
    final InternetConnectionChecker customInstance =
    InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1),
      checkInterval: const Duration(seconds: 1),
    );

    // Check internet connection with created instance
    execute(customInstance);
    Future.delayed(
        const Duration(seconds: 5),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        ));
  }

  Future<void> execute(
      InternetConnectionChecker internetConnectionChecker,
      ) async {
    // Simple check to see if we have Internet
    // ignore: avoid_print
    print('''The statement 'this machine is connected to the Internet' is: ''');
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    print(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    print(
      'Current status: ${await InternetConnectionChecker().connectionStatus}',
    );
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
          // ignore: avoid_print
            print('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            print('You are disconnected from the internet.');
            // Container(
            //   width: 200,
            //   height: 500,
            //   color: Colors.grey,
            //   child: const Center(
            //     child: Text('Please connect to Internet',
            //       style: TextStyle(color: Colors.black,fontSize: 20),),
            //   ),
            // );
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const BlankPage()));
            break;
        }
      },
    );
    // close listener after 30 seconds, so the program doesn't run forever
    // await Future<void>.delayed(const Duration(seconds: 30));
    // await listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/images/CV_LOGO.png"),
          ),
        ],
      ),
    );
  }
}
