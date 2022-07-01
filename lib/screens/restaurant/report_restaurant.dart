import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/models/ticket_req.dart';
import 'package:playground_ifma/screens/ticket_report.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'package:playground_ifma/util/ifma_rules.dart';
import 'package:playground_ifma/util/messages.dart';

class ReportRestaurantScreen extends StatefulWidget {
  static const routeName = '/report_restaurant';

  const ReportRestaurantScreen({Key? key}) : super(key: key);

  @override
  _ReportRestaurantScreenState createState() => _ReportRestaurantScreenState();
}

class _ReportRestaurantScreenState extends State<ReportRestaurantScreen> {
  late Map<String, List<TicketReq>> statuses;
  DateTime day = DateTime.now();

  Future<List<String>> updateStatusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> validatedTickets =
        prefs.getStringList('validatedTickets') ?? [];

    String response =
        await changeTicketsStatus(false, validatedTickets, Status.used);
    if (response == 'OK') {
      List<TicketReq>? tickets = await ticketReportList(day);
      if (tickets != null) {
        List<String> uploadedTickets = tickets
            .where((ticket) => (ticket.status == Status.used))
            .map((t) => t.id)
            .toList();

        if (IFMARules.checkDateToday(day)) {
          prefs.setStringList('uploadedTickets', uploadedTickets);
        }

        prefs.setStringList('validatedTickets', []);

        Map<String, List<TicketReq>> statusMap = {};
        String statusName = '';
        for (TicketReq t in tickets) {
          if ((t.status == Status.approved) ||
              (t.status == Status.payment) ||
              (t.status == Status.used)) {
            statusName = TicketStyle.getStatusStr(t.status);
            if (t.status == Status.used) {
              if (IFMARules.isStudentHighSchool(t.student)) {
                statusName = '${TicketStyle.getMealStr(t.meal)} - Básico';
              } else {
                statusName = '${TicketStyle.getMealStr(t.meal)} - Superior';
              }
            }

            if (statusMap.containsKey(statusName)) {
              statusMap[statusName]!.add(t);
            } else {
              statusMap[statusName] = [t];
            }
          }
        }
        statuses = statusMap;
        return statusMap.keys.toList();
      }
    }

    Message.showError(context,
        'Não foi possível atualizar a lista de tickets. Verifique sua conexão.');
    statuses = {};
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Data: ${TicketStyle.getDateStr(day)}',
                      style: Style.subtitleTextStyle,
                    ),
                    Style.formSizedBox,
                    IconButton(
                        onPressed: () async {
                          var pickDate = await showDatePicker(
                              context: context,
                              initialDate: day,
                              firstDate:
                                  day.subtract(const Duration(days: 365)),
                              lastDate: day.add(const Duration(days: 365)));

                          if (pickDate != null) {
                            setState(() {
                              day = pickDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today,
                            color: Style.primaryColor)),
                  ],
                ),
                Style.formSizedBox,
                Expanded(
                  child: FutureBuilder<List<String>>(
                      future: updateStatusList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Style.padding),
                                  child: Container(
                                    decoration: Style.boxDecoration,
                                    child: ListTile(
                                      leading: TicketStyle.getStatusWidget(
                                          statuses[snapshot.data![index]]!
                                              .first
                                              .status),
                                      title: Text(snapshot.data![index],
                                          style: Style.defaultTextStyle),
                                      trailing: Text(
                                          'Total: ${statuses[snapshot.data![index]]!.length}'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TicketReportScreen(statuses[
                                                        snapshot.data![index]]!
                                                    .reversed
                                                    .toList()),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                                child: Text(
                              'Nenhum ticket solicitado até o momento.',
                              textAlign: TextAlign.center,
                              style: Style.subtitleTextStyle,
                            ));
                          }
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text(
                            'Erro ao carregar os dados.',
                            textAlign: TextAlign.center,
                            style: Style.subtitleTextStyle,
                          ));
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              Style.sizedBox,
                              Text('Carregando dados...',
                                  style: Style.subtitleTextStyle),
                            ],
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
