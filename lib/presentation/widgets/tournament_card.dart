import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/tournament_model.dart';

class TournamentCard extends StatelessWidget {
  final TournamentModel tournament;
  final VoidCallback onJoin;

  const TournamentCard({
    super.key,
    required this.tournament,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final isFull = tournament.availableSlots == 0;
    final isJoined = tournament.isJoined;

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isFull || isJoined ? null : onJoin,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tournament Name and Status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tournament.name,
                        style: AppTheme.heading2,
                      ),
                    ),
                    if (isJoined)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppTheme.successColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Joined',
                              style: TextStyle(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Prize Pool and Entry Fee
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.emoji_events,
                        label: 'Prize Pool',
                        value: '₹${tournament.prizePool}',
                        color: AppTheme.warningColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.account_balance_wallet,
                        label: 'Entry Fee',
                        value: '₹${tournament.entryFee}',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Slots and Status
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.people,
                        label: 'Available Slots',
                        value: '${tournament.availableSlots}/${tournament.totalSlots}',
                        color: AppTheme.successColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.trending_up,
                        label: 'Status',
                        value: isFull ? 'Full' : 'Open',
                        color: isFull ? AppTheme.errorColor : AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Join Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (isFull || isJoined) ? null : onJoin,
                    style: isJoined
                        ? ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor.withOpacity(0.1),
                      foregroundColor: AppTheme.successColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                        : isFull
                        ? AppTheme.dangerButton
                        : AppTheme.primaryButton,
                    child: Text(
                      isJoined
                          ? 'Already Joined'
                          : isFull
                          ? 'Tournament Full'
                          : 'Join Tournament',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.caption,
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}