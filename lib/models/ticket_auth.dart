import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'dart:convert';

enum Days { seg, ter, qua, qui, sex, sab, dom }

class TicketAuth extends Ticket {
  late Set<Days> days;

  TicketAuth(String student, Meal meal, String reason, String text, this.days)
      : super.init(student, meal, reason, text, Status.analysis);

  TicketAuth.fromJson(Map<String, dynamic> json) {
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

    List<dynamic> lstJson = jsonDecode(json['days']);
    days = Set.from(lstJson.map((i) => Days.values[i]));
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
    data['days'] = jsonEncode(days.map((day) => day.index).toList());

    return data;
  }

  String get daysStr => days.map((d) => TicketStyle.getDaysStr(d)).toString();

  @override
  bool operator ==(Object other) => other is TicketAuth && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
