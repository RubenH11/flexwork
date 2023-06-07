// import "dart:js_util";

import "package:flexwork/database/database.dart";
import "package:flutter/material.dart";
import "package:email_validator/email_validator.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _errorMessage = "";

  void setErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void _login() async {
    try {
      await DatabaseFunctions.login(_email, _password);
    } on CustomError catch (error) {
      switch (error.code) {
        case "INVALID_ROLE":
          setErrorMessage(
              "You account type is resgistered incorrectly, please contact the administrator");
          break;
        case "MISSING_VALUES":
          setErrorMessage("Please enter all fields");
          break;
        case "INVALID_EMAIL":
          setErrorMessage("Invalid email address");
          break;
        case "NONEXIST_EMAIL":
          setErrorMessage("There is no account with this email address");
          break;
        case "INCORR_PASSWORD":
          setErrorMessage("Incorrect password");
          break;
        case "MISSING_COOKIES":
        setErrorMessage("Log in request failed due to missing cookies");
         break;
        default:
          setErrorMessage(
              "Something went wrong, please try again or contact the administator");
      }
    }
  }

  void submitForm() {
    print("complete");
    if (_formKey.currentState!.validate()) {
      print("1");
      _formKey.currentState!.save();
      if (_email != "" && _password != "") {
        print("2");
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
                            if (!EmailValidator.validate(value)) {
                              return "Please enter a valid email address";
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
