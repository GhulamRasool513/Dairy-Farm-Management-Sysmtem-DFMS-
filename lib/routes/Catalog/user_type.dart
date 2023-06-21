import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';

class UserType extends StatefulWidget {
  static String id = 'UserType';

  String? userType;

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  bool editList = false;

  //Controllers
  TextEditingController userTypeController = TextEditingController();

  //Firebase Instance With Custom Collection
  final firestore = FirebaseFirestore.instance
      .collection('Catalog').doc('User Types').collection('User Types');

  //Adding Data To Firebase
  addData() async {
    firestore.doc(userTypeController.text.toLowerCase()).set({
      'User Type': userTypeController.text.trim().toLowerCase(),
    });
  }

  //Delete Method
  deleteData(String id) {
    firestore.doc(id.toLowerCase()).delete();
  }

  //Checking Duplicate Data
  Future<bool> duplicateData(String checkDuplicate) async {
    final QuerySnapshot result = await firestore
        .where('User Type',
        isEqualTo: userTypeController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs!;
    return documents.length == 1;
  }

  GlobalKey<FormState> key = GlobalKey();


  //Start Of Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: greenColor,
          centerTitle: true,
          title: const Text('User Types'),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: key,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  //Text Field For Adding Animal Types.
                  MyTextField(
                    onChanged: (value) {
                      if (userTypeController.text.isEmpty) {
                        editList = false;
                      }
                    },
                    hintText: 'User Types',
                    hintIcon: Icon(
                      FontAwesomeIcons.cow,
                      color: greenColor,
                    ),
                    controller: userTypeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        Fluttertoast.showToast(msg: 'Field Cannot Be Empty');
                      }
                    },
                  ),

                  //Adding Data To Firebase
                  CustomButton(
                    buttonName: 'Add User Type',
                    onPressed: () async {

                      //Checking Validation
                      if (key.currentState!.validate()) {

                        //Checking Duplicate Data.
                        if (await duplicateData(
                            userTypeController.text.toLowerCase())) {
                          Fluttertoast.showToast(
                              msg: 'Data Already Exists');

                          //Adding Data To Firebase
                        } else {
                          addData();
                          userTypeController.clear();
                          Fluttertoast.showToast(msg: 'Data Added Succesfully');
                        }
                      }
                      setState(() {});
                    },
                  ),
                  //Showing List
                  StreamBuilder(
                      stream: firestore.snapshots(),
                      builder: (context, snapshot) {
                        List<TableRow> animalTypeList = [
                          TableRow(
                              decoration:
                              BoxDecoration(color: Colors.grey.shade300),
                              children: [
                                StaffListColumn(
                                  columnName: 'User Type',
                                  fontSize: fontSize,
                                ),
                                StaffListColumn(
                                  columnName: 'Action',
                                  fontSize: fontSize,
                                )
                              ])
                        ];

                        if (!snapshot.hasData) {
                          Fluttertoast.showToast(msg: 'Add Data');
                        } else {
                          //Getting Data From Firebase and adding It To The List.
                          dynamic data = snapshot.data?.docs;
                          for (var dataOfSnapshots in data) {
                            widget.userType =
                            dataOfSnapshots.data()['User Type'];
                            animalTypeList.add(TableRow(children: [
                              StaffListColumn(columnName: widget.userType),
                              GestureDetector(
                                  child: Center(
                                      child: ActionIcon(
                                          color: Colors.grey,
                                          icon: FontAwesomeIcons.trashCan)),
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Warning!'),
                                              content: Text(
                                                  'Are you sure you want to delete this information?'),
                                              actions: [
                                                CustomButton(
                                                  buttonName: 'Delete',
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    deleteData(dataOfSnapshots
                                                        .data()['User Type']);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        '${dataOfSnapshots.data()['User Type'] + ' Deleted'}');
                                                  },
                                                ),
                                                CustomButton(
                                                    buttonName: 'Cancel',
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            );
                                          });
                                    });
                                    setState(() {});
                                  })
                            ]));
                          }
                        }
                        return CustomTableRowDesign(children: animalTypeList);
                      })
                ],
              )),
        ));
  }
}
