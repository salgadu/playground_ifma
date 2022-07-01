import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playground_ifma/cloud/api_functions.dart';
import 'package:playground_ifma/models/ticket.dart';
import 'package:playground_ifma/theme/constants.dart';
import 'package:playground_ifma/util/ifma_rules.dart';
import 'dart:convert' as convert;

class PaymentRestaurantScreen extends StatefulWidget {
  static const routeName = '/payment_restaurant';

  const PaymentRestaurantScreen({Key? key}) : super(key: key);

  @override
  _PaymentRestaurantScreenState createState() =>
      _PaymentRestaurantScreenState();
}

class _PaymentRestaurantScreenState extends State<PaymentRestaurantScreen> {
  final int timeBetweenReads = 1; //seconds
  bool ready = false;
  String result = 'Buscando QR Code...';
  List<String> paidTickets = [];
  // QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      prefs = value;

      paidTickets = prefs.getStringList('paidTickets') ?? [];

      uploadRecords();
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
    // if (controller != null) {
    //   if (Platform.isAndroid) {
    //     controller!.pauseCamera();
    //   }
    //   controller!.resumeCamera();
    // }
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
  //       Map<String, dynamic> qrCodeInfo = convert.jsonDecode(scanData.code!);
  //       Status status = Status.values[qrCodeInfo['status']];
  //       setState(() {
  //         if (status == Status.payment) {
  //           result =
  //               'Código de pagamento: ${IFMARules.ticketKey(qrCodeInfo['id'])}';
  //           HapticFeedback.heavyImpact();
  //           paidTickets.add(qrCodeInfo['id']);
  //           prefs.setStringList('paidTickets', paidTickets);
  //         } else {
  //           result = 'Ticket inválido';
  //         }
  //       });
  //       if (paidTickets.length % 10 == 0) {
  //         uploadRecords();
  //       }
  //     }
  //   });
  // }

  @override
  void dispose() {
    // controller?.dispose();
    uploadRecords();
    super.dispose();
  }

  void uploadRecords() {
    confirmTicketsPayment(paidTickets).then((response) {
      if (response == 'OK') {
        paidTickets.clear();
        prefs.setStringList('paidTickets', []);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Pagamento'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
