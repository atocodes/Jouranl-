import 'package:flutter/material.dart';
import 'package:journal/data/models/journal_entry.dart';

class JournalMetaSection extends StatefulWidget {
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
  State<JournalMetaSection> createState() => _JournalMetaSectionState();
}

class _JournalMetaSectionState extends State<JournalMetaSection> {
  bool _isExpand = false;

  void _expandSummary() {
    setState(() {
      _isExpand = !_isExpand;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// --- Posted / Summary ---
        if (widget.journal.isPosted ||
            (widget.journal.summary?.isNotEmpty ?? false)) ...[
          Text(
            "Posted Version",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _expandSummary,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                width: double.infinity,
                height: _isExpand ? MediaQuery.of(context).size.height * .2 : null,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row (makes it intuitive)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Summary",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Icon(
                            _isExpand
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                  
                      // Spacing
                      if (_isExpand) const SizedBox(height: 8),
                  
                      // Animated content
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _isExpand
                            ? Text(
                                widget.journal.summary ?? "",
                                key: const ValueKey("expanded"),
                                style: theme.textTheme.bodyMedium,
                              )
                            : Text(
                                "Tap to view summary",
                                key: const ValueKey("collapsed"),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.7),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        /// --- Tags ---
        TextFormField(
          controller: widget.tagsController,
          decoration: const InputDecoration(hintText: "Tags (comma separated)"),
        ),
        const SizedBox(height: 12),

        /// --- Mood ---
        Wrap(
          spacing: 8,
          children: ['Happy', 'Sad', 'Neutral', 'Angry'].map((mood) {
            final isSelected = mood == widget.journal.mood;
            return ChoiceChip(
              label: Text(mood),
              selected: isSelected,
              onSelected: (_) => widget.onMoodChanged(isSelected ? null : mood),
              selectedColor: theme.colorScheme.primaryContainer,
              backgroundColor: theme.colorScheme.surface,
            );
          }).toList(),
        ),
      ],
    );
  }
}
