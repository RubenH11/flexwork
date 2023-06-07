import 'package:flexwork/database/database.dart';
import 'package:flexwork/widgets/bottomSheets.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flutter/material.dart';
import "dart:math" as math;

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
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
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
              Text(
                "A password will be sent to this email address",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
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
    return FlexworkFutureBuilder(
      future: DatabaseFunctions.getUsers(),
      builder: (users) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: Column(
            children: [
              CustomElevatedButton(
                onPressed: () {
                  openCreateUserDialog(
                    context,
                    (email) async {
                      try {
                        await DatabaseFunctions.registerUser(email, "123456");
                      } catch (error) {
                        showBottomSheetWithTimer(
                          context,
                          "Something went wrong",
                          error: true,
                        );
                      }
                    },
                  );
                },
                active: true,
                selected: true,
                text: "Add a new user",
                icon: Icons.add,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(users[index].id.toString())),
                            Expanded(child: Text(users[index].email)),
                            IconButton(
                              onPressed: () async {
                                final statusCode = await DatabaseFunctions.deleteUser(users[index].id);
                                if(statusCode == 200){
                                  showBottomSheetWithTimer(context, "User deleted succesfully", succes: true);
                                }
                                else{
                                  showBottomSheetWithTimer(context, "Could not delete user", error: true);
                                }
                                DatabaseFunctions().notifyListeners();
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
          ),
        );
      },
    );
  }
}
