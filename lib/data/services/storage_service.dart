import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late final FlutterSecureStorage _secureStorage;

  // Android Options for better security
  final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<void> init() async {
    _secureStorage = FlutterSecureStorage(
      aOptions: _androidOptions,
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  // ============== User Methods ==============
  Future<void> saveUser(UserModel user) async {
    await _secureStorage.write(
      key: AppConstants.storageUserKey,
      value: jsonEncode(user.toJson()),
    );
    await saveToken(user.accessToken);
    if (user.refreshToken.isNotEmpty) {
      await saveRefreshToken(user.refreshToken);
    }
  }

  Future<UserModel?> getUser() async {
    final String? userString = await _secureStorage.read(key: AppConstants.storageUserKey);
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }

  // ============== Token Methods ==============
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.storageTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.storageTokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: AppConstants.storageRefreshTokenKey, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.storageRefreshTokenKey);
  }

  // ============== Wallet Methods ==============
  Future<void> saveWalletBalance(double balance) async {
    await _secureStorage.write(
      key: AppConstants.storageWalletBalanceKey,
      value: balance.toString(),
    );
  }

  Future<double> getWalletBalance() async {
    final String? balanceString = await _secureStorage.read(key: AppConstants.storageWalletBalanceKey);
    if (balanceString != null) {
      return double.parse(balanceString);
    }
    return AppConstants.initialWalletBalance; // Using constant
  }

  // ============== Joined Tournaments Methods ==============
  Future<void> saveJoinedTournaments(List<int> tournamentIds) async {
    await _secureStorage.write(
      key: AppConstants.storageJoinedTournamentsKey,
      value: jsonEncode(tournamentIds),
    );
  }

  Future<List<int>> getJoinedTournaments() async {
    final String? idsString = await _secureStorage.read(key: AppConstants.storageJoinedTournamentsKey);
    if (idsString != null) {
      return List<int>.from(jsonDecode(idsString));
    }
    return [];
  }

  Future<void> addJoinedTournament(int tournamentId) async {
    final currentIds = await getJoinedTournaments();
    if (!currentIds.contains(tournamentId)) {
      currentIds.add(tournamentId);
      await saveJoinedTournaments(currentIds);
    }
  }

  // ============== Clear Methods ==============
  Future<void> clearUser() async {
    await _secureStorage.delete(key: AppConstants.storageUserKey);
    await _secureStorage.delete(key: AppConstants.storageTokenKey);
    await _secureStorage.delete(key: AppConstants.storageRefreshTokenKey);
    await _secureStorage.delete(key: AppConstants.storageWalletBalanceKey);
    await _secureStorage.delete(key: AppConstants.storageJoinedTournamentsKey);
  }

  Future<void> clearWallet() async {
    await _secureStorage.delete(key: AppConstants.storageWalletBalanceKey);
    await _secureStorage.delete(key: AppConstants.storageJoinedTournamentsKey);
  }

  // ============== Status Methods ==============
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<bool> hasWalletData() async {
    return await _secureStorage.containsKey(key: AppConstants.storageWalletBalanceKey);
  }
}