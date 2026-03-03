import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      print('Login response: $response');

      final user = UserModel.fromJson(response);
      await _storageService.saveUser(user);

      return user;
    } catch (e) {
      print('Auth repository error: $e');
      throw Exception('Login failed: Invalid username or password');
    }
  }

  Future<void> logout() async {
    await _storageService.clearUser();
  }

  Future<UserModel?> getCurrentUser() async {
    return await _storageService.getUser();
  }

  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  Future<String?> getAccessToken() async {
    return await _storageService.getToken();
  }

  Future<String?> getRefreshToken() async {
    return await _storageService.getRefreshToken();
  }
}