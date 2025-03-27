import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'profile_screen.dart';

void main() {
  runApp(MaterialApp(home: PracticeScreen()));
}

class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<Map<String, String>> videos = [
    {"title": "Organic Farming Basics", "link": "https://youtu.be/15VFaEVsCKc?si=RIwYyvhcIKZ-3tdE"},
    {"title": "Modern Irrigation Techniques", "link": "https://youtu.be/JXcMu0jmeQQ?si=6Z0hPttJ3bvGpQ67"},
  ];

  List<Map<String, String>> ebooks = [
    {"title": "Organic Farming Guide", "pdf": "assets/ebook1.pdf"},
    {"title": "Irrigation Systems Explained", "pdf": "assets/ebook2.pdf"},
  ];

  void addVideo(String title, String link) {
    setState(() {
      videos.add({"title": title, "link": link});
    });
  }

  void addEbook(String title, String filePath) {
    setState(() {
      ebooks.add({"title": title, "pdf": filePath});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5E9E8D),
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("PRACTICE",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                GestureDetector( // <-- Wrap with GestureDetector
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()), // Navigate to ProfileScreen
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 30,
                    backgroundImage: AssetImage("assets/default_avatar.png"),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("VIDEOS", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FullVideoSection(videos, addVideo)));
                    }),
                    _buildVideoSection(limit: 2),
                    SizedBox(height: 20),
                    _buildSectionHeader("GUIDE & TIPS", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FullEbookSection(ebooks, addEbook)));
                    }),
                    _buildEbookSection(limit: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onExpand) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.white), onPressed: onExpand),
      ],
    );
  }

  Widget _buildVideoSection({int limit = 2}) {
    return Column(
      children: videos.take(limit).map((video) {
        return _buildVideoItem(video);
      }).toList(),
    );
  }

  Widget _buildVideoItem(Map<String, String> video) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(video['link']!)!,
                flags: YoutubePlayerFlags(autoPlay: false, mute: false),
              ),
              showVideoProgressIndicator: true,
            ),
            SizedBox(height: 8),
            Text(video['title']!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildEbookSection({int limit = 2}) {
    return Column(
      children: ebooks.take(limit).map((ebook) {
        return ListTile(
          leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
          title: Text(ebook['title']!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          onTap: () {
            print("Opening PDF: ${ebook['pdf']}");
          },
        );
      }).toList(),
    );
  }
}

class FullVideoSection extends StatefulWidget {
  final List<Map<String, String>> videos;
  final Function(String, String) addVideo;
  FullVideoSection(this.videos, this.addVideo);

  @override
  _FullVideoSectionState createState() => _FullVideoSectionState();
}

class _FullVideoSectionState extends State<FullVideoSection> {
  String searchQuery = "";

  void _addNewVideo() {
    TextEditingController titleController = TextEditingController();
    TextEditingController linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Video"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Video Title")),
            TextField(controller: linkController, decoration: InputDecoration(labelText: "YouTube Link")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(onPressed: () {
            widget.addVideo(titleController.text, linkController.text);
            Navigator.pop(context);
            setState(() {});
          }, child: Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5E9E8D),
      appBar: AppBar(title: Text("All Videos"), backgroundColor: Colors.green[900]),
      body: Column(
        children: [
          Expanded(child: ListView(children: widget.videos.map((video) => _buildVideoItem(video)).toList())),
        ],
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: _addNewVideo),
    );
  }

  Widget _buildVideoItem(Map<String, String> video) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(video['link']!)!,
          flags: YoutubePlayerFlags(autoPlay: false, mute: false),
        ),
        showVideoProgressIndicator: true,
      ),
    );
  }
}

class FullEbookSection extends StatelessWidget {
  final List<Map<String, String>> ebooks;
  final Function(String, String) addEbook;
  FullEbookSection(this.ebooks, this.addEbook);

  void _addNewEbook(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      addEbook(result.files.single.name, result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5E9E8D),
      appBar: AppBar(title: Text("All E-books"), backgroundColor: Colors.green[900]),
      body: ListView(
        children: ebooks.map((ebook) {
          return ListTile(
            title: Text(ebook['title']!, style: TextStyle(color: Colors.white)),
            onTap: () => print("Opening PDF: ${ebook['pdf']}"),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () => _addNewEbook(context)),
    );
  }
}
