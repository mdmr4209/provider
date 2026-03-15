class PointTransaction {
  final String title;
  final String date;
  final int points;
  final bool isCredit; // true for adding points, false for spending

  PointTransaction({
    required this.title,
    required this.date,
    required this.points,
    this.isCredit = true,
  });
}