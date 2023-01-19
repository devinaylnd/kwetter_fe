// ignore: file_names
class TweetModel {
  late int id;
  late String? description;
  late int idUser;
  late String? username;
  late String? name;
  late int totalLike;
  late String? dateTime;
  late String? userPic;

  TweetModel({
    this.id = 0,
    this.description,
    this.idUser = 0,
    this.username,
    this.name,
    this.totalLike = 0,
    this.dateTime,
    this.userPic,
  });
}
