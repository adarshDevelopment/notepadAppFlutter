import 'package:flutter/material.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/routes/routes.dart';
import 'package:notes_app/services/notes_service.dart';
import 'package:notes_app/theme/dark_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NoteService(),
        ),
      ],
      child: MaterialApp(
        color: Colors.grey.shade800,
        // theme: darkTheme,
        home: const HomePage(),
        initialRoute: RouteManager.homePage,
        onGenerateRoute: RouteManager.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
