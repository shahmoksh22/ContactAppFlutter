import 'package:contactproject/Providers/ContactProvider.dart';
import 'package:contactproject/Providers/ThemeProvider.dart';
import 'package:contactproject/Providers/platformprovider.dart';
import 'package:contactproject/Screens/AddContact.dart';
import 'package:contactproject/Screens/HiddenContactDetails.dart';
import 'package:contactproject/Screens/HiddenContactList.dart';
import 'package:contactproject/Screens/HomePage.dart';
import 'package:contactproject/Screens/SettingScreen.dart';
import 'package:contactproject/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider()),
        ChangeNotifierProvider(create: (context) => PlatformProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeProvider>(context).isDark
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/home': (context) => Homepage(),
        '/addcontact': (context) => AddContactPage(),
        '/hidenlist': (context) => Hiddencontactlist(),
        '/setting': (context) => Settingscreen(),
      },
    );
  }
}