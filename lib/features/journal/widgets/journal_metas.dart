import 'package:flutter/material.dart';
import 'package:journal/data/models/journal_entry.dart';

class JournalMetaSection extends StatelessWidget {
  final JournalEntity journal;
  final Function(String?) onMoodChanged;
  final TextEditingController tagsController;

  const JournalMetaSection({
    super.key,
    required this.journal,
    required this.onMoodChanged,
    required this.tagsController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// --- Posted / Summary ---
        if (journal.isPosted || (journal.summary?.isNotEmpty ?? false)) ...[
          Text(
            "Posted Version",
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              journal.summary ?? journal.content,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
        ],

        /// --- Tags ---
        TextFormField(
          controller: tagsController,
          decoration: const InputDecoration(
            hintText: "Tags (comma separated)",
          ),
        ),
        const SizedBox(height: 12),

        /// --- Mood ---
        Wrap(
          spacing: 8,
          children: ['Happy', 'Sad', 'Neutral', 'Angry'].map((mood) {
            final isSelected = mood == journal.mood;
            return ChoiceChip(
              label: Text(mood),
              selected: isSelected,
              onSelected: (_) => onMoodChanged(isSelected ? null : mood),
              selectedColor: theme.colorScheme.primaryContainer,
              backgroundColor: theme.colorScheme.surface,
            );
          }).toList(),
        ),
      ],
    );
  }
}