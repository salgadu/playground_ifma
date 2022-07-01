// import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:playground_ifma/models/app_state.dart';
import 'package:playground_ifma/models/ticket_auth.dart';
import 'package:playground_ifma/models/ticket_req.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/screens/confirmation.dart';
import 'package:playground_ifma/screens/ticket_auth_list.dart';
import 'package:playground_ifma/screens/ticket_list.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'package:playground_ifma/util/messages.dart';
import 'package:playground_ifma/cloud/api_functions.dart';

class TicketRequestScreen extends StatefulWidget {
  static const routeName = '/ticket_request';

  const TicketRequestScreen({Key? key}) : super(key: key);

  @override
  _TicketRequestScreenState createState() => _TicketRequestScreenState();
}

class _TicketRequestScreenState extends State<TicketRequestScreen> {
  final textController = TextEditingController();
  String? dropdownValue;
  List<bool> meals = [false, false, false, false];

  bool permanent = true;

  List<bool> days = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  bool loading = false;

  final List<DropdownMenuItem<String>> dropdownOpts = [
    'Contra-turno',
    'Monitoria',
    'Estudos',
    'Evento',
    'Outro'
  ]
      .map<DropdownMenuItem<String>>(
          (v) => DropdownMenuItem<String>(value: v, child: Text(v)))
      .toList();

  request() async {
    if (loading) return;

    if (dropdownValue == null) {
      Message.showError(context, 'Informe o motivo da solicitação.');
      return;
    }

    if (!meals.contains(true)) {
      Message.showError(context, 'Selecione uma refeição.');
      return;
    }

    if (permanent && !days.contains(true)) {
      Message.showError(context, 'Selecione pelo menos um dia da semana.');
      return;
    }

    setState(() {
      loading = true;
    });

    String student = Provider.of<AppState>(context, listen: false).user.id;

    late Meal meal = Meal.values[meals.indexOf(true)];

    String response = '';
    if (permanent) {
      Set<Days> daySet = {};

      for (int i = 0; i < days.length; i++) {
        if (days[i]) {
          daySet.add(Days.values[i]);
        }
      }

      TicketAuth ticket = TicketAuth(
          student, meal, dropdownValue!, textController.text, daySet);

      response = await requestTicketAuth(ticket);
      if (response != '') {
        ticket.setId = response;
        Provider.of<AppState>(context, listen: false).addTicketAuth(ticket);
      }
    } else {
      response = await checkDoubleTicket(student, meal);

      if (response == '') {
        TicketReq ticket =
            TicketReq(student, meal, dropdownValue!, textController.text);

        response = await requestTicket(ticket);
        if (response != '') {
          ticket.setId = response;
          Provider.of<AppState>(context, listen: false).addTicketReq(ticket);
        }
      } else {
        Message.showError(context,
            'Verifique se existe outro ticket solicitado na mesma data ou problemas na conexão.');
        setState(() {
          loading = false;
        });
        return;
      }
    }

    setState(() {
      loading = false;
    });

    if (response != '') {
      String destScreen = permanent
          ? TicketAuthListScreen.routeName
          : TicketListScreen.routeName;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(destination: destScreen),
        ),
      );
    } else {
      Message.showError(context,
          'Verifique sua conexão ou se o horário limite para solicitar passou.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Refeição'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Style.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Style.sizedBox,
                const Text(
                  'Motivo',
                  style: Style.subtitleTextStyle,
                ),
                Style.formSizedBox,
                Container(
                  decoration: Style.boxDecoration,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: Style.padding, right: Style.padding),
                    child: DropdownButton<String>(
                      hint: const Text("Selecione o motivo"),
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 36,
                      underline: Container(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            dropdownValue = value;
                          });
                        }
                      },
                      items: dropdownOpts,
                    ),
                  ),
                ),
                Style.sizedBox,
                const Text(
                  'Justificativa',
                  style: Style.subtitleTextStyle,
                ),
                Style.formSizedBox,
                TextField(
                  maxLength: 250,
                  controller: textController,
                  minLines: 3,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText:
                        'Não é obrigatório.\nEscreva uma justificativa se necessário.',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Style.borderColor),
                      borderRadius: Style.borderRadius,
                    ),
                  ),
                ),
                Style.sizedBox,
                const Text(
                  'Refeição',
                  style: Style.subtitleTextStyle,
                ),
                Style.formSizedBox,
                ToggleButtons(
                  borderRadius: Style.borderRadius,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Style.padding),
                      child: Row(
                        children: [
                          Text(TicketStyle.getMealStr(Meal.breakfast),
                              style: Style.defaultTextStyle),
                          const Icon(Icons.coffee),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Style.padding),
                      child: Row(
                        children: [
                          Text(TicketStyle.getMealStr(Meal.lunch),
                              style: Style.defaultTextStyle),
                          const Icon(Icons.local_restaurant),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Style.padding),
                      child: Row(
                        children: [
                          Text(TicketStyle.getMealStr(Meal.dinner),
                              style: Style.defaultTextStyle),
                          const Icon(Icons.food_bank),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Style.padding),
                      child: Row(
                        children: [
                          Text(TicketStyle.getMealStr(Meal.supper),
                              style: Style.defaultTextStyle),
                          const Icon(Icons.soup_kitchen),
                        ],
                      ),
                    )
                  ],
                  isSelected: meals,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < meals.length; i++) {
                        meals[i] = false;
                      }
                      meals[index] = true;
                    });
                  },
                ),
                Style.sizedBox,
                Row(
                  children: [
                    const Text(
                      'Autorização Permanente',
                      style: Style.subtitleTextStyle,
                    ),
                    Switch(
                        value: permanent,
                        onChanged: (value) {
                          setState(() {
                            permanent = value;
                          });
                        }),
                  ],
                ),
                Style.formSizedBox,
                (permanent)
                    ? ToggleButtons(
                        borderRadius: Style.borderRadius,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(Style.padding),
                            child: Text(TicketStyle.getDaysStr(Days.seg),
                                style: Style.defaultTextStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Style.padding),
                            child: Text(TicketStyle.getDaysStr(Days.ter),
                                style: Style.defaultTextStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Style.padding),
                            child: Text(TicketStyle.getDaysStr(Days.qua),
                                style: Style.defaultTextStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Style.padding),
                            child: Text(TicketStyle.getDaysStr(Days.qui),
                                style: Style.defaultTextStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Style.padding),
                            child: Text(TicketStyle.getDaysStr(Days.sex),
                                style: Style.defaultTextStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Style.padding),
                            child: Text(TicketStyle.getDaysStr(Days.sab),
                                style: Style.defaultTextStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Style.padding),
                            child: Text(TicketStyle.getDaysStr(Days.dom),
                                style: Style.defaultTextStyle),
                          ),
                        ],
                        isSelected: days,
                        onPressed: (int index) {
                          setState(() {
                            days[index] = !days[index];
                          });
                        },
                      )
                    : const Text(
                        'O ticket diário deve ser solicitado das 6h às 9h (Almoço) e das 14h às 17h (Jantar).',
                        style: Style.defaultTextStyle,
                      ),
                Style.sizedBox,
                SizedBox(
                  height: Style.buttonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: request,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Solicitar',
                            style: Style.buttonTextStyle,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
