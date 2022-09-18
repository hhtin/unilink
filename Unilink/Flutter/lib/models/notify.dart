class Notify {
  String id;
  String title;
  String content;
  bool isSeen;
  String date;
  Notify(
    String id,
    String title,
    String content,
    bool isSeen,
    String date,
  ) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.isSeen = isSeen;
    this.date = date;
  }
}
