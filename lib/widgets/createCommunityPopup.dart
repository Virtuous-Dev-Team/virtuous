import 'package:flutter/material.dart';
import 'package:virtuetracker/api/communityCreation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/controllers/communityCreationController.dart';
import 'package:virtuetracker/api/communityCreation.dart';

// dev only
// for creating community and adding to database

void showCreateCommunityDialog(BuildContext context, WidgetRef ref) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Create Community"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Community Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Community Description",
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

                await communityCreationController.createNewCommunity(nameController.text, descriptionController.text);
              } catch (e) {
                print('Error in create community popup $e');
              }
            },
            child: Text("Create Community"),
          ),
        ],
      );
    },
  );
}