class Vaccine {
  final int id;
  final String title;
  // final DateTime scheduledAt;

  Vaccine({ 
    this.id,
    this.title, 
    // this.scheduledAt,
  });

  Map<String,dynamic> toMap(){
    return <String,dynamic> {
      "id": id,
      "title": title,
      // "scheduledAt": scheduledAt,
    };
  }
}