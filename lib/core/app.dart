import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/style/theme.dart';

import '../pages/auth/signin.dart';
import '../pages/auth/signup.dart';
import '../pages/screens/accounts/accounts.dart';
import '../pages/screens/accounts/add_expense.dart';
import '../pages/screens/accounts/add_revenue.dart';
import '../pages/screens/accounts/view_expense.dart';
import '../pages/screens/accounts/view_revenue.dart';
import '../pages/screens/equipments/add_equipment.dart';
import '../pages/screens/equipments/equipments.dart';
import '../pages/screens/home/main_page.dart';
import '../pages/screens/members/add_member.dart';
import '../pages/screens/members/members.dart';
import '../pages/screens/notification/notification.dart';
import '../pages/screens/trainers/add_trainer.dart';
import '../pages/screens/trainers/trainers.dart';
import '../utilities/page_transition.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: authStateFunction(),
      onGenerateRoute: generateRoute,
    );
  }

  StreamBuilder<User?> authStateFunction() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainPage();
        } else {
          return const SignInPage();
        }
      },
    );
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/homepage':
        return buildPageTransition(const MainPage());
      case '/signup':
        return buildPageTransition(const SignUpPage());
      case '/signin':
        return buildPageTransition(const SignInPage());
      case '/member':
        return buildPageTransition(const GymMembers());
      case '/trainer':
        return buildPageTransition(const GymTrainers());
      case '/equipment':
        return buildPageTransition(const GymEquipments());
      case '/account':
        return buildPageTransition(const GymAccounts());
      case '/newMember':
        return buildPageTransition(const AddMember());
      case '/newTrainer':
        return buildPageTransition(const AddTrainer());
      case '/newEquipment':
        return buildPageTransition(const AddEquipment());
      case '/addExpense':
        return buildPageTransition(const AddExpenses());
      case '/addRevenue':
        return buildPageTransition(const AddRevenue());
      case '/expense':
        return buildPageTransition(const ViewExpenses());
      case '/revenue':
        return buildPageTransition(const ViewRevenue());
      case '/notify':
        return buildPageTransition(const GymNotification());
      default:
        return null;
    }
  }
}
