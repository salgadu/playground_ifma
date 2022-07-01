import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'dart:convert';

import 'package:playground_ifma/util/ifma_rules.dart';

class ValidateRestaurantScreen extends StatefulWidget {
  static const routeName = '/validate_restaurant';

  const ValidateRestaurantScreen({Key? key}) : super(key: key);

  @override
  _ValidateRestaurantScreenState createState() =>
      _ValidateRestaurantScreenState();
}

class _ValidateRestaurantScreenState extends State<ValidateRestaurantScreen> {
  int totalValid = 0;
  final int timeBetweenReads = 2; //seconds
  bool ready = false;
  String result = 'Buscando QR Code...';
  List<String> validatedTickets = [];
  List<String> uploadedTickets = [];
  String? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      prefs = value;

      validatedTickets = prefs.getStringList('validatedTickets') ?? [];

      uploadedTickets = prefs.getStringList('uploadedTickets') ?? [];

      setState(() {
        totalValid = validatedTickets.length + uploadedTickets.length;
      });
    });

    _getCameraPermission().then((status) {
      if (status.isGranted) {
        setState(() {
          ready = true;
        });
      }
    });
  }

  Future<PermissionStatus> _getCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      return result;
    } else {
      return status;
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        // controller!.pauseCamera();
      }
      // controller!.resumeCamera();
    }
  }

  // void _onQRViewCreated(QRViewController ctrl) {
  //   controller = ctrl;
  //   ctrl.scannedDataStream.listen((scanData) {
  //     if (!ready) return;

  //     if (scanData.code != null) {
  //       ready = false;
  //       Future.delayed(Duration(seconds: timeBetweenReads), () {
  //         setState(() {
  //           ready = true;
  //         });
  //       });
  //       Map<String, dynamic> qrCodeInfo = jsonDecode(scanData.code!);
  //       Status status = Status.values[qrCodeInfo['status']];
  //       DateTime date = DateTime.parse(qrCodeInfo['date']);

  //       if ((status == Status.approved) && (IFMARules.checkDateToday(date))) {
  //         if (validatedTickets.contains(qrCodeInfo['id']) ||
  //             uploadedTickets.contains(qrCodeInfo['id'])) {
  //           setState(() {
  //             result = 'Ticket ${qrCodeInfo['id']} já validado';
  //           });
  //         } else {
  //           HapticFeedback.heavyImpact();
  //           validatedTickets.add(qrCodeInfo['id']);
  //           prefs.setStringList('validatedTickets', validatedTickets);
  //           setState(() {
  //             result = 'Ticket validado: ${qrCodeInfo['student']}';
  //             totalValid = validatedTickets.length + uploadedTickets.length;
  //           });
  //         }
  //       } else {
  //         setState(() {
  //           result = 'Ticket inválido';
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar Ticket'),
        actions: [
          IconButton(
              onPressed: () {
                // if (controller != null) controller!.flipCamera();
              },
              icon: const Icon(Icons.flip_camera_ios_outlined))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Style.padding),
          child: Center(
            child: Column(
              children: [
                Style.formSizedBox,
                Expanded(
                  child: ready
                      ?
                      // ? QRView(
                      //     key: qrKey,
                      //     onQRViewCreated: _onQRViewCreated,
                      //     formatsAllowed: const [BarcodeFormat.qrcode],
                      //   )
                      Container()
                      : const Center(child: CircularProgressIndicator()),
                ),
                Style.formSizedBox,
                Text(result, style: Style.subtitleTextStyle),
                Style.formSizedBox,
                Text('Total validados: $totalValid',
                    style: Style.subtitleTextStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
