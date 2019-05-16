import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dms/widget/widget_box.dart';
import 'package:flutter_dms/api/api_dms.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_dms/common/model/message.dart';
import 'dart:io';
import 'package:stomp/stomp.dart';

//import 'package:stomp/websocket.dart' show connect;
import 'package:stomp/vm.dart' show connect;
import 'package:flutter_dms/common/constant/url_constant.dart';
import 'dart:core';
import 'package:mqtt_client/mqtt_client.dart';
//import "dart:html" show WebSocket, MessageEvent;

class HomePage extends StatefulWidget {
  final IOWebSocketChannel channel;

  HomePage({Key key, @required this.channel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int volume = 0;
  final sum = 100;
  dynamic progressValue = 0.0;
  dynamic volumeVal = 0;
  dynamic pub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //startConnect();
    startMqttConnect();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // sendMsg();
                    _subscribeToTopic("a");
                  },
                  child: BoxWidget('本地会议', Colors.white, Colors.black, 150, 50),
                ),
                GestureDetector(
                  onTap: () {
                    sendMsg();
//                    _subscribeToTopic("a");
                  },
                  child: BoxWidget('电话会议', Colors.white, Colors.black, 150, 50),
                ),
                BoxWidget('视频会议', Colors.white, Colors.black, 150, 50),
              ],
            ),
            Container(
                child: BoxWidget('结束会议', Colors.white, Colors.black, 150, 50),
                margin: EdgeInsets.only(top: 80)),
            Container(
              margin: EdgeInsets.only(left: 50, top: 80),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text('总音量 $volume/$sum'),
//                    child: StreamBuilder(
//                        stream: widget.channel.stream,
//                        builder: (context, snapshot) {
//                          return Text(snapshot.hasData
//                              ? '总音量 $volume/$sum'
//                              : '总音量 0/100');
//                        }),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Slider(
                          value: progressValue,
                          max: 100,
                          min: 0,
                          onChangeEnd: (double val) {
                            print("onChangeEnd=$val");
                            int volume = val.round();
                            double percentage = volume / sum;
                            volumeVal = 65535 * percentage;
                            print("onPressAdd:volumeVal=$volumeVal");
                            DMSApi.controlVolume(volumeVal.toString());
                          },
                          onChanged: (double val) {
                            print("val=$val");
                            progressValue = volume / sum;

                            setState(() {
                              this.volume = val.round();
                              this.progressValue = val;
                            });
                          })),
                ],
              ),
            ),
          ],
        ),
        margin: EdgeInsets.only(top: 130));
  }

  @override
  void dispose() {
    super.dispose();
    webSocket.close();
    subscription.cancel();
  }

  WebSocket webSocket;

  void onData(dynamic content) {
    print("onData=$content");
  }

  void onError(StompClient client, String message, String detail,
      Map<String, String> headers) {
    print("onError=$message");
  }

  void onConnect(StompClient client, Map<String, String> headers) {
    print("onConnect=");
  }

  void onFailed(StompClient client, error, stackTrace) {
    print("onFailed=$error");
  }

  void startConnect() async {
    print("正在连接...");
    connect(UrlConstant.API_DMS_WEB_SOCKET_HOST,
            host: 'ws.ezpro.com',
            port: 8083,
            onConnect: onConnect,
            onError: onError,
            onFault: onFailed)
        .then((StompClient stomp) {
      print("连接成功...");
      stomp.subscribeString("0", "/foo",
          (Map<String, String> headers, String message) {
        print("Recive $message");
      });
      stomp.sendString("/foo", "hello flutter");
    });
  }

  MqttClient client;
  StreamSubscription subscription;

  void startMqttConnect() async {
//    client = MqttClient.withPort(
//        UrlConstant.API_DMS_WEB_SOCKET_HOST, "flutter", 8083);
    client = MqttClient(UrlConstant.API_DMS_WEB_SOCKET_HOST, "");
    client.keepAlivePeriod = 30;
    client.onDisconnected = _disconnected;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('MQTT_Flutter_ID')
        .startClean()
        .keepAliveFor(30)
        .withWillTopic('willTopic')
        .withWillMessage('My Will message')
        .withWillQos(MqttQos.atLeastOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;
    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnected();
    }
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('MQTT client connected');
      setState(() {
        connectionState = client.connectionStatus.state;
      });
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionStatus.state}');
    }

    client.onConnected = () {
      print("onConnected");
    };

    subscription = client.updates.listen(_onMessage);
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    print(event.length);
    print(client.connectionStatus);
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The payload is a byte buffer, this will be specific to the topic
    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');
    print(client.connectionStatus.state);
  }

  MqttConnectionState connectionState;
  Set<String> topics = Set<String>();

  void _subscribeToTopic(String topic) {
    print(client.connectionStatus.state);
    if (connectionState == MqttConnectionState.connected) {
      setState(() {
        if (topics.add(topic.trim())) {
          print('Substring to');
          client.subscribe(topic, MqttQos.exactlyOnce);
        }
      });
    }
  }

  void _disconnected() {
    print("断开连接");
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    setState(() {
      topics.clear();
      connectionState = client.connectionStatus.state;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('MQTT client disconnected');
  }

  sendMsg() {
    //  final Stream<Message> sub = widget.channel.stream.asBroadcastStream();
//    client.subscribe("a", MqttQos.atLeastOnce);
    print("发消息 ${client.connectionStatus.state}");
    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString("hello flutter");
    client.publishMessage("a", MqttQos.atLeastOnce, builder.payload);
    // webSocket.add("a");
    //client.publishMessage("a",  MqttQos.atLeastOnce, "hello f")
  }
}
