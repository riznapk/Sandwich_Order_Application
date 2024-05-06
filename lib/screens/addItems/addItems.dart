import 'dart:html' as html;
import 'dart:math';
import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:sandwich_order_app/helpers/utils.dart';
import 'package:sandwich_order_app/screens/home.dart';
import 'package:uuid/uuid.dart';

class AddItems extends StatefulWidget {
  const AddItems({
    Key? key,
  }) : super(key: key);

  @override
  AddItemsState createState() => AddItemsState();
}

class AddItemsState extends State<AddItems> {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final productDecController = TextEditingController();
  final imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  double _price = 0.0;
  String _imageUrl = "";

  Uint8List? fileImageInBytes;
  String? urlDownload;

  imageUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      fileImageInBytes = result.files.first.bytes;
      setState(() {
        fileImageInBytes = fileImageInBytes;
      });
      String fileName = result.files.first.name;

      UploadTask task = FirebaseStorage.instance
          .ref()
          .child("files/$fileName")
          .putData(fileImageInBytes!);

      final snapshot = await task!.whenComplete(() => {});
      print("hi");
      final urlDownloadTemp = await snapshot.ref.getDownloadURL();
      setState(() {
        print('inout $urlDownloadTemp');
        urlDownload = urlDownloadTemp;
      });
      print('out $urlDownload');
      print("hello");
    }
  }

  Future addToList() async {
    //final user = FirebaseAuth.instance.currentUser!;
    print("user");
    //print(user);
    //String uid = user.uid;
    const uuid = Uuid();
    //Create UUID version-4
    final id = uuid.v4();
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('productList/$id');

      await ref.set({
        "imageURL": urlDownload,
        "productName": productNameController.text,
        "productID": id,
        "productPrice": priceController.text,
        "productDescription": productDecController.text,
      });
      utils.showSnackBar("PRODUCT ADDED");
      setState(() {
        productNameController.text = "";
        priceController.text = "";
        productDecController.text = "";
        fileImageInBytes = null;
      });
    } on FirebaseAuthException catch (e) {
      utils.showSnackBar(e.message);
    }

    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (fileImageInBytes != null)
                      Expanded(
                        child: Container(
                          //color: Colors.amber,
                          child: Center(child: Image.memory(fileImageInBytes!)),
                        ),
                      ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          onPressed: imageUpload,
                          child: Text('Upload Image'),
                        )),
                    TextFormField(
                      controller: productNameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name.';
                        }
                        return null;
                      },
                      onSaved: (value) => _name = value!,
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        return null;
                      },
                      onSaved: (value) => _price = double.parse(value!),
                    ),
                    TextFormField(
                      controller: productDecController,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        return null;
                      },
                      onSaved: (value) => _price = double.parse(value!),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
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
                          onPressed: addToList,
                          child: Text('Add Item to the List'),
                        ))
                  ],
                ))),
      ),
    );
  }
}
