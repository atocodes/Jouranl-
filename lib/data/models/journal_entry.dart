import 'package:objectbox/objectbox.dart';

@Entity()
class JournalEntity {
  @Id()
  int id = 0;
  String title;
  String content;
  String? summary;
  List<String>? tags;
  String? mood;
  bool isPosted;
  @Property(type: PropertyType.date)
  DateTime createdAt;

  JournalEntity({
    this.id = 0,
    required this.title,
    required this.content,
    this.summary,
    this.tags,
    this.mood,
    this.isPosted = false,
    required this.createdAt,
  });
}
