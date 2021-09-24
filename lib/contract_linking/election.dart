import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:provider/provider.dart';
import './ethereumConnection.dart';

class ElectionContract extends ChangeNotifier {
  var ethereumConnection;
  //String _rpcUrl = ethereumConnection.rpcUrl;
  //final String _wsUrl = ethereumConnection.wsUrl;
  //final String _privateKey = ethereumConnection.privateKey;

  late Web3Client _client;
  late String _abiCode;

  late Credentials _credentials;
  late EthereumAddress _ownAddress;
  late EthereumAddress _contractAddress;

  late DeployedContract _contract;
  late ContractFunction _organizerAdmin;
  late ContractFunction _registerFunc;
  late ContractFunction _voteFunc;
  late ContractFunction _declareWinnerFunc;
  late ContractFunction _getTotalVotesFunc;
  late ContractFunction _getTotalVotersFunc;
  late ContractFunction _getCandidateVoteFunc;
  late ContractFunction _announcedWinnerFunc;
  late ContractFunction _isWinnerAnnounced;

  bool isLoading = true;
  late String totalVotes;
  late String totalVoters;
  late bool isWinnerAnnounced;

  ElectionContract() {
    inititalSetup();
  }

  inititalSetup() async {
    ethereumConnection = new EthereumConnection();
    _client = await Web3Client(ethereumConnection.rpcUrl, Client(),
        socketConnector: () {
      return IOWebSocketChannel.connect(ethereumConnection.wsUrl)
          .cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
    await getTotalVotes();
    await getTotalVoters();
    await WinnerAnnounced();
    await getOrganizerAdmin();
  }

  getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/Election.json");
    var jsonFile = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonFile["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonFile["networks"]["5777"]["address"]);
  }

  getCredentials() async {
    _credentials =
        await _client.credentialsFromPrivateKey(ethereumConnection.privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Election"), _contractAddress);
    _organizerAdmin = _contract.function("organizerAdmin");
    _registerFunc = _contract.function("Register");
    _voteFunc = _contract.function("Vote");
    _declareWinnerFunc = _contract.function("Winner");
    _getTotalVotesFunc = _contract.function("totalVotes");
    _getTotalVotersFunc = _contract.function("totalVoters");
    _getCandidateVoteFunc = _contract.function("getCandidateVote");
    _announcedWinnerFunc = _contract.function("announcedWinner");
    _isWinnerAnnounced = _contract.function("isWinnerAnnounced");
  }

  getCandidateVotes(int pro) async {
    try {
      var reponse = await _client.call(
          contract: _contract, function: _getCandidateVoteFunc, params: [pro]);

      totalVotes = reponse[0].toString();
      print("totalVotes ====>");

      print(totalVotes);
    } catch (e) {
      print(e);
      totalVotes = "0";
    }
  }

  getTotalVotes() async {
    isLoading = true;
    notifyListeners();
    try {
      var reponse = await _client
          .call(contract: _contract, function: _getTotalVotesFunc, params: []);

      totalVotes = reponse[0].toString();
      print("totalVotes ====>");

      print(totalVotes);
    } catch (e) {
      print(e);
      totalVotes = "0";
    }
    isLoading = false;
    notifyListeners();
  }

  getTotalVoters() async {
    isLoading = true;
    notifyListeners();
    try {
      var reponse = await _client
          .call(contract: _contract, function: _getTotalVotersFunc, params: []);
      totalVoters = reponse[0].toString();
    } catch (e) {
      print(e);
      totalVoters = "0";
    }
    isLoading = false;
    notifyListeners();
  }

  WinnerAnnounced() async {
    isLoading = true;
    notifyListeners();
    try {
      var reponse = await _client
          .call(contract: _contract, function: _isWinnerAnnounced, params: []);
      isWinnerAnnounced = reponse[0];
      print("isWinnerAnnounced ===== >>>");
      print(isWinnerAnnounced);
      print("-------");
    } catch (e) {
      print(e);
      isWinnerAnnounced = false;
    }
    isLoading = false;
    notifyListeners();
  }

  getOrganizerAdmin() async {
    var organizerAdmin = await _client
        .call(contract: _contract, function: _organizerAdmin, params: []);
    print("${organizerAdmin.first}");
    isLoading = false;
    notifyListeners();
  }

  registerVoter(String voterAddress, String organizerAdminAddress) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _registerFunc,
            parameters: [
              EthereumAddress.fromHex(voterAddress),
              EthereumAddress.fromHex(organizerAdminAddress)
            ]));
    print("Voter Registered");
    getOrganizerAdmin();
  }

  vote(int toProposal, String voterAddress) async {
    isLoading = true;
    print("print -----------Vote -----");
    print("toProposal = ${toProposal}-----");
    print("voterAddress = ${voterAddress}-----");
    notifyListeners();
    var response = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _voteFunc,
            parameters: [
              BigInt.from(toProposal),
              EthereumAddress.fromHex(voterAddress)
            ]));

    print("print -----------Vote -----");
    print(response);
    print(response[0]);
    print("---- Voting DOne---");
    getOrganizerAdmin();
  }

  winner() async {
    var winnerIs = await _client
        .call(contract: _contract, function: _declareWinnerFunc, params: []);
    print("winner-----------${winnerIs.first} -----");
    return "${winnerIs.first}";
  }

  announcedWinner() async {
    print("print -----------announcedWinner -----");
    var winnerIs = await _client
        .call(contract: _contract, function: _announcedWinnerFunc, params: []);
    print("outPut-----------${winnerIs} -----");
  }
}
