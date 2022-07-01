import 'package:flutter/material.dart';
import 'package:playground_ifma/screens/home.dart';
import 'package:playground_ifma/theme/constants.dart';

class ConfirmationScreen extends StatefulWidget {
  final String destination;

  const ConfirmationScreen({this.destination = '', Key? key}) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oba!'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Style.formSizedBox,
              const Text('Relaxa!', style: Style.subtitleTextStyle),
              const Text(
                'Seu pedido foi enviado.',
                style: Style.subtitleTextStyle,
              ),
              Style.sizedBox,
              Image.asset(
                "assets/images/relax.png",
              ),
              const Text(
                  'Você pode acompanhar o andamento da sua solicitação em Meus Tickets ou Autorizações Permanentes.',
                  textAlign: TextAlign.center,
                  style: Style.defaultTextStyle),
              Style.sizedBox,
              SizedBox(
                height: Style.buttonHeight,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.destination == '') {
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (route) => false);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          widget.destination,
                          (route) =>
                              route.settings.name == HomeScreen.routeName);
                    }
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
