import 'package:flutter/material.dart';
import 'package:flutter_login/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  bool registering = false;
  String error = "";

  @override
  void dispose() {
    super.dispose();
    _accountController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
  }

  void _onGotoLoginScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _accountController,
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
          TextField(
            controller: _repasswordController,
            decoration: const InputDecoration(
              hintText: "Repassword"
            ),
          ),
          if(error != null && error.isNotEmpty)
            Text(error),
          MaterialButton(
            onPressed: _onRegister,
            child: const Text("Register"),
          ),
          MaterialButton(
            onPressed: _onGotoLoginScreen,
            child: const Text("Login"),
          )
        ],
      ),
    );
  }

  void _onRegister() async{
    if(registering) {
      return;
    }
    setState(() {
      registering = true;
    });
    String _account = _accountController.text;
    String _password = _passwordController.text;
    String _repassword = _repasswordController.text;
    if(_account.isEmpty) {
      showError("Account invalid!");
      return;
    }
    if(_password.isEmpty) {
      showError("Password invalid!");
      return;
    }
    if(_repassword.isEmpty) {
      showError("Repassword invalid!");
      return;
    }
    if(!_repassword.contains(_password)) {
      showError("Password not match repassword");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    String ?_dbAccount = prefs.getString(_account);
    if(_dbAccount != null && _dbAccount.isNotEmpty) {
      showError("Account existed!");
      return;
    }
    prefs.setString(_account, _password);
    prefs.setString("user", _account);
    setState(() {
      registering = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void showError(String message) {
    setState(() {
      error = message;
      registering = false;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        error = "";
      });
    });
  }
}