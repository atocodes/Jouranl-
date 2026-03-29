import "package:flutter/material.dart";

class GuideCard extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String steps;
  final String buttonText;
  final VoidCallback onPressed;

  const GuideCard(
    this.theme, {
    super.key,
    required this.title,
    required this.steps,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(steps, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.open_in_new),
            label: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
