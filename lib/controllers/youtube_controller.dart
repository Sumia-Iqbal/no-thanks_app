import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class YoutubeVideoController extends GetxController {
  var isLoading = false.obs;
  var videos = <Map<String, dynamic>>[].obs;
  var filteredVideos = <Map<String, dynamic>>[].obs; // filtered list for search
  var selectedLanguage = "English".obs;
  var nextPageTokenVideos = "".obs;

      final String apiKey = "AIzaSyCReAhUjopYH87yikSUXuRbK3l4MG7qrBo";
  final Map<String, String> channelsByLanguage = {
    "English": "UCNye-wNBqNL5ZzHSJj3l8Bg",
    "Arabic": "UCfiwzLy-8yKzIbsmZTzxDgw",
  };

  Future<void> fetchVideos({bool loadMore = false}) async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      final channelId = channelsByLanguage[selectedLanguage.value]!;
      var channelUrl =
          "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=$channelId&key=$apiKey";
      var channelRes = await http.get(Uri.parse(channelUrl));
      if (channelRes.statusCode != 200) return;

      var channelData = jsonDecode(channelRes.body);
      var uploadsPlaylistId =
      channelData['items'][0]['contentDetails']['relatedPlaylists']['uploads'];

      var url =
          "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$uploadsPlaylistId&maxResults=50&key=$apiKey";
      if (loadMore && nextPageTokenVideos.isNotEmpty) {
        url += "&pageToken=${nextPageTokenVideos.value}";
      }

      var response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return;

      var data = jsonDecode(response.body);
      nextPageTokenVideos.value = data['nextPageToken'] ?? "";

      var items = data['items'] as List;
      var newVideos = items.map((item) {
        var snippet = item['snippet'];
        return {
          "title": snippet['title'],
          "description": snippet['description'],
          "thumbnail": snippet['thumbnails']?['high']?['url'],
          "videoId": snippet['resourceId']?['videoId'],
          "channelTitle": snippet['channelTitle'],
          "publishedAt": snippet['publishedAt'],
        };
      }).toList();

      if (loadMore) {
        videos.addAll(newVideos);
      } else {
        videos.value = newVideos;
      }

      _updateFilteredVideos(); // always update filtered list
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFilteredVideos() {
    filteredVideos.value = List.from(videos);
  }

  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    nextPageTokenVideos.value = "";
    fetchVideos();
  }

  void searchVideos(String query) {
    if (query.isEmpty) {
      filteredVideos.value = List.from(videos); // search cancelled
    } else {
      filteredVideos.value = videos.where((video) {
        final title = video["title"]?.toLowerCase() ?? "";
        final description = video["description"]?.toLowerCase() ?? "";
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery) || description.contains(searchQuery);
      }).toList();
    }
  }
}
