import 'package:flexwork/database/database.dart';
import 'package:flexwork/widgets/bottomSheets.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flutter/material.dart';
import "dart:math" as math;

class AdminUsersContent extends StatefulWidget {
  const AdminUsersContent({super.key});

  @override
  State<AdminUsersContent> createState() => _AdminUsersContentState();
}

class _AdminUsersContentState extends State<AdminUsersContent> {
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

  void openCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: ((dialogContext) {
        final emailController = TextEditingController();
        final nameController = TextEditingController();
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
                  controller: emailController,
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
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: 400,
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Optional: enter the (full) name of the user",
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
                      Navigator.pop(dialogContext);
                    },
                    selected: false,
                    text: "Cancel",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomElevatedButton(
                    active: true,
                    onPressed: () async {
                      final result = await DatabaseFunctions.registerUser(
                          emailController.text, "123456", nameController.text);

                      if (result.item1) {
                        // ignore: use_build_context_synchronously
                        showBottomSheetWithTimer(
                          context,
                          "Succesfullt added user with email ${emailController.text}",
                          succes: true,
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        String message = "Something went wrong";
                        switch (result.item2) {
                          case "INVALID_EMAIL":
                            message = "Email adress was badly formatted";
                            break;
                          case "ER_DUP_ENTRY":
                            message = "Email address already exists";
                            break;
                          default:
                            print("error code was: ${result.item2}");
                        }
                        showBottomSheetWithTimer(
                          context,
                          message,
                          error: true,
                        );
                      }

                      Navigator.pop(dialogContext);
                      setState(() {});
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
    return Row(
      children: [
        SizedBox(
          width: 350,
        ),
        VerticalDivider(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: FlexworkFutureBuilder(
              future: DatabaseFunctions.getUsers(),
              builder: (users) {
                return Column(
                  children: [
                    CustomElevatedButton(
                      onPressed: () => openCreateUserDialog(context),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 20),
                                  Expanded(child: Text(users[index].email)),
                                  Expanded(child: Text(users[index].role)),
                                  IconButton(
                                    onPressed: users[index].role == "admin"
                                        ? null
                                        : () async {
                                            final statusCode =
                                                await DatabaseFunctions
                                                    .deleteUser(
                                                        users[index].id);
                                            if (statusCode == 200) {
                                              showBottomSheetWithTimer(context,
                                                  "User deleted succesfully",
                                                  succes: true);
                                            } else {
                                              showBottomSheetWithTimer(context,
                                                  "Could not delete user",
                                                  error: true);
                                            }
                                            setState(() {});
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
              },
            ),
          ),
        ),
        VerticalDivider(),
        SizedBox(
          width: 350,
        ),
      ],
    );
  }
}
