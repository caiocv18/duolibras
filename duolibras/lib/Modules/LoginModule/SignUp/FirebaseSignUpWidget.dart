import 'package:duolibras/Modules/LoginModule/ViewModel/SignUpViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseSignUpWidget extends StatefulWidget {
  final SignUpViewModelProtocol _viewModel;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailTextfieldController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              return widget._viewModel.validateEmailInput(value);
            },
          ),
          TextFormField(
            controller: passwordTextfieldController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              return widget._viewModel.validatePasswordInput(value);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                signUp();
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      widget._viewModel.signUpInFirebase(
          emailTextfieldController.text, passwordTextfieldController.text);
    }
  }
}
