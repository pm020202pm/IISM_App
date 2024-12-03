class ParticipantModel {
  String id;
  String name;
  String email;
  String gender;
  String sport;
  String team;
  String id_generation;
  String hall_name;

  ParticipantModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.sport,
    required this.team,
    required this.id_generation,
    required this.hall_name
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    String email = (json['email']??"");
    String team = json['team']??"";
    String collegeFolder = team.split(" ")[1].toLowerCase();
    String qrUrl = "https://firebasestorage.googleapis.com/v0/b/iism2024.appspot.com/o/QR%2F$collegeFolder%2F${email}_qrcode.png?alt=media";


    return ParticipantModel(
      id: (json['id']??0).toString(),
      name: json['name']??"",
      email: json['email']??"",
      gender: json['gender']??"",
      sport: json['sport']??"",
      team: json['team']??"",
      id_generation: qrUrl,
      hall_name: (json['hall_name']??0).toString()
    );
  }
}