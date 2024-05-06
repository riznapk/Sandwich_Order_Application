import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_order_app/helpers/sideDish_list.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({
    Key? key,
  }) : super(key: key);

  @override
  MyOrderState createState() => MyOrderState();
}

class MyOrderState extends State<MyOrder> {
  var buyFood = 1;
  var orderList;
  List orderListfetched = [];

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

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser!;
    print("user");
    print(user);
    String uid = user.uid;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref("/users/$uid/orders");
    dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("data from db $data");
      orderList = OrderList(children: data as Map);
      var listFetched = orderList.setupProductList();
      print("list $listFetched");
      setState(() {
        orderListfetched = listFetched;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
        // Container(
        //   padding: const EdgeInsets.all(20),
        //   color: const Color(0xffDFC7D9),
        //   child: Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           IconButton(
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //             icon: const Icon(
        //               CupertinoIcons.chevron_left_square_fill,
        //               color: Colors.white,
        //               size: 35,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Text(
            "Orders",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (orderListfetched.length == 0) Text("No Orders Placed"),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 70, 20, 20),
          child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderListfetched.length,
            itemBuilder: (context, index) {
              var options = orderListfetched[index];
              return Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                'ORDER ID: ${options["orderID"]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              "Total Price: £${options["totalPrice"]}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "STATUS : ORDER PLACED",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ));
            },
          ),
        )
      ]))),
    );
  }
}

class OrderList {
  Map? children;

  List<Map> orderList = [];

  OrderList({required this.children});

  List<Map> setupProductList() {
    print("childredn $children");
    print("childredn entereis ${children!.entries}");
    children!.entries.forEach((element) {
      var orderdata = element.value as Map;
      print("childredn entereis order ${element.value}");
      orderList.add(orderdata);
    });

    return orderList;
  }
}
