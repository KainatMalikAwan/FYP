import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../Services/config.dart';
import '../../../ThemeSettings/ThemeSettings.dart';
import 'EditProfile.dart';
import 'package:fyp/screens/PHR/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilesScreen extends StatefulWidget {
  final int userId;

  ProfilesScreen({required this.userId});

  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  late List<Profile> _profiles = [];

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    int? id=await prefs.getInt('userId');
    final String url = '${Config.baseUrl}/patients/profiles/${id}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        setState(() {
          _profiles = (jsonData['data'] as List)
              .map((profileJson) => Profile.fromJson(profileJson))
              .toList();
        });
      } else {
        print('Failed to fetch profiles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profiles: $e');
    }
  }

  void _openProfileDetail(Profile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailScreen(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles'),
      ),
      body: _profiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _profiles.length,
        itemBuilder: (context, index) {
          final profile = _profiles[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: ThemeSettings.labelColor),
                color: ThemeSettings.lightbg,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: ThemeSettings.buttonColor,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  profile.name,
                  style: TextStyle(color: ThemeSettings.labelColor),
                ),
                subtitle: Text(
                  profile.relation,
                  style: TextStyle(color: ThemeSettings.labelColor),
                ),
                trailing: ElevatedButton(
                  onPressed: () => _openProfileDetail(profile),
                  child: Text(
                    'Open Profile',
                    style: TextStyle(color: ThemeSettings.buttonTextColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: ThemeSettings.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Profile {
  final int id;
  final int userId;
  final int mrId;
  final String? profilePicture;
  final String name;
  final int age;
  final DateTime dob;
  final String gender;
  final String relation;

  Profile({
    required this.id,
    required this.userId,
    required this.mrId,
    required this.profilePicture,
    required this.name,
    required this.age,
    required this.dob,
    required this.gender,
    required this.relation,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['userId'],
      mrId: json['mrId'],
      profilePicture: json['profilePicture'],
      name: json['name'],
      age: json['age'],
      dob: DateTime.parse(json['dob']),
      gender: json['gender'],
      relation: json['relation'],
    );
  }
}











class ProfileDetailScreen extends StatelessWidget {
  final Profile profile;

  ProfileDetailScreen({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(profile: profile)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: ThemeSettings.labelColor,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              _buildProfileDetail('Age', profile.age.toString()),
              _buildProfileDetail('Gender', profile.gender),
              _buildProfileDetail('Relation', profile.relation),
              _buildProfileDetail('Dob', DateFormat('yyyy-MM-dd').format(profile.dob)),

              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _build_SwitchedButton(context)),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ThemeSettings.labelColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 16.0), // Adjust spacing as needed
      ],
    );
  }

  Widget _build_SwitchedButton(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          _switchtoProf();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen(token: "token")),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: ThemeSettings.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Switch Profile',
          style: TextStyle(color: ThemeSettings.buttonTextColor),
        ),
      ),
    );
  }




  Future<void> _switchtoProf() async {
    final prefs = await SharedPreferences.getInstance();
    final int? patientId = profile.id;
    prefs.setInt('Patient-id',patientId!);

  }


}
//------------------------------------------------------------------




  // Widget _buildSwitchTile() {
  //   bool isSwitched = false; // Replace with actual logic for switch state
  //   return Container(
  //     padding: EdgeInsets.all(12.0),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8.0),
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.5),
  //           spreadRadius: 1,
  //           blurRadius: 3,
  //           offset: Offset(0, 2), // changes position of shadow
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           'Enable Notifications',
  //           style: TextStyle(
  //             color: ThemeSettings.labelColor,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         Switch(
  //           value: isSwitched,
  //           onChanged: (value) {
  //             // Update switch state logic here
  //             isSwitched = value;
  //           },
  //           activeColor: ThemeSettings.buttonColor,
  //         ),
  //       ],
  //     ),
  //   );
  // }

