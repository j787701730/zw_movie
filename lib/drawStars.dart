import 'package:flutter/material.dart';

class DrawStars extends StatelessWidget {
  final stars;

  DrawStars(this.stars);

  Widget starWight = Icon(
    Icons.star,
    color: Colors.black12,
    size: 18,
  );
  Widget starWight2 = Icon(
    Icons.star,
    color: Color.fromRGBO(255, 183, 18, 1),
    size: 18,
  );
  Widget halfStarWight = Icon(
    Icons.star,
    color: Color.fromRGBO(255, 183, 18, 1),
    size: 18,
  );

  _draw() {
    double star = double.parse(stars) / 10;
    if (star == 0) {
      return Row(
        children: <Widget>[
          starWight,
          starWight,
          starWight,
          starWight,
          starWight,
        ],
      );
    } else if (star > 0 && star < 1) {
      return Row(
        children: <Widget>[
          halfStarWight,
          starWight,
          starWight,
          starWight,
          starWight,
        ],
      );
    } else if (star == 1) {
      return Row(
        children: <Widget>[
          starWight2,
          starWight,
          starWight,
          starWight,
          starWight,
        ],
      );
    } else if (star > 1 && star < 2) {
      return Row(
        children: <Widget>[
          starWight2,
          halfStarWight,
          starWight,
          starWight,
          starWight,
        ],
      );
    } else if (star == 2) {
      return Row(
        children: <Widget>[
          starWight2,
          starWight2,
          starWight,
          starWight,
          starWight,
        ],
      );
    } else if (star > 2 && star < 3) {
      return Row(
        children: <Widget>[
          starWight2,
          starWight2,
          halfStarWight,
          starWight,
          starWight,
        ],
      );
    } else if (star == 3) {
      return Row(
        children: <Widget>[
          starWight2,
          starWight2,
          starWight2,
          starWight,
          starWight,
        ],
      );
    } else if (star > 3 && star < 4) {
      return Row(
        children: <Widget>[
          starWight2,
          starWight2,
          starWight2,
          halfStarWight,
          starWight,
        ],
      );
    } else if (star == 4) {
      return Row(
        children: <Widget>[
          starWight2,
          starWight2,
          starWight2,
          starWight2,
          starWight,
        ],
      );
    } else if (star > 4 && star < 5) {
      return Row(
        children: <Widget>[
          starWight2,
          starWight2,
          starWight2,
          starWight2,
          halfStarWight,
        ],
      );
    } else if (star >= 5) {
      return Row(
        children: <Widget>[
          starWight2,
          starWight2,
          starWight2,
          starWight2,
          starWight2,
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _draw(),
    );
  }
}
