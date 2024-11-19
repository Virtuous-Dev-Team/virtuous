import 'package:flutter/material.dart';
import 'package:virtuetracker/api/communityCreation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/controllers/communityCreationController.dart';
import 'package:virtuetracker/api/communityCreation.dart';

// dev only
// for creating virtue and adding to database

void showCreateVirtueDialog(BuildContext context, WidgetRef ref, String currentCommunity) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController colorCodeController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Create Virtue"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Virtue Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Virtue Definition",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextField(
              controller: colorCodeController,
              decoration: InputDecoration(
                labelText: "Color Code",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                final communityCreationController = 
                  ref.read(communityCreationProvider);

                await communityCreationController
                  .createVirtue(
                    currentCommunity,
                    nameController.text,
                    descriptionController.text,
                    colorCodeController.text);
              } catch (e) {
                print('Error in create virtue popup $e');
              }
            
            },
            child: Text("Create Virtue"),
          ),
        ],
      );
    },
  );
}