import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .95,
        width: MediaQuery.of(context).size.width * .95,
        child: Column(
          children: const [Text("Register"), Text("Sign In")],
        ),
      ),
    );
  }
}
