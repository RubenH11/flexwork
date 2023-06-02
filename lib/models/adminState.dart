import 'package:flexwork/admin/admin.dart';
import 'package:flexwork/models/floors.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';

class AdminState extends ChangeNotifier{
  String? _email;
  String? _password;
  AdminPages _openPage = AdminPages.floors;
  Floors _floor = Floors.f9;
  Workspace? _selectedWorkspace;

  AdminPages getOpenPage(){
    return _openPage;
  }

  Floors getFloor(){
    return _floor;
  }

  Workspace? getSelectedWorkspace(){
    return _selectedWorkspace;
  }

  String? getPassword(){
    return _password;
  }

  String? getEmail(){
    return _email;
  }

  void setOpenPage(AdminPages page){
    _openPage = page;
    notifyListeners();
  }

  void setFloor(Floors floor){
    _floor = floor;
    notifyListeners();
  }

  void selectWorkspace(Workspace? workspace){
    _selectedWorkspace = workspace;
    notifyListeners();
  }

  void setPassword(String password){
    _password = password;
    print("password set to $_password");
  }

  void setEmail(String email){
    _email = email;
    print("email set to $_email");
  }
}