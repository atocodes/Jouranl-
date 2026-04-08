import 'package:flutter/material.dart';

class JournalFormSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;

  const JournalFormSection({
    super.key,
    required this.titleController,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TextFormField(
          controller: titleController,
          style: theme.textTheme.titleMedium,
          decoration: const InputDecoration(
            hintText: "Title",
            fillColor: Colors.transparent,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Required" : null,
        ),

        Divider(color: theme.dividerColor),

        Expanded(
          child: TextFormField(
            controller: contentController,
            maxLines: null,
            expands: true,
            style: theme.textTheme.bodyMedium,
            decoration: const InputDecoration(
              hintText: "Start writing your journal...",
              border: InputBorder.none,
              fillColor: Colors.transparent,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
          ),
        ),
      ],
    );
  }
}
