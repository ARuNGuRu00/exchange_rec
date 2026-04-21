import 'package:flutter/material.dart';
import 'package:Exchange_Rate/keyRole/adZone.dart';

class OfflineGrid extends StatefulWidget {
  final List<List<String>> filterData;
  final List<List<String>> offSelect;
  final Function(List<String>) offvoid;
  const OfflineGrid({
    super.key,
    required this.filterData,
    required this.offSelect,
    required this.offvoid,
  });

  @override
  State<OfflineGrid> createState() => _OfflineGridState();
}

class _OfflineGridState extends State<OfflineGrid> {
  List<List<List<String>>> editedList = [];
  @override
  void initState() {
    super.initState();
    editFun();
  }

  @override
  void didUpdateWidget(covariant OfflineGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.filterData != widget.filterData) {
      editedList.clear(); // clear old data
      editFun(); // rebuild with new filtered data
    }
  }

  void editFun() {
    for (var i = 0; i < widget.filterData.length; i += 6) {
      editedList.add(
        widget.filterData.sublist(
          i,
          i + 6 > widget.filterData.length ? widget.filterData.length : i + 6,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: editedList.length,
      itemBuilder: (context, lindex) {
        return Column(
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: editedList[lindex].length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                crossAxisCount: 3,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => widget.offvoid(editedList[lindex][index]),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color:
                          widget.offSelect.contains(editedList[lindex][index])
                          ? Theme.of(context).colorScheme.tertiary
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
                              widget.offSelect.contains(
                                    editedList[lindex][index],
                                  )
                                  ? Icons.check_circle_sharp
                                  : Icons.circle_outlined,
                              color:
                                  widget.offSelect.contains(
                                    editedList[lindex][index],
                                  )
                                  ? const Color.fromARGB(211, 213, 213, 213)
                                  : const Color.fromARGB(212, 158, 158, 158),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assert/flags/${editedList[lindex][index][0]}-compressed.png',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(editedList[lindex][index][0]),
                        SizedBox(height: 0),
                        Flexible(
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            editedList[lindex][index][1],
                            textAlign: TextAlign.center,
                          ),
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
