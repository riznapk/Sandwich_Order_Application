import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  List userList = [];
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("users");

  Future getData() async {
    try {
      //to get data from a single/particular document alone.
      // var temp = await collectionRef.doc("<your document ID here>").get();
      print("hello from func");
      // to get data from all documents sequentially
      await collectionRef.get().then((querySnapshot) {
        print("hello from func2");
        for (var result in querySnapshot.docs) {
          print("hello from func2");
          userList.add(result.data());
          print("hello from func2");
        }
      });
      print(userList);
      return userList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }
}
