import 'dart:convert';
import 'package:Exchange_Rate/keyRole/adZone.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Exchange_Rate/compount/offline_grid.dart';
import 'package:Exchange_Rate/compount/updated_grid.dart';
import 'package:Exchange_Rate/keyRole/condata.dart';
import 'package:Exchange_Rate/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyBank extends StatefulWidget {
  final String whichHand;
  const CurrencyBank({super.key, required this.whichHand});

  @override
  State<CurrencyBank> createState() => _CurrencybankState();
}

class _CurrencybankState extends State<CurrencyBank> {
  final double fSize = 19;
  List<List<String>> filteredData = [];
  List<List<String>> selectedRate = [];
  List times = [];
  @override
  void initState() {
    super.initState();
  }

  Future<bool> ExtractData() async {
    final pref = await SharedPreferences.getInstance();
    final result = await pref.getString("SelectedRates")!;
    final raw = await pref.getString("times");
    List decode = jsonDecode(result);
    // setState(() {
    selectedRate = decode.map((e) => List<String>.from(e)).toList();
    times = jsonDecode(raw!).map((e) => List<String>.from(e)).toList()[0];
    // });
    return true;
  }

  void search(String value) {
    final result = cData.where((i) {
      final code = i[0].toLowerCase();
      final name = i[1].toLowerCase();
      if (code.contains(value.toLowerCase()) ||
          name.contains(value.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();
    setState(() {
      filteredData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ExtractData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: Image.asset("assert/loadings.gif", width: 150)),
          );
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              title: Text("Currency bank"),
              bottom: TabBar(
                indicatorColor: Theme.of(context).colorScheme.onTertiary,
                tabs: [
                  Tab(
                    child: Text(
                      "Updated",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Include",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                UpdatedData(
                  selectedRate: selectedRate,
                  times: times,
                  hand: widget.whichHand,
                ),
                Offline(selectedRate: selectedRate, hand: widget.whichHand),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UpdatedData extends StatefulWidget {
  final List<List<String>> selectedRate;
  final List times;
  final String hand;
  const UpdatedData({
    super.key,
    required this.selectedRate,
    required this.times,
    required this.hand,
  });

  @override
  State<UpdatedData> createState() => _UpdatedDataState();
}

class _UpdatedDataState extends State<UpdatedData> {
  late List<List<String>> filterData;
  late TextEditingController upcontrol;
  bool selection = false;
  List<List<String>> delSelect = [];

  @override
  void initState() {
    super.initState();
    filterData = widget.selectedRate;
    upcontrol = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant UpdatedData oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ Only update if data actually changed
    if (oldWidget.selectedRate != widget.selectedRate) {
      if (upcontrol.text.isEmpty) {
        setState(() {
          filterData = widget.selectedRate;
        });
      }
    }
  }

  void search(String value) {
    final result = widget.selectedRate.where((i) {
      final code = i[0].toLowerCase();
      final name = i[1].toLowerCase();
      if (code.contains(value.toLowerCase()) ||
          name.contains(value.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();
    setState(() {
      filterData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final providers = Provider.of<changeProvider>(context);
    void ontap(List<String> getFilterData) {
      if (selection != true) {
        if (widget.hand == "left") {
          providers.pcChange(getFilterData);
          Navigator.pop(context);
        } else {
          providers.scChange(getFilterData);
          Navigator.pop(context);
        }
      } else {
        if (delSelect.contains(getFilterData)) {
          setState(() {
            delSelect.remove(getFilterData);
          });
        } else {
          setState(() {
            delSelect.add(getFilterData);
          });
        }
      }
    }

    void onLongPress(List<String> getFilterData) {
      setState(() {
        selection = true;
        delSelect.add(getFilterData);
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 12),
            TextFormField(
              cursorColor: Theme.of(context).colorScheme.onTertiary,
              controller: upcontrol,
              onChanged: (value) {
                search(value);
              },
              decoration: InputDecoration(
                suffixIcon: (upcontrol.text.isNotEmpty)
                    ? IconButton(
                        onPressed: () {
                          upcontrol.clear();
                          search("");
                        },
                        icon: Icon(Icons.clear),
                      )
                    : null,
                prefixIcon: Icon(Icons.search),
                hintText: "Search currency",
                filled: true,
                // fillColor: const Color.fromARGB(255, 41, 41, 41),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Theme.of(context).colorScheme.onSecondary,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Lastly Updated", style: TextStyle(fontSize: 19)),
                        Text(
                          '${widget.times[0]} / ${widget.times[1].toString().substring(0, 5)}',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 36,
                      // backgroundColor: const Color.fromARGB(255, 42, 42, 42),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Loading(
                                  callfrom: CurrencyBank(
                                    whichHand: widget.hand,
                                  ),
                                  loadingFunction: providers.databaseDownload,
                                  destination: CurrencyBank(
                                    whichHand: widget.hand,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Center(
                            child: Icon(
                              Icons.download,
                              size: 32,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                // shape: BorderDirectional(
                //   bottom: BorderSide(
                //     color: const Color.fromARGB(83, 255, 255, 255),
                //   ),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Updated Currency"),
                    ),
                    if (selection == true)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selection = false;
                            delSelect.clear();
                          });
                        },
                        icon: Icon(Icons.close),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: UpdatedGrid(
                filterData: filterData,
                delSelect: delSelect,
                selection: selection,
                hand: widget.hand,
                ontap: ontap,
                onLongPress: onLongPress,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: (selection == true)
          ? FloatingActionButton.extended(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("delSelect", jsonEncode(delSelect));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loading(
                      callfrom: CurrencyBank(whichHand: widget.hand),
                      loadingFunction: providers.delSelect,
                      destination: CurrencyBank(whichHand: widget.hand),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.delete),
              isExtended: false,
              label: Text("delete"),
            )
          : null,
    );
  }
}

class Offline extends StatefulWidget {
  final List<List<String>> selectedRate;
  final String hand;
  const Offline({super.key, required this.selectedRate, required this.hand});

  @override
  State<Offline> createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  late List<List<String>> filterData;
  late List<List<String>> modif;
  final List<List<String>> offSelect = [];
  late TextEditingController offControll;

  @override
  void initState() {
    super.initState();
    modif = cData
        .where(
          (item1) => !widget.selectedRate.any((item2) => item1[0] == item2[0]),
        )
        .toList();
    filterData = modif;
    offControll = TextEditingController();
  }

  void search(String value) {
    final result = modif.where((i) {
      final code = i[0].toLowerCase();
      final name = i[1].toLowerCase();
      if (code.contains(value.toLowerCase()) ||
          name.contains(value.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();
    if (value == "" && offSelect.isNotEmpty) {
      result.removeWhere(
        (item) => offSelect.any((item2) => item[0] == item2[0]),
      );
      offSelect.forEach((item) {
        result.insert(0, item);
      });
    }
    setState(() {
      filterData = result;
    });
  }

  void offlineSelect(List<String> filterIndex) {
    offSelect.contains(filterIndex)
        ? setState(() {
            offSelect.remove(filterIndex);
            // search("");
            // if (offControll.text.isNotEmpty) {
            //   offControll.text = "";
            // }
          })
        : setState(() {
            offSelect.add(filterIndex);
            // search("");
            // if (offControll.text.isNotEmpty) {
            //   offControll.text = "";
            // }
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      bottomNavigationBar: AdSite(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 12),
            TextFormField(
              cursorColor: Theme.of(context).colorScheme.onTertiary,
              controller: offControll,
              onChanged: (value) {
                search(value);
                setState(() {});
              },
              decoration: InputDecoration(
                suffixIcon: (offControll.text.isNotEmpty)
                    ? IconButton(
                        onPressed: () {
                          offControll.clear();
                          search("");
                        },
                        icon: Icon(Icons.clear),
                      )
                    : null,
                prefixIcon: Icon(Icons.search),
                hintText: "Search currency",
                filled: true,
                // fillColor: const Color.fromARGB(255, 41, 41, 41),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: OfflineGrid(
                filterData: filterData,
                offSelect: offSelect,
                offvoid: offlineSelect,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: (offSelect.length > 0)
          ? FloatingActionButton.extended(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("addSet", jsonEncode(offSelect));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loading(
                      callfrom: CurrencyBank(whichHand: widget.hand),
                      loadingFunction: Provider.of<changeProvider>(
                        context,
                      ).addSelected,
                      destination: CurrencyBank(whichHand: widget.hand),
                    ),
                  ),
                );
              },
              label: Text("Add Selected"),
              icon: Icon(Icons.add),
              backgroundColor: Theme.of(context).colorScheme.onTertiary,
            )
          : null,
    );
  }
}
