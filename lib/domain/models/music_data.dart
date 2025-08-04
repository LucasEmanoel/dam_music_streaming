class MusicData {
  int? id;
  String apiId;
  String title;
  String artist;
  String album;
  String coverUrl;
  String localPath;

  MusicData({
    this.id,
    required this.apiId,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.localPath,
  });
}