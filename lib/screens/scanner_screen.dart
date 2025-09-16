import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:no_thanks/screens/companies_screen.dart';
import 'package:no_thanks/screens/products_screen.dart';
import 'package:no_thanks/screens/scan_screen.dart';
import 'package:no_thanks/screens/show_results.dart';
import 'package:no_thanks/screens/updates_screen.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../controllers/scan_cotroller.dart';
import '../helpers/colors.dart';

class ScannerScreen extends StatelessWidget {
  final RxString scanResults = "".obs;
  ScanController scanController = Get.put(ScanController());
  RxInt selectedIndex = 0.obs;

  List pages = [
    ProductsScreen(),
    CompaniesScreen(),
    UpdatesScreen(),
    ScanScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
            () => ConvexAppBar(
          backgroundColor: Colors.white,
          color: Colors.black54,
          activeColor: kPrimary,
          style: TabStyle.reactCircle,
          items: const [
            TabItem(icon: Icons.list, title: "List"),
            TabItem(icon: Icons.support_agent, title: "Support"),
            TabItem(icon: Icons.info_outline, title: "About"),
            TabItem(icon: Icons.qr_code_scanner, title: "Scan"), // 👈 new scan item
            TabItem(icon: Icons.storefront, title: "Store"),
          ],
          initialActiveIndex: selectedIndex.value,
          onTap: (int i) async {
            if (i == 3) {
              await scanBarCode(context);
            } else {
              selectedIndex.value = i;
            }
          },
        ),
      ),

      body: Obx(() {
        return pages[selectedIndex.value];
      }),
    );
  }

  Future<void> scanBarCode(context) async {
    try {
      String? res = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Scan Product',
          centerTitle: true,
          enableBackButton: true,
          backButtonIcon: Icon(Icons.arrow_back_ios),
        ),
        isShowFlashIcon: true,
        delayMillis: 2000,
        cameraFace: CameraFace.back,
      );

      if (res != null && res != "-1") {
        scanResults.value = res;
        await scanController.fetchApi(scanResults.value);
        Get.to(() => const ShowResults());
      }
    } on PlatformException {
      scanResults.value = "Failed to scan results";
    }
  }
}
