import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/leaderboard_repository.dart';
import '../../data/models/leaderboard_model.dart';

class LeaderboardController extends GetxController {
  final LeaderboardRepository _repository = LeaderboardRepository();

  final players = <LeaderboardModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final currentPage = 1.obs;
  final int pageSize = 20; // Changed to 20 as per requirement

  @override
  void onInit() {
    super.onInit();
    // Fetch initial 20 players
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLeaderboard();
    });
  }

  @override
  void onClose() {
    players.clear();
    super.onClose();
  }

  Future<void> fetchLeaderboard({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      players.clear();
      hasMore.value = true;
    }

    if (!hasMore.value || isLoading.value) return;

    try {
      isLoading.value = true;

      print('Fetching page ${currentPage.value} with size $pageSize');
      final data = await _repository.getLeaderboard(currentPage.value, pageSize);

      if (data.isEmpty) {
        hasMore.value = false;
        print('No more data available');
      } else {
        players.addAll(data);
        currentPage.value++;
        print('Loaded ${data.length} players. Total: ${players.length}');
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
      Get.snackbar(
        'Error',
        'Failed to load leaderboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    try {
      isLoadingMore.value = true;
      await fetchLeaderboard();
    } catch (e) {
      print('Error loading more: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshLeaderboard() async {
    await fetchLeaderboard(refresh: true);
  }

  // Get total players count
  int get totalPlayers => players.length;

  // Check if we have minimum 20 players
  bool get hasMinimumPlayers => players.length >= 20;
}