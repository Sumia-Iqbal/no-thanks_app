import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:no_thanks/screens/show_results.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../controllers/scan_cotroller.dart';

class ScannerScreen extends StatelessWidget {
  final RxString scanResults = "".obs;
  ScanController scanController = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👇 Floating Scan Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        elevation: 6,
        shape: CircleBorder(),
        onPressed: () {scanBarCode(context);

          },
        child: Icon(Icons.document_scanner, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 👇 Custom Bottom NavBar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // space for FAB
        notchMargin: 8.0,
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(Icons.list, "The List"),
              buildNavItem(Icons.support_agent, "Support"),
              SizedBox(width: 40), // gap for center FAB
              buildNavItem(Icons.info_outline, "About"),
              buildNavItem(Icons.storefront, "Store"),
            ],
          ),
        ),
      ),

      // 👇 Body
      body:  Column(
          children: [
            Image.asset(
                "assets/images/How to spot products made in Israel_ barcode 729.jpeg"),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Welcome to",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600)),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "No!\n",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Thanks",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                      Text("🖐", style: TextStyle(fontSize: 40))
                    ],
                  ),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Text("make Informed choices\nabout the products you buy",
                                style: TextStyle(
                                    color: Colors.white,
                                    )),
                                  
                          Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.share_sharp,
                                  color: Colors.green, size: 20))
                        ]),
                  ),
                ]),
              ),
            ),
          ],
        ),
     
    );
  }

  Future<void> scanBarCode(context) async {
    try {
      String? res = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Test',
          centerTitle: false,
          enableBackButton: true,
          backButtonIcon: Icon(Icons.arrow_back_ios),
        ),
        isShowFlashIcon: true,
        delayMillis: 2000,
        cameraFace: CameraFace.back,
      );

      if (res != null && res != "-1") {
        scanResults.value = res;
        await scanController.fetchApi(scanResults.value); // 👈 sirf yeh
        Get.to(() => const ShowResults()); // 👈 aur yeh
      }
    } on PlatformException {
      scanResults.value = "Failed to scan results";
    }
  }

  Widget buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black54),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
