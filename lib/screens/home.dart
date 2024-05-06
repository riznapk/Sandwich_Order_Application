// ignore_for_file: unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sandwich_order_app/helpers/utils.dart';
//import 'package:sandwich_order_app/helpers/list_food.dart';
import 'package:sandwich_order_app/screens/productDetails.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  var productList;
  var foodList = [];

  //initail loading of data
  // @override
  // void initState() {
  //   super.initState();
  //   readJson();
  //   print("hi on initial load");
  // }

  // List foodList = [
  //   {
  //     "name": "chips",
  //     "price": 12,
  //     "imageUrl": "assets/images/sandwich_meal.jpeg"
  //   }
  // ];

// Fetch content from the json file
  // Future<void> readJson() async {
  //   final String response = await rootBundle.loadString('data/order_list.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     foodList = data["snacks"];
  //   });
  // }

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

  Future<Object?> removeItem(String itemDel) async {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref('/productList/${itemDel}')
        .remove() as DatabaseReference;
    utils.showSnackBar("PRODUCT DELETED");
    fetchUserDetails();
  }

  @override
  void initState() {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref("/productList");
    dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("data from db $data");
      productList = ProductList(children: data as Map);
      var listFetched = productList.setupProductList();
      print("list $listFetched");
      setState(() {
        foodList = listFetched;
      });
    });
    fetchUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView.builder(
      itemCount: foodList.length,
      itemBuilder: (BuildContext context, int index) {
        //final foodItem = foodList[index];
        print(foodList[index]);
        return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetails(food: foodList[index])));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              // child: Column(children: [
              //   ElevatedButton(
              //     onPressed: readJson,
              //     child: const Text('Load Data'),
              //   ),
              // ])
              child: Column(children: [
                ClipRect(
                    //borderRadius: BorderRadius.circular(15),
                    child: Hero(
                  tag: foodList[index]["imageURL"],
                  child: Image(
                    height: 200,
                    width: 200,
                    image: NetworkImage(foodList[index]["imageURL"])
                        as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                )),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        foodList[index]["productName"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // RatingStars(
                      //   rating: restaurant.rating,
                      // ),
                      // SizedBox(
                      //   height: 4,
                      // ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            '£ ${foodList[index]["productPrice"]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )),
                      // SizedBox(
                      //   height: 4,
                      // ),

                      if (isAdmin == true)
                        ElevatedButton.icon(
                          label: const Text('REMOVE'),
                          icon: const Icon(
                            Icons.delete,
                            size: 15,
                          ),
                          onPressed: () =>
                              {removeItem(foodList[index]["productID"])},
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                        )
                    ],
                  ),
                )
              ]),
            ));
      },
    )));
  }
}

class ProductList {
  Map? children;

  List<Map> productList = [];

  ProductList({required this.children});

  List<Map> setupProductList() {
    print("childredn $children");
    print("childredn entereis ${children!.entries}");
    children!.entries.forEach((element) {
      var productdata = element.value as Map;
      print("childredn entereis order ${element.value}");
      productList.add(productdata);
    });

    return productList;
  }
}
