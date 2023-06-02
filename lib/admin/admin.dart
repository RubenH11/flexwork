import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flexwork/admin/content.dart";
import "package:flexwork/admin/menu.dart";
import "package:flexwork/admin/newSpace/keyboardListener.dart";
import "package:flexwork/admin/newSpace/menuAbove.dart";
import "package:flexwork/admin/newSpace/menuInfiniteCoords.dart";
import "package:flexwork/admin/newSpace/rectMenu.dart";
import "package:flexwork/admin/usersContent.dart";
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/models/adminState.dart';
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/newSpaceNotifier.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/editWorkspace.dart";
import "package:flexwork/widgets/layout.dart";
import 'package:flexwork/widgets/menuItem.dart';
import 'package:flexwork/widgets/floor.dart';
import "package:flexwork/widgets/navButton.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../widgets/customTextButton.dart";
import '../models/workspaceSelectionNotifier.dart';

enum AdminPages {
  floors,
  newSpaceAdvanced,
  newSpaceRect,
  users,
}

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService().getWorkspaceTypesStream(),
      builder: (context, typeSnapshot) {
        if (typeSnapshot.hasError) {
          print(typeSnapshot.error);
          return const Text("An error occurred, please reload the page.");
        }

        if (typeSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary),
          );
        }

        FirebaseService().buildWorkspaceTypesRepo(typeSnapshot.data!);

        return StreamBuilder(
          stream: FirebaseService().getWorkspacesStream(),
          builder: (context, workspaceSnapshot) {
            if (workspaceSnapshot.hasError) {
              print(workspaceSnapshot.error);
              return const Text("An error occurred, please reload the page.");
            }

            if (workspaceSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary),
              );
            }

            FirebaseService().buildWorkspacesRepo(workspaceSnapshot.data!);
            return StreamBuilder(
              stream: FirebaseService().getEmployeesStream(),
              builder: (context, employeesSnapshot) {
                if (employeesSnapshot.hasError) {
                  print(employeesSnapshot.error);
                  return const Text(
                      "An error occurred, please reload the page.");
                }

                if (employeesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary),
                  );
                }
                FirebaseService().buildEmployeesReop(employeesSnapshot.data!);
                return _AdminScreen();
              },
            );
          },
        );
      },
    );
  }
}

class _AdminScreen extends StatelessWidget {
  _AdminScreen({super.key});

  final newSpaceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final adminState = Provider.of<AdminState>(context);

    late final Widget screen;

    if (adminState.getOpenPage() == AdminPages.newSpaceRect ||
        adminState.getOpenPage() == AdminPages.newSpaceAdvanced) {
      screen = ChangeNotifierProvider<NewSpaceNotifier>(
        create: (_) {
          if (adminState.getSelectedWorkspace() == null) {
            return NewSpaceNotifier(floor: adminState.getFloor());
          }
          return NewSpaceNotifier(
            floor: adminState.getFloor(),
            coordinates: adminState.getSelectedWorkspace()!.getCoords(),
          );
        },
        builder: (ctx, _) {
          final newSpace = Provider.of<NewSpaceNotifier>(ctx);
          return Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                width: 350,
                child: Column(children: [
                  NewSpaceMenuAbove(),
                  Expanded(
                    child: adminState.getOpenPage() == AdminPages.newSpaceRect
                        ? NewSpaceDefaultMenu(
                            newSpaceFocusNode: newSpaceFocusNode,
                          )
                        : NewSpaceMenuInfiniteCoordinates(
                            newSpaceFocusNode: newSpaceFocusNode,
                          ),
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            adminState.setOpenPage(AdminPages.floors);
                          },
                          active: true,
                          selected: false,
                          text: "cancel",
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () async {
                            await FirebaseService().workspaces.add(newSpace);
                            adminState.setOpenPage(AdminPages.floors);
                          },
                          active: newSpace.isValid(adminState.getFloor()),
                          selected: true,
                          text: "add",
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: NewSpaceKeyboardListener(
                      floor: adminState.getFloor(),
                      focusNode: newSpaceFocusNode),
                ),
              ),
            ],
          );
        },
      );
    } else if (adminState.getOpenPage() == AdminPages.users) {
      screen = Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: AdminUsersContent(),
      );
    } else {
      screen = Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            width: 350,
            child: AdminMenu(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: AdminContent(),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          child: Row(
            children: [
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 20,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NavButton(
                        selected: adminState.getOpenPage() == AdminPages.floors,
                        action: () => adminState.setOpenPage(AdminPages.floors),
                        text: "Floors",
                      ),
                      Container(
                        height: 25,
                        width: 1,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      NavButton(
                        selected: adminState.getOpenPage() == AdminPages.users,
                        action: () => adminState.setOpenPage(AdminPages.users),
                        text: "Users",
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: screen,
        ),
      ],
    );
  }
}
