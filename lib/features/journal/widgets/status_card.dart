import "package:flutter/material.dart";

class StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isActive;

  final VoidCallback? onTap;
  final VoidCallback? onRetry;

  const StatusCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isActive = false,
    this.onTap,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    Widget card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: colors.primary),
          ),

          const SizedBox(width: 6),

          // Text
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: text.labelSmall),
              Text(
                value,
                style: text.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(width: 6),

          // Retry (only when inactive)
          if (!isActive && onRetry != null)
            GestureDetector(
              onTap: onRetry,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.refresh,
                  size: 14,
                  color: colors.primary,
                ),
              ),
            ),

          const SizedBox(width: 4),

          // Status dot
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? colors.primary
                  : colors.error.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}