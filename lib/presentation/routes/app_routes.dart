import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dar.dart';
import '../screen/leaderboard_screen.dart';
import '../screen/login_screen.dart';
import '../screen/tournament_list_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String tournaments = '/tournaments';
  static const String leaderboard = '/leaderboard';

  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: tournaments,
      page: () => TournamentListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: leaderboard,
      page: () => LeaderboardScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn.value) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}