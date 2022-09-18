import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DateOfBirth extends StatefulWidget {
  Function callback;
  DateOfBirth({Key key, this.callback}) : super(key: key);

  @override
  _DateOfBirthState createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  Function callback;
  TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    callback = widget.callback;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: size.width * 0.7,
          child: InkWell(
            onTap: (() {
              onClickShowDate(context);
            }),
            child: TextField(
              controller: _textController,
              enabled: false,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            onClickShowDate(context);
          },
          child: Icon(Icons.date_range),
        )
      ],
    );
  }

  void onClickShowDate(BuildContext context) {
    DateTime nowTime = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1990, 1, 1),
        maxTime: DateTime(nowTime.year, nowTime.month, nowTime.day),
        theme: DatePickerTheme(
            headerColor: Colors.blue,
            backgroundColor: Colors.green,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {
      // print('change $date in time zone ' +
      //     date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      setState(() {
        _textController.text = date.toLocal().toString().split(" ")[0];
      });
      callback(date);
    },
        currentTime: _textController.text == ""
            ? DateTime(nowTime.year, nowTime.month, nowTime.day)
            : DateTime.parse(_textController.text),
        locale: LocaleType.en);
  }
}
