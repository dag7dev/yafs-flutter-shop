// this is a visual representation of a cart (widget)

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'cart.dart';
import 'utils.dart';

class BeautifulCart extends StatefulWidget {
  Cart cart;

  BeautifulCart(Cart cart) {
    this.cart = cart;
  }

  @override
  _BeautifulCartState createState() => _BeautifulCartState(cart);
}

class _BeautifulCartState extends State<BeautifulCart> {
  Cart cart;

  _BeautifulCartState(Cart cart) {
    this.cart = cart;
  }

  @override
  Widget build(BuildContext context) {
    var totCart =
        cart.isEmpty() ? "0.00€" : cart.getTotal().toStringAsFixed(2) + "€";

    // core part which will be shown in the modal cart window
    return Container(
      width: 500,
      height: 450,
      child: CupertinoScrollbar(
        child: Column(children: [
          Expanded(
            // build something scrollable
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: cart.length,
              itemBuilder: (context, index) {
                var item = cart.get(index);
                String tot =
                    (item.price * cart.getQtyByProd(item)).toStringAsFixed(2) +
                        "€";
                // this is gonna to be returned by itembuilder: card!
                return SizedBox(
                  height: 145,
                  child: InkWell(
                    onTap: () {},
                    child: FlipCard(
                      // card on a card, to build shadow easier
                      front: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(children: [
                            // CARD thumbnail
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: 400,
                                child: Image.network(
                                  item.thumbnailUrl,
                                ),
                              ),
                            ),

                            // card product title
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 8.0, right: 8),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          item.title,
                                          maxLines: 2,
                                          style:
                                              TextStyle(fontFamily: "Poppins"),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: AutoSizeText(
                                            capitalize(item.category),
                                            maxLines: 2,
                                            style:
                                                TextStyle(fontFamily: "Lato"),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),

                            //card product unit price
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: Column(
                                  children: [
                                    AutoSizeText(
                                      "Unit price",
                                      maxLines: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: AutoSizeText(
                                          item.price.toStringAsFixed(2) + "€"),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            // card product quantity (based on cart)
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: Column(
                                  children: [
                                    AutoSizeText("Qty"),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: SpinBox(
                                            min: 1,
                                            max: 99,
                                            value: cart
                                                .getQtyByProd(item)
                                                .toDouble(),
                                            onChanged: (value) {
                                              setState(() {
                                                tot = (item.price *
                                                            cart.getQtyByProd(
                                                                item))
                                                        .toStringAsFixed(2) +
                                                    "€";
                                                totCart = cart.isEmpty()
                                                    ? "0.00€"
                                                    : cart
                                                            .getTotal()
                                                            .toStringAsFixed(
                                                                2) +
                                                        "€";
                                              });
                                              cart.updateQty(
                                                  item, value.toInt());
                                            })
                                        //child: AutoSizeText(cart.getQtyByProd(item).toString()),
                                        )
                                  ],
                                ),
                              ),
                            ),

                            //card product total (quantity*unitprice)
                            Column(children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 32.0),
                                  child: Column(
                                    children: [
                                      AutoSizeText("Tot."),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: AutoSizeText(tot),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          ]),
                        ),
                      ),

                      //card product description
                      back: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: AutoSizeText(item.description)),
                      ),
                      direction: FlipDirection.HORIZONTAL,
                      flipOnTouch: true,
                    ),
                  ),
                );
              },
            ),
          ),

          // building real total price (cart total)
          Container(
            width: 200,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(flex: 1, child: AutoSizeText("Total: ")),
                  Expanded(
                    flex: 1,
                    child: AutoSizeText(
                      cart.isEmpty() ? "0.00€" : totCart.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontFamily: 'Lato', fontSize: 20),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
