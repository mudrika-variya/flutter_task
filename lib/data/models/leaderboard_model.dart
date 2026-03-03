class LeaderboardModel {
  final int rank;
  final String playerName;
  final int points;

  LeaderboardModel({
    required this.rank,
    required this.playerName,
    required this.points,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      rank: json['rank'],
      playerName: json['playerName'],
      points: json['points'],
    );
  }
}