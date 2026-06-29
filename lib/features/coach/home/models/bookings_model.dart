class BookingsModel {
  final List<dynamic>? current;
  final List<dynamic>? history;

  BookingsModel({this.current, this.history});

  factory BookingsModel.fromJson(Map<String, dynamic> json) {
    return BookingsModel(
      current: json['current'] as List<dynamic>?,
      history: json['history'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'current': this.current, 'history': this.history};
  }
}
