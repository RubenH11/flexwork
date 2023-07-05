import 'package:flexwork/admin/users/content.dart';
import 'package:flexwork/admin/users/menu.dart';
import 'package:flexwork/helpers/database.dart';
import 'package:flexwork/widgets/bottomSheets.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flutter/material.dart';
import "dart:math" as math;

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  void _setState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FlexworkFutureBuilder(
      future: DatabaseFunctions.getUsers(),
      builder: (users) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: AdminUsersMenu(
              pendingUsers:
                  users.where((user) => user.role == 'pending').toList(),
              setState: _setState,
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: AdminUsersContent(
              users: users,
              setState: _setState,
            ),
          ),
        ],
      ),
    );
  }
}
