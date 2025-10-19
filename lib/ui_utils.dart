import 'package:evently/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtils {
  static void showLoading(
    BuildContext context, {
    Widget? content,
    Widget? title,
    String? buttonText,
    VoidCallback? onTap,
    bool? canPop,
  }) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: canPop ?? false,
      child: AlertDialog(
        title: Center(child: title),
        content: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.03,
          child:
              content ??
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: onTap,
            child: Text(buttonText ?? "Ok"),
          ),
        ],
      ),
    ),
  );

  static void hideLoading(BuildContext context) => Navigator.of(context).pop();

  static void showSuccessMessage(String message) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: AppTheme.green,
    textColor: AppTheme.white,
  );
  static void showErrorMessage(String? message) => Fluttertoast.showToast(
    msg: message ?? "Something Went Wrong",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: AppTheme.red,
    textColor: AppTheme.white,
  );
}
