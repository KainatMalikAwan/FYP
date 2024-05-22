import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeTextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMd().format(DateTime.now());
    String formattedTime = DateFormat.Hm().format(DateTime.now());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Display current date and time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date:   $formattedDate',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Time:   $formattedTime',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Edit icon
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.green, // Adjust color according to your preference
              onPressed: () {
                // Implement edit functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}


