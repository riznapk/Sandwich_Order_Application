import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_order_app/helpers/list_food.dart';
import 'package:sandwich_order_app/helpers/option_selection.dart';
import 'package:sandwich_order_app/helpers/utils.dart';
import 'package:sandwich_order_app/screens/myCart/my_cart.dart';
import 'package:sandwich_order_app/screens/sideDishDetails.dart';

class ProductDetails extends StatefulWidget {
  final food;
  const ProductDetails({Key? key, required this.food}) : super(key: key);
  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  final String selectedItemName = "";
  double cartCount = 1;
  double totalPrice = 0;
  late final double sideDishPrice;
  SelectedItems itemSelected =
      new SelectedItems(sideDishId: "", sideDishName: "", sideDishPrice: 0.0);
  SelectedSnackItems itemSnackSelected = new SelectedSnackItems(
      sideDishId: "", sideDishName: "", sideDishPrice: 0.0);

  selectedSideItem(id, name, price) {
    var item =
        SelectedItems(sideDishId: id, sideDishName: name, sideDishPrice: price);
    print(item.sideDishName);
    setState(() {
      itemSelected = item;
    });

    calculateTotalPrice();
  }

  selectedSnackItems(id, name, price) {
    var itemSnack = SelectedSnackItems(
        sideDishId: id, sideDishName: name, sideDishPrice: price);
    print(itemSnack.sideDishName);
    setState(() {
      itemSnackSelected = itemSnack;
    });

    calculateTotalPrice();
  }

  calculateTotalPrice() {
    print("hhi");
    //BuyFood buyFood;
    double pp = double.parse(widget.food["productPrice"]);
    //print("${pp.runtimeType} pp type ${pp}, ${}");

    double totalPriceTemp = pp * cartCount +
        itemSelected.sideDishPrice +
        itemSnackSelected.sideDishPrice;

    print(
      widget.food["productPrice"],
    );
    print(
      widget.food["productPrice"].runtimeType,
    );
    print("price type above");
    print(totalPrice);
    setState(() {
      totalPrice = totalPriceTemp;
    });
  }

  double getValueOfCartCount(count) {
    setState(() {
      cartCount = count;
    });
    return cartCount;
  }

  Future addToCart() async {
    final user = FirebaseAuth.instance.currentUser!;
    print("user");
    print(user);
    String uid = user.uid;
    Map filteredData = {
      "itemID": widget.food["productID"],
      "itemName": widget.food["productName"],
      "itemImage": widget.food["imageURL"],
      "itemPrice": widget.food["productPrice"],
      "totalPrice": totalPrice,
      "snacks": {
        "snackName": itemSnackSelected.sideDishName,
        "snackPrice": itemSnackSelected.sideDishPrice,
        "snackID": itemSnackSelected.sideDishId,
      },
      "drinks": {
        "drinkName": itemSelected.sideDishName,
        "drinkPrice": itemSelected.sideDishPrice,
        "drinkID": itemSelected.sideDishId,
      }
    };

    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/$uid/cart');

      await ref.set({
        "itemID": widget.food["productID"],
        "itemName": widget.food["productName"],
        "itemImage": widget.food["imageURL"],
        "itemPrice": widget.food["productPrice"],
        "totalPrice": totalPrice,
        "snacks": {
          "snackName": itemSnackSelected.sideDishName,
          "snackPrice": itemSnackSelected.sideDishPrice,
          "snackID": itemSnackSelected.sideDishId,
        },
        "drinks": {
          "drinkName": itemSelected.sideDishName,
          "drinkPrice": itemSelected.sideDishPrice,
          "drinkID": itemSelected.sideDishId,
        }
      });
    } on FirebaseAuthException catch (e) {
      utils.showSnackBar(e.message);
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MyCart(data: filteredData)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xffDFC7D9),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.chevron_left_square_fill,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    Image.network(
                      widget.food["imageURL"],
                      width: 250,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.food["productName"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      widget.food["productDescription"],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "£${widget.food["productPrice"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff533F4E),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: BuyFood(
                                getValueOfCartCount: getValueOfCartCount,
                                calculateTotalPrice: calculateTotalPrice),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      widget.food["productDescription"],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),

              //drinks and snacks session

              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select option",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Required",
                        style: TextStyle(
                          color: Color(0xff533F4E),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: optionList.length,
                  itemBuilder: (context, index) {
                    final OptionSelection options = optionList[index];
                    return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SideDishDetails(
                                  selectionValue: options.value,
                                  selectedSideItem: selectedSideItem,
                                  selectedSnackItem: selectedSnackItems)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                                    child: Image.asset(options.image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          options.optionHeading,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          "SELECTED",
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xff533F4E),
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          itemSelected.sideDishName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          '£ ${itemSelected.sideDishPrice}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //FavB(),
                          ],
                        ));
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SideDishDetails(
                              selectionValue: "snacks",
                              selectedSideItem: selectedSideItem,
                              selectedSnackItem: selectedSnackItems)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                                child: Image.asset("images/fries.jpg"),
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
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Snacks and Dips",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "SELECTED",
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xff533F4E),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      itemSnackSelected.sideDishName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      '£ ${itemSnackSelected.sideDishPrice}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //FavB(),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),

      //Add to Cart button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: (itemSelected.sideDishPrice != 0 &&
                itemSnackSelected.sideDishPrice != 0)
            ? ElevatedButton(
                onPressed: addToCart,
                //onPressed: calculateTotalPrice,
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
                child: Text("Add to cart £ $totalPrice"),
              )
            : ElevatedButton(
                onPressed: null,
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
                child: Text("Add to cart £ $totalPrice"),
              ),
      ),
    );
  }
}

class BuyFood extends StatefulWidget {
  final Function getValueOfCartCount;
  final Function calculateTotalPrice;
  const BuyFood(
      {Key? key,
      required this.getValueOfCartCount,
      required this.calculateTotalPrice})
      : super(key: key);

  @override
  State<BuyFood> createState() => _BuyFoodState();
}

//   class FavB extends StatefulWidget {
//   const FavB({Key? key}) : super(key: key);

//   @override
//   State<FavB> createState() => _FavBState();
// }

class _BuyFoodState extends State<BuyFood> {
  double buyFood = 1;

  void _incFood() {
    setState(() {
      buyFood++;
      widget.getValueOfCartCount(buyFood);
      widget.calculateTotalPrice();
    });
  }

  void _decFood() {
    setState(() {
      if (buyFood > 1) {
        buyFood--;
        widget.getValueOfCartCount(buyFood);
        widget.calculateTotalPrice();
      } else {
        buyFood = 1;
        widget.getValueOfCartCount(buyFood);
        widget.calculateTotalPrice();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _decFood,
          icon: const Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
        Text(
          "$buyFood",
          style: const TextStyle(color: Colors.white),
        ),
        IconButton(
          onPressed: _incFood,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class SelectedItems {
  String sideDishId;
  String sideDishName;
  double sideDishPrice;

  SelectedItems(
      {required this.sideDishId,
      required this.sideDishName,
      required this.sideDishPrice});
}

class SelectedSnackItems {
  String sideDishId;
  String sideDishName;
  double sideDishPrice;

  SelectedSnackItems(
      {required this.sideDishId,
      required this.sideDishName,
      required this.sideDishPrice});
}
