import 'package:flutter/material.dart';

class CustomAddVitalsPopUp extends StatefulWidget {
  final VoidCallback onClose;

  const CustomAddVitalsPopUp({Key? key, required this.onClose}) : super(key: key);

  @override
  _CustomAddVitalsPopUpState createState() => _CustomAddVitalsPopUpState();
}

class _CustomAddVitalsPopUpState extends State<CustomAddVitalsPopUp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SaveCancelButtons(
        onSave: () {
          print('Save button pressed'); // Perform save operation here
          widget.onClose(); // Close the popup
        },
        onCancel: () {
          print('Cancel button pressed'); // Perform cancel operation here
          widget.onClose(); // Close the popup
        },
      ),
    );
  }
}

class SaveCancelButtons extends StatefulWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const SaveCancelButtons({
    Key? key,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _SaveCancelButtonsState createState() => _SaveCancelButtonsState();
}

class _SaveCancelButtonsState extends State<SaveCancelButtons> {
  bool saveSelected = false;
  bool cancelSelected = true; // Set Cancel button selected by default

  @override
  void initState() {
    super.initState();
    // Set Cancel button selected by default
    setState(() {
      cancelSelected = true;
      saveSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 45,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.5,
              blurRadius: 2,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    saveSelected = true;
                    cancelSelected = false;
                  });
                  widget.onSave();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: saveSelected ? Colors.white : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: saveSelected ? Color(0xFF199A8E) : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    cancelSelected = true;
                    saveSelected = false;
                  });
                  widget.onCancel();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: cancelSelected ? Colors.white : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: cancelSelected ? Color(0xFF199A8E) : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
