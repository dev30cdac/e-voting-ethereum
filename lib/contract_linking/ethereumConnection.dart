import 'dart:developer' as devlog;
import 'package:flutter/foundation.dart' show kIsWeb;

class EthereumConnection {
  final String rpcUrl =
      kIsWeb ? "http://127.0.0.1:7545" : "http://10.0.2.2:7545";
  final String wsUrl = kIsWeb ? "ws://127.0.0.1:7545/" : "ws://10.0.2.2:7545/";
  final String privateKey =
      "0dc70029c1ff19a11ac556e3c229d9ff9627e49ed82c5782147fdd9b9dc20d0d";
}
