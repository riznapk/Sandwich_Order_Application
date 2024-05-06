import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_order_app/screens/accounts/my_account.dart';
import 'package:sandwich_order_app/screens/accounts/register.dart';
import 'package:sandwich_order_app/screens/accounts/sign_in.dart';
import 'package:sandwich_order_app/screens/addItems/addItems.dart';
import 'package:sandwich_order_app/screens/home.dart' as home;
import 'package:sandwich_order_app/screens/myCart/my_cart.dart';
import 'package:sandwich_order_app/screens/orders/my_order.dart';
import 'package:sandwich_order_app/screens/productDetails.dart' as product;
//import 'package:cloud_firestore/firebase_database.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  //UserDetails userData = new UserDetails(values: {});
  var isAdmin;

  Future<Object?> fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('/users');
    final snapshot =
        await dbRef.child('/${user?.uid ?? ''}').child('isAdmin').get();
    if (snapshot.exists) {
      if (snapshot.value != null) {
        setState(() {
          isAdmin = snapshot.value;
        });
      } else
        setState(() {
          isAdmin = false;
        });

      return snapshot.value;
    } else {}
  }

  Widget renderMenu(var screenIndex) {
    if (screenIndex == 2 && isAdmin) {
      return Container(
        //color: Colors.yellow.shade100,
        alignment: Alignment.center,

        child: AddItems(),
      );
    }
    if (screenIndex == 3) {
      return Container(
        //color: Colors.yellow.shade100,
        alignment: Alignment.center,
        //child: MyCart(),
        child: MyAccount(),
      );
    } else
      return _screens[screenIndex];
  }

  final List<Widget> _screens = [
    Container(
      alignment: Alignment.center,
      child: const home.Home(),
    ),
    Container(alignment: Alignment.center, child: const MyOrder()),
    Container(alignment: Alignment.center, child: const MyCart()),
    // Container(
    //   alignment: Alignment.center,
    //   //child: MyAccount(),
    //   child: AddItems(),
    // ),
  ];

  @override
  void initState() {
    fetchUserDetails();
    super.initState();
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.green.shade900,
              // called when one tab is selected
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              // bottom tab items
              items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.feed), label: 'Orders'),
                  BottomNavigationBarItem(
                      //icon: Icon(Icons.shopping_cart_rounded), label: 'Cart'),
                      icon: Icon(Icons.add_card_sharp),
                      label: 'Add Items'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle), label: 'Account')
                ])
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            NavigationRail(
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedIndex: _selectedIndex,

              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.feed), label: Text('Orders')),
                NavigationRailDestination(
                    // icon: Icon(Icons.shopping_cart_rounded),
                    // label: Text('Cart')),
                    icon: Icon(Icons.add_card_sharp),
                    label: Text('Add Items')),
                NavigationRailDestination(
                    icon: Icon(Icons.account_circle), label: Text('Account')),
              ],

              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: const TextStyle(
                color: Color.fromARGB(255, 14, 73, 18),
              ),

              unselectedLabelTextStyle: const TextStyle(),
              // Called when one tab is selected
              leading: Column(
                children: const [
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          Expanded(child: renderMenu(_selectedIndex))
        ],
      ),
    );
  }
}

class UserDetails {
  Object? values;
  String userName = "";
  String email = "";
  bool isAdmin = false;
  String uid = "";

  UserDetails({
    required this.values,
  });

  initialiseValues() {}
}
