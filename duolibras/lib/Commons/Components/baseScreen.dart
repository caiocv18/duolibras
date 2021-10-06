import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class BaseScreen<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Function(T)? onModelReady;
  final Tuple2<dynamic, dynamic>? parameters;

  BaseScreen({required this.builder, this.parameters, this.onModelReady});
  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseScreen<T>> {
  late T model; // = locator<T>(p);
  @override
  void initState() {
    if (widget.parameters == null) {
      model = locator<T>();
    } else {
      print(T);
      model = locator<T>(
          param1: widget.parameters!.item1, param2: widget.parameters!.item2);
    }

    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
