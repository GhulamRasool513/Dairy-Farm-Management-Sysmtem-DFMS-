import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';

class FoodItem extends StatefulWidget {
  static String id = 'FoodItem';

  String? foodItem;

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool editList = false;

  //Controllers
  TextEditingController foodItemController = TextEditingController();

  //Firebase Instance With Custom Collection
  final firestore = FirebaseFirestore.instance
      .collection('Catalog').doc('Food Items').collection('Food Items');

  //Adding Data To Firebase
  addData() async {
    firestore.doc(foodItemController.text.toLowerCase()).set({
      'Food Item': foodItemController.text.trim().toLowerCase(),
    });
  }

  //Delete Method
  deleteData(String id) {
    firestore.doc(id.toLowerCase()).delete();
  }

  //Checking Duplicate Data
  Future<bool> duplicateData(String checkDuplicate) async {
    final QuerySnapshot result = await firestore
        .where('Food Item',
        isEqualTo: foodItemController.text.toLowerCase())
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
          title: const Text('Food Items'),
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
                      if (foodItemController.text.isEmpty) {
                        editList = false;
                      }
                    },
                    hintText: 'Food Items',
                    hintIcon: Icon(
                      FontAwesomeIcons.cow,
                      color: greenColor,
                    ),
                    controller: foodItemController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        Fluttertoast.showToast(msg: 'Field Cannot Be Empty');
                      }
                    },
                  ),

                  //Adding Data To Firebase
                  CustomButton(
                    buttonName: 'Add Item',
                    onPressed: () async {

                      //Checking Validation
                      if (key.currentState!.validate()) {

                        //Checking Duplicate Data.
                        if (await duplicateData(
                            foodItemController.text.toLowerCase())) {
                          Fluttertoast.showToast(
                              msg: 'Data Already Exists');

                          //Adding Data To Firebase
                        } else {
                          addData();
                          foodItemController.clear();
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
                                  columnName: 'Food Item',
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
                            widget.foodItem =
                            dataOfSnapshots.data()['Food Item'];
                            animalTypeList.add(TableRow(children: [
                              StaffListColumn(columnName: widget.foodItem),
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
                                                        .data()['Food Item']);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        '${dataOfSnapshots.data()['Food Item'] + ' Deleted'}');
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
