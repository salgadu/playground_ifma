import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playground_ifma/models/app_state.dart';
import 'package:playground_ifma/screens/admin/admin_home.dart';
import 'package:playground_ifma/screens/admin/report_admin.dart';
import 'package:playground_ifma/screens/home.dart';
import 'package:playground_ifma/screens/login.dart';
import 'package:playground_ifma/screens/restaurant/payment_restaurant.dart';
import 'package:playground_ifma/screens/restaurant/report_restaurant.dart';
import 'package:playground_ifma/screens/restaurant/restaurant_home.dart';
import 'package:playground_ifma/screens/restaurant/validate_restaurant.dart';
import 'package:playground_ifma/screens/restaurant/validate_ticket_id.dart';
import 'package:playground_ifma/screens/ticket_auth_list.dart';
import 'package:playground_ifma/screens/ticket_list.dart';
import 'package:playground_ifma/screens/ticket_request.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:playground_ifma/theme/constants.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket IFMA',
      theme: ThemeData(
        primarySwatch: Style.primaryColor,
      ),
      // home: const LoginScreen(),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        TicketRequestScreen.routeName: (context) => const TicketRequestScreen(),
        TicketAuthListScreen.routeName: (context) =>
            const TicketAuthListScreen(),
        TicketListScreen.routeName: (context) => const TicketListScreen(),
        AdminHomeScreen.routeName: (context) => const AdminHomeScreen(),
        ReportAdminScreen.routeName: (context) => const ReportAdminScreen(),
        RestaurantHomeScreen.routeName: (context) =>
            const RestaurantHomeScreen(),
        ReportRestaurantScreen.routeName: (context) =>
            const ReportRestaurantScreen(),
        PaymentRestaurantScreen.routeName: (context) =>
            const PaymentRestaurantScreen(),
        ValidateRestaurantScreen.routeName: (context) =>
            const ValidateRestaurantScreen(),
        ValidateTicketIDScreen.routeName: (context) =>
            const ValidateTicketIDScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
