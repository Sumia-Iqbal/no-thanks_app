import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../controllers/scan_cotroller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
          return const Center(child: Text("No results found"));
        }

        final product = scanController.results.first;

        final bool isBoycott = product.message == "Boycott this brand";

        return Container(
          color: isBoycott ? const Color(0xFFFF5A5A) : const Color(0xFF3AAE51),
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // White card container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top Text
                        if (isBoycott)
                          Text(
                            'NO! THANKS',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF5A5A),
                              letterSpacing: 2,
                              height: 1,
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF3AAE51),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),

                        const SizedBox(height: 15),

                        // Middle text under header
                        if (isBoycott)
                          Text(
                            'This product is on the boycott list!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF5A5A),
                            ),
                          )
                        else
                          Column(
                            children: [
                              Text(
                                'This product is good for now!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                product.productName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '---------',
                                style: TextStyle(
                                  fontSize: 22,
                                  letterSpacing: 4,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Enter the name of the product or brand you are trying to scan',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: Colors.black45),
                                ),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Type a brand name...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                        if (isBoycott) ...[
                          const SizedBox(height: 30),

                          // Brand and Company logos with ↔ icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  product.productImageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 40, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '↔',
                                style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  product.companyImageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 40, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Boycott markdown proof text
                          SizedBox(
                            height: 180,
                            child: SingleChildScrollView(
                              child: MarkdownBody(
                                data: product.companyProof,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Open proof button
                          ElevatedButton.icon(
                            onPressed: () async {
                              final url = product.companyProofUrl;
                              if (url.isNotEmpty) {
                                final uri = Uri.parse(url);
                                if (!await launchUrl(uri,
                                    mode: LaunchMode.externalApplication)) {
                                  // handle error if needed
                                }
                              }
                            },
                            icon: const Icon(Icons.open_in_new, color: Colors.black),
                            label: const Text(
                              'Open proof',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              shape: const StadiumBorder(),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Bottom text and social icons
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your voice is powerful!\nYour share could help more\npeople make an ethical choice',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Social icons - please add your icon assets accordingly
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     IconButton(
                      //       icon: Image.asset('assets/icons/whatsapp.png'),
                      //       iconSize: 30,
                      //       onPressed: () {},
                      //     ),
                      //     const SizedBox(width: 10),
                      //     IconButton(
                      //       icon: Image.asset('assets/icons/x.png'),
                      //       iconSize: 30,
                      //       onPressed: () {},
                      //     ),
                      //     const SizedBox(width: 10),
                      //     IconButton(
                      //       icon: Image.asset('assets/icons/instagram.png'),
                      //       iconSize: 30,
                      //       onPressed: () {},
                      //     ),
                      //     const SizedBox(width: 10),
                      //     IconButton(
                      //       icon: Image.asset('assets/icons/linkedin.png'),
                      //       iconSize: 30,
                      //       onPressed: () {},
                      //     ),
                      //     const SizedBox(width: 10),
                      //     IconButton(
                      //       icon: Image.asset('assets/icons/facebook.png'),
                      //       iconSize: 30,
                      //       onPressed: () {},
                      //     ),
                      //     const SizedBox(width: 10),
                      //     IconButton(
                      //       icon: Image.asset('assets/icons/link.png'),
                      //       iconSize: 30,
                      //       onPressed: () {},
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
