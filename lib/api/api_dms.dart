import 'package:flutter_dms/common/net/http_response.dart';
import 'package:flutter_dms/common/net/http_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dms/common/model/volume.dart';

class DMSApi {
  static const String API_DMS_HOST = 'http://192.168.1.21:8899';
  static const String API_DMS_WEB_SOCKET_HOST = 'ws.ezpro.com:8083';
  static const String API_SUBMIT = "$API_DMS_HOST/control/execute";
  static const String API_QUERY_LIST_PRESETS =
      "$API_DMS_HOST/device-preset/presets";
  static const String API_EXECUTE_PRESETS =
      "$API_DMS_HOST/control/call-preset";

  /*
    * {
      "requestId":"1234567890",
        "inputs":[
          {
            "intent":"action.device.EXECUTE",
            "payload":{
                "device":{
                "id":"1",
                "customData":{
                "deviceName":"camera1",
                "ipAddress":"192.168.1.118"
                  }
                },
                "execution":{
                "command":"action.device.commands.VOLUME",
                "params":{
                "operation":"volume",
                "controlNum":"31",
                "controlPosition":"3635353335"
                }
              }
            }
          }
        ]
      }
    * */

  static controlVolume(String val) async {
    PlayLoad playLoad = PlayLoad();
    playLoad.device = Device("1", CustomData("camera1", "192.168.1.118"));
    playLoad.execution = Execution(
        "action.device.commands.VOLUME", Params("volume", "31", "65535"));

    var data = {
      "requestId": DateTime.now().millisecond,
      "inputs": [
        {
          "intent": "action.device.EXECUTE",
          "payload": {
            "device": {
              "id": "1",
              "customData": {
                "deviceName": "camera1",
                "ipAddress": "192.168.1.118"
              }
            },
            "execution": {
              "command": "action.device.commands.VOLUME",
              "params": {
                "operation": "volume",
                "controlNum": "1",
                "controlPosition": val,
              }
            }
          }
        }
      ]
    };

    print(data);
    HttpResponse response =
        await HttpManager.fetch(API_SUBMIT, params: data, method: "post");
    return response.data;
  }

  static controlVideo(String direction) async {
    var data = {
      "requestId": DateTime.now().millisecondsSinceEpoch,
      "inputs": [
        {
          "intent": "action.device.EXECUTE",
          "payload": {
            "device": {
              "id": "2",
              "customData": {
                "deviceName": "camera1",
                "ipAddress": "192.168.1.118"
              }
            },
            "execution": {
              "command": "action.device.commands.TILT",
              "params": {
                "camAddress": "1",
                "direction": direction,
              }
            }
          }
        }
      ]
    };

    print(data);
    HttpResponse response =
        await HttpManager.fetch(API_SUBMIT, params: data, method: "post");
    return response.data;
  }

  static controlVideoZoom(String type) async {
    var data = {
      "requestId": "1234567890",
      "inputs": [
        {
          "intent": "action.device.EXECUTE",
          "payload": {
            "device": {
              "id": "2",
              "customData": {
                "deviceName": "camera1",
                "ipAddress": "192.168.1.118"
              }
            },
            "execution": {
              "command": "action.device.commands.ZOOM",
              "params": {
                "camAddress": "1",
                "zoom": type,
              }
            }
          }
        }
      ]
    };

    print(data);
    HttpResponse response =
        await HttpManager.fetch(API_SUBMIT, params: data, method: "post");
    return response.data;
  }

  static Future  saveState(String name) async {
    var data = {
      "requestId": "1234567890",
      "inputs": [
        {
          "intent": "action.device.EXECUTE",
          "payload": {
            "device": {
              "id": "2",
              "customData": {
                "deviceName": "camera1",
                "ipAddress": "192.168.1.118"
              }
            },
            "execution": {
              "command": "action.device.commands.PRESET",
              "params": {"camAddress": 1, "presetName": name}
            }
          }
        }
      ]
    };
    print(data);
    HttpResponse response =
        await HttpManager.fetch(API_SUBMIT, params: data, method: "post");
    return response.data;
  }

  ///获取预设列表///

  static listPreset(String deviceId) async {
    String url = API_QUERY_LIST_PRESETS + "/$deviceId";
    HttpResponse response = await HttpManager.fetch(url);
    return response.data;
  }

  ///执行预设///

  static executePreset(String presetId) async {
    String url = API_EXECUTE_PRESETS + "/$presetId";
    HttpResponse response = await HttpManager.fetch(url,method: "post");
    return response.data;
  }
}
