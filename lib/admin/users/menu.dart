import 'package:flexwork/helpers/database.dart';
import 'package:flexwork/models/employee.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/menuItem.dart';
import 'package:flutter/material.dart';

class AdminUsersMenu extends StatelessWidget {
  final List<User> pendingUsers;
  final void Function() setState;
  const AdminUsersMenu({super.key, required this.pendingUsers, required this.setState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      width: 200,
      child: SingleChildScrollView(
        child: MenuItem(
          icon: const Icon(Icons.notifications),
          title: "Account requests",
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: pendingUsers.length,
              itemBuilder: (context, index) {
                print(pendingUsers.length);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      pendingUsers[index].email,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            async: true,
                            onPressed: () async {
                              await DatabaseFunctions.deleteUser(pendingUsers[index].id);
                            },
                            active: true,
                            selected: true,
                            text: "Reject",
                            selectedColor: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomElevatedButton(
                            async: true,
                            onPressed: () async {
                              await DatabaseFunctions.updateUser(pendingUsers[index].id, 'user');
                              setState();
                            },
                            active: true,
                            selected: true,
                            selectedColor: Colors.green,
                            text: "Accept",
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
