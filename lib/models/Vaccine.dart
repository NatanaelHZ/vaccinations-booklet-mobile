class Vaccine {
  final int id;
  final String title;

  Vaccine({ 
    this.id,
    this.title
  });

  Map<String,dynamic> toMap(){
    return <String,dynamic> {
      "id": id,
      "title": title
    };
  }
}