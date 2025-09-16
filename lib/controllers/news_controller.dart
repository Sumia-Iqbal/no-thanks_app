import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class NewsController extends GetxController {
  var isLoading = false.obs;
  var aljazeeraNews = <Map<String, dynamic>>[].obs;
  var categories = <String>[].obs; // 🟢 Unique categories
  var selectedCategory = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchAljazeeraNews();
  }

  Future<void> fetchAljazeeraNews() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("https://www.aljazeera.com/xml/rss/all.xml"),
      );

      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final items = document.findAllElements("item");

        final newsList = items.map((node) {
          return {
            "title": node.getElement("title")?.text ?? "",
            "link": node.getElement("link")?.text ?? "",
            "description": node.getElement("description")?.text ?? "",
            "pubDate": node.getElement("pubDate")?.text ?? "",
            "category": node.getElement("category")?.text ?? "General",
          };
        }).toList();

        aljazeeraNews.value = newsList;

        // unique categories extract karo
        final cats = newsList.map((e) => e["category"] as String).toSet().toList();
        categories.value = ["All", ...cats]; // "All" first option
        selectedCategory.value = "All";
      } else {
        Get.snackbar("Error", "Failed to fetch Al Jazeera news");
      }
    } catch (e) {
      log("Error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredNews {
    if (selectedCategory.value == "All") {
      return aljazeeraNews;
    }
    return aljazeeraNews
        .where((item) => item["category"] == selectedCategory.value)
        .toList();
  }
}
