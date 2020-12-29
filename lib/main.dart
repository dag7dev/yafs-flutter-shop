// various import
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'product.dart';
import 'beautifulcart.dart';
import 'cart.dart';
import 'utils.dart';

// fetches products
Future<List<Product>> fetchProducts(http.Client client) async {
  final response = await client.get('https://fakestoreapi.com/products');

  return compute(parseProducts, response.body);
}

// converts a response body into a List<Product>.
List<Product> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

// main function
void main() => runApp(YafsApp());

class YafsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'YAFS - Demo';

    return MaterialApp(
      title: appTitle,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// main class containing the shop
class _HomePageState extends State<HomePage> {
  // declaring variables and costants
  final String title = "YAFS - Demo";
  final String btnAddText = "Add to cart";
  Cart cart = Cart();
  List<Product> products;

  // constructor
  _HomePageState({this.products});

  // build method: it defines the main application
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title),
        actions: [
          // defining search placeholder button
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.search,
              size: 26.0,
            ),
          ),

          // defining cart and what happens when you click on cart button
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton.icon(
                color: Colors.white,
                icon: Icon(
                  Icons.shopping_cart,
                ),
                label: Text(
                  "Cart",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Lato'),
                ),
                onPressed: () => {
                  AwesomeDialog(
                    customHeader: Icon(
                      Icons.shopping_cart,
                      size: 44,
                      color: Colors.green,
                    ),
                    width: 600,
                    context: context,
                    headerAnimationLoop: false,
                    animType: AnimType.BOTTOMSLIDE,

                    // if cart is empty then show an appropriate message
                    // else, shows the cart
                    body: cart.isEmpty()
                        ? Text("This cart is empty!")
                        : BeautifulCart(cart),
                    btnOk: Center(
                      child: Column(children: [
                        // defining buttons (pay now, empty cart)
                        SizedBox(
                          height: 100,
                          child: Container(
                            child: Column(
                              children: [
                                // PAY NOW BUTTON
                                FlatButton.icon(
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: cart.isEmpty()
                                        ? Colors.grey
                                        : Colors.green,
                                  ),
                                  minWidth: 200,
                                  onPressed: cart.isEmpty() ? null : () => {},
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 30.0,
                                      right: 30,
                                      bottom: 20,
                                      top: 20),
                                  label: Text(
                                    "Pay now",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: cart.isEmpty()
                                            ? Colors.grey
                                            : Colors.green,
                                        fontFamily: 'Lato'),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: cart.isEmpty()
                                          ? Colors.grey
                                          : Colors.green,
                                    ),
                                  ),
                                ),

                                // EMPTY CART BUTTON
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: FlatButton.icon(
                                    disabledColor: Colors.white,
                                    icon: Icon(
                                      Icons.cancel,
                                      color: cart.isEmpty()
                                          ? Colors.grey
                                          : Colors.red,
                                    ),
                                    onPressed: cart.isEmpty()
                                        ? null
                                        : () => {
                                              cart.removeAll(),
                                              Navigator.pop(context, false)
                                            },
                                    color: Colors.white,
                                    padding: EdgeInsets.only(
                                        left: 30.0,
                                        right: 30,
                                        bottom: 20,
                                        top: 20),
                                    label: Text(
                                      "Empty Cart",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: cart.isEmpty()
                                              ? Colors.grey
                                              : Colors.red,
                                          fontFamily: 'Lato'),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: cart.isEmpty()
                                            ? Colors.grey
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  )..show()
                },
              ),
            ),
          ),
        ],
      ),

      // builds main homepage with cards
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(http.Client()),
        builder: (context, snapshot) {
          // in case of error while calling api, print the error
          if (snapshot.hasError) print(snapshot.error);

          // defining number of axis, it will be useful later
          int noaxis;

          int Function() axisCount = () {
            if (MediaQuery.of(context).orientation == Orientation.landscape) {
              return 4;
            } else {
              return 2;
            }
          };

          noaxis = axisCount();

          // in case of no error
          if (snapshot.hasData) {
            products = snapshot.data;

            // build cards
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // mandatory: without them, we would not be able to
                // proper visualize elements on screen
                crossAxisCount: noaxis,
                childAspectRatio: noaxis == 2 ? 0.4 : 0.999, // ratio 4 mobiles
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),

                  // let's build our card!
                  child: Card(
                    elevation: 10,
                    child: InkWell(
                      onTap: () {},
                      child: FlipCard(
                        front: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // defining card product title
                              Expanded(
                                flex: 0,
                                child: AutoSizeText(
                                  products[index].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  maxLines: 2,
                                  minFontSize: 10,
                                  maxFontSize: 22,
                                ),
                              ),

                              // defining card product category
                              Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 3, bottom: 16.0),
                                  child: Text(
                                    capitalize(products[index].category),
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 18,
                                        color: Colors.grey[800]),
                                  ),
                                ),
                              ),

                              // defining card product image
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  child: Container(
                                      height: 100,
                                      child: Image.network(
                                          products[index].thumbnailUrl)),
                                ),
                              ),

                              // defining card product cost
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 16),
                                child: AutoSizeText(
                                  products[index].price.toStringAsFixed(2) +
                                      " €",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                              ),

                              // Button "add to cart"
                              RaisedButton.icon(
                                focusColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)),
                                color: Colors.white,
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.black,
                                ),
                                label: Padding(
                                  padding: EdgeInsets.only(bottom: 20, top: 20),
                                  child: AutoSizeText(
                                    btnAddText,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    minFontSize: 14,
                                    maxFontSize: 18,
                                  ),
                                ),
                                onPressed: () => {
                                  // if cart already contains that product, dont
                                  // add it and show a proper modal window
                                  // else, add to cart that product and
                                  // show the modal window
                                  if (!cart.cart.containsKey(products[index]))
                                    {
                                      cart.insert(products[index], 1),
                                      AwesomeDialog(
                                          context: context,
                                          animType: AnimType.BOTTOMSLIDE,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.SUCCES,
                                          title: 'Success',
                                          body: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: AutoSizeText(
                                                "Item has been added to your cart.",
                                                style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 20)),
                                          ),
                                          btnOkOnPress: () {},
                                          btnOkIcon: Icons.check_circle,
                                          onDissmissCallback: () {})
                                        ..show()
                                    }
                                  else
                                    {
                                      AwesomeDialog(
                                          context: context,
                                          animType: AnimType.BOTTOMSLIDE,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.ERROR,
                                          title: 'Failed',
                                          body: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: AutoSizeText(
                                                'Item has already been added to your cart!',
                                                style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 20)),
                                          ),
                                          btnCancelText: "Go back",
                                          btnCancelOnPress: () {},
                                          btnCancelIcon: Icons.arrow_back,
                                          onDissmissCallback: () {})
                                        ..show()
                                    },
                                },
                              )
                            ],
                          ),
                        ),

                        // show the description of the product
                        back: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                              child: AutoSizeText(
                            products[index].description,
                            style: TextStyle(fontFamily: 'Lato', fontSize: 20),
                          )),
                        ),
                        direction: FlipDirection.HORIZONTAL,
                        flipOnTouch: true,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            // while waiting show a circular progress indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
