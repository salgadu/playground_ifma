import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/app_state.dart';
import 'package:playground_ifma/models/user.dart';
import 'package:playground_ifma/screens/admin/admin_home.dart';
import 'package:playground_ifma/screens/home.dart';
import 'package:playground_ifma/screens/restaurant/restaurant_home.dart';
import 'package:playground_ifma/theme/app_logo.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/util/ifma_rules.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String id = '';
  String password = '';
  bool passwordVisible = false;
  bool loading = false;
  String version = '';
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((info) {
      setState(() {
        version = 'Versão: ${info.version}';
      });
    });

    SharedPreferences.getInstance().then((value) {
      prefs = value;

      id = prefs.getString('user') ?? '';
      if (id != '') {
        password = prefs.getString('password') ?? '';
        login();
      }
    });
  }

  Future login() async {
    setState(() {
      loading = true;
    });

    id = '20141CXCC0339';
    id = '20221AD.CAX0013';

    password = '20141CXCC0339@ifma';
    password = 'Amor58152531#';

    // var response = await loginStudent(id, password);
    // print(response);

    Provider.of<AppState>(context, listen: false)
        .setUser(User(id, password, '', Type.graduation));
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    return;

    if ((id == 'USER') && (password == 'test1Store')) {
      Provider.of<AppState>(context, listen: false)
          .setUser(User(id, password, id, Type.graduation));
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      return;
    }

    if (id == 'CAE') {
      if (password == '1fcx*cae') {
        IFMARules.saveLogin(id, password);
        Navigator.pushReplacementNamed(context, AdminHomeScreen.routeName);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Senha inválida.'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else if (id == 'RESTAURANTE') {
      if (password == 'res*1fcx') {
        IFMARules.saveLogin(id, password);
        Navigator.pushReplacementNamed(context, RestaurantHomeScreen.routeName);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Senha inválida.'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      var response = await loginStudent(id, password);
      if (response.startsWith('OK')) {
        IFMARules.saveLogin(id, password);
        String name = (response.length > 3) ? response.split('OK:')[1] : '';
        Provider.of<AppState>(context, listen: false)
            .setUser(User(id, password, name, Type.graduation));
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(response),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Style.padding),
            child: Column(
              children: [
                Style.sizedBox,
                Style.sizedBox,
                const AppLogo(),
                Style.sizedBox,
                const Text(
                  "Entre para continuar",
                  style: Style.subtitleTextStyle,
                ),
                Style.sizedBox,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: !loading,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: "Matrícula",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.teal,
                          ),
                          filled: true,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            id = value.trim().toUpperCase();
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            if (id == '') {
                              return "Insira sua matrícula";
                            } else {
                              return null;
                            }
                          } else {
                            if (value.isEmpty) {
                              return "Insira sua matrícula";
                            }
                            return null;
                          }
                        },
                      ),
                      Style.formSizedBox,
                      TextFormField(
                        enabled: !loading,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            if (password == '') {
                              return "Insira sua senha";
                            } else {
                              return null;
                            }
                          } else {
                            if (value.isEmpty) {
                              return "Insira sua senha";
                            }
                            return null;
                          }
                        },
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: !passwordVisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.teal,
                          ),
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Style.sizedBox,
                Style.sizedBox,
                SizedBox(
                  height: Style.buttonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (loading == false) {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: loading == false ? Colors.teal : Colors.black26,
                      onSurface: Colors.black54,
                    ),
                    child: loading == false
                        ? const Text("Entrar", style: Style.buttonTextStyle)
                        : const CircularProgressIndicator(color: Colors.white),
                  ),
                ),
                Style.sizedBox,
                Text(version)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
