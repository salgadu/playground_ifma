import 'package:flutter/material.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/models/ticket_auth.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:intl/intl.dart';

class TicketStyle {
  static String formatName(String name) {
    if (name.isEmpty) return '';

    List<String> strLst = name.split(' ');

    if (strLst.length < 2) return name;

    String res = strLst[0] + ' ';
    for (var s in strLst.sublist(1, strLst.length - 1)) {
      if (s.length > 3) res += '${s[0].toUpperCase()}. ';
    }
    res += strLst[strLst.length - 1];

    return res;
  }

  static Color getStatusColor(Status status) {
    switch (status) {
      case Status.approved:
        return Style.primaryColor;
      case Status.used:
        return Style.primaryColor;
      case Status.cancelled:
        return Colors.red.shade500;
      case Status.refused:
        return Colors.red.shade500;
      default:
        return Colors.amber.shade700;
    }
  }

  static Icon getStatusIcon(Status status) {
    switch (status) {
      case Status.approved:
        return const Icon(Icons.check_circle, color: Colors.white);
      case Status.cancelled:
        return const Icon(Icons.stop, color: Colors.white);
      case Status.payment:
        return const Icon(Icons.lock, color: Colors.white);
      case Status.refused:
        return const Icon(Icons.close, color: Colors.white);
      case Status.used:
        return const Icon(Icons.food_bank, color: Colors.white);
      default:
        return const Icon(Icons.access_time, color: Colors.white);
    }
  }

  static Widget getStatusWidget(Status status) {
    return CircleAvatar(
      backgroundColor: getStatusColor(status),
      child: TicketStyle.getStatusIcon(status),
    );
  }

  static String getWeekDay(DateTime date) {
    String weekDay = DateFormat("EEEE", "pt_BR").format(date);
    return weekDay[0].toUpperCase() + weekDay.substring(1);
  }

  static String getDateStr(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  static String getDateFull(DateTime date) {
    return DateFormat("d 'de' MMMM 'de' y", "pt_BR").format(date);
  }

  static String getStatusStr(Status status) {
    switch (status) {
      case Status.analysis:
        return 'Em análise';
      case Status.payment:
        return 'Aguardando pagamento';
      case Status.cancelled:
        return 'Cancelado';
      case Status.refused:
        return 'Recusado';
      case Status.approved:
        return 'Aprovado';
      case Status.used:
        return 'Utilizado';
      default:
        return 'Erro: cod - status';
    }
  }

  static String getMealStr(Meal meal) {
    switch (meal) {
      case Meal.breakfast:
        return 'Café';
      case Meal.lunch:
        return 'Almoço';
      case Meal.dinner:
        return 'Jantar';
      case Meal.supper:
        return 'Ceia';
      default:
        return 'Erro: cod - refeição';
    }
  }

  static String getDaysStr(Days day) {
    switch (day) {
      case Days.seg:
        return 'Seg';
      case Days.ter:
        return 'Ter';
      case Days.qua:
        return 'Qua';
      case Days.qui:
        return 'Qui';
      case Days.sex:
        return 'Sex';
      case Days.sab:
        return 'Sab';
      case Days.dom:
        return 'Dom';
      default:
        return 'Erro: cod - dia';
    }
  }
}
