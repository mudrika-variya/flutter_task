import '../models/tournament_model.dart';
import '../services/api_service.dart';

class TournamentRepository {
  final ApiService _apiService = ApiService();

  Future<List<TournamentModel>> getTournaments() async {
    return await _apiService.getTournaments();
  }
}