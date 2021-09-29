import 'package:flutter/material.dart';
import 'package:vaccines_app/components/MainPage.dart';

Map<String, Widget Function(BuildContext)> buildRoutes() {
  return {
    '/': (context) => MainPage()
  };
}
