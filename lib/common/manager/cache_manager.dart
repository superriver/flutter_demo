import 'dart:convert';
import 'dart:io';
import 'package:objectdb/objectdb.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dms/common/constant/constant.dart';

class CacheManager {
  static ObjectDB db;

  static init() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, "${Constant.DB_CACHE}");
    db = ObjectDB(path);
    await db.open();
  }

  static set(CacheObject cacheObject) async {
    cacheObject.time = DateTime.now().millisecondsSinceEpoch;
    var cacheObjectList = await db.find({'url': cacheObject.url});
    if (cacheObjectList != null && cacheObjectList.length > 0) {
      await db.update({
        'url': cacheObjectList[0]['url']
      }, {
        'value': json.encode(cacheObject.value),
        'time': cacheObject.time,
      });
    } else {
      await db.insert(cacheObject.toJson());
    }
  }

  static get(String url) async {
    var cachedObjectList = await db.find({'url': url});
    if (cachedObjectList != null && cachedObjectList.length > 0) {
      return json.decode(cachedObjectList[0]['value']);
    }
  }
}

class CacheObject {
  String url;
  dynamic value;
  int time;

  CacheObject({this.url, this.value, this.time});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['value'] = json.encode(this.value);
    data['time'] = this.time;
    return data;
  }
}
