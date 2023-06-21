import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import 'package:intl/intl.dart';

import 'package:khan_dairy/modals/global_widgets.dart';

class UserList extends StatelessWidget {
  static String id = 'UserList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('User List'),
      ),
      body: SingleChildScrollView(
        child: ShowList(userList: true),
      ),
    );
  }
}
