import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;
  String title;
  String channelTitle;


   VideoPlayerScreen({Key? key, required this.videoId,required this.title,required this.channelTitle});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoPlayerControllerX());
    controller.initPlayer(videoId);

    return Scaffold(
      appBar: AppBar(title: const Text("Play Video")),
      body: Center(
        child: YoutubePlayerScaffold(
          controller: controller.youtubeController,
          builder: (context, player) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Player
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: player,
                ),

                const SizedBox(height: 16),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal:16.0),
                 child:
                 Column(
                             crossAxisAlignment: CrossAxisAlignment.start,

                             children:[
                   Text(title,

                   style:TextStyle(
                       fontSize:20,
                             fontWeight:FontWeight.w600
                             )



                             ),
                             SizedBox(height:10),
                             Row(children:[
                             CircleAvatar(radius:20),
                             SizedBox(width:10),

                             Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children:[
                             Text(channelTitle,

                             style:TextStyle(
                             fontSize:16,
                             )

                             ),
                             Text("2.7 million subscribers",

                             style:TextStyle(
                             color:Colors.black38
                             )

                             )
                             ]),
                             SizedBox(width:20),
                             Container(
                               padding:EdgeInsets.symmetric(vertical:6,horizontal:12),
                             decoration:BoxDecoration(
                             color:Colors.black,
                             borderRadius:BorderRadius.circular(16),

                             ),
                             child:Text("Subscribe",
                             style:TextStyle(
                             color:Colors.white,
                             fontSize:16,
                             fontWeight:FontWeight.bold,


                             ))
                             )

                             ],
                             )]
                             ),
               )]);
          },
        ),
      ),
    );
  }
}
