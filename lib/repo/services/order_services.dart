import 'package:bebeautyapp/model/MStatus.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../model/MOrder.dart';
import '../../model/MOrigin.dart';
import '../../model/MProduct.dart';
import '../../model/MProductInCart.dart';

class OrderServices {
  final CollectionReference refOrder =
      FirebaseFirestore.instance.collection('Order');
  ProductServices productServices = ProductServices();


  List<MStatus> statuses = [
    MStatus(id: 0, name: "Pending"),
    MStatus(id: 1, name: "Preparing"),
    MStatus(id: 2, name: "Shipping"),
    MStatus(id: 3, name: "Received"),
    MStatus(id: 4, name: "Rated"),
    MStatus(id: 5, name: "Completed"),
    MStatus(id: -1, name: "Cancelled"),
  ];

  List<MStatus> getAllStatuses(){
    return statuses;
  }

  int getStatusByTabName(String tabName) {
    for(int i = 0; i < statuses.length; i++) {
      if(tabName == statuses[i].name) return statuses[i].id;
    }
    return -2;
  }
  
  List<MStatus> getStatusesForAdmin(int status) {
    List<MStatus> temp = statuses;
    temp.removeLast();
    if(status == 0) {
      temp.removeLast();
      temp.removeLast();
    }
    else if(status == 1) {
      temp.removeAt(0);
      temp.removeLast();
      temp.removeLast();
    }
    else if(status == 2) {
      temp.removeAt(0);
      temp.removeAt(0);
      temp.removeLast();
      temp.removeLast();
    }
    else if(status == 3) {
      temp.removeAt(0);
      temp.removeAt(0);
      temp.removeAt(0);
      temp.removeLast();
      temp.removeLast();
    }
    else if(status == 4) {
      temp.removeAt(0);
      temp.removeAt(0);
      temp.removeAt(0);
      temp.removeAt(0);
    }
    else if(status == 5) {
      temp.removeAt(0);
      temp.removeAt(0);
      temp.removeAt(0);
      temp.removeAt(0);
      temp.removeAt(0);
    }

    return temp;
  }
  


  //Add Order
  Future<bool> addOrder(
      String userID,
      String voucherCode,
      double discountValue,
      double shippingValue,
      double totalPayment,
      int totalQuantity,
      int numOfProducts,
      String address,
      double latitude,
      double longitude,
      String userName,
      String phone,
      int time,
      List<MProductInCart> productsInCart) async {
    String orderID = "";

    try {
      await refOrder.doc().set({
        'orderID': "",
        'userID': userID,
        'voucherCode': voucherCode,
        'discountValue': discountValue,
        'shippingValue': shippingValue,
        'totalPayment': totalPayment,
        'totalQuantity': totalQuantity,
        'numOfProducts': numOfProducts,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'userName': userName,
        'phone': phone,
        'time': time,
        'status': 0
      });

      await refOrder.where('userID', isEqualTo: userID).get().then((result) {
        for (DocumentSnapshot Order in result.docs) {
          if (Order.get('orderID') == "") orderID = Order.id;
        }
      });

      if (orderID != "") {
        bool isUpdateID = await updateOrderID(orderID);
        if (isUpdateID == true) {
          bool checkAddProductInOrder =
              await addProductsInOrder(orderID, productsInCart);
          if (checkAddProductInOrder == true) {
            //MOrder result_Order = await getOrderByOrderID(orderID, products);
            return true;
          } else
            return false;
        } else
          return false;
      } else
        return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<MOrder> getOrderByOrderID(
      String orderID, List<MProduct> products) async {
    List<MOrder> orders = [];
    await refOrder.where('orderID', isEqualTo: orderID).get().then((result) {
      for (DocumentSnapshot Order in result.docs) {
        orders.add(MOrder.fromSnapshot(Order));
      }
    });
    await refOrder.doc(orderID).collection('Products').get().then((result) {
      for (DocumentSnapshot Order in result.docs) {
        int productID = Order.get('productID');
        int quantity = Order.get('quantity');
        MProduct product = productServices.getProductByID(products, productID);
        MProductInCart productInCart = new MProductInCart(
            id: productID,
            name: product.getName(),
            engName: product.getEngName(),
            quantity: quantity,
            displayImage: product.getImage(0),
            price: product.getPrice());
        orders[0].productsInCart.add(productInCart);
      }
    });
    return orders[0];
  }

  Future<List<MProductInCart>> getProductsInOrder(
      String orderID, List<MProduct> products) async {
    List<MProductInCart> productsInOrder = [];
    await refOrder.doc(orderID).collection('Products').get().then((result) {
      for (DocumentSnapshot Order in result.docs) {
        int productID = Order.get('productID');
        int quantity = Order.get('quantity');
        MProduct product = productServices.getProductByID(products, productID);
        MProductInCart productInCart = new MProductInCart(
            id: productID,
            name: product.getName(),
            engName: product.getEngName(),
            quantity: quantity,
            displayImage: product.getImage(0),
            price: product.getPrice());
        productsInOrder.add(productInCart);
      }
    });
    return productsInOrder;
  }

  /*Future<List<MOrder>> getOrderByUserID(String userID, List<MProduct> products) async {
    List<MOrder> orders = [];
    await refOrder.where('userID', isEqualTo: userID).get().then((result) {
      for (DocumentSnapshot Order in result.docs) {
        orders.add(MOrder.fromSnapshot(Order));
      }
    });
    for(int i = 0; i < orders.length; i++) {
      await refOrder.doc(orders[i].getID()).collection('Products').get().then((result) {
        for (DocumentSnapshot Order in result.docs) {
          int productID = Order.get('productID');
          int quantity = Order.get('quantity');
          MProduct product = productServices.getProductByID(products, productID);
          MProductInCart productInCart = new MProductInCart(id: productID, name: product.getName(),
              engName: product.getEngName(), quantity: quantity, displayImage: product.getImage(0), price: product.getPrice());
          orders[i].productsInCart.add(productInCart);
        }
      });
    }

    return orders;
  }*/

  getOrderByUserID(String userID, int status) async {
    return refOrder
        .where('userID', isEqualTo: userID)
        .where('status', isEqualTo: status)
        .orderBy('time', descending: true)
        .snapshots();
  }

  getOrderByStatus(int status) async {
    return refOrder
        .where('status', isEqualTo: status)
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<bool> updateOrderID(String orderID) async {
    try {
      await refOrder.doc(orderID).update({'orderID': orderID});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addProductsInOrder(
      String orderID, List<MProductInCart> products) async {
    try {
      int iCount = 0;
      for (int i = 0; i < products.length; i++) {
        Map<String, dynamic> product = {
          "productID": products[i].getID(),
          "quantity": products[i].getQuantity()
        };
        await refOrder.doc(orderID).collection('Products').add(product);
        iCount++;
      }
      if (iCount == products.length)
        return true;
      else
        return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  String getDate(int time) {
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat('EEEE, d MMM, yyyy').format(date);
  }
  //Delete Order

  Future<bool> deleteOrder(String orderID) async {
    try {
      await refOrder.doc(orderID.toString()).delete();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderID, int status) async {
    try {
      await refOrder.doc(orderID).update({'status': status});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
