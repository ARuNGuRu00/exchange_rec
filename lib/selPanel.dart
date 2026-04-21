import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Exchange_Rate/keyRole/condata.dart';
import 'package:Exchange_Rate/loading.dart';
import 'package:Exchange_Rate/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Selpanel extends StatefulWidget {
  const Selpanel({super.key});

  @override
  State<Selpanel> createState() => _SelpanelState();
}

class _SelpanelState extends State<Selpanel> {
  final TextEditingController con2 = TextEditingController();

  List<List<String>> selectedRate = [];
  List<List<String>> filtervalue = [];
  void search(String value) {
    final result = cData.where((i) {
      final code = i[0].toLowerCase();
      final country = i[1].toLowerCase();
      if (code.contains(value.toLowerCase()) ||
          country.contains(value.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();
    if (value == "") {
      for (var i in selectedRate) {
        result.remove(i);
      }
    }
    if (value == "" && selectedRate.isNotEmpty) {
      result.removeWhere(
        (item) => selectedRate.any((item2) => item[0] == item2[0]),
      );
      selectedRate.forEach((item) {
        result.insert(0, item);
      });
    }
    setState(() {
      filtervalue = result;
    });
  }

  @override
  void initState() {
    super.initState();
    filtervalue = cData;
  }

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 30, top: 100, bottom: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentGeometry.topRight,
                  end: AlignmentGeometry.bottomCenter,
                  colors: [Colors.red, Colors.transparent, Colors.transparent],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assert/rect77.png", width: 65),
                  const SizedBox(height: 5),
                  const Text(
                    "Exchange Rate",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(188, 32, 37, 100),
                    ),
                  ),
                  const Text(
                    "See your change offline",
                    style: TextStyle(
                      fontSize: 18,
                      // color: Color.fromARGB(255, 213, 213, 213),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(onChanged: search, controller: con2),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return GestureDetector(
                onTap: () {
                  selectedRate.contains(filtervalue[index])
                      ? setState(() {
                          selectedRate.remove(filtervalue[index]);
                        })
                      : setState(() {
                          selectedRate.add(filtervalue[index]);
                        });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: selectedRate.contains(filtervalue[index])
                        ? const Color.fromRGBO(188, 32, 37, 100)
                        : null,
                    // : const Color.fromARGB(255, 26, 26, 26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentGeometry.topEnd,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0, right: 3),
                          child: Icon(
                            selectedRate.contains(filtervalue[index])
                                ? Icons.check_circle_sharp
                                : Icons.circle_outlined,
                            color: selectedRate.contains(filtervalue[index])
                                ? const Color.fromARGB(211, 213, 213, 213)
                                : const Color.fromARGB(212, 158, 158, 158),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(
                          'assert/flags/${filtervalue[index][0]}-compressed.png',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(filtervalue[index][0]),
                      SizedBox(height: 0),
                      Flexible(
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          filtervalue[index][1],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: filtervalue.length),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.95,
            ),
          ),
        ],
      ),
      bottomNavigationBar: (2 - selectedRate.length > 0)
          ? SizedBox(
              height: 30,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.vertical(
                    bottom: Radius.circular(0),
                  ),
                ),
                color: const Color.fromARGB(255, 175, 28, 28),
                child: Center(
                  child: Text(
                    "Select ${2 - selectedRate.length} more",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButton: (2 - selectedRate.length <= 0)
          ? FloatingActionButton.extended(
              elevation: 0,
              onPressed: selectedRate.isNotEmpty && selectedRate.length >= 2
                  ? () async {
                      final prefs = await SharedPreferences.getInstance();
                      String jsonString = jsonEncode(selectedRate);
                      await prefs.setString('SelectedRates', jsonString);
                      final provider = Provider.of<changeProvider>(
                        context,
                        listen: false,
                      );
                      setState(() {
                        isloading = true;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Loading(
                            callfrom: Selpanel(),
                            loadingFunction: provider.databaseDownload,
                            destination: const TheApp(),
                          ),
                        ),
                      );
                    }
                  : null,
              label: isloading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      "Save checked",
                    ), //style: TextStyle(color: Colors.white)
              icon: isloading ? null : Icon(Icons.done),
              backgroundColor: const Color.fromRGBO(188, 32, 37, 100),
            )
          : null,
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Function(String) onChanged;
  final TextEditingController controller;

  _SearchBarDelegate({required this.onChanged, required this.controller});

  @override
  double get minExtent => 100;

  @override
  double get maxExtent => 100;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(height: 25),
          TextFormField(
            onChanged: (value) {
              onChanged(value);
            },
            controller: controller,
            decoration: InputDecoration(
              hintText: "Search Currency",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text != ""
                  ? IconButton(
                      onPressed: () {
                        controller.clear();
                        onChanged("");
                      },
                      icon: Icon(Icons.clear),
                    )
                  : null,
              filled: true,
              // fillColor: const Color.fromARGB(255, 32, 31, 31),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
