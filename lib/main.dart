import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/vpn_cubit.dart';
import 'screens/vpn_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // try {
  //   await Firebase.initializeApp();
  // } catch (e) {
  //   // Handle Firebase initialization error
  //   debugPrint('Firebase initialization failed: $e');
  // }

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize Firebase Analytics
  // final analytics = FirebaseAnalytics.instance;

  runApp(MyApp(
    prefs: prefs,
    // analytics: analytics,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  // final FirebaseAnalytics analytics;

  const MyApp({
    super.key,
    required this.prefs,
    // required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => VpnCubit(
            prefs: prefs,
            // analytics: analytics,
          ),
          child: MaterialApp(
            title: 'VPN Connection App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: ThemeMode.system,
            home: const VpnScreen(),
          ),
        );
      },
    );
  }
}
