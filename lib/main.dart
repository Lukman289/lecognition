import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lecognition/screens/bookmarked.dart';
import 'package:lecognition/widgets/tabs.dart';
import 'package:skeletonizer/skeletonizer.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromARGB(
      255,
      255,
      0,
      0,
    ), // Seed color yang Anda inginkan
    brightness: Brightness.light, // Untuk memastikan warna terang
  ).copyWith(
    primary: Colors.amber, // Set warna primary secara eksplisit
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  extensions: const [
    SkeletonizerConfigData(),
  ],
);

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Flutter Demo',
      routes: {
        '/': (context) => const TabsScreen(),
        '/bookmarked': (context) => BookmarkedScreen(),
      },
      // home: const TabsScreen(),
    );
  }
}
