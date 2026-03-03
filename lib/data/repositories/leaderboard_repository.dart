import '../models/leaderboard_model.dart';
import '../services/api_service.dart';

class LeaderboardRepository {
  final ApiService _apiService = ApiService();

  Future<List<LeaderboardModel>> getLeaderboard(int page, int limit) async {
    return await _apiService.getLeaderboard(page, limit);
  }
}