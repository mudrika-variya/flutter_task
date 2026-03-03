class AppConstants {
  // API
  static const String baseUrl = 'https://dummyjson.com';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';

  // Storage Keys
  static const String storageUserKey = 'user';
  static const String storageTokenKey = 'token';
  static const String storageRefreshTokenKey = 'refreshToken';
  static const String storageWalletBalanceKey = 'wallet_balance';
  static const String storageJoinedTournamentsKey = 'joined_tournaments';

  // Wallet
  static const double initialWalletBalance = 500.0;

  // Tournament
  static const int defaultPageSize = 10;
  static const int maxTournamentSlots = 100;

  // Validation
  static const int minPasswordLength = 6;
  static const int minUsernameLength = 3;

  // UI
  static const Duration snackBarDuration = Duration(seconds: 2);
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashDelay = Duration(seconds: 1);

  // Messages
  static const String errorGeneric = 'Something went wrong';
  static const String errorNetwork = 'Network error occurred';
  static const String errorInvalidCredentials = 'Invalid username or password';
  static const String errorTournamentFull = 'Tournament is full';
  static const String errorAlreadyJoined = 'Already joined this tournament';
  static const String errorInsufficientBalance = 'Insufficient balance';

  // Success Messages
  static const String successLogin = 'Login successful';
  static const String successLogout = 'Logged out successfully';
  static const String successJoinTournament = 'Successfully joined tournament!';

  // Test Credentials
  static const String testUsername = 'emilys';
  static const String testPassword = 'emilyspass';
}