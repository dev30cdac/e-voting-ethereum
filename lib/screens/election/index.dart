import 'dart:async';
import '../../utils/api.dart';
import '../../contract_linking/election.dart';
import './proposals.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/signin.dart';

class ElectionUI extends StatefulWidget {
  @override
  _ElectionUI createState() => _ElectionUI();
}

class _ElectionUI extends State<ElectionUI> {
  String? role;
  String? email;
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    role = preferences.getString("role");
    email = preferences.getString("email");
  }

  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ElectionContract>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.compare_arrows),
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setInt("id", 0);
            preferences.clear();
            print("--- LogOut -->");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => new SignIn()),
            );
          },
        ),
        title: Container(
          child: Column(
            children: [
              Text(
                "Decentralized Election",
              ),
              Text(
                "Email - ${email}",
                textAlign: TextAlign.right,
              )
            ],
          ),
        ),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: Container(
        child: Center(
          child: contractLink.isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.3),
                                offset: Offset(0, 2),
                                blurRadius: 5)
                          ],
                        ),
                        constraints:
                            BoxConstraints(maxHeight: 240, maxWidth: 240),
                        child: CircleAvatar(
                          maxRadius: 240,
                          backgroundColor: Colors.blueGrey,
                          backgroundImage: AssetImage('assets/voting.gif'),
                        ),
                      ),
                      Text(
                        "Election On Blockchain",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      _buildWidgetBasedOnRole(role, contractLink),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Proposals()));
                              },
                              label: Text("Vote"),
                              icon: Icon(Icons.how_to_vote),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                print("Aadhaar Verification");
                              },
                              label: Text("KYC"),
                              icon: Icon(Icons.fingerprint),
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await contractLink.WinnerAnnounced();
                              bool falg = false;
                              if (falg) {
                                showError(
                                    " PLEASE WAIT FOR WINNER ANNOUNCEMENT",
                                    context);
                              } else {
                                String winnerIs = await contractLink.winner();
                                displayWinner(
                                    context,
                                    candidateNames[int.parse(winnerIs)],
                                    assetsImages[int.parse(winnerIs)]);
                              }
                            },
                            label: Text("Display Winner"),
                            icon: Icon(Icons.card_giftcard),
                          )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildWidgetBasedOnRole(String? role, var contractLink) {
    print("_buildWidgetBasedOnRole ====>>> ");
    if (role == ORG_ADMIN_ROLE) {
      return _buildGroupAdminWidget(role, contractLink);
    } else if (role != null && role == SUPER_ADMIN_ROLE) {
      return _buildSuperAdminWidget(role, contractLink);
    }
    return Container();
  }

  Widget _buildSuperAdminWidget(String? role, var contractLink) {
    print("_buildSuperAdminWidget ====>>> ");
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
      child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              registerOrganizationDialog(context);
            },
            label: Text("Register Organization"),
            icon: Icon(Icons.app_registration),
          )),
    );
  }

  Widget _buildGroupAdminWidget(String? role, var contractLink) {
    print("_buildGroupAdminWidget ====>>> ");
    return Container(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
          child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  registerVoterDialog(context);
                },
                label: Text("Register Voter"),
                icon: Icon(Icons.app_registration),
              )),
        ),
        contractLink.isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        contractLink.getTotalVotes();
                      },
                      label: Text("Total Voted - ${contractLink.totalVotes} "),
                      icon: Icon(Icons.countertops),
                    )),
              ),
        contractLink.isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        contractLink.getTotalVoters();
                      },
                      label:
                          Text("Total Voters - ${contractLink.totalVoters} "),
                      icon: Icon(Icons.countertops),
                    )),
              ),
        contractLink.isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await contractLink.announcedWinner();
                        print(" Winner is announced! ");
                      },
                      label: Text("Announced Winner"),
                      icon: Icon(Icons.announcement),
                    )),
              )
      ]),
    );
  }

  registerOrganizationDialog(context) {
    var contractLink = Provider.of<ElectionContract>(context, listen: false);
    TextEditingController voterAddress = TextEditingController();
    TextEditingController chairpersonAddress = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Register Organization",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "(ONLY Super Admin CAN REGISTER Organization!)",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18.0, bottom: 8.0),
                  child: TextField(
                    controller: chairpersonAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Organization Name",
                        hintText: "Organization Name"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: voterAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Organization Admin Address",
                        hintText: "Enter Org Admin Address..."),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          //Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            print(
                                "Organization register successful - TODO integration is pending");
                            showToast(
                                "Organization ${voterAddress.text.substring(0, 5)}XXXX Registered.",
                                context);
                            Navigator.pop(context);
                            //Navigator.of(context).pop();
                          },
                          child: Text("Register")),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  registerVoterDialog(context) {
    var contractLink = Provider.of<ElectionContract>(context, listen: false);
    TextEditingController voterAddress = TextEditingController();
    TextEditingController chairpersonAddress = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Register Voter",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "(ONLY Group Admin CAN REGISTER VOTERS!)",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18.0, bottom: 8.0),
                  child: TextField(
                    controller: chairpersonAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Group Admin Address",
                        hintText: "Enter Group Admin Address..."),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: voterAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Voter Address",
                        hintText: "Enter Voter Address..."),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          //Navigator.pop(context);
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            contractLink.registerVoter(
                                voterAddress.text, chairpersonAddress.text);
                            showToast(
                                "Voter ${voterAddress.text.substring(0, 5)}XXXX Registered.",
                                context);
                            // Navigator.pop(context);
                            Navigator.of(context).pop();
                          },
                          child: Text("Register")),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  displayWinner(context, winnerIs, image) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Winner Is $winnerIs",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Image(image: AssetImage(image)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"))
              ],
            ),
          );
        });
  }

  showToast(String message, BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.teal,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      textColor: Colors.white,
      fontSize: 20,
    );
  }

  showError(String message, BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.amberAccent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      textColor: Colors.white,
      fontSize: 20,
    );
  }
}
