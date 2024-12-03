
class PlayerModel {
  String id;
  String name;
  String email;
  String gender;
  String sport;
  String team;
  String photo;

  PlayerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.sport,
    required this.team,
    required this.photo,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    String email = (json['email']??"").toLowerCase();
    String team = json['team']??"";
    String collegeFolder = team.split(" ")[1].toLowerCase();
    String photoUrl = "https://firebasestorage.googleapis.com/v0/b/iism2024.appspot.com/o/studentPhotos%2F$collegeFolder%2F$email.jpg?alt=media";

    return PlayerModel(
        id: (json['id']??0).toString(),
        name: json['name']??"",
        email: email,
        gender: json['gender']??"",
        sport: json['sport']??"",
        team: json['team']??"",
        photo: photoUrl
    );
  }
}