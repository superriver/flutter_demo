import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_dms/common/net/http_code.dart';
import 'package:flutter_dms/common/net/http_response.dart';
import 'package:flutter_dms/config/dms_config.dart';
import 'package:flutter_dms/common/manager/cache_manager.dart';
class HttpManager{

  static Dio dio = Dio();

  static Future<HttpResponse> fetch(url,
      {noTip = false,
      dynamic params,
      Map<String,String> header,method='get',Function onError,void onDone()}) async {
      Map<String,String> headers = HashMap();
      if(header!=null){
        headers.addAll(header);
      }
      Options options = Options(method: method);
      options.headers = headers;
      options.connectTimeout = 15000;
      Response response;

      //取缓存
//    var cacheData = await CacheManager.get(url);
//    var connectivityResult = await (Connectivity().checkConnectivity());
//    if(connectivityResult==ConnectivityResult.none){
//        if(cacheData!=null){
//          return HttpResponse(cacheData, true, Code.SUCCESS,headers: null);
//        }else{
//          return HttpResponse(
//              Code.errorHandleFunction(Code.NETWORK_ERROR, "", noTip),
//              false,
//              Code.NETWORK_ERROR);
//        }
//    }

    try{
      response = await dio.request(url,data: params,options: options);
    }on DioError catch (e){
//      ///如果缓存不为空且接口可以缓存，那么直接从缓存取即可.
//      if (cacheData != null) {
//        if (DMSConfig.DEBUG) {
//          print('httpManager=====>【缓存】cache请求url: ' + url);
//          print('httpManager=====>【缓存】请求头: ' + options.headers.toString());
//          if (params != null) {
//            print('httpManager=====>【缓存】请求参数: ' + params.toString());
//          }
//          if (response != null) {
//            print('httpManager=====>【缓存】返回结果: ' + cacheData.toString());
//          }
//        }
//        return HttpResponse(cacheData, true, Code.SUCCESS, headers: null);
//      }
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (DMSConfig.DEBUG) {
        print('httpManager=====>请求异常: ' + e.toString());
        print('httpManager=====>请求异常url: ' + url);
      }
      return HttpResponse(
          Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode);
    }
      if (DMSConfig.DEBUG) {
        print('httpManager=====>请求url: ' + url);
        print('httpManager=====>请求头: ' + options.headers.toString());
        if (params != null) {
          print('httpManager=====>请求参数: ' + params.toString());
        }
        if (response != null) {
          print('httpManager=====>返回参数: ' + response.toString());
        }
      }
      try{
        if(response.statusCode==200||response.statusCode==201){
          return HttpResponse(response.data, true, Code.SUCCESS,headers: response.headers);
        }
      }catch (e){
          return HttpResponse(response.data,false,response.statusCode,headers: response.headers);
      }

      return HttpResponse(Code.errorHandleFunction(response.statusCode, "", noTip),false,response.statusCode);
  }
}