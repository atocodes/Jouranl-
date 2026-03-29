import 'package:journal/data/models/journal_entry.dart';

String formatTelegramPost(JournalEntity j) {
  final tags = j.tags?.map((e) => '#$e').join(" ") ?? "";

  return """
${j.summary ?? ''}

$tags
""";
}
