import 'package:flutter/material.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/models/ticket_auth.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'package:playground_ifma/util/messages.dart';
import 'package:playground_ifma/util/ifma_rules.dart';

class TicketEvaluateScreen extends StatefulWidget {
  final List<Ticket> tickets;
  final bool permanent;
  const TicketEvaluateScreen(this.tickets, this.permanent, {Key? key})
      : super(key: key);

  @override
  _TicketEvaluateScreenState createState() => _TicketEvaluateScreenState();
}

class _TicketEvaluateScreenState extends State<TicketEvaluateScreen> {
  late bool selectAll;
  List<Ticket> selected = [];
  List<Ticket> filtered = [];
  bool loading = false;
  TextEditingController filterController = TextEditingController();

  @override
  void initState() {
    selectAll = true;

    selected.addAll(widget.tickets);
    filtered.addAll(widget.tickets);

    super.initState();
  }

  void approve() {
    if (selected.isEmpty) return;

    if (widget.permanent) {
      changeStatus(context, Status.approved);
    } else {
      if (IFMARules.isStudentHighSchool(widget.tickets.first.student)) {
        changeStatus(context, Status.approved);
      } else {
        changeStatus(context, Status.payment);
      }
    }
  }

  void refuse() {
    if (selected.isEmpty) return;
    changeStatus(context, Status.refused);
  }

  String showDate(Ticket t) {
    if (widget.permanent) {
      return (t as TicketAuth).daysStr;
    } else {
      return TicketStyle.getDateStr(t.dateTime);
    }
  }

  String formatTicketInfo(Ticket ticket) {
    if (ticket.text.isEmpty) {
      return '${TicketStyle.getMealStr(ticket.meal)} - ${showDate(ticket)}\n${ticket.reason}';
    } else {
      return '${TicketStyle.getMealStr(ticket.meal)} - ${showDate(ticket)}\n${ticket.reason}: ${ticket.text}';
    }
  }

  void filterTickets(String query) {
    filtered.clear();
    if (query.isNotEmpty) {
      List<Ticket> tmpList = [];
      for (var item in widget.tickets) {
        if (item.student.contains(query.toUpperCase())) {
          tmpList.add(item);
        }
      }
      setState(() {
        filtered.addAll(tmpList);
      });
      return;
    } else {
      setState(() {
        filtered.addAll(widget.tickets);
      });
    }
  }

  Future<void> changeStatus(var parentContext, Status status) async {
    if (loading) return;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: (status == Status.refused)
              ? const Text('Confirma a REJEIÇÃO dos tickets selecionados?')
              : const Text('Confirma a APROVAÇÃO dos tickets selecionados?'),
          actions: [
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                setState(() {
                  loading = true;
                });

                List<String> ticketsId = selected.map((t) => t.id).toList();
                changeTicketsStatus(widget.permanent, ticketsId, status)
                    .then((response) async {
                  if (response == 'OK') {
                    Message.showMessage(
                        parentContext, 'Operação realizada com sucesso.');
                    for (var i = 0; i < selected.length; i++) {
                      widget.tickets.remove(selected[i]);
                    }
                  } else {
                    Message.showError(parentContext,
                        'Problema ao atualizar os tickets. Verifique sua conexão.');
                  }

                  setState(() {
                    loading = false;
                    selectAll = true;
                    filterController.clear();
                    selected.clear();
                    filtered.clear();
                    selected.addAll(widget.tickets);
                    filtered.addAll(widget.tickets);
                  });
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitações por Turma"),
        actions: [
          IconButton(
            onPressed: () {
              if (loading) return;
              selected.clear();
              setState(() {
                selectAll = !selectAll;
                if (selectAll) {
                  selected.addAll(widget.tickets);
                }
              });
            },
            icon: Icon(
                selectAll ? Icons.check_box : Icons.check_box_outline_blank),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: loading
                  ? const [
                      CircularProgressIndicator(),
                      Style.formSizedBox,
                      Text('Atualizando...', style: Style.subtitleTextStyle)
                    ]
                  : [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: Style.padding),
                        child: TextField(
                          onChanged: (value) {
                            filterTickets(value);
                          },
                          controller: filterController,
                          decoration: InputDecoration(
                            labelText: "Busca",
                            hintText: "Busca",
                            suffixIcon: const Icon(Icons.search,
                                color: Style.primaryColor),
                            border: OutlineInputBorder(
                                borderRadius: Style.borderRadius),
                          ),
                        ),
                      ),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(
                                child: Text('Nenhuma solicitação encontrada.',
                                    textAlign: TextAlign.center,
                                    style: Style.subtitleTextStyle),
                              )
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Style.padding),
                                    child: Container(
                                      decoration: Style.boxDecoration,
                                      child: ListTile(
                                        title: Text(
                                            '${filtered[index].student} - ',
                                            style: Style.defaultTextStyle),
                                        subtitle: Text(
                                            formatTicketInfo(filtered[index])),
                                        trailing: Icon(
                                            (selected.contains(filtered[index])
                                                ? Icons.check_box
                                                : Icons
                                                    .check_box_outline_blank),
                                            color: Style.primaryColor),
                                        onTap: () {
                                          setState(() {
                                            if (selected
                                                .contains(filtered[index])) {
                                              selected.remove(filtered[index]);
                                            } else {
                                              selected.add(filtered[index]);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              onPressed: refuse,
                              child: const Text(
                                'Recusar',
                                style: Style.buttonTextStyle,
                              ),
                            ),
                          ),
                          Style.formSizedBox,
                          Expanded(
                            child: ElevatedButton(
                              onPressed: approve,
                              child: const Text(
                                'Aprovar',
                                style: Style.buttonTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
