import 'package:flutter/material.dart';

class BoxWidget extends StatelessWidget {
  final String title;


  
  final double widthSize;
  final double heightSize;
  final dynamic bgColor;
  final dynamic textColor;

  const BoxWidget(this.title, this.bgColor,this.textColor,this.widthSize,this.heightSize);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: widthSize,
      height: heightSize,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 20),
      ),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black, width: 1.0)),
    );
  }
}
