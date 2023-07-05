// import "dart:js_util";

import "dart:ui";

import 'package:flexwork/helpers/database.dart';
import "package:flexwork/models/floors.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/customTextButton.dart";
import "package:flexwork/widgets/customTextField.dart";
import "package:flexwork/widgets/floor.dart";
import "package:flutter/material.dart";
import "package:email_validator/email_validator.dart";
import "package:intl/date_symbols.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthState createState() => _AuthState();
}

enum _States {
  login,
  changePassword,
  requestAccount,
}

class _AuthState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  var _loading = false;
  String _errorMessage = "";
  String _successMessage = "";
  var _state = _States.login;

  void setErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void setSuccessMessage(String message) {
    setState(() {
      _successMessage = message;
    });
  }

  void _submitLogin() async {
    setErrorMessage("");
    setSuccessMessage("");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_emailController.text != "" && _passwordController.text != "") {
        try {
          setState(() {
            _loading = true;
          });
          await DatabaseFunctions.login(
              _emailController.text, _passwordController.text);
        } on CustomError catch (error) {
          setErrorMessage(DatabaseFunctions.errorCodeToMessage(error.code));
        } finally {
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  Future<void> _submitRequest() async {
    setErrorMessage("");
    setSuccessMessage("");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_emailController.text != "" && _passwordController.text != "") {
        try {
          setState(() {
            _loading = true;
          });
          final code = await DatabaseFunctions.requestAccount(
              _emailController.text, _passwordController.text);
          setState(() {
            _loading = false;
          });
          if (code != "NO_ERROR") {
            throw CustomError(code);
          }

          setSuccessMessage(
              "You succesfully requested an account.\nPlease wait until the administrator has accepted your request.");
        } on CustomError catch (error) {
          setErrorMessage(DatabaseFunctions.errorCodeToMessage(error.code));
        } finally {
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  Future<void> _submitPasswordChange() async {
    setErrorMessage("");
    setSuccessMessage("");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_emailController.text != "" &&
          _oldPasswordController.text != "" &&
          _newPasswordController.text != "") {
        try {
          setState(() {
            _loading = true;
          });
          final code = await DatabaseFunctions.changePassword(
            _emailController.text,
            _oldPasswordController.text,
            _newPasswordController.text,
          );
          setState(() {
            _loading = false;
          });

          print("? $code");
          if (code != "NO_ERROR") {
            throw CustomError(code);
          }

          setSuccessMessage("Succesfully changed your password");
        } on CustomError catch (error) {
          setErrorMessage(DatabaseFunctions.errorCodeToMessage(error.code));
        } finally {
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    late final String titleMessage;
    switch (_state) {
      case _States.changePassword:
        titleMessage = "Change your password";
        break;
      case _States.login:
        titleMessage = "Login";
        break;
      case _States.requestAccount:
        titleMessage = "Request an account";
        break;
      default:
    }

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
              child: Text("Welcome to the NU building's flex-work system",
                  style: Theme.of(context).textTheme.headlineMedium)),
        ),
        Expanded(
          child: Stack(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(50.0),
              //   child: Floor(floor: Floors.f9, selectedWorkspace: null, setSelectedWorkspace: (_){}, blockedWorkspaceIds: [], legend: {}, ignoreWorkpaces: true),
              // ),
              // Container(color: Color.fromRGBO(255, 255, 255, 0.95)),
              Center(
                child: _loading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: 280,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text(
                                    titleMessage,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  //login
                                  if (_state == _States.login)
                                    const SizedBox(height: 10),
                                  if (_state == _States.login)
                                    _EmailTextField(
                                      controller: _emailController,
                                      onEditingComplete: _submitLogin,
                                    ),
                                  if (_state == _States.login)
                                    const SizedBox(height: 10),
                                  if (_state == _States.login)
                                    _PasswordTextField(
                                      controller: _passwordController,
                                      onEditingComplete: _submitLogin,
                                      hintText: "Password",
                                    ),

                                  // request account
                                  if (_state == _States.requestAccount)
                                    const Text(
                                      "Once the administrator accepts your request, you will have access to the reservation system.",
                                      textAlign: TextAlign.center,
                                    ),
                                  if (_state == _States.requestAccount)
                                    const SizedBox(height: 10),
                                  if (_state == _States.requestAccount)
                                    _EmailTextField(
                                      controller: _emailController,
                                    ),
                                  if (_state == _States.requestAccount)
                                    const SizedBox(height: 10),
                                  if (_state == _States.requestAccount)
                                    _PasswordTextField(
                                      controller: _passwordController,
                                      hintText: "Password",
                                    ),
                                  if (_state == _States.requestAccount)
                                    const SizedBox(height: 10),
                                  if (_state == _States.requestAccount)
                                    CustomElevatedButton(
                                      onPressed: _submitRequest,
                                      active: true,
                                      selected: true,
                                      text: "Request account",
                                    ),

                                  // change password
                                  if (_state == _States.changePassword)
                                    _EmailTextField(
                                        controller: _emailController),
                                  if (_state == _States.changePassword)
                                    const SizedBox(height: 10),
                                  if (_state == _States.changePassword)
                                    _PasswordTextField(
                                        controller: _oldPasswordController,
                                        hintText: "Old password"),
                                  if (_state == _States.changePassword)
                                    const SizedBox(height: 10),
                                  if (_state == _States.changePassword)
                                    _PasswordTextField(
                                        controller: _newPasswordController,
                                        hintText: "New password"),
                                  if (_state == _States.changePassword)
                                    const SizedBox(height: 10),
                                  if (_state == _States.changePassword)
                                    CustomElevatedButton(
                                      onPressed: () async {
                                        _submitPasswordChange();
                                      },
                                      active: true,
                                      selected: true,
                                      text: "Change password",
                                    ),

                                  SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        _successMessage == ""
                                            ? _errorMessage
                                            : _successMessage,
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _successMessage == ""
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                              : Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_state != _States.changePassword)
                                  SizedBox(
                                    width: 140,
                                    child: CustomTextButton(
                                      onPressed: () {
                                        setState(() {
                                          _state = _States.changePassword;
                                        });
                                      },
                                      selected: true,
                                      text: 'change password',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                if (_state != _States.requestAccount)
                                  SizedBox(
                                    width: 140,
                                    child: CustomTextButton(
                                      onPressed: () {
                                        setState(() {
                                          _state = _States.requestAccount;
                                        });
                                      },
                                      selected: true,
                                      text: 'request account',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                if (_state != _States.login)
                                  SizedBox(
                                    width: 140,
                                    child: CustomTextButton(
                                      onPressed: () {
                                        setState(() {
                                          _state = _States.login;
                                        });
                                      },
                                      selected: true,
                                      text: 'login',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  void Function()? onEditingComplete;
  TextEditingController controller;
  String hintText;
  _PasswordTextField(
      {super.key,
      this.onEditingComplete,
      required this.controller,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      onEditingComplete: onEditingComplete,
      textAlign: TextAlign.center,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: BorderRadius.zero,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onBackground),
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
    );
  }
}

class _EmailTextField extends StatelessWidget {
  void Function()? onEditingComplete;
  TextEditingController controller;
  _EmailTextField({
    super.key,
    required this.controller,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.center,
      onEditingComplete: onEditingComplete,
      controller: controller,
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: BorderRadius.zero,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onBackground),
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
    );
  }
}
