import 'package:flutter/material.dart';
import 'package:flutter_login/screens/home_screen.dart';
import 'package:flutter_login/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loggingIn = false;
  String error = "";

  @override
  void dispose() {
    super.dispose();
    _userController.dispose();
    _passwordController.dispose();
  }

  void _onGotoRegisterScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
        actions: [
          IconButton(onPressed: _onGotoRegisterScreen, icon: const Icon(Icons.plus_one))
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _userController,
            decoration: const InputDecoration(
              hintText: "Account"
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: "Password"
            ),
          ),
          if(error != null && error.isNotEmpty) Text(error),
          MaterialButton(
            onPressed: _onLogin,
            child: const Text("Login"),
          )
        ],
      ),
    );
  }

  void _onLogin() async {
    if(loggingIn) {
      return;
    }
    setState(() {
      loggingIn = true;
    });
    String _account = _userController.text;
    String _password = _passwordController.text;
    if(_account.isEmpty) {
      showError("Account invalid!");
      return;
    }
    if(_password.isEmpty) {
      showError("Password invalid!");
      return;
    }
    if(_password.isEmpty) {
      showError("Password invalid!");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    String ?_dbPassword = prefs.getString(_account);
    if(_dbPassword == null) {
      showError("Account not existed!");
      return;
    }
    if(!_dbPassword.contains(_password)) {
      showError("Password wrong!");
      return;
    }
    setState(() {
      loggingIn = false;
    });
    prefs.setString("user", _account);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void showError(String message) {
    setState(() {
      error = message;
      loggingIn = false;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        error = "";
      });
    });
  }
}