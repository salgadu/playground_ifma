import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/app_state.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/models/ticket_req.dart';
import 'package:playground_ifma/models/user.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'package:playground_ifma/util/ifma_rules.dart';

import 'package:playground_ifma/util/messages.dart';

class TicketDetailScreen extends StatefulWidget {
  final TicketReq ticket;
  const TicketDetailScreen(this.ticket, {Key? key}) : super(key: key);

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  bool loading = false;
  String paymentCode = "";
  late User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AppState>(context, listen: false).user;
  }

  Widget showQRCode() {
    if ((widget.ticket.status == Status.approved) ||
        (widget.ticket.status == Status.payment)) {
      return Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container();
          // return QrImage(
          //   data: IFMARules.qrCodeInfo(widget.ticket),
          //   version: QrVersions.auto,
          //   size: constraints.maxWidth * 0.75,
          //   errorStateBuilder: (cxt, err) {
          //     return const Center(
          //       child: Text(
          //         "Erro",
          //         textAlign: TextAlign.center,
          //       ),
          //     );
          //   },
          // );
        }),
      );
    } else {
      return Container();
    }
  }

  String buttonLabel() {
    switch (widget.ticket.status) {
      case Status.analysis:
        return 'Cancelar ticket';
      case Status.payment:
        return 'Confirmar pagamento';
      default:
        return '';
    }
  }

  Future<void> cancelDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelar ticket'),
          content: const Text('Deseja solicitar o cancelamento do ticket?'),
          actions: [
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                setState(() {
                  loading = true;
                });

                Navigator.of(context).pop();

                String response = await cancelTicket(widget.ticket.id);
                if (response == 'OK') {
                  setState(() {
                    widget.ticket.cancel();
                  });
                  Message.showMessage(context, 'Ticket cancelado com sucesso.');
                } else {
                  Message.showError(context,
                      'Não foi possível cancelar. Verifique sua conexão.');
                }

                setState(() {
                  loading = false;
                });
              },
            ),
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> paymentDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar pagamento'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text(
                    'Digite o código de pagamento fornecido pelo restaurante.'),
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      paymentCode = value;
                    });
                  },
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                if (paymentCode == IFMARules.ticketKey(widget.ticket.id)) {
                  String response = await approveTickets([widget.ticket.id]);
                  if (response != 'OK') {
                    Provider.of<AppState>(context, listen: false)
                        .approveTicket(widget.ticket.id);
                  }

                  setState(() {
                    widget.ticket.approve();
                  });

                  Navigator.of(context).pop();
                  Message.showMessage(
                      context, 'Pagamento confirmado com sucesso.');
                } else {
                  loading = true;
                  Future.delayed(const Duration(seconds: 5), () {
                    setState(() {
                      loading = false;
                    });
                  });
                  Navigator.of(context).pop();

                  Message.showError(
                      context, 'Código inválido. Tente novamente.');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void buttonClick() async {
    if (loading) return;

    if (widget.ticket.status == Status.analysis) {
      cancelDialog();
    } else if (widget.ticket.status == Status.payment) {
      paymentDialog();
    }
  }

  Widget showButton() {
    if (loading) return const Center(child: CircularProgressIndicator());

    if ((widget.ticket.status == Status.analysis) ||
        (widget.ticket.status == Status.payment)) {
      return Padding(
        padding: const EdgeInsets.all(Style.padding),
        child: SizedBox(
          height: Style.buttonHeight,
          width: double.infinity,
          child: ElevatedButton(
            child: Text(buttonLabel(), style: Style.buttonTextStyle),
            onPressed: buttonClick,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket nº ${widget.ticket.id}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: SingleChildScrollView(
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: TicketStyle.getStatusColor(widget.ticket.status),
                    child: Column(
                      children: [
                        Style.formSizedBox,
                        Text(
                          TicketStyle.getMealStr(widget.ticket.meal),
                          style: Style.cardTexStyle,
                        ),
                        Text(
                          TicketStyle.getWeekDay(widget.ticket.dateTime),
                          style: Style.cardTexStyle,
                        ),
                        Style.formSizedBox,
                      ],
                    ),
                  ),
                  Style.formSizedBox,
                  Text(
                    TicketStyle.getStatusStr(widget.ticket.status),
                    textAlign: TextAlign.center,
                    style: Style.subtitleTextStyle,
                  ),
                  Style.formSizedBox,
                  showQRCode(),
                  Style.formSizedBox,
                  Text(
                    'Data: ${TicketStyle.getDateStr(widget.ticket.dateTime)}',
                    textAlign: TextAlign.center,
                    style: Style.subtitleTextStyle,
                  ),
                  Style.formSizedBox,
                  Visibility(
                    visible: user.name.isNotEmpty,
                    child: Text(
                      TicketStyle.formatName(user.name),
                      textAlign: TextAlign.center,
                      style: Style.subtitleTextStyle,
                    ),
                  ),
                  Text(
                    widget.ticket.student,
                    textAlign: TextAlign.center,
                    style: Style.subtitleTextStyle,
                  ),
                  Style.sizedBox,
                  showButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
