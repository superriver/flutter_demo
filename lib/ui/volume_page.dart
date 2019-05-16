import 'package:flutter/material.dart';
import 'package:flutter_dms/widget/widget_box.dart';

class VolumePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VolumePageState();
  }
}

class _VolumePageState extends State<VolumePage>
    with SingleTickerProviderStateMixin {
  int volume = 0;
  final sum = 100;
  dynamic progressValue = 0.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  child: Text(
                    "天花麦克风",
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    BoxWidget('—', Colors.white, Colors.black, 50, 40),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10,bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Text('总音量 $volume/$sum'),
                          SizedBox(
                            width: 300.0,
                            height: 5.0,
                            child: LinearProgressIndicator(
                              value: progressValue,
                              valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.red),
                              backgroundColor: Color(0xff00ff00),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BoxWidget('+', Colors.white, Colors.black, 50, 40),
                  ],
                ),
                flex: 3,
              ),
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.volume_up), onPressed: onPressAdd),
                flex: 1,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  child: Text(
                    "桌面话筒",
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    BoxWidget('—', Colors.white, Colors.black, 50, 40),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10,bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Text('总音量 $volume/$sum'),
                          SizedBox(
                            width: 300.0,
                            height: 5.0,
                            child: LinearProgressIndicator(
                              value: progressValue,
                              valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.red),
                              backgroundColor: Color(0xff00ff00),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BoxWidget('+', Colors.white, Colors.black, 50, 40),
                  ],
                ),
                flex: 3,
              ),
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.volume_up), onPressed: onPressAdd),
                flex: 1,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  child: Text(
                    "电话",
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    BoxWidget('—', Colors.white, Colors.black, 50, 40),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10,bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Text('总音量 $volume/$sum'),
                          SizedBox(
                            width: 300.0,
                            height: 5.0,
                            child: LinearProgressIndicator(
                              value: progressValue,
                              valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.red),
                              backgroundColor: Color(0xff00ff00),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BoxWidget('+', Colors.white, Colors.black, 50, 40),
                  ],
                ),
                flex: 3,
              ),
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.volume_up), onPressed: onPressAdd),
                flex: 1,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  child: Text(
                    "视频会议",
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    BoxWidget('—', Colors.white, Colors.black, 50, 40),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10,bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Text('总音量 $volume/$sum'),
                          SizedBox(
                            width: 300.0,
                            height: 5.0,
                            child: LinearProgressIndicator(
                              value: progressValue,
                              valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.red),
                              backgroundColor: Color(0xff00ff00),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BoxWidget('+', Colors.white, Colors.black, 50, 40),
                  ],
                ),
                flex: 3,
              ),
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.volume_up), onPressed: onPressAdd),
                flex: 1,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  child: Text(
                    "总音量",
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    BoxWidget('—', Colors.white, Colors.black, 50, 40),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10,bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Text('总音量 $volume/$sum'),
                          SizedBox(
                            width: 300.0,
                            height: 5.0,
                            child: LinearProgressIndicator(
                              value: progressValue,
                              valueColor:
                                  new AlwaysStoppedAnimation<Color>(Colors.red),
                              backgroundColor: Color(0xff00ff00),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BoxWidget('+', Colors.white, Colors.black, 50, 40),
                  ],
                ),
                flex: 3,
              ),
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.volume_up), onPressed: onPressAdd),
                flex: 1,
              ),
            ],
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 120),
    );
  }

  void onPressAdd() {
    if (volume < 100) {
      setState(() {
        volume = volume + 10;
        progressValue = volume / sum;
      });
    }
  }

  void onPressDecrease() {
    if (volume > 0) {
      setState(() {
        volume = volume - 10;
        progressValue = volume / sum;
      });
    }
  }
}
