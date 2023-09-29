import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskproject/home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Screen'),
        leading: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          child: Icon(Icons.arrow_back)),
      ),
      backgroundColor: const Color(0xff5CDB95),
      bottomSheet: Container(
        height: 50,
        padding: EdgeInsets.only(bottom: 10),
        color: const Color(0xff5CDB95),
        child: SizedBox(
          width: 100,
          child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff05386B)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100))),
                            fixedSize: MaterialStateProperty.all(
                                const Size(50, 50))),
                        onPressed: () async {
                         
                        },
                        child: const Text(
                          'Buy',
                          style: TextStyle(color: Colors.white),
                        )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cartItem')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(); // Loading indicator while data is loading
                  }
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final data =
                            documents[index].data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            SizedBox(
                              height: 110,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(
                                              '${data['itemimage']}')),
                                      Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                data['itemname'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Price',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                  ),),
                                                  Text(
                                                      '₹${int.parse(data['itemprice']) * int.parse(data['itemquantity'])}',
                                                      style: TextStyle(
                                                    color: Colors.white
                                                  ),)
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Quantity',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                  )),
                                                  Text(
                                                    '${data['itemquantity']}',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
