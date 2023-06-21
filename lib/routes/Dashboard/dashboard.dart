import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/modals/DashboardDrawer.dart' as drawer;
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Settings/user_settings.dart';

class Dashboard extends StatefulWidget {
  static String id = "Dashboard";

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  //Firebase Instance.
  final firestore = FirebaseFirestore.instance;

  //Variables Holding Dashboard Data.
  double totalCollectedMilk = 0;
  double totalSoldMilk = 0;
  double totalExpense = 0;
  double totalRevenue = 0;
  int totalStaff = 0;
  int totalCows = 0;
  int totalStalls = 0;
  int totalSuppliers = 0;
  int totalCalves = 0;
  int totalPregnantCows = 0;

  //Function To call Dashboard Data From Firebase
  dashboardData()async{

    //Total Milk Collection
    List<double> ltrList = [];
    await firestore.collection('Milk Collection').get()
        .then((QuerySnapshot querySnapshot)  {
      querySnapshot.docs.forEach((doc) {
        ltrList.add(double.parse(doc['Milk LTR']));
      });
    });
    totalCollectedMilk = ltrList.reduce((a, b) => a + b);

    //Total Milk Sold
    List<double> soldmilkLlist = [];
    await firestore.collection('Milk Sale').get()
        .then((QuerySnapshot querySnapshot)  {
      querySnapshot.docs.forEach((doc) {
        soldmilkLlist.add(double.parse(doc['Milk LTR']));
      });
      totalSoldMilk = soldmilkLlist.reduce((a, b) => a + b);
    });

    //Total Farm Expense
    List<double> expenseList = [];
    await firestore.collection('Expense List').get()
        .then((QuerySnapshot querySnapshot)  {
      querySnapshot.docs.forEach((doc) {
        expenseList.add(double.parse(doc['Amount']));
      });
    });
    totalExpense = expenseList.reduce((a, b) => a + b);

    //Total Revenue
    double totalCollectedMilkPrice = 0;
    double totalSoldMilkPrice = 0;
    List<double> collectedMilkPriceList = [];
    await firestore.collection('Milk Collection').get()
        .then((QuerySnapshot querySnapshot)  {
      querySnapshot.docs.forEach((doc) {
        collectedMilkPriceList.add(double.parse(doc['Total']));});});
    totalCollectedMilkPrice = collectedMilkPriceList.reduce((a, b) => a + b);

    List<double> soldMilkPriceList = [];
    await firestore.collection('Milk Sale').get()
        .then((QuerySnapshot querySnapshot)  {
      querySnapshot.docs.forEach((doc) {
        soldMilkPriceList.add(double.parse(doc['Total']));});});
    totalSoldMilkPrice = soldMilkPriceList.reduce((a, b) => a + b);

    totalRevenue = totalSoldMilkPrice;

    //Total Staff
    final QuerySnapshot staff = await FirebaseFirestore.instance.collection('Staff List').get();
    totalStaff = staff.docs.length;

    //Total Cows
    final QuerySnapshot cows = await FirebaseFirestore.instance.collection('Cows List').get();
    totalCows = cows.docs.length;

    //Total Stalls
    final QuerySnapshot stalls = await FirebaseFirestore.instance.collection('Cows List').get();
    totalStalls = stalls.docs.length;

    //Total Suppliers
    final QuerySnapshot suppliers = await FirebaseFirestore.instance.collection('Cows List').get();
    totalSuppliers = suppliers.docs.length;

    //Total Calves
    final QuerySnapshot calves = await FirebaseFirestore.instance.collection('Cows List').get();
    totalCalves = calves.docs.length;

    //Total Calves
    final QuerySnapshot pregnantcows = await FirebaseFirestore.instance.collection('Animal Pregnancy').get();
    totalPregnantCows = pregnantcows.docs.length;

    setState(() {});
  }
@override
  void initState() {
  super.initState();
  dashboardData();
}


//Dashboard Starts Here.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Side Drawer.
      drawer: drawer.NavigationDrawer(),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        title: Text(
          'DFMS',
          style: TextStyle(fontSize: 25.0),
        ),
        elevation: 7.0,
        toolbarHeight: 70.0,
        actions: [
          //User Info Icon
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, UserSettings.id);
            },
            child: Icon(
              Icons.settings,
              size: 30.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Milk Collection.
                    InteractiveViewer(
                      child: MyCard(
                        name: 'Collected Milk',
                        quantity: '${totalCollectedMilk}-Ltr',
                        image: Image.asset(
                          'images/cowIcon.png',
                          scale: 1.2,
                        ),
                        color: Color(0xFFFD6769),
                      ),
                    ),
                    //Sold Milk
                    MyCard(
                      name: 'Sold Milk',
                      quantity: '${totalSoldMilk}-ltr',
                      image: Image.asset(
                        'images/soldmilkIcon.png',
                        scale: 2.1,
                      ),
                      color: Color(0xFF119DA4),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    //Expense Card
                    MyCard(
                      name: 'Expense',
                      quantity: 'Rs.${totalExpense}',
                      image: Image.asset(
                        'images/expenseIcon.png',
                        scale: 4.1,
                        color: Colors.pink,
                      ),
                      color: Colors.pink,
                    ),
                    //Revenue Card.
                    MyCard(
                      name: 'Revenue',
                      quantity: '${totalRevenue}',
                      image: Image.asset(
                        'images/revenueIcon.png',
                        scale: 1.7,
                      ),
                      color: Color(0xFF48294C),
                    ),
                  ],
                ),
                SizedBox(
                  height: 13.0,
                ),
                Container(
                  child: Table(
                    border:
                        TableBorder.symmetric(inside: BorderSide(width: 0.1)),
                    children: [
                      TableRow(
                        //Farm Details.
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            color: Colors.white,
                          ),
                          children: [
                            //Total Staff
                            TableCard(
                              text: 'Staff',
                              quantity: '$totalStaff',
                            ),
                            //Total Cows
                            TableCard(text: 'Cows', quantity: '$totalCows'),
                            //Total Stalls
                            TableCard(text: 'Stalls', quantity: '$totalStalls')
                          ]),
                      TableRow(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: Colors.white,
                          ),
                          children: [
                            //Total Suppliers
                            TableCard(text: 'Supplies', quantity: '$totalSuppliers'),
                            //Total Calves
                            TableCard(text: 'Calves', quantity: '$totalCalves'),
                            //Total Pregnant Cows
                            TableCard(text: 'Prgnt Cows', quantity: '${totalPregnantCows}')
                          ]),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
