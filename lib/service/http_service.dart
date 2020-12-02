import 'package:dio/dio.dart';
import 'dart:async';
class Global{
  // String BASE_url="http://192.168.1.105:8080/";
  String BASE_url="http://10.206.128.44:8080/";
}
//Dio请求方法封装
Future request(url, {formData}) async {
  try {
    Response response;
    Dio dio = Dio();
    dio.options.responseType=ResponseType.plain;

    //发起POST请求 传入url及表单参数
    response = await dio.get(url);
    //成功返回
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('后端接口异常,请检查测试代码和服务器运行情况...');
    }
  } catch (e) {
    return print('error:::${e}');
  }
}

Future requestPost(url, {formData}) async {
  try {
    Response response;
    Dio dio = Dio();
    dio.options.responseType=ResponseType.plain;
    //dio.options.contentType='multipart/form-data';
    //发起POST请求 传入url及表单参数
    //print("URL:"+url);
    response = await dio.post(url, data: formData);
    print(response);
    //成功返回
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('后端接口异常,请检查测试代码和服务器运行情况...');
    }
  } catch (e) {
    return print('error:::$e');
  }
}