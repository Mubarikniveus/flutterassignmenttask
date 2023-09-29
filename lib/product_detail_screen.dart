import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskproject/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String itemName, itemImage, itemprice;
  const ProductDetailScreen(
      {super.key,
      required this.itemName,
      required this.itemImage,
      required this.itemprice});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  void incrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity++;
        isOutofStock = true;
      });
    } else {
      setState(() {
        quantity++;
        isOutofStock = false;
      });
    }
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;

        if (quantity <= 2 && isOutofStock == true) {
          isOutofStock = false;
        }
      }
    });
  }

  bool isOutofStock = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5CDB95),
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(child: Image.network(widget.itemImage)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.itemName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Rs: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.itemprice,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Add Product Quantity',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                              onPressed: decrementQuantity,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                              onPressed: incrementQuantity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: isOutofStock,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Out of Stock',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff05386B)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100))),
                          fixedSize: MaterialStateProperty.all(
                              const Size(double.infinity, 50))),
                      onPressed: () async {
                        if (!isOutofStock) {
                          Map<String, dynamic> data = {
                            'itemname': widget.itemName,
                            'itemimage': widget.itemImage,
                            'itemquantity': quantity.toString(),
                            'itemprice': widget.itemprice
                          }; // Add the data to a Firestore collection (e.g., 'users')
                          await firestore.collection('cartItem').add(data);

                          if (quantity >= 2) {
                            QuerySnapshot querySnapshot =
                                await FirebaseFirestore.instance
                                    .collection('itemList')
                                    .where('itemname',
                                        isEqualTo: widget.itemName)
                                    .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              DocumentSnapshot documentSnapshot =
                                  querySnapshot.docs.first;
                              String documentID = documentSnapshot.id;

                              print('documentId--$documentID');

                              DocumentReference itemRef = FirebaseFirestore
                                  .instance
                                  .collection('itemList')
                                  .doc(documentID);

                              itemRef.update({
                                'itemstatus': 'Out of Stock',
                              }).then((_) {
                                print('Document updated successfully.');
                              }).catchError((error) {
                                print('Error updating document: $error');
                              });
                            }
                          }

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartScreen()));
                        }
                      },
                      child: const Text(
                        'Add To Cart',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
