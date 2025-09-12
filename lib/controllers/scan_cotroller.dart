import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/scan_model.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
    fetchCompanies();
  }
  RxString scanResult = ''.obs;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var page = 0.obs;
  final int limit = 20;
  var results = <ScanModel>[].obs;
  var baseUrl = "https://boycotts.vercel.app";

  // RxLists
  var categories = <Map<String, dynamic>>[].obs;
  var allProducts = <Map<String, dynamic>>[].obs;
  var companies = <Map<String, dynamic>>[].obs;

  Future<void> fetchApi(String barcode) async {
    try {
      isLoading.value = true;
      results.clear();

      final cleanBarcode = barcode.trim();
      var response = await http.get(Uri.parse("$baseUrl/$cleanBarcode"));

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

  Future<void> fetchProducts({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        page.value = 0;
        hasMore.value = true;
        allProducts.clear();
      }

      if (!hasMore.value) return;

      isLoading.value = true;
      var response = await http.get(
        Uri.parse("$baseUrl/products/all?index=${page.value * limit}&limit=$limit"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;

        if (data.isEmpty) {
          hasMore.value = false; // 🚫 No more products
        } else {
          allProducts.addAll(List<Map<String, dynamic>>.from(data));
          page.value++;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch products");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchProductsByCategory(var categoryId) async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/products/all?category_id=$categoryId"),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        allProducts.value = List<Map<String, dynamic>>.from(data);
      } else {
        log("Failed to load products");
        Get.snackbar("Error", "Failed to fetch products");
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> fetchCategories() async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/categories/all"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        categories.value = List<Map<String, dynamic>>.from(data);
      } else {
        log("Failed to load categories");
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", e.toString());
    }
  }
  Future<void> fetchCompanies() async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/companies/all"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        companies.value = List<Map<String, dynamic>>.from(data);
      } else {
        log("Failed to load companies");
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", e.toString());
    }
  }
  Future<void> fetchCompaniesByCategory(var categoryId) async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/companies/all?category_id=$categoryId"),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        companies.value = List<Map<String, dynamic>>.from(data);
      } else {
        log("Failed to load companies");
        Get.snackbar("Error", "Failed to fetch companies");
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", e.toString());
    }
  }

}
