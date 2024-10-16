import 'package:flutter/material.dart';
import 'package:tongate/widgets/CustomToast.dart';

void showCustomToast(BuildContext context, String message, ToastType type) {
  final overlay = Overlay.of(context);
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      // Change the positioning to bottom
      bottom: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: CustomToast(message: message, type: type),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
