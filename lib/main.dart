import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Exchange_Rate/compount/cButton.dart';
import 'package:Exchange_Rate/flash_screen.dart';
import 'package:Exchange_Rate/keyRole/adZone.dart';
import 'package:Exchange_Rate/keyRole/condata.dart';
import 'package:Exchange_Rate/currency_bank.dart';
import 'package:provider/provider.dart';
import 'package:Exchange_Rate/selPanel.dart';
import 'package:Exchange_Rate/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  final provider = changeProvider();
  await provider.initPrefernce();

  runApp(ChangeNotifierProvider.value(value: provider, child: TheApp()));
}

class TheApp extends StatefulWidget {
  const TheApp({super.key});

  @override
  State<TheApp> createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  bool isDataAva = false;

  Future<bool> checkPref() async {
    final prefs = await SharedPreferences.getInstance();
    final seletedRate = prefs.getString('SelectedRates');
    final dataset = prefs.getString('dataset');
    final times = prefs.getString('times');
    if (seletedRate != null && dataset != null && times != null) {
      isDataAva = true;
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkPref(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'Roboto',
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 16, 16, 16),
              primary: const Color.fromARGB(255, 245, 245, 245),
              onPrimary: const Color.fromARGB(255, 20, 20, 20),
              onSecondaryContainer: const Color.fromARGB(255, 231, 231, 231),
              secondary: const Color.fromARGB(255, 255, 255, 255),
              onSecondary: const Color.fromARGB(255, 234, 234, 234),
              tertiary: const Color.fromARGB(255, 241, 105, 105),
              onTertiary: const Color.fromARGB(255, 236, 100, 100),
              brightness: Brightness.light,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color.fromARGB(255, 19, 19, 19)),
              bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color.fromARGB(255, 245, 245, 245),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: 'Roboto',
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color.fromARGB(255, 15, 15, 15),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 220, 220, 220),
              brightness: Brightness.dark,
              primary: const Color.fromARGB(255, 0, 0, 0),
              onPrimary: const Color.fromARGB(255, 235, 235, 235),
              secondary: const Color.fromARGB(255, 21, 21, 21),
              onSecondary: const Color.fromARGB(255, 41, 41, 41),
              onSecondaryContainer: const Color.fromARGB(255, 31, 31, 31),
              tertiary: const Color.fromARGB(176, 248, 70, 70),
              onTertiary: const Color.fromARGB(255, 248, 70, 70),
            ),

            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color.fromARGB(255, 234, 234, 234)),
              bodyMedium: TextStyle(color: Color.fromARGB(255, 255, 222, 222)),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: ThemeMode.system,
          home: isDataAva ? FlashScreen() : Selpanel(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class ThePageState extends StatefulWidget {
  const ThePageState({super.key});

  @override
  State<ThePageState> createState() => _ThePageStateState();
}

class _ThePageStateState extends State<ThePageState> {
  final TextEditingController primary = TextEditingController();
  final TextEditingController secondary = TextEditingController();
  final double fSize = 18;
  final buts = [
    "clear",
    "flip",
    "back",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "00",
    "0",
    ".",
  ];
  late TextEditingController activeController;
  late TextEditingController nonActiveController;
  List<String> date = [];

  @override
  void initState() {
    super.initState();
    activeController = primary;
    nonActiveController = secondary;
    // Future.microtask(() {
    //   activeController = primary;
    //   nonActiveController = secondary;
    //   Provider.of<changeProvider>(context, listen: false).initPrefernce();
    // });
  }

  String activeCurrencyValue = " ";

  @override
  Widget build(BuildContext context) {
    final countryData = Provider.of<changeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    final connection = countryData.prefs!.getString("dataset");
    var raw = countryData.prefs!.getString("times");
    List raw2 = jsonDecode(raw!);
    final formatedRaw = raw2.map((e) => List<String>.from(e)).toList()[0];
    setState(() {
      date = formatedRaw;
    });
    final dataExtract = jsonDecode(connection!);
    void exchangeValue(String first, String second) {
      var aValue = activeController.text;
      if (aValue.length != 1) {
        aValue = aValue.split(" ")[1];
      }
      var value =
          ((dataExtract[first.toLowerCase()][second.toLowerCase()]) *
          double.parse(aValue));
      setState(() {
        activeCurrencyValue = NumberFormat.currency(
          symbol: currencySymbols[second],
          locale: currencyLocale[second],
        ).format(value);
      });

      try {
        aValue = '${currencySymbols[first]} $aValue';
        if (value < 1) {
          value = '${currencySymbols[second]} $value';
        } else {
          value =
              '${currencySymbols[second]} ${value.toStringAsFixed(3)}'; //{currencySymbols[second]}
        }
      } catch (e) {
        if (value < 1) {
          value = value.toString();
        } else {
          value = value.toStringAsFixed(3);
        }
      }
      activeController.text = aValue;
      nonActiveController.text = value;
    }

    void inputManipulate(String value) {
      if (value == "clear") {
        primary.clear();
        secondary.clear();
        setState(() {
          activeCurrencyValue = "";
        });
      } else if (value == "back") {
        if (activeController.text.isNotEmpty &&
            activeController.text.split(" ")[1].length > 1) {
          activeController.text = activeController.text.substring(
            0,
            activeController.text.length - 1,
          );
          (activeController == primary)
              ? exchangeValue(countryData.pCountry[0], countryData.sCountry[0])
              : exchangeValue(countryData.sCountry[0], countryData.pCountry[0]);
        } else {
          activeController.clear();
          nonActiveController.clear();
          setState(() {
            activeCurrencyValue = "";
          });
        }
      } else if (value == 'flip') {
        final _fData = List<String>.from(countryData.pCountry);
        countryData.pcChange(countryData.sCountry);
        countryData.scChange(_fData);
        var temp = secondary.text;
        secondary.text = primary.text;
        primary.text = temp;
        setState(() {
          activeCurrencyValue = temp;
        });
      } else {
        activeController.text += value;
        (activeController == primary)
            ? exchangeValue(countryData.pCountry[0], countryData.sCountry[0])
            : exchangeValue(countryData.sCountry[0], countryData.pCountry[0]);
      }
    }

    // return FutureBuilder(
    //   future: initialisation(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Scaffold(
    //         body: Center(child: Image.asset("assert/loadings.gif", width: 100)),
    //       );
    //     }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assert/rect77.png', width: 32),
            SizedBox(width: 10),
            Text("Exchange Rate", style: TextStyle(fontFamily: "Sansation")),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
                child: Center(child: Icon(Icons.downloading_outlined)),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text("Update of ${date[0]}    ")],
          ),
          SizedBox(height: height * 0.005),
          //pCountry
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrencyBank(whichHand: "left"),
                    ),
                  );
                },
                child: Card(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              countryData.pCountry[1],
                              style: TextStyle(fontSize: fSize),
                            ),
                            Text(
                              countryData.pCountry[0],
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assert/flags/${countryData.pCountry[0]}-compressed.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.008),
          //primary
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.onSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(100),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: TextFormField(
                  cursorColor: Theme.of(context).colorScheme.onTertiary,
                  autofocus: true,
                  readOnly: true,
                  showCursor: true,
                  onTap: () {
                    activeController = primary;
                    nonActiveController = secondary;
                  },
                  textAlign: TextAlign.center,
                  controller: primary,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 48),
                    hintText:
                        '${countryData.pCountry[0]} ${countryData.pCountry[1]}',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.014),
          //secondary
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.onSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(100),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: TextFormField(
                  cursorColor: Theme.of(context).colorScheme.onTertiary,
                  readOnly: true,
                  showCursor: true,
                  onTap: () {
                    activeController = secondary;
                    nonActiveController = primary;
                  },
                  textAlign: TextAlign.center,
                  controller: secondary,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(right: 48),
                    hintText:
                        "${countryData.sCountry[0]} ${countryData.sCountry[1]}",
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.009),
          //sCountry
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrencyBank(whichHand: "right"),
                    ),
                  );
                },
                child: Card(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assert/flags/${countryData.sCountry[0]}-compressed.png',
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              countryData.sCountry[1],
                              style: TextStyle(fontSize: fSize),
                            ),
                            Text(
                              countryData.sCountry[0],
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: height * 0.001),

          //dial
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        color: Theme.of(context).colorScheme.onSecondary,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            textAlign: TextAlign.center,
                            activeCurrencyValue,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: 15,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Cbutton(
                          butValue: buts[index],
                          onTap: inputManipulate,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdSite(),
    );
    //   },
    // );
  }
}
