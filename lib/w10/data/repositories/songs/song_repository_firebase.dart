import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final String baseUrl =
      'w9-database-bbd01-default-rtdb.asia-southeast1.firebasedatabase.app';

  @override
  Future<void> likeSong(Song song) async {
    final Uri songUri = Uri.https(baseUrl, '/songs/${song.id}.json');

    final likeSong = Song(
      id: song.id,
      title: song.title,
      artistId: song.artistId,
      duration: song.duration,
      imageUrl: song.imageUrl,
      likes: song.likes + 1,
    );

    final response = await http.put(
      songUri,
      body: json.encode(SongDto.toJson(likeSong)),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to like song");
    }
  }

  @override
  Future<List<Song>> fetchSongs() async {
    final Uri songsUri = Uri.https(baseUrl, '/songs.json');

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];

      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }

      return result;
    } else {  
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }
  @override
  Future<Song?> fetchSongById(String id) async {}
}
