// ignore: file_names
class UserModel {
  late int id;
  late String? email;
  late String? username;
  late String? name;
  late String? bio;
  late String? location;
  late String? userPic;
  late String? createdAt;

  UserModel(
      {this.id = 0,
      this.username,
      this.name,
      this.bio,
      this.location,
      this.userPic,
      this.createdAt});
}
