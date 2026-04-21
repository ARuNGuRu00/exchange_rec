import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Exchange_Rate/keyRole/adZone.dart';
import 'package:Exchange_Rate/keyRole/condata.dart';

class UpdatedGrid extends StatefulWidget {
  final List<List<String>> filterData;
  final List<List<String>> delSelect;
  final bool selection;
  final String hand;
  final void Function(List<String>) ontap;
  final void Function(List<String>) onLongPress;
  const UpdatedGrid({
    super.key,
    required this.filterData,
    required this.delSelect,
    required this.selection,
    required this.hand,
    required this.ontap,
    required this.onLongPress,
  });

  @override
  State<UpdatedGrid> createState() => _UpdatedGridState();
}

class _UpdatedGridState extends State<UpdatedGrid> {
  @override
  void didUpdateWidget(covariant UpdatedGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.filterData != widget.filterData) {
      editedlist.clear(); // clear old data
      editFilter(); // rebuild with new filtered data
    }
  }

  List<List<List<String>>> editedlist = [];
  @override
  void initState() {
    super.initState();
    editFilter();
  }

  void editFilter() {
    for (var i = 0; i < widget.filterData.length; i += 6) {
      editedlist.add(
        widget.filterData.sublist(
          i,
          i + 6 > widget.filterData.length ? widget.filterData.length : i + 6,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final providers = Provider.of<changeProvider>(context);
    return ListView.builder(
      itemCount: editedlist.length,
      itemBuilder: (context, lindex) {
        return Column(
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: editedlist[lindex].length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => widget.ontap(editedlist[lindex][index]),
                  onLongPress: () =>
                      widget.onLongPress(editedlist[lindex][index]),
                  child: Card(
                    color:
                        (providers.pCountry[0] ==
                                editedlist[lindex][index][0] ||
                            providers.sCountry[0] ==
                                editedlist[lindex][index][0])
                        ? Theme.of(context).colorScheme.tertiary
                        : null,
                    child: Column(
                      mainAxisAlignment: (widget.selection != true)
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentGeometry.topEnd,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3.0, right: 3),
                            child: (widget.selection == true)
                                ? Icon(
                                    widget.delSelect.contains(
                                          editedlist[lindex][index],
                                        )
                                        ? Icons.check_circle_sharp
                                        : Icons.circle_outlined,
                                    color:
                                        widget.delSelect.contains(
                                          editedlist[lindex][index],
                                        )
                                        ? const Color.fromARGB(
                                            211,
                                            213,
                                            213,
                                            213,
                                          )
                                        : const Color.fromARGB(
                                            212,
                                            158,
                                            158,
                                            158,
                                          ),
                                  )
                                : null,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assert/flags/${editedlist[lindex][index][0]}-compressed.png',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(editedlist[lindex][index][0]),
                        ),
                        Text(
                          editedlist[lindex][index][1],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            NtvAd(),
          ],
        );
      },
    );
  }
}
