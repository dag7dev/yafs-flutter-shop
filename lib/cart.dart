// cart that represents a cart
// to implement the cart, a map has been used, since it is perfect as we are
// memorizing key:value, where keys are products and values are quantity of that
// item

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class Cart extends StatelessWidget {
  Map<Product, int> cart = Map<Product, int>();

  get length => cart.length;

  void insert(Product p, int qty) {
    cart.putIfAbsent(p, () => qty);
  }

  void remove(Product p) {
    cart.remove(p);
  }

  void removeAll() {
    cart.clear();
  }

  void updateQty(Product p, int value) {
    cart.update(p, (v) => value);
  }

  void addQty(Product p) {
    cart.update(p, (v) {
      if (v <= 99) {
        return v + 1;
      } else {
        return v;
      }
    });
  }

  void removeQty(Product p) {
    cart.update(p, (v) {
      if (v > 1) {
        return v - 1;
      }
      return v;
    });
  }

  String printAll() {
    String s = "";

    if (cart.length == 0) {
      s = "Cart empty!";
    } else {
      var _prod = cart.keys.toList();
      var _quant = cart.values.toList();

      for (int i = 0; i < cart.length; i++) {
        s += (_prod[i].toString()) + " ";
        s += (_quant[i].toString()) + "\n" + "\n";
      }
    }

    return s;
  }

  Product get(int index) {
    var _prod = cart.keys.toList();
    return _prod[index];
  }

  int getQty(int index) {
    var _quant = cart.values.toList();
    return _quant[index];
  }

  int getQtyByProd(Product p) {
    return cart[p];
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  bool isEmpty() => cart.length == 0 ? true : false;

  double getTotal() {
    double tot = 0;

    if (cart.length == 0) {
      tot = 0;
    } else {
      var _prod = cart.keys.toList();
      var _quant = cart.values.toList();

      for (int i = 0; i < cart.length; i++) {
        tot += _prod[i].price * _quant[i];
      }
    }

    return tot;
  }
}
