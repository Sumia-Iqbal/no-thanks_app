import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:no_thanks/controllers/scan_cotroller.dart';
import 'package:no_thanks/helpers/colors.dart';
import 'package:ready_made_extensions/ready_made_extensions.dart';

import 'company_details.dart';

class CompaniesScreen extends StatelessWidget {
  ScanController scanController = Get.put(ScanController());
  RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 40),
            SizedBox(
              height: 40,
              child: Obx(() {
                if (scanController.categories.isEmpty) {
                  return Center(child: Text("No Categories found"));
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
                                scanController.fetchCompanies();
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: selectedIndex.value == index
                                      ? kSecondary
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    "All",
                                    style: TextStyle(
                                      color: selectedIndex.value == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                selectedIndex.value = index;
                                scanController.fetchCompaniesByCategory(scanController.categories[index]["id"]);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: selectedIndex.value == index
                                      ? kSecondary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    scanController.categories[index]["name"],
                                    style: TextStyle(
                                      color: selectedIndex.value == index
                                          ? Colors.white
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
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!scanController.isLoading.value &&
                      scanController.hasMore.value &&
                      scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    // ✅ Jab bottom pohanch jaye to aur data laao
                    if (selectedIndex.value == 0) {
                      scanController.fetchCompanies();
                    } else {
                      scanController.fetchCompaniesByCategory(
                        scanController.categories[selectedIndex.value]["id"],
                      );
                    }
                  }
                  return false;
                },
                child: Obx(() {
                  return ListView.builder(
                    itemCount: scanController.companies.length +
                        (scanController.hasMore.value ? 1 : 0), // loader ke liye +1
                    itemBuilder: (context, index) {
                      if (index == scanController.companies.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      var company = scanController.companies[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(CompanyDetails(company: company));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.015),
                                blurRadius: 10,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                company["image_url"],
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60,
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    company["name"],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: thirdColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      company["category"],
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

