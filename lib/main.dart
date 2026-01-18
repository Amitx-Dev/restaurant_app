import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {

          return MaterialApp(
            debugShowCheckedModeBanner: false,

            title: "Restaurant App",

            themeMode: themeProvider.themeMode,

            // 🌞 LIGHT THEME
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,

              colorSchemeSeed: Colors.deepOrange,

              scaffoldBackgroundColor: const Color(0xfff6f6f6),

              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),

              // ✅ FIXED HERE
              cardTheme: CardThemeData(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            // 🌙 DARK THEME
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,

              colorSchemeSeed: Colors.deepOrange,

              scaffoldBackgroundColor: const Color(0xff121212),

              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),

              // ✅ FIXED HERE
              cardTheme: CardThemeData(
                color: const Color(0xff1E1E1E),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
