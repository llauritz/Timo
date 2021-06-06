import 'package:Timo/Services/CorrectionDB.dart';
import 'package:Timo/Services/Theme.dart';
import 'package:Timo/hiveClasses/Correction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../Services/Data.dart';

class BreakCorrection extends StatefulWidget {
  const BreakCorrection({Key? key}) : super(key: key);

  @override
  _BreakCorrectionState createState() => _BreakCorrectionState();
}

class _BreakCorrectionState extends State<BreakCorrection> {
  bool active = true;
  Box<Correction> correctionBox = Hive.box("corrections");
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    active = getIt<Data>().pausenKorrektur;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          shadowColor: Colors.black26,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedOpacity(
                              opacity: active ? 1 : 0.2,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              child: Text(
                                "Pausenkorrektur",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                            Positioned(
                                right: -20,
                                top: -5,
                                child: Icon(
                                  Icons.help_rounded,
                                  size: 17,
                                  color: Colors.black.withAlpha(150),
                                ))
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: -13,
                        child: Switch(
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            activeColor: neon,
                            activeTrackColor: neon.withAlpha(100),
                            value: getIt<Data>().pausenKorrektur,
                            onChanged: (newValue) {
                              setState(() {
                                getIt<Data>().updatePausenKorrektur(newValue);
                                getIt<Data>().pausenKorrektur = newValue;
                              });
                            }),
                      ),
                    ],
                  ),
                  AnimatedList(
                      shrinkWrap: true,
                      key: _listKey,
                      initialItemCount: correctionBox.length,
                      itemBuilder: (BuildContext context, int index,
                          Animation<double> animation) {
                        return Text(correctionBox.getAt(index)!.ab.toString() +
                            ", " +
                            correctionBox.getAt(index)!.um.toString());
                      }),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: correctionBox.length,
                      itemBuilder: (_, index) {
                        return Text(correctionBox.getAt(index)!.ab.toString() +
                            ", " +
                            correctionBox.getAt(index)!.um.toString());
                      }),
                  Text("ab 6 Stunden 30 Minuten"),
                  IconButton(
                      onPressed: () async {
                        setState(() async {
                          await getIt<CorrectionDB>().resetBox();
                          //_listKey.currentState!.insertItem(0);
                        });
                      },
                      icon: Icon(Icons.ac_unit)),
                  IconButton(
                      onPressed: () async {
                        Box box = Hive.box<Correction>("corrections");
                        await box.add(Correction(
                            ab: box.getAt(box.length - 1)!.ab +
                                Duration.millisecondsPerHour,
                            um: box.getAt(box.length - 1)!.um +
                                10 * Duration.millisecondsPerMinute));
                        setState(() {
                          //_listKey.currentState!.insertItem(0);
                        });
                      },
                      icon: Icon(Icons.help)),
                  Text("Regel hinzufügen")
                ],
              ),
            ),
          )),
    );
  }
}