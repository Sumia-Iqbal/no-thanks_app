import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_thanks/controllers/youtube_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../helpers/colors.dart';

class UpdatesScreen extends StatelessWidget {
  final YoutubeVideoController controller = Get.put(YoutubeVideoController());

  UpdatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.videos.isEmpty && !controller.isLoading.value) {
        controller.fetchVideos();
      }
    });

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("News Updates")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Image.network("https://play-lh.googleusercontent.com/1pvYY4tIk0u0ZPkqp-zMRHXekDNq793b5TNxFO0ZUMe2ML87G6moZrvfiVWFWteEUirC",),),
            ListTile(
              title: Text("English"),
              onTap: () {
                controller.changeLanguage("English");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Arabic"),
              onTap: () {
                controller.changeLanguage("Arabic");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:EdgeInsets.symmetric(horizontal:20),
            child: Container(
              padding:EdgeInsets.only(left:12),
              decoration:BoxDecoration(
                borderRadius:BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color:Colors.black.withOpacity(0.015)
                  )
                ]
              ),
              child:TextFormField(
                onChanged: (value){
                  controller.searchVideos(value);
                },

                decoration:InputDecoration(
                  prefixIcon: Icon(Icons.search,color:thirdColor),
                  border:InputBorder.none,
                  hintText:"Search updates...",
                  hintStyle: TextStyle(
                    color:thirdColor
                  )
                )
              )
            ),
          ),
          SizedBox(height:15),
          Expanded(
            child: Obx(() {
              if (controller.videos.isEmpty && controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.videos.isEmpty) {
                return const Center(child: Text("No videos found"));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoading.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      controller.nextPageTokenVideos.isNotEmpty) {
                    controller.fetchVideos(loadMore: true);
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: controller.videos.length + 1, // extra for loader at bottom
                  itemBuilder: (context, index) {
                    if (index == controller.videos.length) {
                      return controller.isLoading.value
                          ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : const SizedBox.shrink();
                    }

                    final video = controller.videos[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.3,
                            width: width,
                            child: Image.network(video["thumbnail"], fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Text(
                                  video["title"],
                                  style: GoogleFonts.lato(
                                      fontSize: 24,
                                      color: thirdColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    video["publishedAt"],
                                    style: GoogleFonts.lato(color: Colors.black45),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
