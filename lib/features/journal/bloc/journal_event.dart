import 'package:journal/data/models/journal_entry.dart';

abstract class JournalEvent {}

class CreateJournal extends JournalEvent {
  final String title;
  final String content;

  CreateJournal(this.title, this.content);
}

class GetJournals extends JournalEvent {}

class RemoveJournal extends JournalEvent {
  JournalEntity journal;
  RemoveJournal(this.journal);
}

class UpdateJournal extends JournalEvent {
  JournalEntity journal;
  UpdateJournal(this.journal);
}

class SummarizeAndPost extends JournalEvent {
  JournalEntity journal;
  SummarizeAndPost(this.journal);
}
