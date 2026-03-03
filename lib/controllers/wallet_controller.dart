import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/storage_service.dart';

class WalletController extends GetxController {
  final StorageService _storageService = StorageService();
  final balance = 0.0.obs;
  final joinedTournamentIds = <int>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    try {
      isLoading.value = true;

      // Load wallet balance using constant
      final savedBalance = await _storageService.getWalletBalance();
      balance.value = savedBalance;

      // Load joined tournaments
      final savedTournaments = await _storageService.getJoinedTournaments();
      joinedTournamentIds.assignAll(savedTournaments);

      print('Wallet loaded: ₹${balance.value}');
      print('Joined tournaments: $joinedTournamentIds');
    } catch (e) {
      print('Error loading wallet data: $e');
      balance.value = AppConstants.initialWalletBalance; // Using constant
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveWalletData() async {
    try {
      await _storageService.saveWalletBalance(balance.value);
      await _storageService.saveJoinedTournaments(joinedTournamentIds.toList());
    } catch (e) {
      print('Error saving wallet data: $e');
    }
  }

  bool hasSufficientBalance(double amount) {
    return balance.value >= amount;
  }

  Future<bool> deductAmount(double amount) async {
    if (hasSufficientBalance(amount)) {
      balance.value -= amount;
      await saveWalletData();
      return true;
    }
    return false;
  }

  Future<void> addAmount(double amount) async {
    balance.value += amount;
    await saveWalletData();
  }

  Future<void> addJoinedTournament(int tournamentId) async {
    if (!joinedTournamentIds.contains(tournamentId)) {
      joinedTournamentIds.add(tournamentId);
      await saveWalletData();
    }
  }

  bool hasJoinedTournament(int tournamentId) {
    return joinedTournamentIds.contains(tournamentId);
  }

  Future<void> resetWallet() async {
    balance.value = AppConstants.initialWalletBalance; // Using constant
    joinedTournamentIds.clear();
    await saveWalletData();
  }

  Future<void> clearWalletOnLogout() async {
    await _storageService.clearWallet();
    balance.value = AppConstants.initialWalletBalance; // Using constant
    joinedTournamentIds.clear();
  }
}