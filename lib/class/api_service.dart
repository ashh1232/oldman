import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/function/checkinternet.dart'; // استيراد وظيفة التحقق

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<Either<StatusRequest, dynamic>> getRequestEither(String path) async {
    try {
      // إضافة الأقواس المفقودة لحل التحذير
      if (!await checkInternet()) {
        return const Left(StatusRequest.offlinefailure);
      }

      final response = await _dio.get(path);

      // التعامل مع الرد بشكل مباشر داخل الدالة لضمان توافق الـ Either
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } on DioException catch (e) {
      // تمرير خطأ Dio إلى دالة المعالجة وتغليفها بـ Left
      return Left(_handleError(e));
    } catch (_) {
      return const Left(StatusRequest.serverfailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> postRequestEither(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      // 1. التحقق من الإنترنت مع استخدام الأقواس (Block)
      if (!await checkInternet()) {
        return const Left(StatusRequest.offlinefailure);
      }

      // 2. إرسال طلب POST
      final response = await _dio.post(path, data: data);

      // 3. معالجة الرد بناءً على كود الحالة
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } on DioException catch (e) {
      // 4. معالجة أخطاء Dio وتغليفها في Left
      return Left(_handleError(e));
    } catch (_) {
      // 5. حالة احتياطية لأي خطأ غير متوقع
      return const Left(StatusRequest.serverfailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> uploadRequestEither(
    String path,
    Map<String, dynamic> data,
    File file, // استيراد dart:io
  ) async {
    try {
      if (!await checkInternet()) {
        return const Left(StatusRequest.offlinefailure);
      }

      // تحويل البيانات والصورة إلى FormData
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        ...data,
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _dio.post(path, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (_) {
      return const Left(StatusRequest.serverfailure);
    }
  }

  // دالة موحدة لمعالجة الردود الناجحة وأكواد الأخطاء المتوقعة (مثل 400 و 409)
  // dynamic _handleResponse(Response response) {
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return response.data;
  //   } else {
  //     return StatusRequest.serverfailure;
  //   }
  // }

  StatusRequest _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return StatusRequest.offlinefailure;
    }
    return StatusRequest.serverfailure;
  }
}
