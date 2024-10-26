class ParticipantModel {
  String id;
  String name;
  String email;
  String gender;
  String sport;
  String team;
  String id_generation;
  String contact;
  String hall_name;
  String photo;

  ParticipantModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.sport,
    required this.team,
    required this.id_generation,
    required this.contact,
    required this.hall_name,
    required this.photo,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    print("json['id'].runtimeType");
    print(json['id'].runtimeType);
    print("json['hall_name'].runtimeType");
    print(json['hall_name'].runtimeType);
    return ParticipantModel(
      id: (json['id']??0).toString(),
      name: json['name']??"",
      email: json['email']??"",
      gender: json['gender']??"",
      sport: json['sport']??"",
      team: json['team']??"",
      id_generation: json['id_generation']??"",
      contact: json['contact']??"",
      hall_name: (json['hall_name']??0).toString(),
      photo: json['photo']??""
    );
  }
}