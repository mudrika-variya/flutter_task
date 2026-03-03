import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import 'wallet_controller.dart';
import '../../core/constants/app_constants.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final user = Rx<UserModel?>(null);
  final isCheckingAuth = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkLoginStatus() async {
    try {
      isCheckingAuth.value = true;
      final loggedIn = await _authRepository.isLoggedIn();

      if (loggedIn) {
        final userData = await _authRepository.getCurrentUser();
        if (userData != null) {
          user.value = userData;
          isLoggedIn.value = true;
          print('User logged in: ${userData.firstName} ${userData.lastName}');

          // Load wallet data when user is logged in
          final walletController = Get.find<WalletController>();
          await walletController.loadWalletData();
        } else {
          await _authRepository.logout();
          isLoggedIn.value = false;
        }
      } else {
        isLoggedIn.value = false;
        print('No user logged in');
      }
    } catch (e) {
      print('Error checking login status: $e');
      isLoggedIn.value = false;
    } finally {
      isCheckingAuth.value = false;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;

      print('Attempting login with username: $username');
      final userData = await _authRepository.login(username, password);

      user.value = userData;
      isLoggedIn.value = true;

      // Load wallet data after successful login
      final walletController = Get.find<WalletController>();
      await walletController.loadWalletData();

      Get.snackbar(
        'Success',
        'Welcome ${userData.firstName}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: AppConstants.snackBarDuration,
      );

      // Navigate to main screen with bottom nav
      Get.offAllNamed('/main');
    } catch (e) {
      print('Login error in controller: $e');
      Get.snackbar(
        'Error',
        AppConstants.errorInvalidCredentials,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: AppConstants.snackBarDuration,
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Clear wallet data
      final walletController = Get.find<WalletController>();
      await walletController.clearWalletOnLogout();

      // Clear auth data
      await _authRepository.logout();

      isLoggedIn.value = false;
      user.value = null;

      Get.snackbar(
        'Success',
        AppConstants.successLogout,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: AppConstants.snackBarDuration,
      );

      // Navigate to login
      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  String getDisplayName() {
    if (user.value != null) {
      return '${user.value!.firstName} ${user.value!.lastName}';
    }
    return 'User';
  }

  String? getProfileImage() {
    return user.value?.image;
  }

  String getUsername() {
    return user.value?.username ?? 'username';
  }

  String getEmail() {
    return user.value?.email ?? 'email@example.com';
  }
}