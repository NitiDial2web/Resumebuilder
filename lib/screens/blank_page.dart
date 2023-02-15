import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:remuse_builder/screens/splash_screen.dart';

class BlankPage extends StatefulWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  void initState() {
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SplashScreenView()));
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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey,
        child: const Center(
          child: Text('Please connect to Internet',
            style: TextStyle(color: Colors.black,fontSize: 20),),
        ),
      ),
    );
  }
}
