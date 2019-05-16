import 'package:flutter/material.dart';
import 'package:flutter_dms/widget/widget_box.dart';
import 'package:flutter_dms/ui/volume_page.dart';
import 'package:flutter_dms/ui/display_page.dart';
import 'package:flutter_dms/ui/home_page.dart';
import 'package:flutter_dms/ui/video_page.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_dms/common/constant/url_constant.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int volume = 60;
  final sum = 100;
  dynamic progressValue = 0.0;
  int _currentPageIndex = 0;

  PageController _pageController;

  Color unSelectColor = Colors.black;
  Color selectedColor = Colors.blue;
  Color color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = new PageController(
      initialPage: 0,
    );
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  int select = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("中控"),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  MaterialButton(
                      key: Key("0"),
                      onPressed: () {
                        _onClick(0);
                      },
                      child: Text(
                        "首页",
                        style: TextStyle(
                            fontSize: 20,
                            color: _currentPageIndex == 0
                                ? selectedColor
                                : unSelectColor),
                      )),
                  MaterialButton(
                      key: Key("1"),
                      onPressed: () {
                        _onClick(1);
                      },
                      child: Text(
                        "显示屏控制",
                        style: TextStyle(
                            fontSize: 20,
                            color: _currentPageIndex == 1
                                ? selectedColor
                                : unSelectColor),
                      )),
                  MaterialButton(
                      key: Key("2"),
                      onPressed: () {
                        _onClick(2);
                      },
                      child: Text(
                        "音量调节",
                        style: TextStyle(
                            fontSize: 20,
                            color: _currentPageIndex == 2
                                ? selectedColor
                                : unSelectColor),
                      )),
                  MaterialButton(
                      key: Key("3"),
                      onPressed: () {
                        _onClick(3);
                      },
                      child: Text(
                        "会议控制",
                        style: TextStyle(
                            fontSize: 20,
                            color: _currentPageIndex == 3
                                ? selectedColor
                                : unSelectColor),
                      )),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              flex: 1,
            ),
            Expanded(
              child: _buildBody(),
              flex: 3,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  void _onClick(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    //_pageController.jumpToPage(index);
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);

    print(_currentPageIndex);
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

  ///页面切换回调
  void _pageChange(int index) {
    setState(() {
      if (_currentPageIndex != index) {
        _currentPageIndex = index;
      }
    });
  }

  Widget _buildBody() {
    return PageView(
      // physics: NeverScrollableScrollPhysics(),
      onPageChanged: _pageChange,
      controller: _pageController,
      children: <Widget>[
//        new HomePage(
//          channel:
//              IOWebSocketChannel.connect(UrlConstant.API_DMS_WEB_SOCKET_HOST),
//        ),
        new HomePage(
        ),
        new ControlPage(),
        new VolumePage(),
        new VideoPage(),
      ],
    );
  }
}
