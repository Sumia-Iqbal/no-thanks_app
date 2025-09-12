import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsDetail extends StatelessWidget {
  final Map<String, dynamic> data;

  ProductsDetail({required this.data});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String markdownText =
        """

# 🛒 **${data["name"]}**


## 📌 Proof of Boycott  
${_highlightNames(data["proof"])}""";

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),

              child: Column(
                children: [
                  Image.network(
                    data["image_url"],
                    fit: BoxFit.cover,
                    width: width,
                    height: height * 0.3,
                  ),
                ],
              ),
            ),
            Container(
              width: width,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  "⚠ Bycott this product",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name in Markdown box
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: MarkdownBody(
                          data:
                              "# 🛒 **${data["name"]}**\n\n## 📌 Proof of Boycott",
                          styleSheet: MarkdownStyleSheet(
                            h1: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Proof text separate red box
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: MarkdownBody(
                          data: _highlightNames(data["proof"]),
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            strong: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            launchUrl(Uri.parse(data["proof_url"]));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.link, color: Colors.blueGrey),
                                SizedBox(width: 8),
                                Text(
                                  "Open Proof Link",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.open_in_new,
                                  size: 18,
                                  color: Colors.blueGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _highlightNames(String text) {
    final names = ["Nestle", "CocaCola", "Pepsi"];
    for (var name in names) {
      text = text.replaceAll(name, "**$name**");
    }
    return text;
  }
}
