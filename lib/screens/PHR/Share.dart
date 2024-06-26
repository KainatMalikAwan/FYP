import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Services/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class Doctor {
  final int id;
  final String specialization;
  final int mrId;
  final String name;

  Doctor({
    required this.id,
    required this.specialization,
    required this.mrId,
    required this.name,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      specialization: json['specialization'],
      mrId: json['mrId'],
      name: json['name'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Doctor> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    try {
      // Replace with your API URL
      final url = Uri.parse('${Config.baseUrlDoc}/doctors');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        setState(() {
          doctors = data.map((doctor) => Doctor.fromJson(doctor)).toList();
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors List'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show dialog with doctor list
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Doctors List',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              tileColor: Colors.grey[200],
                              title: Text(
                                doctors[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Specialization: ${doctors[index].specialization}\nMRID: ${doctors[index].mrId}',
                              ),
                              trailing: Checkbox(
                                value: false, // Replace with actual value
                                onChanged: (bool? value) {
                                  // Handle checkbox change
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text('Open Doctors List'),
        ),
      ),
    );
  }
}
