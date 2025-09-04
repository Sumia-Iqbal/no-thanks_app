import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/scan_model.dart';

class ScanController extends GetxController {
  RxString scanResult = ''.obs;
  var isLoading = false.obs;
  var results = <ScanModel>[].obs;

  Future<void> fetchApi(String barcode) async {
    try {
      isLoading.value = true;
      results.clear();

      // Scanner result ko clean karlo
      final cleanBarcode = barcode.trim();

      // ✅ Correct URL (sir ke example jaisa)
      var baseUrl = "https://boycotts.vercel.app/$cleanBarcode";
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        results.value = [ScanModel.fromJson(result)];
      } else {
        log("Something went wrong: ${response.statusCode}");
        Get.snackbar("Error", "Something went wrong: ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
