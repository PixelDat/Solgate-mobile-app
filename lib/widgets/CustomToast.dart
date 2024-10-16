import 'package:flutter/material.dart';
import 'dart:ui';

enum ToastType { success, warning, error }

class CustomToast extends StatelessWidget {
  final String message;
  final ToastType type;

  const CustomToast({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getIcon(),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(
                    color: _getColor(),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getIcon() {
    IconData iconData;
    Color color;

    switch (type) {
      case ToastType.success:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case ToastType.warning:
        iconData = Icons.warning;
        color = Colors.orange;
        break;
      case ToastType.error:
        iconData = Icons.error;
        color = Colors.red;
        break;
    }

    return Icon(iconData, color: color, size: 24);
  }

  Color _getColor() {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.error:
        return Colors.red;
    }
  }
}

