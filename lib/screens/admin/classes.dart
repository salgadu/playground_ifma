import 'package:flutter/material.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/screens/admin/ticket_evaluate.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/util/messages.dart';

class ClassesScreen extends StatefulWidget {
  final bool permanent;

  const ClassesScreen(this.permanent, {Key? key}) : super(key: key);

  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  late Map<String, List<Ticket>> classes;
  late List<Ticket> tickets;

  Future<List<String>> updateEvaluateList() async {
    var response = (widget.permanent)
        ? await authEvaluateList()
        : await ticketEvaluateList();
    if (response == null) {
      Message.showError(context,
          'Não foi possível atualizar a lista de tickets. Verifique sua conexão.');
      tickets = [];
      return [];
    } else {
      tickets = response;
      classes = {};
      String className = '';
      for (Ticket t in tickets) {
        className = t.student.substring(0, t.student.length - 4);
        if (classes.containsKey(className)) {
          classes[className]!.add(t);
        } else {
          classes[className] = [t];
        }
      }
      return classes.keys.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitações por Turma"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Center(
            child: FutureBuilder<List<String>>(
                future: updateEvaluateList(),
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
                                title: Text('Turma ${snapshot.data![index]}',
                                    style: Style.defaultTextStyle),
                                subtitle: Text(
                                    'Total: ${classes[snapshot.data![index]]!.length}'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TicketEvaluateScreen(
                                              classes[snapshot.data![index]]!,
                                              widget.permanent),
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
