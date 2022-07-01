import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playground_ifma/models/app_state.dart';
import 'package:playground_ifma/models/user.dart';
import 'package:playground_ifma/screens/login.dart';
import 'package:playground_ifma/screens/ticket_auth_list.dart';
import 'package:playground_ifma/screens/ticket_list.dart';
import 'package:playground_ifma/screens/ticket_request.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/theme/ticket_style.dart';
import 'package:playground_ifma/util/ifma_rules.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AppState>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket IFMA"),
        actions: [
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Sair'),
                content: const Text('Você deseja sair do TicketIF?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      IFMARules.clearLogin();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.routeName, (route) => false);
                    },
                    child: const Text('Sim'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Não',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            icon: const Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Style.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Style.sizedBox,
                Visibility(
                  visible: user.name.isNotEmpty,
                  child: Text(TicketStyle.formatName(user.name),
                      style: Style.subtitleTextStyle),
                ),
                Text('Matrícula: ${user.id}', style: Style.subtitleTextStyle),
                Style.formSizedBox,
                Image.asset(
                  "assets/images/food.png",
                ),
                Style.formSizedBox,
                SizedBox(
                  height: Style.buttonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.local_restaurant),
                        Style.sizedBox,
                        Text('Solicitar Refeição',
                            style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, TicketRequestScreen.routeName);
                    },
                  ),
                ),
                Style.formSizedBox,
                SizedBox(
                  height: Style.buttonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.list),
                        Style.sizedBox,
                        Text('Meus Tickets', style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, TicketListScreen.routeName);
                    },
                  ),
                ),
                Style.formSizedBox,
                SizedBox(
                  height: Style.buttonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.description),
                        Style.sizedBox,
                        Text('Autorizações Permanentes',
                            style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, TicketAuthListScreen.routeName);
                    },
                  ),
                ),
                Style.sizedBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
