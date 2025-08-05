class PlaylistData {
  int? id;
  String title;
  String urlCover;
  int? numSongs;
  String author;

  PlaylistData({
    this.id,
    required this.title,
    required this.urlCover,
    this.numSongs,
    required this.author
  });
}