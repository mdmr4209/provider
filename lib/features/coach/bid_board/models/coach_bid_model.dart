class CoachBidSlotModel {
  final String id;
  final String rank;
  final String title;
  final String startingBid;
  final String topBid;
  final String hexColor; // "0xFFC19E5F"

  CoachBidSlotModel({
    required this.id,
    required this.rank,
    required this.title,
    required this.startingBid,
    required this.topBid,
    required this.hexColor,
  });

  factory CoachBidSlotModel.fromJson(Map<String, dynamic> json) {
    return CoachBidSlotModel(
      id: json['id'] ?? '',
      rank: json['rank'] ?? '',
      title: json['title'] ?? '',
      startingBid: json['startingBid'] ?? '',
      topBid: json['topBid'] ?? '',
      hexColor: json['hexColor'] ?? '0xFFFFFFFF',
    );
  }
}
