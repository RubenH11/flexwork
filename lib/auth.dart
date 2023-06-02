import "dart:js_util";

import 'package:flexwork/models/adminState.dart';
import "package:flexwork/widgets/customTextButton.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:provider/provider.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _errorMessage = " ";

  void _login() async {
    try {
      final adminData = Provider.of<AdminState>(context, listen: false);
      adminData.setEmail(_email);
      adminData.setPassword(_password);

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        setState(() {
          _errorMessage = "No user found for that email";
        });
      } else if (e.code == "wrong-password") {
        setState(() {
          _errorMessage = "Incorrect passowrd";
        });
      } else if (e.code == "invalid-email") {
        setState(() {
          _errorMessage = "Invalid email address";
        });
      } else if (e.code == "too-many-requests") {
        setState(() {
          _errorMessage =
              "Access to this account has been temporarily disabled due to many failed login attempts";
        });
      } else {
        print("ERROR: $e");
      }
    }
  }

  void submitForm() {
    print("complete");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_email != "" && _password != "") {
        _login();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");
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
          child: Center(
              child: Text("NU flex",
                  style: Theme.of(context).textTheme.headlineMedium)),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 275,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text("Login",
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onEditingComplete: submitForm,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            isDense: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                              borderRadius: BorderRadius.zero,
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              borderRadius: BorderRadius.zero,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              _email = value.trim();
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          onEditingComplete: submitForm,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            isDense: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                              borderRadius: BorderRadius.zero,
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              borderRadius: BorderRadius.zero,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              _password = value.trim();
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                          child: Center(
                            child: Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}











// class Auth extends StatefulWidget {
//   Auth({super.key});

//   @override
//   State<Auth> createState() => _AuthState();
// }

// class _AuthState extends State<Auth> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   var emailStage = true;
//   var firstEmail = true;
//   var firstPassword = true;

//   Future<bool> _emailAdressExists(String email) async {
//     try {
//       final options =
//           await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

//       return options.isNotEmpty;
//     } catch (error) {
//       print("ERROR: $error");
//       return false;
//     }
//   }

//   Future<bool> _signinSuccesful(String email, String password) async {
//     try {
//       print("sign in with $email and $password");
//       final signedIn = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//       if (signedIn.user != null) {
//         print(signedIn.user!.uid);
//       }
//       return signedIn.user != null;
//     } catch (error) {
//       print("ERROR: $error");
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 50,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.background,
//             border: Border(
//               bottom:
//                   BorderSide(color: Theme.of(context).colorScheme.onBackground),
//             ),
//           ),
//           child: Center(
//               child: Text("NU flex",
//                   style: Theme.of(context).textTheme.headlineMedium)),
//         ),
//         Expanded(
//           child: Center(
//             child: SizedBox(
//               width: 200,
//               child: emailStage
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 40,
//                           child: Text(
//                             "Login",
//                             style: Theme.of(context).textTheme.headlineMedium,
//                           ),
//                         ),
//                         FutureBuilder(
//                           future: _emailAdressExists(emailController.text),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState !=
//                                 ConnectionState.done) {
//                               return Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }

//                             print(
//                                 "connectionstate done! this is firstEmail: $firstEmail and there was an error: ${!snapshot.data!}");
//                             print("succes: ${snapshot.data!}");
//                             if (snapshot.data!) {
//                               setState(() {
//                                 print("next stage");
//                                 emailStage = false;
//                               });
//                             }

//                             return CustomTextField(
//                               controller: emailController,
//                               takeSingleFocus: false,
//                               onEditingComplete: () {
//                                 setState(() {
//                                   firstEmail = false;
//                                 });
//                               },
//                               placeholder: "Email",
//                               textAlign: TextAlign.center,
//                               error: firstEmail ? false : !snapshot.data!,
//                             );
//                           },
//                         ),
//                         SizedBox(
//                           height: 40,
//                         ),
//                       ],
//                     )
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 40,
//                           child: Text(
//                             "Login",
//                             style: Theme.of(context).textTheme.headlineMedium,
//                           ),
//                         ),
//                         FutureBuilder(
//                           future: _signinSuccesful(
//                               emailController.text, passwordController.text),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState !=
//                                 ConnectionState.done) {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }

//                             print("password was ${snapshot.data!}");

//                             return CustomTextField(
//                               controller: passwordController,
//                               takeSingleFocus: false,
//                               onEditingComplete: () {
//                                 setState(() {
//                                   firstPassword = false;
//                                 });
//                               },
//                               placeholder: "Password",
//                               textAlign: TextAlign.center,
//                               error: firstPassword ? false : !snapshot.data!,
//                               password: true,
//                             );
//                           },
//                         ),
//                         SizedBox(
//                           height: 40,
//                           child: CustomTextButton(
//                             onPressed: () {
//                               setState(() {
//                                 emailStage = true;
//                                 firstEmail = true;
//                                 firstPassword = true;
//                               });
//                             },
//                             selected: false,
//                             text: "< Return to email",
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
