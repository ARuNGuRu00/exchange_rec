import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Exchange_Rate/keyRole/adZone.dart';
import 'package:Exchange_Rate/keyRole/condata.dart';

class Loading extends StatefulWidget {
  final Future<void> Function() loadingFunction;
  final Widget destination;
  final Widget callfrom;
  const Loading({
    super.key,
    required this.loadingFunction,
    required this.destination,
    required this.callfrom,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isDone = false;
  bool internet = false;
  @override
  void initState() {
    super.initState();
    checkInt();
  }

  Future<void> checkInt() async {
    final check = await Provider.of<changeProvider>(
      context,
      listen: false,
    ).hasInternet();
    if (!mounted) return;
    if (check) {
      setState(() {
        internet = true;
      });
      waitfunctions();
    } else {
      setState(() => internet = false);
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.destination),
      );
    }
  }

  Future<void> waitfunctions() async {
    await widget.loadingFunction();

    setState(() {
      isDone = true;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: !internet
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assert/no-wifi.png", width: 150),
                  SizedBox(height: 20),
                  Text(
                    "Internet Connection",
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 234, 191, 188),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NtvAd(),
                  // CircularProgressIndicator(
                  //   backgroundColor: const Color.fromARGB(255, 215, 34, 34),
                  // ),
                  Column(
                    children: [
                      Image.asset("assert/loadings.gif", width: 100),
                      Text("   Downloading..."),
                    ],
                  ),
                  NtvAd(),
                ],
              ),
            ),
    );
  }
}
