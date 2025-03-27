import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> crops = [];
  List<Map<String, dynamic>> filteredCrops = [];
  bool _isLoading = true; // For UI loading state

  String _userName = "";
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchMarketData();
  }

  Future<void> _fetchUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc["name"] ?? "User";
          _profileImage = userDoc["profileImage"];
        });
      }
    }
  }

  Future<void> _fetchMarketData() async {
    List<Map<String, dynamic>> sampleCrops = [
      {"name": "Rice", "price": "RM 5.50 /kg"},
      {"name": "Corn", "price": "RM 4.20 /kg"},
      {"name": "Wheat", "price": "RM 6.00 /kg"},
      {"name": "Soybean", "price": "RM 3.80 /kg"},
      {"name": "Barley", "price": "RM 4.50 /kg"},
      {"name": "Sunflower", "price": "RM 5.80 /kg"},
      {"name": "Cotton", "price": "RM 7.00 /kg"},
      {"name": "Coffee", "price": "RM 12.00 /kg"},
      {"name": "Sugarcane", "price": "RM 3.50 /kg"},
      {"name": "Tea", "price": "RM 9.00 /kg"},
    ];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection("market").get();

      if (querySnapshot.docs.isEmpty) {
        // If Firestore is empty, add sample crops
        for (var crop in sampleCrops) {
          await _firestore.collection("market").add(crop);
        }
        setState(() {
          crops = sampleCrops;
          filteredCrops = sampleCrops;
        });
      } else {
        List<Map<String, dynamic>> cropList = querySnapshot.docs.map((doc) {
          return {
            "name": doc["name"],
            "price": doc["price"],
          };
        }).toList();
        setState(() {
          crops = cropList;
          filteredCrops = cropList;
        });
      }
    } catch (e) {
      print("Error fetching market data: $e");
      setState(() {
        crops = sampleCrops; // Show sample crops even if Firestore fails
        filteredCrops = sampleCrops;
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading animation
      });
    }
  }

  void filterSearch(String query) {
    setState(() {
      filteredCrops = crops
          .where((crop) =>
          crop['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("MARKET",
                    style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text(_userName,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    SizedBox(width: 10),
                    GestureDetector(  // <-- Wrap with GestureDetector
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen()),  // Navigate to ProfileScreen
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 30,
                        backgroundImage: _profileImage != null
                            ? NetworkImage(_profileImage!)
                            : AssetImage("assets/default_avatar.png")
                        as ImageProvider,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),
          SizedBox(height: 20),
          Image.asset('assets/graph.jpg', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: "Search crops...",
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.green.shade700,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : filteredCrops.isEmpty
                ? Center(
              child: Text(
                "No crops available",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: filteredCrops.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Card(
                    color: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        filteredCrops[index]['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        filteredCrops[index]['price'],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
