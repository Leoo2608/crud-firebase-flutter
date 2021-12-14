import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  FirebaseFirestore? firestore;
  init() {
    firestore = FirebaseFirestore.instance;
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore!.collection('products').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "price": doc["price"],
            "brand": doc["brand"]
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

  Future<void> update(String id, String name, int price, String brand) async {
    try {
      await firestore!
          .collection("products")
          .doc(id)
          .update({'name': name, 'price': price, 'brand': brand});
    } catch (e) {
      print(e);
    }
  }

  Future<void> create(String name, int price, String brand) async {
    try {
      await firestore!
          .collection("products")
          .add({'name': name, 'price': price, 'brand': brand});
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore!.collection("products").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
}
