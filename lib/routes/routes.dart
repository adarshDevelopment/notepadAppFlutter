import 'package:flutter/material.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/pages/notes_page.dart';

class RouteManager {
  static const String notePage = '/note_page';
  static const String homePage = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case notePage:
        return MaterialPageRoute(builder: (context) => const NotePage());
      case homePage:
        return MaterialPageRoute(builder: (context) => const HomePage());
      default:
        throw Exception('No such page found');
    }
  }
}
