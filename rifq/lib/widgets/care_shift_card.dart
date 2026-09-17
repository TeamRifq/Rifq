import 'package:flutter/material.dart';
import 'package:rifq/models/care_shift_model.dart';
import 'package:rifq/theme/app_colors.dart';

class CareShiftCard extends StatelessWidget {
  final CareShiftModel shift;
  final VoidCallback? onContactTap;

  const CareShiftCard({
    super.key,
    required this.shift,
    this.onContactTap,
  });

  IconData _getShiftIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('morning')) {
      return Icons.wb_sunny_rounded;
    } else if (lower.contains('afternoon')) {
      return Icons.wb_twilight_rounded;
    } else {
      return Icons.bedtime_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = shift.status == ShiftStatus.active;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: isActive ? 1.8 : 1.0,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    colorScheme.surfaceContainerLowest,
                    AppColors.primaryContainer.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : colorScheme.surfaceContainerLowest,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    shift.avatarInitials,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.caregiverName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              shift.caregiverRole,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                _buildStatusBadge(context, shift.status),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryContainer.withValues(alpha: 0.4)
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isActive
                      ? colorScheme.primary.withValues(alpha: 0.2)
                      : colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? colorScheme.primary.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getShiftIcon(shift.shiftTitle),
                      size: 18,
                      color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shift.shiftTitle,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${shift.startTime} – ${shift.endTime} • ${shift.duration}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onContactTap != null)
                    IconButton.filledTonal(
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                      tooltip: 'Message ${shift.caregiverName}',
                      onPressed: onContactTap,
                      style: IconButton.styleFrom(
                        backgroundColor: isActive
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHigh,
                        foregroundColor: isActive
                            ? colorScheme.onPrimary
                            : colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.checklist_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      shift.dutiesSummary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, ShiftStatus status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeBg;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case ShiftStatus.active:
        badgeBg = AppColors.primaryContainer;
        textColor = AppColors.onPrimaryContainer;
        label = 'Active Now';
        icon = Icons.fiber_manual_record_rounded;
        break;
      case ShiftStatus.upcoming:
        badgeBg = colorScheme.surfaceContainerHigh;
        textColor = colorScheme.onSurfaceVariant;
        label = 'Upcoming';
        icon = Icons.schedule_rounded;
        break;
      case ShiftStatus.completed:
        badgeBg = colorScheme.surfaceContainerLow;
        textColor = colorScheme.outline;
        label = 'Completed';
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: status == ShiftStatus.active ? 8 : 12,
            color: textColor,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
