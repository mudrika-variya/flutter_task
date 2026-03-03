class TournamentModel {
  final int id;
  final String name;
  final double entryFee;
  final double prizePool;
  final int totalSlots;
  int availableSlots;
  bool isJoined;

  TournamentModel({
    required this.id,
    required this.name,
    required this.entryFee,
    required this.prizePool,
    required this.totalSlots,
    required this.availableSlots,
    this.isJoined = false,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'],
      name: json['name'],
      entryFee: json['entryFee'].toDouble(),
      prizePool: json['prizePool'].toDouble(),
      totalSlots: json['totalSlots'],
      availableSlots: json['availableSlots'],
    );
  }

  TournamentModel copyWith({
    int? id,
    String? name,
    double? entryFee,
    double? prizePool,
    int? totalSlots,
    int? availableSlots,
    bool? isJoined,
  }) {
    return TournamentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      entryFee: entryFee ?? this.entryFee,
      prizePool: prizePool ?? this.prizePool,
      totalSlots: totalSlots ?? this.totalSlots,
      availableSlots: availableSlots ?? this.availableSlots,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}