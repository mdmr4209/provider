class BookingModel {
  final String id;
  final String sessionName;
  final String coachName;
  final String date;
  final String time;
  final String amount;

  BookingModel({
    required this.id,
    required this.sessionName,
    required this.coachName,
    required this.date,
    required this.time,
    required this.amount,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      sessionName: json['sessionName'] ?? '',
      coachName: json['coachName'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      amount: json['amount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionName': sessionName,
      'coachName': coachName,
      'date': date,
      'time': time,
      'amount': amount,
    };
  }
}
