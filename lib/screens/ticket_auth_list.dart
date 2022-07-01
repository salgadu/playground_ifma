import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/app_state.dart';
import 'package:playground_ifma/models/ticket_auth.dart';
import 'package:playground_ifma/screens/ticket_auth_detail.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'package:playground_ifma/util/messages.dart';

class TicketAuthListScreen extends StatefulWidget {
  static const routeName = '/ticket_auth_list';

  const TicketAuthListScreen({Key? key}) : super(key: key);

  @override
  _TicketAuthListScreenState createState() => _TicketAuthListScreenState();
}

class _TicketAuthListScreenState extends State<TicketAuthListScreen> {
  late String student;

  @override
  void initState() {
    super.initState();
    student = Provider.of<AppState>(context, listen: false).user.id;
  }

  Future<List<TicketAuth>> updateList() async {
    List<TicketAuth>? tckLst = await ticketAuthList(student);
    if (tckLst != null) {
      Provider.of<AppState>(context, listen: false).setTicketsAuth(tckLst);
      return tckLst;
    } else {
      Message.showError(context,
          'Não foi possível atualizar a lista de tickets. Verifique sua conexão.');
      return Provider.of<AppState>(context, listen: false).authorizations;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Autorizações Permanentes"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Center(
            child: FutureBuilder<List<TicketAuth>>(
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
                                    '${TicketStyle.getMealStr(snapshot.data![index].meal)} - ${TicketStyle.getStatusStr(snapshot.data![index].status)}',
                                    style: Style.defaultTextStyle),
                                subtitle: Text(snapshot.data![index].daysStr),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TicketAuthDetailScreen(
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
