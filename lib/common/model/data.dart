import 'package:flutter_dms/common/model/preset.dart';

class Data {
  String status;
  String msg;
  List<Presets> presetList=[];

  Data.fromJson(Map<String, dynamic> json) {
    var results = json['data'];
    _createListFromJson(results);
  }

  List<Presets> _createListFromJson(List value) {
    
    var dataList =
        value.map<Presets>((item) => Presets.fromJson(item)).toList();
    presetList.addAll(dataList);
    return dataList;
  }
}
