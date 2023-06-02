import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/models/adminState.dart';
import 'package:flexwork/models/employee.dart';

class EmployeesRepo {
  List<Employee> _employees = [];

  EmployeesRepo(this._employees);

  void registerUser(String email, String type, String password, AdminState adminLogin) async {
    assert(type == "user" || type == "admin");

    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseService()
        .firestore
        .collection("users")
        .doc(userCredential.user!.uid)
        .set({
      "email": email,
      "role": "user",
    });

    await FirebaseAuth.instance.signOut();

    await FirebaseAuth.instance.signInWithEmailAndPassword(email: adminLogin.getEmail()!, password: adminLogin.getPassword()!);
  }

  Employee getById(String uid) {
    return _employees.firstWhere((emp) => emp.uid == uid);
  }

  List<Employee> get({String? role}) {
    var list = [..._employees];
    if (role != null) {
      list = list.where((emp) => emp.role == role).toList();
    }
    return list;
  }

  Future<void> delete(String uid) async {
    await FirebaseService().firestore.collection("users").doc(uid).delete();
  }
}
