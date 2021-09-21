import 'dart:developer' as devlog;
import 'package:flutter/foundation.dart' show kIsWeb;

class EthereumConnection {
  final String rpcUrl =
      kIsWeb ? "http://127.0.0.1:7545" : "http://10.0.2.2:7545";
  final String wsUrl = kIsWeb ? "ws://127.0.0.1:7545/" : "ws://10.0.2.2:7545/";
  final String privateKey =
      "c9bd8778b591d4fce342318efba6e00e995d985c659fc5ef40d3f1325f64cc7a";
}
