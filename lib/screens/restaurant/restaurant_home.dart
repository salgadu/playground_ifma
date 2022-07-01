import 'package:flutter/material.dart';
import 'package:playground_ifma/screens/login.dart';
import 'package:playground_ifma/screens/restaurant/payment_restaurant.dart';
import 'package:playground_ifma/screens/restaurant/report_restaurant.dart';
import 'package:playground_ifma/screens/restaurant/validate_restaurant.dart';
import 'package:playground_ifma/screens/restaurant/validate_ticket_id.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/util/ifma_rules.dart';

class RestaurantHomeScreen extends StatefulWidget {
  static const routeName = '/restaurant_home';

  const RestaurantHomeScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantHomeScreen> createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
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
                const Text('Restaurante IFMA', style: Style.subtitleTextStyle),
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
                        Icon(Icons.attach_money),
                        Style.sizedBox,
                        Text('Confirmar Pagamento',
                            style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, PaymentRestaurantScreen.routeName);
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
                        Icon(Icons.numbers),
                        Style.sizedBox,
                        Text('Validar por Número',
                            style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ValidateTicketIDScreen.routeName);
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
                        Icon(Icons.qr_code_scanner),
                        Style.sizedBox,
                        Text('Validar por QR Code',
                            style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ValidateRestaurantScreen.routeName);
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
                        Text('Relatórios', style: Style.buttonTextStyle),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ReportRestaurantScreen.routeName);
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
