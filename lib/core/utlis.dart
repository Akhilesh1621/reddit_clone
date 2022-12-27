import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSNackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
