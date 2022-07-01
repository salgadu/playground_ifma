import 'package:flutter/material.dart';
import 'package:playground_ifma/screens/admin/classes.dart';
import 'package:playground_ifma/screens/admin/report_admin.dart';
import 'package:playground_ifma/screens/login.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/util/ifma_rules.dart';

class AdminHomeScreen extends StatefulWidget {
  static const routeName = '/admin_home';

  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  // late User user;

  @override
  void initState() {
    super.initState();
    // user = Provider.of<AppState>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket IFMA"),
        actions: [
          IconButton(
            onPressed: () async {
              IFMARules.clearLogin();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.routeName, (route) => false);
            },
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
                // Text('Usuário ${user.id}', style: Style.subtitleTextStyle),
                // Style.formSizedBox,
                Image.asset(
                  "assets/images/avatar.png",
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
                        Text('Tickets Diários', style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClassesScreen(false),
                        ),
                      );
                      // Navigator.pushNamed(context, ClassesScreen.routeName);
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
                        Text('Tickets Permanentes',
                            style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClassesScreen(true),
                        ),
                      );
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
                        Text('Relatório', style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ReportAdminScreen.routeName);
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
