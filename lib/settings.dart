import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Exchange_Rate/keyRole/adZone.dart';
import 'package:Exchange_Rate/keyRole/condata.dart';
import 'package:Exchange_Rate/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<List<String>> date = [];
  int lastHour = 0;
  bool great = true;
  Brightness themeValue = Brightness.dark;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
  }

  Future<bool> getter() async {
    prefs = await SharedPreferences.getInstance();
    var raw = prefs.getString("times");
    (prefs.getString("theme") == "Brightness.dark"
        ? themeValue = Brightness.dark
        : themeValue = Brightness.light);
    if (raw != null) {
      List raw2 = jsonDecode(raw);
      DateTime now = DateTime.now();
      date = raw2.map((e) => List<String>.from(e)).toList();
      var i = date[0][1].split(":");
      lastHour = int.parse(i[0]);
      if (now.hour > lastHour + 3) {
        great = false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenPro = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getter(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: Image.asset("assert/loadings.gif", width: 100)),
          );
        }
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: AppBar(title: Text('Updates')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                SizedBox(height: screenPro.width * 0.02),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lastly Updated at",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(date[0][0], style: TextStyle(fontSize: 15)),
                              Text(date[0][1], style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (great) SizedBox(width: screenPro.width * 0.1),
                              if (great)
                                CircleAvatar(
                                  radius: screenPro.width * 0.12,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      customBorder: CircleBorder(),
                                      onTap: () {},
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          size: screenPro.width * 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              CircleAvatar(
                                radius: (great)
                                    ? screenPro.width * 0.05
                                    : screenPro.width * 0.12,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    customBorder: CircleBorder(),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Loading(
                                            callfrom: Settings(),
                                            loadingFunction:
                                                Provider.of<changeProvider>(
                                                  context,
                                                ).databaseDownload,
                                            destination: Settings(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Icon(
                                        Icons.download,
                                        size: (great)
                                            ? screenPro.width * 0.05
                                            : screenPro.width * 0.1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          if (great)
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "On Latest Update",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "World update: ${date[0][2]}",
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(children: [Text("last updates")]),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: date.length + 1,

                    itemBuilder: (context, index) {
                      var autoReindex = (date.length >= 3)
                          ? (index == 2)
                                ? date.length
                                : (index < 2)
                                ? index
                                : index - 1
                          : index;
                      if (autoReindex == date.length) {
                        return NtvAd();
                      }
                      return Card(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,

                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(child: Icon(Icons.check)),
                              Text(date[autoReindex][0]),
                              Text(date[autoReindex][1]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: AdSite(),
        );
      },
    );
  }
}
