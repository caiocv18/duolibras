import 'package:duolibras/Modules/LoginModule/ViewModel/autheticationViewModel.dart';
import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseSignUpWidget extends StatefulWidget {
  final FirebaseAuthenticatorProtocol _viewModel;
  FirebaseSignUpWidget(this._viewModel);

  @override
  _FirebaseSignUpWidgetState createState() => _FirebaseSignUpWidgetState();
}

class _FirebaseSignUpWidgetState extends State<FirebaseSignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  final emailTextfieldController = TextEditingController();
  final passwordTextfieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
              controller: emailTextfieldController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                return widget._viewModel.validateEmailInput(value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              keyboardType: TextInputType.visiblePassword,
              controller: passwordTextfieldController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                return widget._viewModel.validatePasswordInput(value);
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  // padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      widget._viewModel.firebaseSignUp(
          emailTextfieldController.text, passwordTextfieldController.text);
    }
  }
}
