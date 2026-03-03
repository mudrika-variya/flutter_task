import 'package:flutter/material.dart';
import 'package:flutter_task/presentation/screen/leaderboard_screen.dart';
import 'package:flutter_task/presentation/screen/login_screen.dart';
import 'package:flutter_task/presentation/screen/mainScreen.dart';
import 'package:flutter_task/presentation/screen/profile.dart';
import 'package:flutter_task/presentation/screen/splash_screen.dart';
import 'package:flutter_task/presentation/screen/tournament_list_screen.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dar.dart';
import 'controllers/leaderboard_controller.dart';
import 'controllers/tournament_controller.dart';
import 'controllers/wallet_controller.dart';
import 'data/services/storage_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure storage
  final storageService = StorageService();
  await storageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GameOn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headlineLarge: AppTheme.heading1,
          headlineMedium: AppTheme.heading2,
          headlineSmall: AppTheme.heading3,
          bodyLarge: AppTheme.bodyText1,
          bodyMedium: AppTheme.bodyText2,
          labelSmall: AppTheme.caption,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppTheme.primaryButton,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
          iconTheme: IconThemeData(
            color: AppTheme.textPrimary,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 12),
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/main',
          page: () => const MainScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/tournaments',
          page: () => const TournamentListScreen(),
        ),
        GetPage(
          name: '/leaderboard',
          page: () => const LeaderboardScreen(),
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfileScreen(),
        ),
      ],
      initialBinding: InitialBinding(),
    );
  }
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(WalletController(), permanent: true);
    Get.put(TournamentController(), permanent: true);
    Get.put(LeaderboardController(), permanent: true);
  }
}