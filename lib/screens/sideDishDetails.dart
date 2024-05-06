import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_order_app/helpers/sideDish_list.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:sandwich_order_app/screens/productDetails.dart';

class SideDishDetails extends StatefulWidget {
  final String selectionValue;
  final Function selectedSideItem;
  final Function selectedSnackItem;

  const SideDishDetails({
    Key? key,
    required this.selectionValue,
    required this.selectedSideItem,
    required this.selectedSnackItem,
  }) : super(key: key);

  @override
  SideDishDetailsState createState() => SideDishDetailsState();
}

class SideDishDetailsState extends State<SideDishDetails> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
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
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.selectionValue == "drinks"
                ? drinksList.length
                : snacksList.length,
            itemBuilder: (context, index) {
              final SideDishList options = widget.selectionValue == "drinks"
                  ? drinksList[index]
                  : snacksList[index];
              return InkWell(
                  // onTap: () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => SideDishDetails()));
                  // },
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                options.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              "£${options.price}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (widget.selectionValue == "drinks") {
                                  widget.selectedSideItem(
                                      options.id, options.name, options.price);
                                } else {
                                  widget.selectedSnackItem(
                                      options.id, options.name, options.price);
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('Add'),
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

class SelectedItems {
  String sideDishName;
  double sideDishPrice;

  SelectedItems({required this.sideDishName, required this.sideDishPrice});

  // Map toJson() => {
  //       'sideDishName': sideDishName,
  //       'sideDishPrice': sideDishPrice,
  //     };
}
