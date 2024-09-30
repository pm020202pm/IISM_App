class ParticipantModel {
  String id;
  String name;
  String email;
  String gender;
  String photo;
  String sport;
  String team;
  String id_generation;
  String contact;
  String hall_name;

  ParticipantModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.photo,
    required this.sport,
    required this.team,
    required this.id_generation,
    required this.contact,
    required this.hall_name,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: (json['id']??'0').toString(),
      name: json['name']??"",
      email: json['email']??"",
      gender: json['gender']??"",
      photo: json['photo']??"",
      sport: json['sport']??"",
      team: json['team']??"",
      id_generation: json['id_generation']??"",
      contact: json['contact']??"",
      hall_name: json['hall_name']??"",
    );
  }
}