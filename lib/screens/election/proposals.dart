import '../../contract_linking/election.dart';
import 'index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

List candidateNames = ["Nageshwar Rao", "Ashok Reddy", "Hari Prasad"];

List assetsImages = [
  "assets/logos/p1.png",
  "assets/logos/p2.png",
  "assets/logos/p3.png",
];

class Proposals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ElectionContract>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Election On Blockchain"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, int index) {
            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  margin: EdgeInsets.only(left: 30),
                  child: Card(
                    color: Colors.indigo[100],
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 74.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Name - ${candidateNames[index]}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                textBaseline: TextBaseline.ideographic),
                          ),
                          ElevatedButton(
                            child: Text("Vote"),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.cyan),
                            onPressed: () {
                              voteProposal(context, index);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20.0,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blue.withOpacity(.3),
                            offset: Offset(0, 2),
                            blurRadius: 5)
                      ],
                    ),
                    constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
                    child: CircleAvatar(
                      maxRadius: 60,
                      backgroundColor: Colors.lightBlueAccent,
                      backgroundImage: AssetImage("${assetsImages[index]}"),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  voteProposal(context, int toProposal) {
    var contractLink = Provider.of<ElectionContract>(context, listen: false);
    TextEditingController voterAddress = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Vote Proposal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18, bottom: 8.0),
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
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            contractLink.vote(toProposal, voterAddress.text);
                            showToast("Thanks for voting !", context);
                            //Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ElectionUI()),
                                (route) => false);
                          },
                          child: Text("VOTE")),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  showToast(String message, BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.orange,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      textColor: Colors.white,
      fontSize: 20,
    );
  }
}
