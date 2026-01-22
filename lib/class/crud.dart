import 'dart:convert';
import 'dart:core';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/function/checkinternet.dart';

class Crud {
  // إضافة الـ Headers وتأكد من استخدامها
  Map<String, String> get _headers => {
    // هذا السطر يضمن للسيرفر أن البيانات القادمة هي UTF-8
    "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
    "Accept": "application/json",
  };

  Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
    try {
      if (await checkInternet()) {
        var response = await http
            .post(Uri.parse(linkurl), body: data, headers: _headers)
            .timeout(const Duration(seconds: 15));

        return _handleResponse(response);
      } else {
        return const Left(StatusRequest.offline);
      }
    } catch (e) {
      return const Left(StatusRequest.serverfailure);
    }
  }

  Future<Either<StatusRequest, Map>> getData(String linkurl) async {
    try {
      if (await checkInternet()) {
        var response = await http
            .get(Uri.parse(linkurl), headers: _headers)
            .timeout(const Duration(seconds: 15));

        return _handleResponse(response);
      } else {
        return const Left(StatusRequest.offline);
      }
    } catch (e) {
      return const Left(StatusRequest.serverfailure);
    }
  }

  Either<StatusRequest, Map> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      return Right(responseBody);
    } else {
      return const Left(StatusRequest.serverfailure);
    }
  }
}
