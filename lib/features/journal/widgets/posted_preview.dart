import 'package:flutter/material.dart';

class PostedPreviewSection extends StatelessWidget {
  final String? summary;

  const PostedPreviewSection({super.key, this.summary});

  @override
  Widget build(BuildContext context) {
    if (summary == null || summary!.isEmpty) {
      return const SizedBox();
    }

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Posted Version", style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(summary!, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
