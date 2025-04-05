import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medico/screens/splash_screen.dart';
import 'package:medico/screens/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()

//function to inizialize the firebase


// function for the dark mode

async {
  // handling the initialization of the firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //handling the initialization of the dark mode
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Medico',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
