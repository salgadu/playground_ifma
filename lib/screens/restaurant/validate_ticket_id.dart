import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playground_ifma/theme/constants.dart';

class ValidateTicketIDScreen extends StatefulWidget {
  static const routeName = '/validate_ticket_id';

  const ValidateTicketIDScreen({Key? key}) : super(key: key);

  @override
  _ValidateTicketIDScreenState createState() => _ValidateTicketIDScreenState();
}

class _ValidateTicketIDScreenState extends State<ValidateTicketIDScreen> {
  final textController = TextEditingController();

  String result = '';

  List<String> validatedTickets = [];
  List<String> uploadedTickets = [];
  List<String> totalTickets = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      prefs = value;

      validatedTickets = prefs.getStringList('validatedTickets') ?? [];

      uploadedTickets = prefs.getStringList('uploadedTickets') ?? [];

      setState(() {
        totalTickets = validatedTickets + uploadedTickets;
        totalTickets.sort();
      });
    });
  }

  void validateTicketId() {
    String ticketId = textController.text;

    if (ticketId.isEmpty) return;

    if (validatedTickets.contains(ticketId) ||
        uploadedTickets.contains(ticketId)) {
      setState(() {
        result = 'Ticket $ticketId já validado.';
      });
    } else {
      textController.text = '';
      validatedTickets.add(ticketId);
      totalTickets.insert(0, ticketId);
      prefs.setStringList('validatedTickets', validatedTickets);
      setState(() {
        result = 'Ticket $ticketId validado com sucesso.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar Ticket'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: totalTickets.isEmpty
                    ? const Center(
                        child: Text('Nenhum ticket validado até o momento.',
                            textAlign: TextAlign.center,
                            style: Style.subtitleTextStyle),
                      )
                    : ListView.builder(
                        itemCount: totalTickets.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: Style.padding),
                            child: Container(
                              decoration: Style.boxDecoration,
                              child: ListTile(
                                title: Text('Ticket nº: ${totalTickets[index]}',
                                    style: Style.defaultTextStyle),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Style.divider,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nº do Ticket',
                    style: Style.defaultTextStyle,
                  ),
                  Text('Total: ${totalTickets.length}',
                      style: Style.defaultTextStyle),
                ],
              ),
              Style.formSizedBox,
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Style.borderColor),
                    borderRadius: Style.borderRadius,
                  ),
                ),
              ),
              Style.formSizedBox,
              Text(result, style: Style.subtitleTextStyle),
              Style.formSizedBox,
              SizedBox(
                height: Style.buttonHeight,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: validateTicketId,
                  child: const Text(
                    'Validar',
                    style: Style.buttonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
