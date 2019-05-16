import 'package:flutter/material.dart';
import 'package:flutter_dms/widget/widget_box.dart';

class ControlPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ControlPageState();
  }
}

class _ControlPageState extends State<ControlPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "98寸显示器",
                  style: TextStyle(fontSize: 20),
                ),
                BoxWidget("off", Colors.blueAccent, Colors.white, 100, 40),
                BoxWidget("on", Colors.blueAccent, Colors.white, 100, 40),
                BoxWidget("HDMI1", Colors.blueAccent, Colors.white, 100, 40),
                BoxWidget("HDMI12", Colors.blueAccent, Colors.white, 100, 40),
              ],
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "98寸显示器",
                    style: TextStyle(fontSize: 20),
                  ),
                  margin: EdgeInsets.only(right: 40,left:50),
                ),
                Container(
                  child: BoxWidget(
                      "off", Colors.blueAccent, Colors.white, 100, 40),
                ),
                Container(
                  child:
                      BoxWidget("on", Colors.blueAccent, Colors.white, 100, 40),
                  margin: EdgeInsets.only(left:40),
                ),
              ],
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "98寸显示器",
                    style: TextStyle(fontSize: 20),
                  ),
                  margin: EdgeInsets.only(right: 40,left:50),
                ),
                Container(
                  child: BoxWidget(
                      "off", Colors.blueAccent, Colors.white, 100, 40),
                ),
                Container(
                  child:
                  BoxWidget("on", Colors.blueAccent, Colors.white, 100, 40),
                  margin: EdgeInsets.only(left:40),
                ),
                Container(
                  child:
                  BoxWidget("HDMI1", Colors.blueAccent, Colors.white, 100, 40),
                  margin: EdgeInsets.only(left:40),
                ),

              ],
            ),
          ],
        ),
        margin: EdgeInsets.only(top: 150));
  }
}
