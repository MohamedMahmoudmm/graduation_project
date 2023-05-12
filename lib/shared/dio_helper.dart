import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Api {
  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey = "AAAArjczmkM:APA91bGbZiwHQebVhVqRe3gJwaTUfnZ6Q0usEz9mtCNGaEN30uP805_U2hOLHMchBqT7debokjSFCpca_EClUdRU2tk2mQ-_vlLLXKNUm22d1r1O8WKloyNrwUZfoTdPOLlpaOEwKbUw";

  void sendFcm(String title, String body, String fcmToken) async {

    print('11');
    var headers = {'Content-Type': 'application/json', 'Authorization': 'key=$fcmKey'};
    print('22');
    var request = http.Request('POST', Uri.parse(fcmUrl));
    print('33');
    request.body = '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    print('44');
    request.headers.addAll(headers);
    print('55');
    http.StreamedResponse response = await request.send();
    print('66');
    if (response.statusCode == 200) {
      print('77');
      print('not ${await response.stream.bytesToString()}');
    } else {
      print('not send${response.reasonPhrase}');
    }
  }
}
class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          receiveDataWhenStatusError: true,

        )
    );
    (dio?.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  static Future<Response> getData({

    Map<String, dynamic>? query,
    String? lang,
    String? token
  }) async
  {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
    };
    return await dio!.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json?', queryParameters: query);
  }

}