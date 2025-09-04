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
      body: Container(
        decoration:BoxDecoration(
          image:DecorationImage(image: AssetImage("assets/images/How to spot products made in Israel_ barcode 729.jpeg"))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(icon:Icon(Icons.camera),style:ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white,),onPressed:  () {
        scanBarCode(context);
            },

             label: Text("scan Barcode")),
            SizedBox(height: 20),
            // Show scan results reactively
            Obx(() => Text(
              "Result: ${scanResults.value}",
              style: TextStyle(fontSize: 18),
            )),
          ],
        ),
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
        cameraFace: CameraFace.front,
      );

      if (res != null && res != "-1") { // -1 scanner cancel hone ka result hota hai
        scanResults.value = res;
        await scanController.fetchApi(scanResults.value);
        Get.to(() => const ShowResults());  // ✅ navigate properly
      }
    } on PlatformException {
      scanResults.value = "Failed to scan results";
    }
  }
  }
