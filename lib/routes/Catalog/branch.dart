import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class Branch extends StatelessWidget {
  static String id = 'Branch';

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
