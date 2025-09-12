import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_thanks/screens/products_detail.dart';
import 'package:ready_made_extensions/ready_made_extensions.dart';
import '../controllers/scan_cotroller.dart';


class ProductsScreen extends StatelessWidget {
  ProductsScreen({Key? key}) : super(key: key);

  final ScanController scanController =
      Get.find<ScanController>(); // ✅ use same instance
  final RxInt selectedIndex = 0.obs;
  final ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        scanController.fetchProducts();
      }
    });
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 30),
            // Categories
            SizedBox(
              height: 40,
              child: Obx(() {
                if (scanController.categories.isEmpty) {
                  return Center(child: Text("No categories found"));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: scanController.categories.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return index == 0
                          ? GestureDetector(
                              onTap: () {
                                selectedIndex.value = index;
                                scanController.fetchProducts();
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: selectedIndex.value == index
                                      ? Colors.red.withOpacity(0.3)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: selectedIndex.value == index
                                        ? Colors.transparent
                                        : Colors.black,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "All",
                                    style: TextStyle(
                                      color: selectedIndex.value == index
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                selectedIndex.value = index;
                                scanController.fetchProductsByCategory(scanController.categories[index]["id"]);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: selectedIndex.value == index
                                      ? Colors.red.withOpacity(0.3)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  // border: Border.all(
                                  //   color: selectedIndex.value == index
                                  //       ? Colors.transparent
                                  //       : Colors.grey,
                                  // ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: selectedIndex.value ==index?Colors.transparent:Colors.black.withOpacity(0.015),
                                      blurRadius: 10,
                                      spreadRadius: 10
                                    )
                                  ]
                                ),
                                child: Center(
                                  child: Text(
                                    scanController.categories[index]["name"],
                                    style: TextStyle(
                                      color: selectedIndex.value == index
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 20),

            // Products Grid
        Expanded(
          child: Obx(() {
            if (scanController.allProducts.isEmpty &&
                scanController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
              controller: scrollController,
              itemCount: scanController.allProducts.length +
                  (scanController.hasMore.value ? 1 : 0), // 👈 extra item for loader
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                if (index < scanController.allProducts.length) {
                  var product = scanController.allProducts[index];
                  // return Container(
                  //   decoration:BoxDecoration(
                  //     color:Colors.white,
                  //     borderRadius:BorderRadius.circular(16),
                  //
                  // ),
                  //   child:Column(children:[
                  //     Container(
                  //       child:Image.network(data[""])
                  //     )
                  //   ])
                  // );

                  return Column(
                    children: [
                      GestureDetector(
                        onTap:(){
                        context.push(ProductsDetail(data:product));
                        },
                        child: Container(
                          height: 140,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.network(
                            product["image_url"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:10),
                              Text(
                                product["name"],
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                      SizedBox(height:6),
                      Container(
                        padding:EdgeInsets.symmetric(horizontal:8,vertical:4),
                          decoration:BoxDecoration(
                            color:Colors.red.withOpacity(0.1),
                            borderRadius:BorderRadius.circular(16),
                          ),
                          child:Text(product["category"],

                          style:TextStyle(color:Colors.red))
                      )


                    ],
                  );
                } else {
                  // 👇 Loader at bottom while fetching more
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }),
        )],
        ),
      ),
    );
  }
}
