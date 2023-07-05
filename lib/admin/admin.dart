import "package:flexwork/admin/floors/floors.dart";
import 'package:flexwork/admin/users/users.dart';
import "package:flexwork/widgets/navButton.dart";
import "package:flexwork/widgets/topBar.dart";
import "package:flutter/material.dart";

enum _AdminPages {
  floors,
  newSpaceAdvanced,
  newSpaceRect,
  users,
}

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  var _openPage = _AdminPages.floors;

  void setOpenPage(_AdminPages page) {
    setState(() {
      _openPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          nav: [
            NavButton(
              selected: _openPage == _AdminPages.floors,
              action: () => setOpenPage(_AdminPages.floors),
              text: "Floors",
            ),
            NavButton(
              selected: _openPage == _AdminPages.users,
              action: () => setOpenPage(_AdminPages.users),
              text: "Users",
            ),
          ],
        ),
        Expanded(
          child: _openPage == _AdminPages.floors
              ? const AdminFloors()
              : const AdminUsers(),
        ),
      ],
    );
  }
}

// class Admin extends StatefulWidget {
//   const Admin({super.key});

//   @override
//   State<Admin> createState() => _AdminState();
// }

// class _AdminState extends State<Admin> {
//   final _newSpaceFocusNode = FocusNode();
//   var _openPage = _AdminPages.users;
//   Workspace? _selectedWorkspace;
//   Floors _selectedFloor = Floors.f9;

//   void _setPage(_AdminPages page) {
//     setState(() {
//       _openPage = page;
//     });
//   }

//   void _selectFloor(Floors floor) {
//     setState(() {
//       _selectedFloor = floor;
//     });
//   }

//   void _selectWorkspace(Workspace? workspace) {
//     setState(() {
//       _selectedWorkspace = workspace;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     late final Widget screen;

//     if (_openPage == _AdminPages.newSpaceRect ||
//         _openPage == _AdminPages.newSpaceAdvanced) {
//       screen = ChangeNotifierProvider<NewSpaceNotifier>(
//         create: (_) {
//           if (_selectedWorkspace == null) {
//             return NewSpaceNotifier(floor: _selectedFloor);
//           }
//           return NewSpaceNotifier(
//             floor: _selectedFloor,
//             coordinates: _selectedWorkspace!.getCoords(),
//           );
//         },
//         builder: (ctx, _) {
//           final newSpace = Provider.of<NewSpaceNotifier>(ctx);
//           return Row(
//             children: [
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//                 width: 350,
//                 child: Column(children: [
//                   // NewSpaceMenuAbove(
//                   //   openMenu: _openPage,
//                   //   setOpenMenu: _setPage,
//                   // ),
//                   // Expanded(
//                   //   child: _openPage == _AdminPages.newSpaceRect
//                   //       ? NewSpaceDefaultMenu(
//                   //           newSpaceFocusNode: _newSpaceFocusNode,
//                   //         )
//                   //       : NewSpaceMenuInfiniteCoordinates(
//                   //           newSpaceFocusNode: _newSpaceFocusNode,
//                   //         ),
//                   // ),
//                   Row(
//                     // mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Expanded(
//                         child: CustomElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               _openPage = _AdminPages.floors;
//                             });
//                           },
//                           active: true,
//                           selected: false,
//                           text: "cancel",
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: FlexworkFutureBuilder(
//                           future:
//                               DatabaseFunctions.getWorkspaces(_selectedFloor),
//                           builder: (workspaces) {
//                             return CustomElevatedButton(
//                               onPressed: () async {
//                                 await DatabaseFunctions.addWorkspace(newSpace);
//                                 setState(() {
//                                   _openPage = _AdminPages.floors;
//                                 });
//                               },
//                               active:
//                                   newSpace.isValid(_selectedFloor, workspaces),
//                               selected: true,
//                               text: "add",
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ]),
//               ),
//               Expanded(
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
//                   child: FlexworkFutureBuilder(
//                     future: DatabaseFunctions.getWorkspaces(_selectedFloor),
//                     builder: (workspaces) {
//                       return SizedBox();
//                       // return NewSpaceKeyboardListener(
//                       //   floor: _selectedFloor,
//                       //   focusNode: _newSpaceFocusNode,
//                       //   workspaces: workspaces,
//                       // );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     } else if (_openPage == _AdminPages.users) {
//       screen = Container(
//         padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
//         child: const AdminUsersContent(),
//       );
//     } else {
//       screen = Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//             width: 350,
//             child: AdminFloorsMenu(
//               floor: _selectedFloor,
//               selectFloor: _selectFloor,
//               selectWorkspace: _selectWorkspace,
//               setNewSpace: (_) {},
//               workspace: _selectedWorkspace,
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
//               child: AdminFloorsContent(
//                 floor: _selectedFloor,
//                 selectFloor: _selectFloor,
//                 selectWorkspace: _selectWorkspace,
//                 workspace: _selectedWorkspace,
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return Column(
//       children: [
//         TopBar(nav: [
//           NavButton(
//             selected: _openPage == _AdminPages.floors,
//             action: () {
//               setState(() {
//                 _openPage = _AdminPages.floors;
//               });
//             },
//             text: "Floors",
//           ),
//           NavButton(
//             selected: _openPage == _AdminPages.users,
//             action: () {
//               setState(() {
//                 _openPage = _AdminPages.users;
//               });
//             },
//             text: "Users",
//           ),
//         ]),
//         Expanded(
//           child: ChangeNotifierProvider.value(
//             value: _selectedWorkspace,
//             child: screen,
//           ),
//         ),
//       ],
//     );
//   }
// }
