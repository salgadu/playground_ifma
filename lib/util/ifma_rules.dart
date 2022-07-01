import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:playground_ifma/models/ticket_req.dart';
import 'package:crypto/crypto.dart';

class IFMARules {
  static const String paymentKey = 'T1cK3t*1Fm4';

  static saveLogin(String id, String password) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('user', id);
      prefs.setString('password', password);
    });
  }

  static clearLogin() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('user');
      prefs.remove('password');
    });
  }

  static String qrCodeInfo(TicketReq ticket) {
    var data = {
      'id': ticket.id,
      'student': ticket.student,
      'status': ticket.status.index,
      'date': ticket.dateStr
    };
    return convert.jsonEncode(data);
  }

  static bool checkDateToday(DateTime date) {
    DateTime today = DateTime.now();
    return (date.day == today.day) &&
        (date.month == today.month) &&
        (date.year == today.year);
  }

  static String ticketKey(String id) {
    var bytes = convert.utf8.encode(id + paymentKey);
    String digest =
        sha1.convert(bytes).toString().replaceAll(RegExp(r'[^0-9]'), '');
    return digest.substring(digest.length - 4);
  }

  static bool isStudentHighSchool(String student) {
    String adm =
        "20221AD.CAX|20211AD.CAX|20201AD.CAX|20191AD.CAX|20181AD.CAX|20171CXAD";
    String agroind =
        "20221A.CAX|20211A.CAX|20201A.CAX|20191A.CAX|20181A.CAX|20171CXA|20161CXIC";
    String agropec =
        "20221AP.CAX|20211AP.CAX|20201AP.CAX|20191AP.CAX|20181AP.CAX|20171CXAP|20221APE.CAX";
    String info =
        "20221IC.CAX|20211IC.CAX|20201IC.CAX|20191CXIC|20191IC.CAX|20181IC.CAX|20171CXIC|20161CXIC";

    String com = "20221COM.CAX";

    String pronera = "20191PN.CAX";

    String exceptions = "20192ZOO.CAX0046|20192ZOO.CAX0008";

    String classes = "$adm|$agroind|$agropec|$info|$com|$pronera|$exceptions";

    return student.startsWith(RegExp(classes));
  }
}
