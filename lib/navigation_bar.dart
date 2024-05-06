// ignore_for_file: prefer_const_constructors

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

class NavigationBar extends StatefulWidget {
  final index;
  const NavigationBar({Key? key, this.index}) : super(key: key);

  @override
  NavigationBarState createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBar> {
  //UserDetails userData = new UserDetails(values: {});
  bool isAdmin = false;

  Future<Object?> fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('/users');
    final snapshot =
        await dbRef.child('/${user?.uid ?? ''}').child('isAdmin').get();
    print("snapshot value ${snapshot.value}");
    if (snapshot.exists) {
      if (snapshot.value != null) {
        setState(() {
          isAdmin = snapshot.value as bool;
        });
      } else
        setState(() {
          isAdmin = false;
        });

      return snapshot.value;
    } else {}
  }

  Widget renderMenu(var screenIndex) {
    print("admin : ${isAdmin.runtimeType}");
    // if (screenIndex == 2 && isAdmin == "true") {
    //   return Container(
    //     //color: Colors.yellow.shade100,
    //     alignment: Alignment.center,

    //     child: AddItems(),
    //   );
    // }

    if (screenIndex == 2) {
      print('admin type$isAdmin.runtimeType');
      if (isAdmin == true || isAdmin != null) {
        print("hi from is true");
        return Container(
          alignment: Alignment.center,
          child: AddItems(),
        );
      } else {
        return Container(
          alignment: Alignment.center,
          child: MyCart(),
        );
      }
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
  ];

  @override
  void initState() {
    fetchUserDetails();
    super.initState();
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    //int _selectedIndex = widget.index ? widget.index : 0;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        //title: const Text("Hunger Bounce"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            // child: ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: ),),
            child: ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff533F4E),
                padding: const EdgeInsets.all(25),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                ),
              ),
              child: const Text("Logout"),
            ),
          )
        ],
      ),
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
              items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.feed), label: 'Orders'),
                  if (isAdmin)
                    BottomNavigationBarItem(
                        //icon: Icon(Icons.shopping_cart_rounded), label: 'Cart'),
                        icon: Icon(Icons.add_card_sharp),
                        label: 'Add Items'),

                  // if (!isAdmin)
                  //   BottomNavigationBarItem(
                  //       //icon: Icon(Icons.shopping_cart_rounded), label: 'Cart'),
                  //       icon: Icon(Icons.add_card_sharp),
                  //       label: 'Cart'),
                  // BottomNavigationBarItem(
                  //     icon: Icon(Icons.account_circle), label: 'Account')
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

              destinations: [
                // ignore: prefer_const_constructors
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.feed), label: Text('Orders')),
                if (isAdmin)
                  const NavigationRailDestination(
                      // icon: Icon(Icons.shopping_cart_rounded),
                      // label: Text('Cart')),
                      icon: Icon(Icons.add_card_sharp),
                      label: Text('Add Items')),
                // if (!isAdmin)
                //   NavigationRailDestination(
                //       icon: Icon(Icons.shopping_cart_rounded),
                //       label: Text('Cart')),
                //icon: Icon(Icons.add_card_sharp),
                // label: Text('Add Items')),

                // NavigationRailDestination(
                //     icon: Icon(Icons.account_circle), label: Text('Account')),
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
