import 'package:flutter/material.dart';
import '../controllers/scan_cotroller.dart';
import 'package:get/get.dart';
class ShowResults extends StatelessWidget {
  const ShowResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScanController scanController = Get.put(ScanController());
    return Scaffold(
      body: Obx(() {
        if (scanController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (scanController.results.isEmpty) {
          return const Text("No results found");
        }

        final product = scanController.results.first;
        String? imageUrl = product.companyImage != null
            ? "https://boycotts.vercel.app/images/${product.companyImage}"
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 200, right: 200, top: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrHcX9aiOf0VplaixRhlkFyBS4QdzA47JhMg&s",
                    height: 200,
                    width: 200,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            SizedBox(height:20),
            Center(
              child: Container(
                width:double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(children:[
                          product.message == "Boycott this brand"
                              ? Text(
                            "Stop✋🏻 don't use this product",
                            style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                          )
                              : Text("You can use this product"),
                          Text("${product.message}"),
                        ]),
                      ),
                          SizedBox(height:10),

                          Row(
                            children: [
                              Text("Reason:",
                              style:TextStyle(
                                fontSize:20,
                                fontWeight:FontWeight.bold
                              )),
                              SizedBox(width:10),
                              Text("${product.reason}",
                                  style:TextStyle(fontSize:15,
                                      fontWeight:FontWeight.w600
                                  )
                              ),

                            ],
                          ),
                      SizedBox(height:10),

                      Row(
                        children: [

                          Text("Product:",
                              style:TextStyle(
                                  fontSize:20,
                                  fontWeight:FontWeight.bold
                              )),                              SizedBox(width:10),

                          Text("${product.productName}",
                          style:TextStyle(fontSize:15,
                          fontWeight:FontWeight.w600
                          )
                          ),
                        ],
                      ),
                      SizedBox(height:10),


                      Row(
                        children: [
                          Text("Company:",
                              style:TextStyle(
                                  fontSize:20,
                                  fontWeight:FontWeight.bold
                              )),                              SizedBox(width:10),

                          Text("${product.companyName}",
                          style:TextStyle(
                            fontSize:15,
                            fontWeight:FontWeight.w600
                          )
                          ),
                        ],
                      ),
                      SizedBox(height:10),
                      Row(
                        children: [

                          Text("Proof:",
                              style:TextStyle(
                                  fontSize:20,
                                  fontWeight:FontWeight.bold
                              )),                              SizedBox(width:10),

                          Text("${product.proofUrl}",
                              style:TextStyle(fontSize:15,
                                  fontWeight:FontWeight.w600
                              )

                          ),
                        ],
                      ),
                      SizedBox(height:10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
