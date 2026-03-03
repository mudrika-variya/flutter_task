import 'dart:convert';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/tournament_model.dart';
import '../models/leaderboard_model.dart';

class ApiService {
  final String baseUrl = AppConstants.baseUrl;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 30, // optional, defaults to 60
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<List<TournamentModel>> getTournaments() async {
    // Simulating tournament data since dummyjson doesn't have tournaments
    await Future.delayed(const Duration(seconds: 1));

    return [
      TournamentModel(
        id: 1,
        name: 'Battle Royale Championship',
        entryFee: 600,
        prizePool: 5000,
        totalSlots: 100,
        availableSlots: 45,
      ),
      TournamentModel(
        id: 2,
        name: 'Speed Run Masters',
        entryFee: 25,
        prizePool: 2500,
        totalSlots: 50,
        availableSlots: 12,
      ),
      TournamentModel(
        id: 3,
        name: 'Pro League Season 5',
        entryFee: 100,
        prizePool: 10000,
        totalSlots: 200,
        availableSlots: 0,
      ),
      TournamentModel(
        id: 4,
        name: 'Weekend Warriors',
        entryFee: 10,
        prizePool: 1000,
        totalSlots: 30,
        availableSlots: 8,
      ),
      TournamentModel(
        id: 5,
        name: 'Elite Invitational',
        entryFee: 200,
        prizePool: 20000,
        totalSlots: 50,
        availableSlots: 23,
      ),
    ];
  }

  Future<List<LeaderboardModel>> getLeaderboard(int page, int limit) async {
    // Simulating paginated leaderboard data with 50 total players
    await Future.delayed(const Duration(seconds: 1));

    // Generate 50 players
    List<LeaderboardModel> allPlayers = List.generate(50, (index) {
      return LeaderboardModel(
        rank: index + 1,
        playerName: 'Player_${index + 1}',
        points: 5000 - (index * 100), // Decreasing points
      );
    });

    // Calculate pagination
    int startIndex = (page - 1) * limit;
    int endIndex = startIndex + limit;

    print('Leaderboard pagination: page=$page, limit=$limit, start=$startIndex, end=$endIndex');

    if (startIndex >= allPlayers.length) {
      return []; // No more data
    }

    // Ensure we don't go beyond array bounds
    if (endIndex > allPlayers.length) {
      endIndex = allPlayers.length;
    }

    return allPlayers.sublist(startIndex, endIndex);
  }
  // Optional: Method to refresh token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refreshToken': refreshToken,
          'expiresInMins': 30,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }
}