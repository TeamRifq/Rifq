import 'package:flutter/material.dart';
import 'package:rifq/models/care_shift_model.dart';
import 'package:rifq/theme/app_colors.dart';
import 'package:rifq/widgets/care_shift_card.dart';
import 'package:rifq/widgets/shift_swap_dialog.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _fullWeekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _shortWeekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  late DateTime _selectedDate;
  late DateTime _weekStartDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _weekStartDate = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  void _previousWeek() {
    setState(() {
      _weekStartDate = _weekStartDate.subtract(const Duration(days: 7));
      _selectedDate = _weekStartDate;
    });
  }

  void _nextWeek() {
    setState(() {
      _weekStartDate = _weekStartDate.add(const Duration(days: 7));
      _selectedDate = _weekStartDate;
    });
  }

  void _jumpToToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() {
      _selectedDate = today;
      _weekStartDate = today.subtract(Duration(days: today.weekday - 1));
    });
  }

  List<CareShiftModel> _getShiftsForDate(DateTime date) {
    final today = DateTime.now();
    final isToday = _isSameDay(date, today);

    return [
      CareShiftModel(
        id: 'shift-morning-${date.day}',
        caregiverName: 'Sarah Johnson',
        caregiverRole: 'Daughter',
        shiftTitle: 'Morning Shift',
        startTime: '07:00 AM',
        endTime: '01:00 PM',
        duration: '6 hrs',
        dutiesSummary:
            'Breakfast, morning Lisinopril medication, blood pressure check & physical walk',
        status: isToday ? ShiftStatus.active : ShiftStatus.upcoming,
        avatarInitials: 'SJ',
        phoneNumber: '+1-555-0142',
      ),
      CareShiftModel(
        id: 'shift-afternoon-${date.day}',
        caregiverName: 'Mike Johnson',
        caregiverRole: 'Son',
        shiftTitle: 'Afternoon Shift',
        startTime: '01:00 PM',
        endTime: '07:00 PM',
        duration: '6 hrs',
        dutiesSummary:
            'Lunch, doctor appointment visit, blood sugar reading & garden relaxation',
        status: ShiftStatus.upcoming,
        avatarInitials: 'MJ',
        phoneNumber: '+1-555-0189',
      ),
      CareShiftModel(
        id: 'shift-night-${date.day}',
        caregiverName: 'Layla Johnson',
        caregiverRole: 'Granddaughter',
        shiftTitle: 'Night Shift',
        startTime: '07:00 PM',
        endTime: '07:00 AM',
        duration: '12 hrs',
        dutiesSummary:
            'Dinner, evening Atorvastatin medication, night routine & sleep monitoring',
        status: ShiftStatus.upcoming,
        avatarInitials: 'LJ',
        phoneNumber: '+1-555-0210',
      ),
    ];
  }

  Future<void> _openShiftSwapDialog() async {
    final result = await ShiftSwapDialog.show(context);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Swap request sent to ${result.swapWith}!',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    final isToday = _isSameDay(_selectedDate, now);
    final shifts = _getShiftsForDate(_selectedDate);

    final weekdayName = _fullWeekdays[_selectedDate.weekday - 1];
    final monthName = _months[_selectedDate.month - 1];
    final formattedDayTitle = isToday
        ? 'Today, $monthName ${_selectedDate.day}'
        : '$weekdayName, $monthName ${_selectedDate.day}';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Care Schedule'),
            Text(
              'Robert Johnson • Family Coverage',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          if (!isToday)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilledButton.tonalIcon(
                onPressed: _jumpToToday,
                icon: const Icon(Icons.today_rounded, size: 16),
                label: const Text('Today'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendarSection(context),

                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  formattedDayTitle,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (isToday) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Today',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: AppColors.onPrimaryContainer,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '3 Caregivers scheduled • 24h Coverage',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Covered',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  ...shifts.map((shift) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CareShiftCard(
                        shift: shift,
                        onContactTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Connecting to ${shift.caregiverName} (${shift.caregiverRole})...',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _openShiftSwapDialog,
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text(
                    'Request Shift Swap',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();

    final currentMonthYear =
        '${_months[_selectedDate.month - 1]} ${_selectedDate.year}';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      currentMonthYear,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton.filledTonal(
                      icon: const Icon(Icons.chevron_left_rounded, size: 20),
                      tooltip: 'Previous week',
                      onPressed: _previousWeek,
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.chevron_right_rounded, size: 20),
                      tooltip: 'Next week',
                      onPressed: _nextWeek,
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final dayDate = _weekStartDate.add(Duration(days: index));
                final isSelected = _isSameDay(dayDate, _selectedDate);
                final isCurrentRealToday = _isSameDay(dayDate, now);
                final shortWeekday = _shortWeekdays[dayDate.weekday - 1];

                return InkWell(
                  onTap: () => _selectDate(dayDate),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : (isCurrentRealToday
                              ? AppColors.primaryContainer.withValues(alpha: 0.45)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(16),
                      border: isCurrentRealToday && !isSelected
                          ? Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.7),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          shortWeekday,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : (isCurrentRealToday
                                    ? AppColors.primary
                                    : colorScheme.onSurfaceVariant),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${dayDate.day}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
