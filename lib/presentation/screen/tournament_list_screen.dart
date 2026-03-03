import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dar.dart';
import '../../controllers/tournament_controller.dart';
import '../../controllers/wallet_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/tournament_card.dart';
import '../widgets/loading_widget.dart';

class TournamentListScreen extends StatelessWidget {
  const TournamentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Tournaments'),
            floating: true,
            snap: true,
          ),
          const SliverToBoxAdapter(
            child: UserWalletCard(),
          ),
          const TournamentListContent(),
        ],
      ),
    );
  }
}

// Separate widget for user wallet card
class UserWalletCard extends StatelessWidget {
  const UserWalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final WalletController walletController = Get.find<WalletController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Row(
          children: [
            // User Avatar
            _buildUserAvatar(authController),
            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  _buildUserName(authController),
                  const SizedBox(height: 8),
                  _buildWalletBalance(walletController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(AuthController authController) {
    return Obx(() {
      final imageUrl = authController.getProfileImage();
      return Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          backgroundImage: imageUrl != null && imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : null,
          child: imageUrl == null || imageUrl.isEmpty
              ? const Icon(Icons.person, size: 30, color: AppTheme.primaryColor)
              : null,
        ),
      );
    });
  }

  Widget _buildUserName(AuthController authController) {
    return Obx(() => Text(
      authController.getEmail(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      overflow: TextOverflow.ellipsis,
    ));
  }

  Widget _buildWalletBalance(WalletController walletController) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '₹${walletController.balance.value.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ));
  }
}

// Separate widget for tournament list content
class TournamentListContent extends StatelessWidget {
  const TournamentListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TournamentController tournamentController = Get.find<TournamentController>();

    return Obx(() {
      // Show loading state
      if (tournamentController.isLoading.value) {
        return const SliverFillRemaining(
          child: LoadingWidget(),
        );
      }

      // Show error state
      if (tournamentController.errorMessage.isNotEmpty) {
        return SliverFillRemaining(
          child: _buildErrorState(tournamentController),
        );
      }

      // Show empty state
      if (tournamentController.tournaments.isEmpty) {
        return SliverFillRemaining(
          child: _buildEmptyState(tournamentController),
        );
      }

      // Show tournament list
      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final tournament = tournamentController.tournaments[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TournamentCard(
                  tournament: tournament,
                  onJoin: () => tournamentController.joinTournament(tournament),
                ),
              );
            },
            childCount: tournamentController.tournaments.length,
          ),
        ),
      );
    });
  }

  Widget _buildErrorState(TournamentController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: AppTheme.bodyText2,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.fetchTournaments,
            style: AppTheme.primaryButton,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(TournamentController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_esports,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tournaments available',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new tournaments',
            style: AppTheme.bodyText2,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.fetchTournaments,
            style: AppTheme.primaryButton,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}