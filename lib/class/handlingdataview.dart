import 'package:flutter/material.dart';
import 'package:maneger/class/statusrequest.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  final VoidCallback? onRetry; // إضافة إمكانية إعادة المحاولة

  const HandlingDataView({
    super.key,
    required this.statusRequest,
    required this.widget,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (statusRequest) {
      case StatusRequest.loading:
        return const Center(child: CircularProgressIndicator()); // أو Lottie
      case StatusRequest.offlinefailure:
        return _ErrorWidget(
          message: 'لا يوجد اتصال بالإنترنت',
          onRetry: onRetry,
        );
      case StatusRequest.serverfailure:
        return _ErrorWidget(message: 'خطأ في السيرفر', onRetry: onRetry);
      case StatusRequest.failure:
        return _ErrorWidget(message: 'حدث خطأ ما', onRetry: onRetry);
      case StatusRequest.none:
        return const Center(child: Text('لا توجد بيانات حالياً'));
      case StatusRequest.success:
        return widget;
      default:
        return widget;
    }
  }
}

// ويدجت داخلي لعرض الخطأ مع زر إعادة المحاولة
class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorWidget({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(fontSize: 16)),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}
