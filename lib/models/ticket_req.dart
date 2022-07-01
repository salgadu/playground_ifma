import 'package:playground_ifma/models/ticket.dart';

class TicketReq extends Ticket {
  late String payment;

  TicketReq(String student, Meal meal, String reason, String text)
      : payment = '',
        super.init(student, meal, reason, text, Status.analysis);

  TicketReq.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    date = json['date'];
    status = (json['status'] >= 0 && json['status'] < Status.values.length)
        ? Status.values[json['status']]
        : Status.analysis;
    student = json['student'];
    meal = (json['meal'] >= 0 && json['meal'] < Meal.values.length)
        ? Meal.values[json['meal']]
        : Meal.lunch;
    reason = json['reason'];
    text = json['text'];
    payment = json['payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['date'] = date;
    data['status'] = status.index;
    data['student'] = student;
    data['meal'] = meal.index;
    data['reason'] = reason;
    data['text'] = text;
    data['payment'] = payment;
    return data;
  }

  void cancel() {
    status = Status.cancelled;
  }

  @override
  bool operator ==(Object other) => other is Ticket && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
