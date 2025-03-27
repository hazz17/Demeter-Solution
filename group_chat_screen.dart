import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroupChatScreen extends StatefulWidget {
  final Map<String, dynamic> community;

  GroupChatScreen({required this.community});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List messages = [];

  @override
  void initState() {
    super.initState();
    messages = List.from(widget.community["messages"] ?? []);
  }

  void _sendMessage(String text, {String? imagePath}) {
    if (text.isNotEmpty || imagePath != null) {
      setState(() {
        messages.add({
          "user": "You",
          "text": text,
          "image": imagePath,
          "profile": "assets/default_avatar.png"
        });
      });
      _messageController.clear();
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMessage("", imagePath: pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community["name"]),
        backgroundColor: Colors.green[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isNotEmpty
                ? ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var msg = messages[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(msg["profile"]),
                  ),
                  title: Text(
                    msg["user"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: msg["image"] != null
                      ? Image.file(File(msg["image"]!))
                      : Text(msg["text"]),
                );
              },
            )
                : Center(
              child: Text(
                "No messages yet! Start the conversation.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.green[900]),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green[900]),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
