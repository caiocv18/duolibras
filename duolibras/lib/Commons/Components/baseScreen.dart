import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen<T extends BaseViewModel> extends StatelessWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  BaseScreen({required this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => locator<T>(),
      child: Consumer<T>(builder: this.builder),
    );
  }
}
