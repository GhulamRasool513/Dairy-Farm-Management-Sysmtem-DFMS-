import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class Designation extends StatelessWidget {
  static String id = 'Designation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Cow Feed'),
      ),
      body: Container());
  }
}
