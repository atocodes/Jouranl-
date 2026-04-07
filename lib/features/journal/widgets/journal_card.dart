import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/data/models/journal_entry.dart';
import 'package:journal/features/journal/bloc/journal_bloc.dart';
import 'package:journal/features/journal/bloc/journal_event.dart';
import 'package:journal/features/journal/view/journal_editor_page.dart';

class JournalCard extends StatelessWidget {
  final JournalEntity journal;

  const JournalCard({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine status text
    String statusText;
    if (journal.isPosted) {
      statusText = "Posted";
    } else if (journal.summary != null && journal.summary!.isNotEmpty) {
      statusText = "Summarized";
    } else {
      statusText = "Draft";
    }

    // Status color
    Color statusColor;
    switch (statusText) {
      case "Posted":
        statusColor = theme.colorScheme.primary;
        break;
      case "Summarized":
        statusColor = theme.colorScheme.secondary;
        break;
      default:
        statusColor = theme.colorScheme.surfaceVariant;
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MinimalJournalEditorPage(journal: journal),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            /// --- Main content ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12), // spacing for status chip
                /// --- Title ---
                Text(
                  journal.title.isEmpty ? "Untitled" : journal.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // --- Date Time ---
                Text(
                  journal.createdAt.toLocal().toString().split(' ').first,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),

                /// --- Content / Summary Preview ---
                Text(
                  journal.isPosted
                      ? journal.summary ?? journal.content
                      : journal.content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),

            /// --- Status chip (top-right) ---
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// --- Delete Button (top-right below status) ---
            Positioned(
              top: 28,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                onPressed: () => _showDeleteDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Journal'),
        content: const Text(
          'Are you sure you want to delete this journal entry?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<JournalBloc>().add(RemoveJournal(journal));
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
