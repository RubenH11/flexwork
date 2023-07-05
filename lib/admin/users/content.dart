import 'package:flexwork/helpers/database.dart';
import 'package:flexwork/models/employee.dart';
import 'package:flexwork/widgets/bottomSheets.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flutter/material.dart';

class AdminUsersContent extends StatelessWidget {
  final void Function() setState;
  final List<User> users;
  const AdminUsersContent(
      {super.key, required this.setState, required this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    users[index].email,
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child:
                          Text(users[index].role, textAlign: TextAlign.center)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (users[index].role == "pending")
                          IconButton(
                            onPressed: () async {
                              await DatabaseFunctions.updateUser(users[index].id, 'user');
                              setState();
                            },
                            icon: Icon(Icons.check),
                            color: Colors.green,
                          ),
                        if (users[index].role == "pending")
                          IconButton(
                            onPressed: () async {
                              await DatabaseFunctions.deleteUser(users[index].id);
                              setState();
                            },
                            icon: Icon(Icons.close),
                            color: Theme.of(context).colorScheme.error,
                          ),
                        if (users[index].role == "admin" ||
                            users[index].role == "user")
                          IconButton(
                            onPressed: users[index].role == "admin"
                                ? null
                                : () async {
                                    final statusCode =
                                        await DatabaseFunctions.deleteUser(
                                            users[index].id);
                                    if (statusCode == 200) {
                                      showBottomSheetWithTimer(
                                        context,
                                        "User deleted succesfully",
                                        succes: true,
                                      );
                                    } else {
                                      showBottomSheetWithTimer(
                                        context,
                                        "Could not delete user",
                                        error: true,
                                      );
                                    }
                                    setState();
                                  },
                            icon: const Icon(Icons.delete),
                            color: Theme.of(context).colorScheme.error,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
