import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/add_user.dart';
import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';

class StaffList extends StatefulWidget {
  static String id = 'StaffList';

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Staff List'),
      ),
      body: SingleChildScrollView(
        child: ShowList(userList: false,),
      ),

    );
  }
}