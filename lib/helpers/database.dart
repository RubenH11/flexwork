import "dart:io";
import "dart:js_util";

import "package:flexwork/models/employee.dart";
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/newReservationNotifier.dart";
import "package:flexwork/models/request.dart";
import "package:flexwork/models/reservation.dart";
import "package:flexwork/models/workspace.dart";
import "package:flutter/material.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:tuple/tuple.dart";
import "package:universal_html/html.dart" as html;
import 'package:url_launcher/url_launcher.dart';

class CustomError extends Error {
  final String code;
  CustomError(this.code);
}

enum Roles {
  user,
  admin,
}

class DatabaseFunctions extends ChangeNotifier {
  static DatabaseFunctions? _instance;

  DatabaseFunctions._(); // Private constructor

  factory DatabaseFunctions() {
    _instance ??= DatabaseFunctions._();
    return _instance!;
  }

  static Future<http.Response> _get(Uri uri,
      {required Map<String, String> headers}) async {
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response;
    }
    print("no succes");
    print(response.body);

    switch (jsonDecode(response.body)['code']) {
      case 'MISSING_TOKEN':
      case 'INVALID_TOKEN':
        print("inv");
        logout();
        break;
      case 'PERMISSION_DENIED':
        print("error: permission denied");
        break;
      case 'MISSING_VALUES':
        print("error: missing values");
        break;
      default:
        print(jsonDecode(response.body)['code']);
    }
    return response;
  }

  static void setCookie(String name, String value, {int? expiry}) {
    final cookie = '$name=$value;';

    // if (expiry != null) {
    //   final dateTime = DateTime.now().add(Duration(days: expiry));
    //   final formattedExpiry = dateTime.toUtc().toIso8601String();
    //   cookie += 'expires=${formattedExpiry};';
    // }

    html.document.cookie = cookie;
  }

  static String? getCookieValue(String name) {
    final cookies = html.document.cookie;

    final cookieList = cookies!.split(';');

    for (var cookie in cookieList) {
      final parts = cookie.split('=');
      final cookieName = parts[0].trim();
      final cookieValue = parts.length > 1 ? parts[1].trim() : '';

      if (cookieName == name) {
        return cookieValue;
      }
    }

    return null;
  }

  static _handleCompletion(http.Response response) {
    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseData = json.decode(response.body);
    } else {
      print(
          'Request failed with status: ${response.statusCode} ${response.body}');
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      throw ErrorDescription(responseBody['code']);
    }
  }

  static Future<int> deleteUser(int id) async {
    print("=+= deleteUser");
    final url = Uri.parse('http://localhost:3000/users/$id');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final result =
        await http.delete(url, headers: {'Authorization': "Bearer $authToken"});
    print(jsonDecode(result.body));
    return result.statusCode;
  }

  static Future<String> updateUser(int id, String role) async {
    print("+= update user role");
    final url = Uri.parse('http://localhost:3000/users');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final result = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer $authToken",
      },
      body: jsonEncode(
        {
          "id": id,
          "role": role,
        },
      ),
    );
    return jsonDecode(result.body)['code'] ??= "NO_ERROR";
  }

  static Future<String> getMyRole() async {
    print("=+= getMyRole");
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    if (authToken == null) {
      return "none";
    }

    final url = Uri.parse('http://localhost:3000/my_role');
    final response =
        await _get(url, headers: {'Authorization': "Bearer $authToken"});
    // print(response.body);
    final body = jsonDecode(response.body) as List<dynamic>;
    return body[0]['role'];
  }

  static Future<Tuple2<bool, String>> registerUser(
      String email, String password, String name) async {
    print("=+= registerUser");
    final url = Uri.parse('http://localhost:3000/register');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final result = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "role": "user",
          "email": email,
          "password": password,
        },
      ),
    );
    final errorCode = jsonDecode(result.body)['code'] ??= "NO_ERROR";

    if (result.statusCode.toString().startsWith('2')) {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': 'Your%20NU%20flexwork%20account',
          'body':
              'Dear%20$name,\n\n%20Your%20now%20have%20access%20to%20an%20account%20with%20which%20you%20will%20be%20able%20to%20make%20reservations%20for%20workspaces%20in%20the%20NU%20building%20at%20the%20VU.\n\nYou%20can%20log%20in%20with%20your%20email%20address:%20$email\nAnd%20your%20password:%20$password',
        },
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        return Tuple2(
          result.statusCode.toString().substring(0, 1) == '2',
          'NO_EMAIL_LAUNCHER',
        );
      }
    }

    return Tuple2(
        result.statusCode.toString().substring(0, 1) == '2', errorCode);
  }

  static Future<void> login(String email, String password) async {
    print("=+= login");
    final url = Uri.parse('http://localhost:3000/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "email": email,
          "password": password,
        },
      ),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      DatabaseFunctions.setCookie("authToken", body['authToken']);
      DatabaseFunctions().notifyListeners();
      print("?");
      return;
    }

    throw CustomError(body['code']);
  }

  static void logout() {
    html.document.cookie =
        'authToken=; expires=Thu, 01 Jan 2000 00:00:00 UTC; path=/;';
    DatabaseFunctions().notifyListeners();
  }

  static Future<List<Reservation>> getReservations({
    Tuple2<DateTime, DateTime>? timeRange,
    bool personal = false,
    bool others = false,
    int? workspaceId,
  }) async {
    print("=+= getReservations");
    assert(!(personal && others));

    var url = 'http://localhost:3000/reservations';
    if (timeRange != null) {
      url += "?start=${timeRange.item1.toIso8601String()}";
      url += "&end=${timeRange.item2.toIso8601String()}";
    }

    if (personal) {
      if (url.contains("?")) {
        url += "&personal=true";
      } else {
        url += "?personal=true";
      }
    }

    if (others) {
      if (url.contains("?")) {
        url += "&others=true";
      } else {
        url += "?others=true";
      }
    }

    if (workspaceId != null) {
      if (url.contains("?")) {
        url += "&workspace_id=$workspaceId";
      } else {
        url += "?workspace_id=$workspaceId";
      }
    }

    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await _get(Uri.parse(url),
        headers: {'Authorization': "Bearer $authToken"});

    final List<Reservation> reservations = [];
    final responseReservations = jsonDecode(response.body) as List<dynamic>;
    for (var res in responseReservations) {
      reservations.add(Reservation(
        res['id'],
        res['user_id'],
        DateTime.parse(res['start']),
        DateTime.parse(res['end']),
        res['workspace_id'],
      ));
    }

    return reservations;
  }

  static Future<bool> deleteReservation(int id) async {
    final url = Uri.parse('http://localhost:3000/reservations/$id');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    return response.statusCode.toString().substring(0, 1) == "2";
  }

  static Future<List<Workspace>> getWorkspace(
      {int? reservationId, int? workspaceId}) async {
    print("=+= getWorkspace");
    assert(!(reservationId != null && workspaceId != null));

    var url = 'http://localhost:3000/workspaces';
    if (reservationId != null) {
      url += '?reservation_id=$reservationId';
    } else if (workspaceId != null) {
      url += '?workspace_id=$workspaceId';
    }

    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await _get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    final List<Workspace> workspaces = [];
    final responseWorkspaces = json.decode(response.body) as List<dynamic>;
    for (var workspace in responseWorkspaces) {
      late final Floors floor;
      switch (workspace['floor_num']) {
        case 9:
          floor = Floors.f9;
          break;
        case 10:
          floor = Floors.f10;
          break;
        case 11:
          floor = Floors.f11;
          break;
        case 12:
          floor = Floors.f12;
          break;
        default:
          throw ErrorDescription("ErroR: 234262");
      }

      final List<Tuple2<DateTime, DateTime>> blockedMoments = [];
      final blockedMomentsStartString =
          workspace['blocked_moments_start'] as String?;
      final blockedMomentsEndString =
          workspace['blocked_moments_end'] as String?;
      if (blockedMomentsStartString != null &&
          blockedMomentsEndString != null) {
        final blockedMomentsStart = blockedMomentsStartString.split(",");
        final blockedMomentsEnd = blockedMomentsEndString.split(",");
        for (var i = 0; i < blockedMomentsStart.length; i++) {
          blockedMoments.add(
            Tuple2(
              DateTime.parse(blockedMomentsStart[i]),
              DateTime.parse(blockedMomentsEnd[i]),
            ),
          );
        }
      }

      final List<Tuple2<double, double>> coordinates = [];
      final coordinatesXString = workspace['coordinates_x'] as String?;
      final coordinatesYString = workspace['coordinates_y'] as String?;
      if (coordinatesXString != null && coordinatesYString != null) {
        final coordinatesX = coordinatesXString.split(",");
        final coordinatesY = coordinatesYString.split(",");
        for (var i = 0; i < coordinatesX.length; i++) {
          coordinates.add(
            Tuple2(
              double.parse(coordinatesX[i]),
              double.parse(coordinatesY[i]),
            ),
          );
        }
      }

      workspaces.add(
        Workspace(
          id: workspace['id'],
          floor: floor,
          color: Color(workspace['color'] ??= Colors.black.value),
          blockedMoments: blockedMoments,
          coordinates: coordinates,
          identifier: workspace['code'],
          nickname: workspace['nickname'],
          numMonitors: workspace['num_monitors'],
          numScreens: workspace['num_screens'],
          numWhiteboards: workspace['num_whiteboards'],
          type: workspace['type'] ??= "No type set",
          changeNotifyBasics: true,
        ),
      );
    }
    print("got workspaces: ${workspaces}");
    return workspaces;
  }

  static Future<List<Workspace>> getWorkspaces(Floors floor) async {
    print("=+= getWorkspaces");
    final floorNum = FloorsConvert.toFloorNum(floor);
    var url = Uri.parse('http://localhost:3000/workspaces?floor_num=$floorNum');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await _get(
      url,
      headers: {'Authorization': "Bearer $authToken"},
    );

    final List<Workspace> workspaces = [];
    final responseWorkspaces = json.decode(response.body) as List<dynamic>;
    for (var workspace in responseWorkspaces) {
      late final Floors floor;
      switch (workspace['floor_num']) {
        case 9:
          floor = Floors.f9;
          break;
        case 10:
          floor = Floors.f10;
          break;
        case 11:
          floor = Floors.f11;
          break;
        case 12:
          floor = Floors.f12;
          break;
        default:
          throw ErrorDescription("ErroR: 234262");
      }

      final List<Tuple2<DateTime, DateTime>> blockedMoments = [];
      final blockedMomentsStartString =
          workspace['workspace_blocked_moments_start'] as String?;
      final blockedMomentsEndString =
          workspace['workspace_blocked_moments_end'] as String?;
      if (blockedMomentsStartString != null &&
          blockedMomentsEndString != null) {
        final blockedMomentsStart = blockedMomentsStartString.split(",");
        final blockedMomentsEnd = blockedMomentsEndString.split(",");
        for (var i = 0; i < blockedMomentsStart.length; i++) {
          blockedMoments.add(
            Tuple2(
              DateTime.parse(blockedMomentsStart[i]),
              DateTime.parse(blockedMomentsEnd[i]),
            ),
          );
        }
      }

      final List<Tuple2<double, double>> coordinates = [];
      final coordinatesXString = workspace['coordinates_x'] as String?;
      final coordinatesYString = workspace['coordinates_y'] as String?;
      if (coordinatesXString != null && coordinatesYString != null) {
        final coordinatesX = coordinatesXString.split(",");
        final coordinatesY = coordinatesYString.split(",");
        for (var i = 0; i < coordinatesX.length; i++) {
          coordinates.add(
            Tuple2(
              double.parse(coordinatesX[i]),
              double.parse(coordinatesY[i]),
            ),
          );
        }
      }

      workspaces.add(
        Workspace(
          id: workspace['id'],
          floor: floor,
          color: Color(workspace['color'] ??= Colors.black.value),
          blockedMoments: blockedMoments,
          coordinates: coordinates,
          identifier: workspace['code'],
          nickname: workspace['nickname'],
          numMonitors: workspace['num_monitors'],
          numScreens: workspace['num_screens'],
          numWhiteboards: workspace['num_whiteboards'],
          type: workspace['type'] ??= "Set a type here",
          changeNotifyBasics: true,
        ),
      );
    }
    return workspaces;
  }

  static Future<Map<String, Color>> getWorkspaceTypes() async {
    print("=+= getWorkspaceTypes");
    final url = Uri.parse('http://localhost:3000/workspace_types');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await _get(
      url,
      headers: {'Authorization': 'Bearer $authToken'},
    );

    final responseTypes = jsonDecode(response.body) as List<dynamic>;

    final Map<String, Color> workspaceTypes = {};
    for (var type in responseTypes) {
      workspaceTypes.addAll({type['name']: Color(type['color'])});
    }
    return workspaceTypes;
  }

  static Future<List<Request>> getRequests(
      {bool mine = false, bool others = false}) async {
    print("=+= getRequests");
    assert((!mine && others) || (mine && !others));

    var url = 'http://localhost:3000/requests';
    if (mine) {
      url += "?mine=true";
    } else {
      url += "?others=true";
    }

    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await _get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    final List<Request> requests = [];
    final responseRequests = jsonDecode(response.body) as List<dynamic>;
    print(responseRequests);
    for (var req in responseRequests) {
      requests.add(
        Request(
          id: req['id'],
          message: req['message'],
          userId: req['user_id'],
          start: DateTime.parse(req['start']),
          end: DateTime.parse(req['end']),
          workspaceId: req['workspace_id']
        ),
      );
    }
    return requests;
  }

  static Future<List<User>> getUsers() async {
    print("=+= getUsers");
    final url = Uri.parse('http://localhost:3000/users');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await _get(
      url,
      headers: {'Authorization': 'Bearer $authToken'},
    );

    final responseUsers = jsonDecode(response.body) as List<dynamic>;

    final List<User> users = [];
    for (var user in responseUsers) {
      users.add(User(user['id'], user['email'], user['role']));
    }
    return users;
  }

  static Future<void> _addCoordinate(
      int workspaceId, int num, double x, double y) async {
    print("=+= _addCoordinate");
    final url = Uri.parse('http://localhost:3000/workspaces/coordinates');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "workspace_id": workspaceId,
          "num": num,
          "x": x,
          "y": y,
        },
      ),
    );
  }

  static Future<void> _setBlockedMoment(
      int workspaceId, DateTime start, DateTime end) async {
    print("=+= _addBlockedMoment");
    final url = Uri.parse('http://localhost:3000/workspaces/blocked_moments');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "workspace_id": workspaceId,
          "start": start.toIso8601String(),
          "end": end.toIso8601String(),
        },
      ),
    );
  }

  static Future<bool> updateWorkspace(Workspace workspace) async {
    final url = Uri.parse('http://localhost:3000/workspaces');
    final authToken = DatabaseFunctions.getCookieValue('authToken');

    final blockedMoments = jsonEncode(workspace
        .getBlockedMoments()
        .map((moment) => {
              'start': moment.item1.toIso8601String(),
              'end': moment.item2.toIso8601String(),
            })
        .toList());

    final result = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "id": workspace.getId(),
          "floor_num": int.parse(workspace.getFloor().name.substring(1)),
          "code": workspace.getIdentifier(),
          "nickname": workspace.getNickname(),
          "num_monitors": workspace.getNumMonitors(),
          "num_screens": workspace.getNumScreens(),
          "num_whiteboards": workspace.getNumWhiteboards(),
          "type": workspace.getType(),
          "blocked_moments": blockedMoments,
        },
      ),
    );
    return result.statusCode.toString().substring(0, 1) == '2';
  }

  static Future<bool> deleteWorkspace(int id) async {
    final url = Uri.parse('http://localhost:3000/workspaces/$id');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
    );
    try {
      _handleCompletion(response);
      return true;
    } catch (error) {
      return false;
    }
  }

  // not a set because adding involved adding coordinates, while updating does not
  static Future<void> addWorkspace(Workspace workspace) async {
    print("=+= addWorkspace");
    final url = Uri.parse('http://localhost:3000/workspaces');
    final authToken = DatabaseFunctions.getCookieValue('authToken');

    final coordinates = jsonEncode(workspace
        .getCoords()
        .map((coord) => {
              'x': coord.item1,
              'y': coord.item2,
            })
        .toList());

    final blockedMoments = jsonEncode(workspace
        .getBlockedMoments()
        .map((moment) => {
              'start': moment.item1.toIso8601String(),
              'end': moment.item2.toIso8601String(),
            })
        .toList());

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "floor_num": int.parse(workspace.getFloor().name.substring(1)),
          "code": workspace.getIdentifier(),
          "nickname": workspace.getNickname(),
          "num_monitors": workspace.getNumMonitors(),
          "num_screens": workspace.getNumScreens(),
          "num_whiteboards": workspace.getNumWhiteboards(),
          "type": workspace.getType(),
          "coordinates": coordinates,
          "blocked_moments": blockedMoments,
        },
      ),
    );

    // final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    // final coordinates = workspace.getCoords();

    // for (var i = 0; i < coordinates.length; i++) {
    //   _addCoordinate(responseBody['insertId'], i, coordinates[i].item1,
    //       coordinates[i].item2);
    // }

    // final blockedMoments = workspace.getBlockedMoments();
    // for (var i = 0; i < blockedMoments.length; i++) {
    //   _setBlockedMoment(responseBody['insertId'], blockedMoments[i].item1,
    //       blockedMoments[i].item2);
    // }

    _handleCompletion(response);
  }

  static Future<void> addReservations(
      NewReservationNotifier reservations) async {
    print("=+= addReservations");
    assert(reservations.getWorkspace() != null);
    assert(reservations.getStartTime() != null);
    assert(reservations.getEndTime() != null);

    final workspaceId = reservations.getWorkspace()!.getId();
    final ranges = reservations.constructSchedule();

    for (var res in ranges) {
      await _addReservation(workspaceId, res.item1, res.item2);
    }
  }

  static Future<void> _addReservation(
      int workspaceId, DateTime start, DateTime end) async {
    print("=+= _addReservation");
    final url = Uri.parse('http://localhost:3000/reservations');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "workspace_id": workspaceId,
          "start": start.toIso8601String(),
          "end": end.toIso8601String(),
        },
      ),
    );

    _handleCompletion(response);
  }

  static Future<void> addUser(
      String role, String email, String password) async {
    print("=+= addUser");
    final url = Uri.parse('http://localhost:3000/users');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "role": role,
          "email": email,
          "password": password,
        },
      ),
    );

    _handleCompletion(response);
  }

  static Future<Tuple2<bool, String>> acceptRequest(int id) async {
    final url = Uri.parse('http://localhost:3000/requests/accept/${id}');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final result = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
    );

    final errorCode = jsonDecode(result.body)['code'] ??= "NO_ERROR";
    return Tuple2(
        result.statusCode.toString().substring(0, 1) == '2', errorCode);
  }

  static Future<Tuple2<bool, String>> deleteRequest(int id) async {
    final url = Uri.parse('http://localhost:3000/requests/${id}');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final result = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
    );

    final errorCode = jsonDecode(result.body)['code'] ??= "NO_ERROR";
    return Tuple2(
        result.statusCode.toString().substring(0, 1) == '2', errorCode);
  }

  static Future<void> addRequest(Request request) async {
    print("=+= addRequest");
    final url = Uri.parse('http://localhost:3000/requests');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "start": request.getStart().toIso8601String(),
          "end": request.getEnd().toIso8601String(),
          "message": request.getMessage(),
          "workspace_id": request.getWorkspaceId(),
        },
      ),
    );

    _handleCompletion(response);
  }

  static Future<void> addWorkspaceType(String name, Color color) async {
    print("=+= addWorkspaceType");
    final url = Uri.parse('http://localhost:3000/workspace_types');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(
        {
          "name": name,
          "color": color.value,
        },
      ),
    );

    _handleCompletion(response);
  }

  static Future<bool> deleteWorkspaceType(String name) async {
    print("=+= deleteWorkspaceType");
    final url = Uri.parse('http://localhost:3000/workspace_types/${name}');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
    );

    return response.statusCode.toString().substring(0, 1) == "2";
  }

  static Future<bool> updateWorkspaceType(String name, Color color) async {
    print("=+= deleteWorkspaceType");
    final url = Uri.parse('http://localhost:3000/workspace_types');
    final authToken = DatabaseFunctions.getCookieValue('authToken');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        "name": name,
        "color": color.value,
      }),
    );
    print(response.body);

    return response.statusCode.toString().substring(0, 1) == "2";
  }

  static Future<String> requestAccount(String email, String password) async {
    print("=+= request account");
    final url = Uri.parse('http://localhost:3000/request_account');
    final result = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "email": email,
          "password": password,
        },
      ),
    );
    return jsonDecode(result.body)['code'] ??= "NO_ERROR";
  }

  static Future<String> changePassword(
      String email, String oldPassword, String newPassword) async {
    print("=+= change password");
    final url = Uri.parse('http://localhost:3000/change_password');
    final result = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "email": email,
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
      ),
    );
    print(result.body);
    return jsonDecode(result.body)['code'] ??= "NO_ERROR";
  }

  static String errorCodeToMessage(String code) {
    switch (code) {
      case "NO_ERROR":
        return "";
      case "INCORRECT_VALUES":
        return "Some value was incorrect";
      case "INVALID_ROLE":
        return "You account type is resgistered incorrectly, please contact the administrator";
      case "MISSING_VALUES":
        return "Please enter all fields";
      case "INVALID_EMAIL":
        return "Invalid email address";
      case "NONEXIST_EMAIL":
        return "There is no account with this email address";
      case "INCORR_PASSWORD":
        return "Incorrect password";
      case "EMAIL_ALREADY_EXIST":
        return "Email already exists";
      case "PERMISSION_STILL_DENIED":
        return "Please wait until your account is verified by the administrator.";
      default:
        return "Something went wrong, please try again or contact the administator";
    }
  }
}
