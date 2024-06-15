import 'package:flutter/material.dart';

class CustomPopupNotification extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const CustomPopupNotification({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Accessing the theme

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, theme),
    );
  }

  contentBox(context, ThemeData theme) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 50,
                color: theme.primaryColor, // Use theme primary color
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Return true for Yes
                    },
                    child: Text('Yes'),
                    style: ElevatedButton.styleFrom(
                      primary: theme.primaryColor, // Use theme primary color
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Return false for No
                    },
                    child: Text('No'),
                    style: ElevatedButton.styleFrom(
                      primary: theme.primaryColor, // Use theme primary color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void showCustomPopupNotification(BuildContext context, String title, String message, IconData icon) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomPopupNotification(
        title: title,
        message: message,
        icon: icon,
      );
    },
  );
}
