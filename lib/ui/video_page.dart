import 'package:flutter/material.dart';
import 'package:flutter_dms/widget/widget_box.dart';
import 'package:flutter_dms/api/api_dms.dart';
import 'dart:async';
import 'package:flutter_dms/common/model/data.dart';
import 'package:flutter_dms/common/model/preset.dart';

class VideoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VideoPageState();
  }
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin {
  int volume = 0;
  final sum = 100;
  dynamic progressValue = 0.0;

  int sumTBValue = 0;
  int sumLFValue = 0;
  List<String> choices = [];

  Presets selectedVal;
  TextEditingController _editingController;
  FocusNode _contentFocus;

  String _newContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((v) =>
        //print(v.presetList.length)
        buildAndGetDropDownMenuItems(v.presetList));
    _editingController = TextEditingController();
    _contentFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      child: GridView.count(
                        padding: EdgeInsets.all(4.0),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        children: buildGridTileList(),
                      ),
                      width: 200,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        BoxWidget('挂断', Colors.white, Colors.black, 60, 40),
                        BoxWidget('呼叫', Colors.white, Colors.black, 60, 40),
                        MaterialButton(
                          child: BoxWidget(
                              '预设', Colors.white, Colors.black, 60, 40),
                          onPressed: () {
                            //saveState();
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('预设名'),
                                    content: SizedBox(
                                      child: TextField(
                                        controller: _editingController,
                                        autofocus: false,
                                        autocorrect: false,
                                        focusNode: _contentFocus,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(20),
                                            hintText: '请输入预设名'),
                                        onChanged: (val) {
                                          _newContent = val;
                                          // _editingController.text = val;
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('取消')),
                                      FlatButton(
                                          onPressed: () {
                                            if (_editingController
                                                .text.isEmpty) {
//                                              Scaffold.of(context).showSnackBar(
//                                                  SnackBar(
//                                                      content:
//                                                          Text('预设名不能为空')));
                                              return;
                                            }
                                            saveState(_newContent);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('确定'))
                                    ],
                                  );
                                });
                          },
                        ),

//                        PopupMenuButton(itemBuilder: (BuildContext context) {
//                          return choices.skip(2).map((String choice) {
//                            return PopupMenuItem(
//                              child: Text(choice),
//                              value: choice,
//                            );
//                          }).toList();
//                        })
                        DropdownButton(
                          items: items,
                          onChanged: (val) {
                            print(val);
//                            setState(() {
//                              selectedVal = val;
//                            });
                            DMSApi.executePreset(val.toString());
                          },
                          hint: new Text('预设列表'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      "视频会议音量",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      margin: EdgeInsets.all(40.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text('总音量 $volume/$sum'),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: onPressDecrease),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: progressValue,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.red),
                                    backgroundColor: Color(0xff00ff00),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: onPressAdd)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: GestureDetector(
                                    onLongPress: () {
                                      controllerVideo("up");
                                      print("onLongPress");
                                    },
                                    onLongPressUp: () {
                                      print("onLongPressUp");
                                      controllerVideo("tiltstop");
                                    },
                                    onTapUp: (o) {
                                      print("onTapUp");
                                      controllerVideo("tiltstop");
                                      // DMSApi.controlVideo(0, sumValue);
                                    },
                                    onTap: () {
                                      print("onTap");
                                      controllerVideo("up");
                                    },
                                    child: Text(
                                      "上",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(right: 60, left: 30),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          child: GestureDetector(
                                        onLongPress: () {
                                          controllerVideo("left");
                                          print("onLongPress");
                                        },
                                        onLongPressUp: () {
                                          print("onLongPressUp");
                                          controllerVideo("tiltstop");
                                        },
                                        onTapUp: (o) {
                                          controllerVideo("tiltstop");
                                        },
                                        onTap: () {
                                          controllerVideo("left");
                                        },
                                        child: Text(
                                          "左",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )),
                                      Container(
                                        child: Text(
                                          "摄像头",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        margin: EdgeInsets.all(20),
                                      ),
                                      Container(
                                          child: GestureDetector(
                                        onLongPress: () {
                                          controllerVideo("right");
                                          print("onLongPress");
                                        },
                                        onLongPressUp: () {
                                          print("onLongPressUp");
                                          controllerVideo("tiltstop");
                                        },
                                        onTapUp: (o) {
                                          controllerVideo("tiltstop");
                                          // DMSApi.controlVideo(0, sumValue);
                                        },
                                        onTap: () {
                                          controllerVideo("right");
                                        },
                                        child: Text(
                                          "右",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(5),
                                ),
                                Container(
                                  child: GestureDetector(
                                    onLongPress: () {
                                      controllerVideo("down");
                                      print("onLongPress");
                                    },
                                    onLongPressUp: () {
                                      print("onLongPressUp");
                                      controllerVideo("tiltstop");
                                    },
                                    onTapUp: (o) {
                                      controllerVideo("down");
                                      // DMSApi.controlVideo(0, sumValue);
                                    },
                                    onTapDown: (o) {
                                      controllerVideo("tiltstop");
                                    },
                                    child: Text(
                                      "下",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(right: 60, left: 30),
                                ),
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: GestureDetector(
                                    onLongPress: () {
                                      print("onLongPress");
                                      controllerVideoZoom("in");
                                    },
                                    onLongPressUp: () {
                                      print("onLongPressUp");
                                      controllerVideoZoom("zoomstop");
                                    },
                                    onTapUp: (o) {
                                      controllerVideoZoom("zoomstop");
                                      // DMSApi.controlVideo(0, sumValue);
                                    },
                                    onTap: () {
                                      controllerVideoZoom("in");
                                    },
                                    child: Text(
                                      "放大",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(right: 60, left: 30),
                                ),
                                Container(
                                  child: GestureDetector(
                                    onLongPress: () {
                                      print("onLongPress");
                                      controllerVideoZoom("out");
                                    },
                                    onLongPressUp: () {
                                      print("onLongPressUp");
                                      controllerVideoZoom("zoomstop");
                                    },
                                    onTapUp: (o) {
                                      controllerVideoZoom("zoomstop");
                                    },
                                    onTap: () {
                                      controllerVideoZoom("out");
                                    },
                                    child: Text(
                                      "缩小",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                      right: 60, top: 30, left: 30, bottom: 30),
                                ),
                              ],
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
//                GridView.custom(
//                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                        crossAxisCount: 3 ,mainAxisSpacing: 4.0,
//                      crossAxisSpacing: 4.0,),
//                    childrenDelegate: SliverChildBuilderDelegate((context,
//                        index) {
//                      return Text("1");
//                    }, childCount: 9)),

              flex: 1,
            ),
          ],
        ),
        margin: EdgeInsets.only(top: 130));
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

  var state = false;

  void controllerVideo(String direction) {
    if (direction == "tiltstop") {
      Future.delayed(const Duration(milliseconds: 260),
          () => DMSApi.controlVideo(direction));
    } else {
      DMSApi.controlVideo(direction);
    }
  }

  void controllerVideoZoom(String type) {
    if (type == "zoomstop") {
      Future.delayed(const Duration(milliseconds: 260),
          () => DMSApi.controlVideoZoom(type));
    } else {
      DMSApi.controlVideoZoom(type);
    }
  }

  void saveState(String name) {
    DMSApi.saveState(name)
        .then((onValue) => getData())
        .catchError((e) => print(e));
    //getData();
  }

//  List<Widget> buildGridTileList(int number) {
//    List<Widget> widgetList = new List();
//
//    for (int i = 0; i < number; i++) {
//      widgetList.add(new Container(
//        child: Text("1"),
//        decoration: new BoxDecoration(
//          color: Colors.black,
//        ),
//      ));
//    }
//    return widgetList;
//  }
  List<String> datas = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    ".",
    "0",
    "#"
  ];

  List<Widget> buildGridTileList() {
    List<Widget> widgetList = new List();

    for (int i = 0; i < datas.length; i++) {
      widgetList.add(new Container(
          width: 80,
          height: 80,
          child: Align(child: Text(datas[i]), alignment: Alignment.center),
          decoration: new BoxDecoration(
            color: Colors.grey,
          )));
    }
    return widgetList;
  }

  Future<Data> getData() async {
    var dataJson = await DMSApi.listPreset("2");
    var item = Data.fromJson(dataJson);
    //print(item.presetList.length);
    return item;
  }

  List<DropdownMenuItem<int>> items = List();

  List<DropdownMenuItem<int>> buildAndGetDropDownMenuItems(List fruits) {
    for (Presets pr in fruits) {
      // print(pr.presetName);
      items.add(DropdownMenuItem(value: pr.id, child: Text(pr.presetName)));
    }
    setState(() {
      this.items = items;
    });
    return items;
  }
}
