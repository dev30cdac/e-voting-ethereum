import 'dart:developer' as devlog;
import 'package:flutter/foundation.dart' show kIsWeb;

class EthereumConnection {
  final String rpcUrl =
      kIsWeb ? "http://127.0.0.1:7545" : "http://10.0.2.2:7545";
  final String wsUrl = kIsWeb ? "ws://127.0.0.1:7545/" : "ws://10.0.2.2:7545/";
  final String privateKey =
      "60915fdbf7a80e27d9928664c9166150d74d8256bde06892cdad4e26e0777d9a";
}
