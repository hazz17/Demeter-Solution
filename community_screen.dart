import 'dart:math';
import 'package:flutter/material.dart';
import 'group_chat_screen.dart';
import 'chatbot_screen.dart';
import 'profile_screen.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> communities = [
    {
      "name": "Genz Farmers",
      "groupCode": "ABC123",
      "lastMessage": "Farid: harini macam mendung je cuac...",
      "profileImage": "assets/community1.png",
      "messages": [
        {"user": "Farid", "text": "Harini macam mendung je cuaca tapi aku tak rasa hujan ni.", "profile": "assets/user1.png"},
        {"user": "Ali", "text": "Betul, tadi pun macam hujan renyai sekejap.", "profile": "assets/user2.png"}
      ]
    },
    {
      "name": "Organic Growers",
      "groupCode": "XYZ789",
      "lastMessage": "Ali: Ada tips jaga pokok?",
      "profileImage": "assets/community2.png",
      "messages": [
        {"user": "Ali", "text": "Ada tips jaga pokok? Saya nak elakkan daun kuning.", "profile": "assets/user2.png"},
        {"user": "Siti", "text": "Cuba tambah baja organik, ia boleh bantu.", "profile": "assets/user3.png"}
      ]
    }
  ];

  void _navigateToChat(Map<String, dynamic> community) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupChatScreen(community: community)),
    );
  }

  void _showJoinOrCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[800], // Green background
        title: Text("Join or Create Community", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _joinCommunity,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text("Join a Community", style: TextStyle(color: Colors.green[800])),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createCommunity,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text("Create a Community", style: TextStyle(color: Colors.green[800])),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _joinCommunity() {
    TextEditingController groupCodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[800], // Green background
        title: Text("Join Community", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: groupCodeController,
          decoration: InputDecoration(
            hintText: "Enter group code",
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              String enteredCode = groupCodeController.text.trim();
              var foundCommunity = communities.firstWhere(
                      (c) => c["groupCode"] == enteredCode,
                  orElse: () => {});

              if (foundCommunity.isNotEmpty) {
                Navigator.pop(context);
                _navigateToChat(foundCommunity);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invalid group code!")),
                );
              }
            },
            child: Text("Join", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _createCommunity() {
    TextEditingController communityNameController = TextEditingController();
    String generatedGroupCode = _generateGroupCode();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[800], // Green background
        title: Text("Create Community", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: communityNameController,
              decoration: InputDecoration(
                hintText: "Enter community name",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text("Group Code: $generatedGroupCode", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              if (communityNameController.text.trim().isNotEmpty) {
                setState(() {
                  communities.add({
                    "name": communityNameController.text.trim(),
                    "groupCode": generatedGroupCode,
                    "lastMessage": "Welcome to ${communityNameController.text.trim()}!",
                    "profileImage": "assets/default_avatar.png",
                    "messages": []
                  });
                });
                Navigator.pop(context);
              }
            },
            child: Text("Create", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _generateGroupCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5E9E8D),
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("COMMUNITY", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      backgroundImage: AssetImage("assets/default_avatar.png"),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                  ),
                ],
              )
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: communities.length,
              itemBuilder: (context, index) {
                var community = communities[index];
                return GestureDetector(
                  onTap: () => _navigateToChat(community),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(community['profileImage']),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(community['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text("Code: ${community['groupCode']}", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text(community['lastMessage'], style: TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.green[800],
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())),
                    child: Image.asset('assets/chatbot.png', height: 30),
                  ),
                  SizedBox(height: 12),
                  FloatingActionButton(
                    backgroundColor: Colors.green[800],
                    onPressed: _showJoinOrCreateDialog,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
