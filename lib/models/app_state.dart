import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playground_ifma/models/ticket_auth.dart';
import 'package:playground_ifma/models/ticket_req.dart';
import 'package:playground_ifma/models/user.dart';
import 'dart:convert';

class AppState extends ChangeNotifier {
  late User _user;
  late SharedPreferences prefs;
  List<TicketAuth> _ticketsAuth = [];
  List<TicketReq> _ticketsReq = [];
  List<TicketReq> _approved = [];

  AppState() {
    _ticketsAuth = [];
    _ticketsReq = [];
    _approved = [];
    SharedPreferences.getInstance().then((value) {
      prefs = value;

      // prefs.setStringList('tickets', []);
      // prefs.setStringList('authorizations', []);
      // prefs.setStringList('approved', []);

      List<String> data = prefs.getStringList('tickets') ?? [];
      for (String ticketStr in data) {
        _ticketsReq.add(TicketReq.fromJson(json.decode(ticketStr)));
      }

      data = prefs.getStringList('authorizations') ?? [];
      for (String ticketStr in data) {
        _ticketsAuth.add(TicketAuth.fromJson(json.decode(ticketStr)));
      }

      data = prefs.getStringList('approved') ?? [];
      for (String ticketStr in data) {
        _approved.add(TicketReq.fromJson(json.decode(ticketStr)));
      }
    });
  }

  User get user => _user;
  List<TicketAuth> get authorizations =>
      _ticketsAuth.where((auth) => auth.student == user.id).toList();
  List<TicketReq> get tickets =>
      _ticketsReq.where((ticket) => ticket.student == user.id).toList();
  List<TicketReq> get approved =>
      _approved.where((ticket) => ticket.student == user.id).toList();

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void addTicketAuth(TicketAuth ticket) {
    _ticketsAuth.add(ticket);
    saveTicketsAuth();
    notifyListeners();
  }

  void addTicketReq(TicketReq ticket) {
    _ticketsReq.add(ticket);
    saveTicketsReq();
    notifyListeners();
  }

  void approveTicket(String id) {
    for (TicketReq t in _ticketsReq) {
      if (t.id == id) {
        t.approve();
        _approved.add(t);
      }
    }
    saveApproved();
    notifyListeners();
  }

  void clearApproved() {
    _approved.clear();
    saveApproved();
    notifyListeners();
  }

  void setTicketsAuth(List<TicketAuth> tickets) {
    _ticketsAuth = tickets;
    saveTicketsAuth();
    notifyListeners();
  }

  void setTickets(List<TicketReq> tickets) {
    _ticketsReq = tickets;
    saveTicketsReq();
    notifyListeners();
  }

  void saveTicketsAuth() {
    List<String> data = [];
    for (TicketAuth ticket in _ticketsAuth) {
      data.add(json.encode(ticket));
    }
    prefs.setStringList('authorizations', data);
  }

  void saveTicketsReq() {
    List<String> data = [];
    for (TicketReq ticket in _ticketsReq) {
      data.add(json.encode(ticket));
    }
    prefs.setStringList('tickets', data);
  }

  void saveApproved() {
    List<String> data = [];
    for (TicketReq ticket in _approved) {
      data.add(json.encode(ticket));
    }
    prefs.setStringList('approved', data);
  }
}
