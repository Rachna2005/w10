import '../../../model/songs/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchSongs({bool fetch = false});
  Future<void> likeSong(Song song);

  Future<Song?> fetchSongById(String id);
}
