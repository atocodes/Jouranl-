import 'package:journal/data/local/objectbox.g.dart';
import 'package:journal/data/models/journal_entry.dart';

class JournalRepo {
  final Box<JournalEntity> box;

  JournalRepo(this.box);

  Future<void> save(JournalEntity journal) async {
    box.put(journal);
  }

  Future<void> update(JournalEntity journal) async {
    box.put(journal);
  }

  List<JournalEntity> getAll() {
    return box.getAll()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<JournalEntity?> getJournal(int id) async {
    return await box.getAsync(id);
  }

  void removeJournal(int id) async {
    box.remove(id);
  }

  Future<void> markPosted(int id) async {
    final journal = box.get(id);
    if (journal != null) {
      journal.isPosted = true;
      box.put(journal);
    }
  }
}
