import 'package:flutter/material.dart';

class ShippingData extends StatelessWidget {
  const ShippingData({
    Key? key,
    required this.title,
    required this.data
  }) : super(key: key);

  final String title;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 20,),
        Container(
          width: MediaQuery.of(context).size.width * 0.22,
          child: Text(title + ':')
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(data ?? '', softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 1,)
        ),
      ],
    );
  }
}
