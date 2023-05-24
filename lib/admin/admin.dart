import "package:cloud_firestore/cloud_firestore.dart";
import "package:flexwork/admin/content.dart";
import "package:flexwork/admin/menu.dart";
import "package:flexwork/admin/newSpace/keyboardListener.dart";
import "package:flexwork/admin/newSpace/menuAbove.dart";
import "package:flexwork/admin/newSpace/menuInfiniteCoords.dart";
import "package:flexwork/admin/newSpace/rectMenu.dart";
import "package:flexwork/helpers/firebaseService.dart";
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/newSpaceNotifier.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/layout.dart";
import 'package:flexwork/widgets/menuItem.dart';
import 'package:flexwork/widgets/floor.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../widgets/customTextButton.dart";
import '../models/workspaceSelectionNotifier.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _NewReservationStructureState();
}

class _NewReservationStructureState extends State<Admin> {
  final LABEL_INDENT = 10.0;
  var _floor = Floors.f9;
  var newSpaceInterface = false;
  var advancedMenu = false;
  final newSpaceFocusNode = FocusNode();
  Workspace? _selectedWorkspace;

  void setSelectedWorkspace(Workspace? workspace) {
    setState(() {
      _selectedWorkspace = workspace;
    });
  }

  void setFloor(Floors floor) {
    setState(() {
      _floor = floor;
    });
  }

  void setNewSpaceInterface() {
    setState(() {
      newSpaceInterface = true;
    });
  }

  void setAdvancedMenu() {
    setState(() {
      advancedMenu = true;
    });
  }

  void setDefaultMenu() {
    setState(() {
      advancedMenu = false;
    });
  }

  @override
  void dispose() {
    newSpaceFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService().getAllSpacesStreamFromDB(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("An error occurred, please reload the page.");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary),
          );
        }
        //Future accepts the coordinates that come with the workspaces, such that the Workspace objects can be created
        return FutureBuilder(
          future: FirebaseService().getAllWorkspacesFromDB(snapshot.data!.docs),
          builder: (_, workspaces) {
            if (workspaces.hasError) {
              return const Text("An error occurred, please reload the page.");
            }

            if (workspaces.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary),
              );
            }
            // FirebaseService().printWorkspaces();
            return newSpaceInterface
                ? ChangeNotifierProvider<NewSpaceNotifier>(
                    create: (_) => NewSpaceNotifier(_floor),
                    builder: (ctx, _) {
                      final newSpace = Provider.of<NewSpaceNotifier>(ctx);
                      return Layout(
                        navigation: Text(
                          "New workspace on floor ${_floor.name.substring(1)}",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        aboveMenu: NewSpaceMenuAbove(
                          advancedMenu: advancedMenu,
                          setAdvancedMenu: setAdvancedMenu,
                          setDefaultMenu: setDefaultMenu,
                        ),
                        menu: Column(
                          children: [
                            Expanded(
                              child: advancedMenu
                                  ? NewSpaceMenuInfiniteCoordinates(
                                      newSpace: newSpace,
                                      newSpaceFocusNode: newSpaceFocusNode,
                                    )
                                  : NewSpaceDefaultMenu(
                                      newSpaceFocusNode: newSpaceFocusNode,
                                      isValid: newSpace.isValid(_floor),
                                    ),
                            ),
                            Row(
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: CustomElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        newSpaceInterface = false;
                                      });
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
                                      await FirebaseService()
                                          .addNewWorkspaceToDB(newSpace);
                                      setState(() {
                                        newSpaceInterface = false;
                                      });
                                    },
                                    active: newSpace.isValid(_floor),
                                    selected: true,
                                    text: "add",
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        content: NewSpaceKeyboardListener(
                            floor: _floor, focusNode: newSpaceFocusNode),
                      );
                    },
                  )
                : Layout(
                    navigation: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 70,
                            child: CustomTextButton(
                                onPressed: () {},
                                selected: true,
                                text: "Floors",
                                size: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize)),
                        Container(
                          height: 25,
                          width: 1,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        SizedBox(
                            width: 70,
                            child: CustomTextButton(
                                onPressed: () {},
                                selected: false,
                                text: "Other",
                                size: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize)),
                      ],
                    ),
                    menu: AdminMenu(
                      floor: _floor,
                      setFloor: setFloor,
                      setNewSpaceInterface: () {
                        setNewSpaceInterface();
                      },
                      selectedWorkspace: _selectedWorkspace,
                      setSelectedWorkspace: setSelectedWorkspace,
                    ),
                    content: ChangeNotifierProvider<WorkspaceSelectionNotifier>(
                      create: (context) => WorkspaceSelectionNotifier(),
                      child: AdminContent(
                        floor: _floor,
                        selectedWorkspace: _selectedWorkspace,
                        setSelectedWorkspace: setSelectedWorkspace,
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
