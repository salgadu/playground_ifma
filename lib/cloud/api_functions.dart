import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/models/ticket_auth.dart';
import 'package:playground_ifma/models/ticket_req.dart';

import 'api_routes.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

Future<String> loginStudent(String student, String password) async {
  Uri url = Uri.http(SERVER, LOGIN);

  return http
      .post(url,
          body: convert.jsonEncode({'matricula': student, 'senha': password}))
      .then((response) {
    if (response.body.isNotEmpty) {
      return convert.jsonDecode(response.body) as String;
    } else {
      return "Usuário ou senha inválidos";
    }
  }).catchError((Object error) => 'Falha de conexão. Tente novamente.');
}

Future<String> requestTicketAuth(TicketAuth t) async {
  Uri url = Uri.http(SERVER, TICKET_AUTH_REQUEST);

  return http.post(url, body: convert.jsonEncode(t.toJson())).then((response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }).catchError((Object error) => '');
}

Future<String> requestTicket(TicketReq t) async {
  Uri url = Uri.http(SERVER, TICKET_REQUEST);

  var data = {
    'student': t.student,
    'date': t.dateStr,
    'status': t.status.index,
    'meal': t.meal.index,
    'reason': t.reason,
    'text': t.text,
  };

  return http.post(url, body: convert.jsonEncode(data)).then((response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }).catchError((Object error) => '');
}

Future<String> checkDoubleTicket(String student, Meal meal) async {
  Uri url = Uri.http(SERVER, TICKET_CHECK_DOUBLE);

  return http
      .post(url,
          body: convert.jsonEncode({'student': student, 'meal': meal.index}))
      .then((response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }).catchError((Object error) => '');
}

Future<String> confirmTicketAuth(TicketAuth t) async {
  Uri url = Uri.http(SERVER, TICKET_AUTH_CONFIRM);

  return http.post(url, body: convert.jsonEncode(t.toJson())).then((response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }).catchError((Object error) => '');
}

Future<String> cancelTicket(String id) async {
  Uri url = Uri.http(SERVER, TICKET_CANCEL);

  return http.post(url, body: convert.jsonEncode({'id': id})).then((response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }).catchError((Object error) => '');
}

Future<List<TicketAuth>?> ticketAuthList(String student) async {
  Uri url = Uri.http(SERVER, TICKETS_AUTH_STUDENT);

  var data = {
    'student': student,
  };

  return http.post(url, body: convert.jsonEncode(data)).then((response) {
    if (response.statusCode == 200) {
      List<dynamic> ticketsJson =
          convert.jsonDecode(response.body) as List<dynamic>;
      List<TicketAuth> tickets = [];
      for (var tckJson in ticketsJson) {
        tickets.add(TicketAuth.fromJson(tckJson));
      }

      return tickets;
    } else {
      return null;
    }
  }).catchError((Object error) => null);
}

Future<List<TicketReq>?> ticketList(String student) async {
  Uri url = Uri.http(SERVER, TICKETS_STUDENT);

  var data = {
    'student': student,
  };

  return http.post(url, body: convert.jsonEncode(data)).then((response) {
    if (response.statusCode == 200) {
      List<dynamic> ticketsJson =
          convert.jsonDecode(response.body) as List<dynamic>;
      List<TicketReq> tickets = [];
      for (var tckJson in ticketsJson) {
        tickets.add(TicketReq.fromJson(tckJson));
      }

      return tickets;
    } else {
      return null;
    }
  }).catchError((Object error) => null);
}

Future<List<TicketAuth>?> authEvaluateList() async {
  Uri url = Uri.http(SERVER, AUTH_EVALUATE);

  return http.post(url).then((response) {
    if (response.statusCode == 200) {
      List<dynamic> ticketsJson =
          convert.jsonDecode(response.body) as List<dynamic>;
      List<TicketAuth> tickets = [];
      for (var tckJson in ticketsJson) {
        tickets.add(TicketAuth.fromJson(tckJson));
      }
      return tickets;
    } else {
      return null;
    }
  }).catchError((Object error) => null);
}

Future<List<TicketReq>?> ticketEvaluateList() async {
  Uri url = Uri.http(SERVER, TICKETS_EVALUATE);

  return http.post(url).then((response) {
    if (response.statusCode == 200) {
      List<dynamic> ticketsJson =
          convert.jsonDecode(response.body) as List<dynamic>;
      List<TicketReq> tickets = [];
      for (var tckJson in ticketsJson) {
        tickets.add(TicketReq.fromJson(tckJson));
      }
      return tickets;
    } else {
      return null;
    }
  }).catchError((Object error) => null);
}

Future<String> approveTickets(List<String> ticketsId,
    {permanent = false}) async {
  return changeTicketsStatus(permanent, ticketsId, Status.approved);
}

Future<String> changeTicketsStatus(
    bool permanent, List<String> ticketsId, Status status) async {
  Uri url = Uri.http(SERVER, TICKET_STATUS_CHANGE);

  var data = {
    'tickets': ticketsId,
    'status': status.index,
    'permanent': permanent,
  };

  return http.post(url, body: convert.jsonEncode(data)).then((response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }).catchError((Object error) => '');
}

Future<String> confirmTicketsPayment(List<String> ticketsId) async {
  Uri url = Uri.http(SERVER, TICKETS_PAYMENT);

  var data = {
    'tickets': ticketsId,
  };

  return http.post(url, body: convert.jsonEncode(data)).then((response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }).catchError((Object error) => '');
}

Future<List<TicketReq>?> ticketReportList(DateTime day) async {
  Uri url = Uri.http(SERVER, TICKETS_REPORT);

  return http
      .post(url, body: convert.jsonEncode({'day': day.toIso8601String()}))
      .then((response) {
    if (response.statusCode == 200) {
      if (response.body != '') {
        List<dynamic> ticketsJson =
            convert.jsonDecode(response.body) as List<dynamic>;
        List<TicketReq> tickets = [];
        for (var tckJson in ticketsJson) {
          tickets.add(TicketReq.fromJson(tckJson));
        }
        return tickets;
      }
    }
    return null;
  }).catchError((Object error) => null);
}


//TODO implementar função countValidated