import 'package:flutter/material.dart';
import 'package:playground_ifma/models/ticket_req.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';

class TicketReportScreen extends StatefulWidget {
  final List<TicketReq> tickets;
  const TicketReportScreen(this.tickets, {Key? key}) : super(key: key);

  @override
  _TicketReportScreenState createState() => _TicketReportScreenState();
}

class _TicketReportScreenState extends State<TicketReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${TicketStyle.getStatusStr(widget.tickets[0].status)} - ${TicketStyle.getDateStr(widget.tickets[0].dateTime)}',
            style: Style.defaultTextStyle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: widget.tickets.isEmpty
                      ? const Center(
                          child: Text('Nenhum ticket.',
                              textAlign: TextAlign.center,
                              style: Style.subtitleTextStyle),
                        )
                      : ListView.builder(
                          itemCount: widget.tickets.length,
                          // reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Style.padding),
                              child: Container(
                                decoration: Style.boxDecoration,
                                child: ListTile(
                                  title: Text(
                                      '${widget.tickets[index].student} - ${widget.tickets[index].reason}',
                                      style: Style.defaultTextStyle),
                                  subtitle: Text(
                                      'Ticket nº: ${widget.tickets[index].id}'),
                                ),
                              ),
                            );
                          },
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
