import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/tournament_repository.dart';
import '../../data/models/tournament_model.dart';
import 'wallet_controller.dart';
import '../../core/constants/app_constants.dart';

class TournamentController extends GetxController {
  final TournamentRepository _repository = TournamentRepository();
  final WalletController _walletController = Get.find<WalletController>();

  final tournaments = <TournamentModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchTournaments();
  }

  Future<void> fetchTournaments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _repository.getTournaments();

      // Check which tournaments the user has already joined
      for (var tournament in data) {
        if (_walletController.hasJoinedTournament(tournament.id)) {
          tournament.isJoined = true;
        }
      }

      tournaments.assignAll(data);
    } catch (e) {
      errorMessage.value = AppConstants.errorGeneric; // Using constant
      print('Error fetching tournaments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> joinTournament(TournamentModel tournament) async {
    try {
      // Check if tournament is full
      if (tournament.availableSlots <= 0) {
        Get.snackbar(
          'Cannot Join',
          AppConstants.errorTournamentFull, // Using constant
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: AppConstants.snackBarDuration, // Using constant
        );
        return false;
      }

      // Check if already joined
      if (tournament.isJoined || _walletController.hasJoinedTournament(tournament.id)) {
        Get.snackbar(
          'Cannot Join',
          AppConstants.errorAlreadyJoined, // Using constant
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: AppConstants.snackBarDuration, // Using constant
        );
        return false;
      }

      // Check wallet balance
      if (!_walletController.hasSufficientBalance(tournament.entryFee)) {
        Get.snackbar(
          'Insufficient Balance',
          'Need ₹${tournament.entryFee} but have ₹${_walletController.balance.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: AppConstants.snackBarDuration, // Using constant
        );
        return false;
      }

      // Deduct entry fee and save to storage
      bool deducted = await _walletController.deductAmount(tournament.entryFee);
      if (!deducted) return false;

      // Add to joined tournaments
      await _walletController.addJoinedTournament(tournament.id);

      // Update tournament in list
      final index = tournaments.indexWhere((t) => t.id == tournament.id);
      if (index != -1) {
        final updatedTournament = tournament.copyWith(
          availableSlots: tournament.availableSlots - 1,
          isJoined: true,
        );
        tournaments[index] = updatedTournament;

        Get.snackbar(
          'Success',
          AppConstants.successJoinTournament, // Using constant
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: AppConstants.snackBarDuration, // Using constant
        );
        return true;
      }

      return false;
    } catch (e) {
      print('Error joining tournament: $e');
      Get.snackbar(
        'Error',
        AppConstants.errorGeneric, // Using constant
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: AppConstants.snackBarDuration, // Using constant
      );
      return false;
    }
  }
}