import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String showTitle;

  const MyText({this.showTitle});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Center(
          child: Text(showTitle),
        ),
      ),
    );
  }
}
