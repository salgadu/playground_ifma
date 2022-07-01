import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/app_state.dart';
import 'package:playground_ifma/models/ticket_req.dart';
import 'package:playground_ifma/screens/ticket_detail.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'package:playground_ifma/util/messages.dart';

class TicketListScreen extends StatefulWidget {
  static const routeName = '/ticket_list';

  const TicketListScreen({Key? key}) : super(key: key);

  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late String student;

  @override
  void initState() {
    super.initState();
    student = Provider.of<AppState>(context, listen: false).user.id;
  }

  Future<List<TicketReq>> updateList() async {
    List<String> ticketsId = Provider.of<AppState>(context, listen: false)
        .approved
        .map((e) => e.id)
        .toList();

    String response = await approveTickets(ticketsId);
    if (response == 'OK') {
      Provider.of<AppState>(context, listen: false).clearApproved();
    }

    List<TicketReq>? tckLst = await ticketList(student);
    if (tckLst != null) {
      Provider.of<AppState>(context, listen: false).setTickets(tckLst);
      List<TicketReq> approved =
          Provider.of<AppState>(context, listen: false).approved;
      for (TicketReq t in approved) {
        int idx = tckLst.indexOf(t);
        tckLst[idx] = t;
      }

      return tckLst;
    } else {
      Message.showError(context,
          'Não foi possível atualizar a lista de tickets. Verifique sua conexão.');
      return Provider.of<AppState>(context, listen: false).tickets;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Tickets"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Message.showMessage(
        //             context, 'Atualizando a lista de tickets...');
        //         updateList();
        //       },
        //       icon: const Icon(Icons.refresh))
        // ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Center(
            child: FutureBuilder<List<TicketReq>>(
                future: updateList(),
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
                                    snapshot.data![index].status),
                                title: Text(
                                    TicketStyle.getDateFull(
                                        snapshot.data![index].dateTime),
                                    style: Style.defaultTextStyle),
                                subtitle: Text(
                                    '${TicketStyle.getMealStr(snapshot.data![index].meal)} - ${TicketStyle.getStatusStr(snapshot.data![index].status)}'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TicketDetailScreen(
                                          snapshot.data![index]),
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
        ),
      ),
    );
  }
}
