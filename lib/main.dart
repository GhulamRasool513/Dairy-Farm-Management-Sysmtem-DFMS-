import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/routes/Catalog/animal_types.dart';
import 'package:khan_dairy/routes/Cow%20Feed/cow_feed.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_animal_pregnancy_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_routine_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_vaccine_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/animal_pregnancy.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/routine_monitor.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/vaccine_monitor.dart';
import 'package:khan_dairy/routes/Cow%20Sale/add_cow_sale_information.dart';
import 'package:khan_dairy/routes/Cow%20Sale/cow_sale.dart';
import 'package:khan_dairy/routes/Cow%20Sale/cow_sale_due_collection.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Farm%20Expense/add_expense_information.dart';
import 'package:khan_dairy/routes/Farm%20Expense/expense_list.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/add_salary.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/salary_list.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/staff_list.dart';
import 'package:khan_dairy/routes/Management/add_calf.dart';
import 'package:khan_dairy/routes/Management/add_cow.dart';
import 'package:khan_dairy/routes/Management/add_stall.dart';
import 'package:khan_dairy/routes/Management/manage_calf.dart';
import 'package:khan_dairy/routes/Management/manage_cow.dart';
import 'package:khan_dairy/routes/Management/manage_stall.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/add_milk_collection.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/add_milk_sale.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/collect_milk.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/milk_sale_due.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/sale_milk.dart';
import 'package:khan_dairy/routes/Reports/cow_sale_report.dart';
import 'package:khan_dairy/routes/Reports/employee_salary_report.dart';
import 'package:khan_dairy/routes/Reports/expense_report.dart';
import 'package:khan_dairy/routes/Reports/milk_Collection_report.dart';
import 'package:khan_dairy/routes/Reports/milk_sale_report.dart';
import 'package:khan_dairy/routes/Reports/vaccine_monitor_report.dart';
import 'package:khan_dairy/routes/Settings/user_settings.dart';
import 'package:khan_dairy/routes/Suppliers/add_suppliers.dart';
import 'package:khan_dairy/routes/Suppliers/suppliers_list.dart';
import 'firebase_options.dart';
import 'modals/routes.dart';
import 'routes/Login Registration/Login.dart';
import 'routes/Dashboard/dashboard.dart';


//Initializing Firebase Firestore.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Questrial'),
      initialRoute: Login.id,
      routes: routes,
    );
  }
}
