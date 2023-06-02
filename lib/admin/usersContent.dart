import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/models/adminState.dart';
import 'package:flexwork/models/employee.dart';
import 'package:flexwork/widgets/bottomSheets.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flutter/material.dart';
import "dart:math" as math;

import 'package:provider/provider.dart';

class AdminUsersContent extends StatelessWidget {
  const AdminUsersContent({super.key});

  String generateRandomPassword(int length) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%&*()-_=+';
    math.Random random = math.Random();
    String password = '';

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(chars.length);
      password += chars[randomIndex];
    }

    return password;
  }

  void openCreateUserDialog(
      BuildContext context, void Function(String) confirm) {
    showDialog(
      context: context,
      builder: ((context) {
        final messageController = TextEditingController();
        return AlertDialog(
          contentPadding:
              const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          actionsPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                width: 400,
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Enter email address",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                            color:
                                Theme.of(context).colorScheme.onBackground),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                      borderRadius: BorderRadius.zero,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Text("A password will be sent to this email address", style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    active: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    selected: false,
                    text: "Cancel",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomElevatedButton(
                    active: true,
                    onPressed: () {
                      confirm(messageController.text);
                      Navigator.pop(context);
                    },
                    selected: true,
                    text: "Confirm",
                  ),
                ),
              ],
            )
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employees = FirebaseService().employees.get(role: "user");
    final adminData = Provider.of<AdminState>(context, listen: false);
    print("num employyes: ${employees.length}");
    return Column(
      children: [
        CustomElevatedButton(
          onPressed: () {
            openCreateUserDialog(context, (email) async {
              try {
                FirebaseService()
                    .employees
                    .registerUser(email, "user", generateRandomPassword(12), adminData);
              } on FirebaseAuthException catch (error) {
                showBottomSheetWithTimer(
                  context,
                  "Error: $error",
                  Theme.of(context).colorScheme.error,
                  Theme.of(context).colorScheme.onError,
                );
              } catch (error) {
                showBottomSheetWithTimer(
                  context,
                  "Something went wrong",
                  Theme.of(context).colorScheme.error,
                  Theme.of(context).colorScheme.onError,
                );
              }
            });
          },
          active: true,
          selected: true,
          text: "Add a new user",
          icon: Icons.add,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: employees.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(employees[index].uid)),
                      Expanded(child: Text(employees[index].email)),
                      IconButton(
                        onPressed: () {
                          FirebaseService()
                              .employees
                              .delete(employees[index].uid);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
