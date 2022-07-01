import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/app_state.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/models/ticket_auth.dart';
import 'package:playground_ifma/models/user.dart';
import 'package:playground_ifma/screens/confirmation.dart';
import 'package:playground_ifma/screens/ticket_list.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'package:playground_ifma/util/ifma_rules.dart';
import 'package:playground_ifma/util/messages.dart';

class TicketAuthDetailScreen extends StatefulWidget {
  final TicketAuth ticket;
  const TicketAuthDetailScreen(this.ticket, {Key? key}) : super(key: key);

  @override
  _TicketAuthDetailScreenState createState() => _TicketAuthDetailScreenState();
}

class _TicketAuthDetailScreenState extends State<TicketAuthDetailScreen> {
  bool loading = false;
  late User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AppState>(context, listen: false).user;
  }

  Future<void> confirmTicket() async {
    setState(() {
      loading = true;
    });

    String response =
        await checkDoubleTicket(widget.ticket.student, widget.ticket.meal);

    if (response == '') {
      if (IFMARules.isStudentHighSchool(widget.ticket.student)) {
        widget.ticket.status = Status.approved;
      } else {
        widget.ticket.status = Status.payment;
      }

      response = await confirmTicketAuth(widget.ticket);
      if (response != '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ConfirmationScreen(
                destination: TicketListScreen.routeName),
          ),
        );
      } else {
        widget.ticket.status = Status.approved;
        Message.showError(context,
            'A autorização não corresponde ao dia de hoje ou está fora do horário limite.');
      }
    } else {
      Message.showError(context,
          'Verifique se existe outro ticket solicitado na mesma data ou problemas na conexão.');
    }

    setState(() {
      loading = false;
    });
  }

  Widget showButton() {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(Style.padding),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.ticket.status == Status.approved) {
      return Padding(
        padding: const EdgeInsets.all(Style.padding),
        child: SizedBox(
          height: Style.buttonHeight,
          width: double.infinity,
          child: ElevatedButton(
            child:
                const Text('Confirmar Refeição', style: Style.buttonTextStyle),
            onPressed: confirmTicket,
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
      appBar: AppBar(title: Text('Autorização nº ${widget.ticket.id}')),
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
                          widget.ticket.daysStr,
                          style: Style.cardTexStyle,
                        ),
                        Style.formSizedBox,
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Style.padding),
                    child: Column(
                      children: [
                        Style.formSizedBox,
                        Text(
                          TicketStyle.getStatusStr(widget.ticket.status),
                          textAlign: TextAlign.center,
                          style: Style.subtitleTextStyle,
                        ),
                        Style.formSizedBox,
                        Text(
                          widget.ticket.reason,
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
                        const Text(
                          'A confirmação da refeição deve ser realizada até 11h (Almoço) e até 19h (Jantar).',
                          style: Style.defaultTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        Style.formSizedBox,
                        showButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
