// import 'package:flutter/material.dart';
// import 'Home.dart';
// import 'Profile.dart';
// import 'Support.dart';
// import 'Transactions.dart';
// import 'package:flutter_session/flutter_session.dart';
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatefulWidget {
//
//
//   @override
//   _HomeState createState() => _HomeState();// import 'package:flutter/material.dart';
// // import 'Home.dart';
// // import 'Profile.dart';
// // import 'Support.dart';
// // import 'Transactions.dart';
// // import 'package:flutter_session/flutter_session.dart';
// //
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       theme: ThemeData(
// //         primarySwatch: Colors.green,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: Home(),
// //     );
// //   }
// // }
// //
// // class Home extends StatefulWidget {
// //
// //
// //   @override
// //   _HomeState createState() => _HomeState();
// // }
// //
// //
// // class _HomeState extends State<Home> {
// //   int _selectedIndex = 0;
// //
// //   Home home;
// //   Transactions transactions;
// //   Support support;
// //   Profile profile;
// //   List<Widget> pages;
// //   Widget currentPage;
// //
// //
// //   @override
// //   void initState() {
// //     home = HomePage() as Home;
// //     transactions = Transactions();
// //     support = Support();
// //     profile = Profile();
// //
// //     pages = [home, transactions, support, profile];
// //     currentPage = home;
// //     super.initState();
// //   }
// //
// //   void ItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //       currentPage= pages[index];
// //       if(currentPage == pages[1]){
// //         //  OpenDialog();
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body:currentPage,
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
// //           BottomNavigationBarItem(
// //               icon: Icon(Icons.highlight), title: Text("Add Report")),
// //           BottomNavigationBarItem(
// //               icon: Icon(Icons.add_alert), title: Text("Emergency")),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.person),
// //             title: Text("Profile"),
// //           ),
// //         ],
// //         currentIndex: _selectedIndex,
// //         onTap: ItemTapped,
// //         type : BottomNavigationBarType.fixed,
// //         fixedColor: Colors.green,
// //       ),
// //     );
// //   }
// // }
// //
// }
//
//
// class _HomeState extends State<Home> {
//   int _selectedIndex = 0;
//
//   Home home;
//   Transactions transactions;
//   Support support;
//   Profile profile;
//   List<Widget> pages;
//   Widget currentPage;
//
//
//   @override
//   void initState() {
//     home = HomePage() as Home;
//     transactions = Transactions();
//     support = Support();
//     profile = Profile();
//
//     pages = [home, transactions, support, profile];
//     currentPage = home;
//     super.initState();
//   }
//
//   void ItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       currentPage= pages[index];
//       if(currentPage == pages[1]){
//         //  OpenDialog();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:currentPage,
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.highlight), title: Text("Add Report")),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.add_alert), title: Text("Emergency")),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             title: Text("Profile"),
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: ItemTapped,
//         type : BottomNavigationBarType.fixed,
//         fixedColor: Colors.green,
//       ),
//     );
//   }
// }
//
