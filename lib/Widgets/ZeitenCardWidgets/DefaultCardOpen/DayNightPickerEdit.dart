import 'package:day_night_time_picker/lib/daynight_banner.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:work_in_progress/Services/Theme.dart';
import 'package:work_in_progress/Widgets/TimerTextWidget.dart';

import '../../../Services/HiveDB.dart';
import '../../../Services/Theme.dart';

final getIt = GetIt.instance;

class DayNightDialogEdited extends StatefulWidget {
  const DayNightDialogEdited(
      {Key key,
      @required this.selectedMilli,
      @required this.previousMilli,
      @required this.followingMilli,
      @required this.index,
      @required this.listindex,
      @required this.isStartTime})
      : super(key: key);

  final int selectedMilli;
  final int previousMilli;
  final int followingMilli;
  final int index;
  final int listindex;
  final bool isStartTime;

  @override
  _DayNightDialogEditedState createState() =>
      _DayNightDialogEditedState(editedMilli: selectedMilli);
}

class _DayNightDialogEditedState extends State<DayNightDialogEdited> {
  _DayNightDialogEditedState({this.editedMilli});

  int editedMilli;

  @override
  Widget build(BuildContext context) {
    print("DayNightDialog - edited: " +
        DateTime.fromMillisecondsSinceEpoch(editedMilli).toString());
    DateTime editedTime = DateTime.fromMillisecondsSinceEpoch(editedMilli);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DayNightBanner(
              hour: editedTime.hour,
              displace: mapRange(editedMilli * 1.0, widget.previousMilli * 1.0,
                  widget.followingMilli * 1.0),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                            icon: Icon(Icons.remove_circle_rounded),
                            color: grayDark,
                            onPressed: () {
                              setState(() {
                                editedMilli = editedMilli - 60000;
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child:
                            Text("${editedTime.hour}:", style: dayNightNumbers),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: DoubleDigit(
                            i: editedTime.minute,
                            style: TextStyle(
                              fontSize: 60,
                              color: grayDark,
                              fontFamily: "Roboto-Mono",
                              letterSpacing: 0,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                            icon: Icon(Icons.add_circle_rounded),
                            color: grayDark,
                            onPressed: () {
                              setState(() {
                                editedMilli = editedMilli + 60000;
                              });
                            }),
                      ),
                    ],
                  ),
                  Slider(
                    value: editedMilli * 1.0,
                    onChanged: (value) {
                      setState(() {
                        editedMilli = value.toInt();
                      });
                    },
                    min: widget.previousMilli * 1.0,
                    max: widget.followingMilli * 1.0,
                    //activeColor: color,
                    //inactiveColor: color.withAlpha(55),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              getIt<HiveDB>()
                                  .listChangesStream
                                  .sink
                                  .add(getIt<HiveDB>().changeNumber++);
                            },
                            child: Text(
                              "Abbrechen",
                              style: TextStyle(fontSize: 16),
                            )),
                        FlatButton(
                          onPressed: () {
                            getIt<HiveDB>().updateStartEndZeit(widget.listindex,
                                widget.index, widget.isStartTime, editedMilli);
                            Navigator.pop(context);
                            getIt<HiveDB>()
                                .listChangesStream
                                .sink
                                .add(getIt<HiveDB>().changeNumber++);
                          },
                          child: Text(
                            "Speichern",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
