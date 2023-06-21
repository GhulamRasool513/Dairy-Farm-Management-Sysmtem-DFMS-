import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';

class CatalogColors extends StatefulWidget {
  static String id = 'CatalogColors';

  String? catalogColors;

  @override
  State<CatalogColors> createState() => _CatalogColorsState();
}

class _CatalogColorsState extends State<CatalogColors> {
  bool editList = false;

  //Controllers
  TextEditingController catalogColors = TextEditingController();

  //Firebase Instance With Custom Collection
  final firestore = FirebaseFirestore.instance
      .collection('Catalog').doc('Colors').collection('Colors');

  //Adding Data To Firebase
  addData() async {
    firestore.doc(catalogColors.text.toLowerCase()).set({
      'Color': catalogColors.text.trim().toLowerCase(),
    });
  }

  //Delete Method
  deleteData(String id) {
    firestore.doc(id.toLowerCase()).delete();
  }

  //Checking Duplicate Data
  Future<bool> duplicateData(String checkDuplicate) async {
    final QuerySnapshot result = await firestore
        .where('Color',
        isEqualTo: catalogColors.text.toLowerCase())
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
          title: const Text('Catalog Colors'),
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
                      if (catalogColors.text.isEmpty) {
                        editList = false;
                      }
                    },
                    hintText: 'Catalog Color',
                    hintIcon: Icon(
                      FontAwesomeIcons.cow,
                      color: greenColor,
                    ),
                    controller: catalogColors,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        Fluttertoast.showToast(msg: 'Field Cannot Be Empty');
                      }
                    },
                  ),

                  //Adding Data To Firebase
                  CustomButton(
                    buttonName: 'Add Color',
                    onPressed: () async {

                      //Checking Validation
                      if (key.currentState!.validate()) {

                        //Checking Duplicate Data.
                        if (await duplicateData(
                            catalogColors.text.toLowerCase())) {
                          Fluttertoast.showToast(
                              msg: 'Data Already Exists');

                          //Adding Data To Firebase
                        } else {
                          addData();
                          catalogColors.clear();
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
                                  columnName: 'Color',
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
                            widget.catalogColors =
                            dataOfSnapshots.data()['Color'];
                            animalTypeList.add(TableRow(children: [
                              StaffListColumn(columnName: widget.catalogColors),
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
                                                        .data()['Color']);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        '${dataOfSnapshots.data()['Color'] + ' Deleted'}');
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
