enum Meal { breakfast, lunch, dinner, supper }
enum Status { analysis, payment, cancelled, refused, approved, used }

class Ticket {
  late String id;
  late String date;
  late String student;
  late Meal meal;
  late Status status;
  late String reason;
  late String text;

  Ticket();

  Ticket.init(this.student, this.meal, this.reason, this.text, this.status)
      : id = '',
        date = '';

  DateTime get dateTime => DateTime.parse(date);
  String get dateStr => date;

  set setId(String idx) {
    id = idx;
  }

   void approve() {
    status = Status.approved;
  }

}
