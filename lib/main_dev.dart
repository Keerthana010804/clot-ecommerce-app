import 'package:e_commerce/provider/auth_provider.dart';
import 'package:e_commerce/provider/favorite_provider.dart';
import 'package:e_commerce/provider/profile_provider.dart';
import 'package:e_commerce/screens/signin_screen.dart';
import 'package:e_commerce/screens/splash_screen.dart';
import 'package:e_commerce/utils/flavour_config.dart';
import 'package:e_commerce/utils/shared_preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/provider/cart_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyA8q4zgim0sG6l01xi90RdQi3irOqZN33o",
              authDomain: "e-commerce-8da14.firebaseapp.com",
              projectId: "e-commerce-8da14",
              storageBucket: "e-commerce-8da14.firebasestorage.app",
              messagingSenderId: "1030396304590",
              appId: "1:1030396304590:web:dfe6a2be52ba5deeaa049f",
              measurementId: "G-BGVY75FVNJ"
          ),
        )
      : await Firebase.initializeApp();
  await SharedPrefs.init();
  FlavorConfig(
    flavor: Flavor.dev,
    baseUrl: 'https://fakestoreapi.com/',
    name: 'DEV',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        // Add other providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: "Clot",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/signin': (context) => SignInScreen(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
