import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String result) {
  SnackBar snackBar = SnackBar(content: Text(result));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
