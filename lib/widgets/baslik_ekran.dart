import 'package:flutter/material.dart';

class BaslikEkran extends StatelessWidget {
  const BaslikEkran(this.headerText,
      {Key? key, this.geriButton = 'assets/icons/gerires.png'})
      : super(key: key);
  final String geriButton;
  final String headerText;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            child: Image(
              image: AssetImage(geriButton),
              width: 40,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            headerText,
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    );
  }
}
