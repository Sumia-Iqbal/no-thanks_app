import 'package:flutter/material.dart';
import '../controllers/scan_cotroller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowResults extends StatelessWidget {
  const ShowResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScanController scanController = Get.put(ScanController());
    return Scaffold(
      backgroundColor: Colors.red,
      body: Obx(() {
        if (scanController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (scanController.results.isEmpty) {
          return const Text("No results found");
        }

        final product = scanController.results.first;


        return
          Padding(
            padding:EdgeInsets.symmetric(horizontal:30,vertical:40),
            child: Container(
              padding:EdgeInsets.all(30),
              decoration:BoxDecoration(color:Colors.white,
              borderRadius:BorderRadius.only(topLeft:Radius.circular(15),topRight:Radius.circular(15))
              ),
              child: SingleChildScrollView(
                child: Column(
                children: [
                
                  Text(product.message =="Boycott this brand"?"Bycott this\n    Brand!":product.message,
                  style:TextStyle(color:product.message=="Boycott this brand"?Colors.red:Colors.green,fontSize:35,
                  fontWeight:FontWeight.bold
                  )
                  ),
                  SizedBox(height:10),
                  Text(product.reason=="Match found in boycott list"?"Match found in bycotte\nlist of products":product.reason,
                      style:TextStyle(
                          color:Colors.red,
                        fontSize:18,
                        fontWeight:FontWeight.bold
                      )
                  ),
                  SizedBox(height:20),
                  Text(product.productName,
                      style:TextStyle(
                          color:Colors.black,
                        fontSize:20,
                        fontWeight:FontWeight.bold
                      )
                  ),
                  SizedBox(height:10),Text(product.companyproof,
                  style:TextStyle(
                    color:Colors.black
                  )
                  ),
                  SizedBox(height:20),
                  ElevatedButton.icon(onPressed: () { _launchUrl(product.proofUrl) ;},label: Text("Open Proof",
                  style:TextStyle(color:Colors.black)
                  ),
                  )
                
                
                
                ],
                        ),
              ),
            ),
          );
      }),
    );
  }
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // 👈 Opens in external browser/app
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
