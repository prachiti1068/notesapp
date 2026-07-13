class Note {
  String id;
  String title;
  String description;

  Note({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      title: map['title'],
      description: map['description'],
    );
  }
}