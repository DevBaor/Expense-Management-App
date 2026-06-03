import 'package:flutter/material.dart';
import 'package:nhom4/GUI/style.dart';
import 'package:nhom4/GUI/widgets/spinkit.dart';

//
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Style.backgroundColor,
      child: Center(child: spinkit),
    );
  }
}
