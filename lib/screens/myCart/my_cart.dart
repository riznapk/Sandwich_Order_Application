import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_order_app/helpers/bottom_navigation.dart';
import 'package:sandwich_order_app/helpers/sideDish_list.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:sandwich_order_app/helpers/utils.dart';
import 'package:sandwich_order_app/screens/home.dart';
import 'package:sandwich_order_app/screens/orders/my_order.dart';
import '../../navigation_bar.dart' as nav;

class MyCart extends StatefulWidget {
  final Map? data;
  const MyCart({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  MyCartState createState() => MyCartState();
}

class MyCartState extends State<MyCart> {
  var buyFood = 1;
  String orderNumber = '';

  void _incFood() {
    setState(() {
      buyFood++;
    });
  }

  void _decFood() {
    setState(() {
      if (buyFood > 1) {
        buyFood--;
      } else {
        buyFood = 1;
      }
    });
  }

  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("ORDERS"),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => nav.NavigationBar(index: 1)));
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Order ID $orderNumber"),
        content: Text(
            "Your order is under preperation. Please visit the store for take away. Collection ID: $orderNumber"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Future onCheckout() async {
      showAlertDialog(context);
      print("hi from checkout");
      final user = FirebaseAuth.instance.currentUser!;

      String uid = user.uid;
      String subNumber = uid.substring(1, 7);
      String orderID = 'OR$subNumber';
      setState(() {
        orderNumber = orderID;
      });
      Map filteredData = {
        "orderID": orderID,
        "itemID": widget.data!["itemID"],
        "itemName": widget.data!["itemName"],
        "itemImage": widget.data!["itemImage"],
        "itemPrice": widget.data!["itemPrice"],
        "totalPrice": widget.data!["totalPrice"],
        "snacks": widget.data!["snacks"],
        "drinks": widget.data!["drinks"]
      };

      print("filtered data $filteredData");

      try {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('users/$uid/orders/$orderID');

        await ref.set(filteredData);
      } on FirebaseAuthException catch (e) {
        utils.showSnackBar(e.message);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Text(
                  "Cart Items",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200]!,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey[200]!,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(30, 70, 20, 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    final SideDishList options = snacksList[index];
                    return InkWell(
                        // onTap: () {
                        //   Navigator.of(context).push(MaterialPageRoute(
                        //       builder: (context) => SideDishDetails()));
                        // },
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 13),
                              decoration: BoxDecoration(
                                //color: Color(0xffDFC7D9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: FittedBox(
                                child: Image.network(
                                  widget.data!["itemImage"],
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 500,
                                    child: Text(
                                      widget.data!["itemName"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "£${widget.data!["totalPrice"]}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: _decFood,
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Color(0xff533F4E),
                                        ),
                                      ),
                                      Text(
                                        "$buyFood",
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 4, 4, 4)),
                                      ),
                                      IconButton(
                                        onPressed: _incFood,
                                        icon: const Icon(
                                          Icons.add,
                                          color: Color(0xff533F4E),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                      ],
                    ));
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text.rich(
                  TextSpan(
                    text: 'Total: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text: "£${widget.data!["totalPrice"]}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        //onPressed: () => {showAlertDialog(context)},
                        onPressed: onCheckout,
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
                        child: const Text("PROCEED TO CHECKOUT"),
                      ),
                      ElevatedButton(
                        onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  nav.NavigationBar(index: 0)))
                        },
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
                        child: const Text("HOME"),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
      //bottomNavigationBar: BottomNav(),
    );
  }
}
