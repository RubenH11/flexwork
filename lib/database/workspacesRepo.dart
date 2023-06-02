import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/floors.dart';
import 'package:flexwork/models/newSpaceNotifier.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:tuple/tuple.dart';

class WorkspacesRepo{
    List<Workspace> _workspaces = [];

  // Set<String> getWorkspaceTypes() {
  //   return _workspaces.map((workspace) => workspace.getType()).toSet();
  // }

  // void set(List<Workspace> workspaces) {
  //   _workspaces = workspaces;
  // }

  WorkspacesRepo(this._workspaces);

  List<Workspace> get({Floors? floor, String? id}) {
    var workspaces = [..._workspaces];

    if (id != null) {
      return [workspaces.firstWhere((workspace) => workspace.getId() == id)];
    }

    if (floor != null) {
      workspaces = workspaces
          .where((workspace) => workspace.getFloor() == floor)
          .toList();
    }
    return workspaces;
  }

  //C
  Future<String?> add(NewSpaceNotifier workspace) {
    return FirebaseService().lock.synchronized(() => _add(workspace));
  }

  //C
  Future<String?> _add(NewSpaceNotifier workspace) async {
    try {
      // print("== add New Workspace To DB");

      final floor = workspace.getFloor();
      final identifier = workspace.getIdentifier();
      final nickname = workspace.getNickname();
      final numMonitors = workspace.getNumMonitors();
      final numWhiteboards = workspace.getNumWhiteboards();
      final numScreens = workspace.getNumScreens();
      final coords = workspace.getCoords();
      final blockedMoments = workspace.getBlockedMoments();
      final type = workspace.getType();

      final coordsMaps =
          coords.map((coord) => {"x": coord.item1, "y": coord.item2}).toList();
      final blockedMomentsMaps = blockedMoments
          .map((moment) => {"start": moment.item1.toIso8601String(), "end": moment.item2.toIso8601String()})
          .toList();

      var docRef = await FirebaseService().firestore.collection("workspaces").add({
        "floor": int.parse(workspace.getFloor().name.substring(1)),
        "identifier": identifier,
        "nickname": nickname,
        "numMonitors": numMonitors,
        "numWhiteboards": numWhiteboards,
        "numScreens": numScreens,
        "type": type,
        "coordinates": coordsMaps,
        "blockedMoments": blockedMomentsMaps,
      });

      // add to current state
      _workspaces.add(workspace.finalize(docRef.id));
      // print("== END: add New Workspace To DB");
      return docRef.id;
    } catch (error) {
      print("ERROR in addSpace: $error");
    }
    return null;
  }

  void printAll() {
    for (var workspace in _workspaces) {
      print(workspace.toString());
    }
  }

  Future<void> update(Workspace workspace) async {
    try {
      // print("${workspace.getType()}");
      final updateMap = {
        "floor": int.parse(workspace.getFloor().name.substring(1)),
        "identifier": workspace.getIdentifier(),
        "nickname": workspace.getNickname(),
        "numMonitors": workspace.getNumMonitors(),
        "numWhiteboards": workspace.getNumWhiteboards(),
        "numScreens": workspace.getNumScreens(),
        "type": workspace.getType(),
        "coordintes": workspace
            .getCoords()
            .map((coord) => {"x": coord.item1, "y": coord.item2})
            .toList(),
        "blockedMoments": workspace
            .getBlockedMoments()
            .map((moment) => {"start": moment.item1.toIso8601String(), "end": moment.item2.toIso8601String()})
            .toList(),
      };
      await FirebaseService().firestore
          .collection("workspaces")
          .doc(workspace.getId())
          .update(updateMap);

      print("end of update");
    } catch (error) {
      print("ERROR in updateWorkspace: $error");
    }
  }

  Future<void> delete(Workspace workspace) async {
    try {
      await FirebaseService().reservations.delete(workspaceId: workspace.getId());
      
      _workspaces.removeWhere((space) => space.getId() == workspace.getId());
      await FirebaseService().firestore.collection("workspaces").doc(workspace.getId()).delete();
    } catch (error) {
      print("ERROR: $error");
    }
  }
}