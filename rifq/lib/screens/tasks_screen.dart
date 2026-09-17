import 'package:flutter/material.dart';
import 'package:rifq/models/pill_model.dart';
import 'package:rifq/models/visit_model.dart';
import 'package:rifq/screens/add_pill_screen.dart';
import 'package:rifq/screens/add_visit_screen.dart';
import 'package:rifq/services/pill_service.dart';
import 'package:rifq/services/visit_service.dart';
import 'package:rifq/theme/app_colors.dart';
import 'package:rifq/widgets/pill_widget.dart';
import 'package:rifq/widgets/visit_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'all';
  final PillService _pillService = PillService();
  final VisitService _visitService = VisitService();
  final Set<PillModel> _takenPills = <PillModel>{};
  final Set<VisitModel> _handledVisits = <VisitModel>{};

  void _onMarkAsTaken(PillModel pill) {
    setState(() {
      _takenPills.add(pill);
    });
  }

  void _onMarkAsHandled(VisitModel visit) {
    setState(() {
      _handledVisits.add(visit);
    });
  }

  void _openAddPillDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddPillScreen(
        pillService: _pillService,
        isDialog: true,
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  void _openAddVisitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddVisitScreen(
        visitService: _visitService,
        isDialog: true,
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final pills = _pillService.getPills();
    final visits = _visitService.getVisits();

    final takenCount = pills.where((p) => p.isTaken || _takenPills.contains(p)).length;
    final handledCount = visits.where((v) => v.isHandled || _handledVisits.contains(v)).length;
    final totalTasks = pills.length + visits.length;
    final completedTasks = takenCount + handledCount;
    final progress = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily Care Tasks'),
            Text(
              'Medication & Doctor Appointments',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surfaceContainerLowest,
                    AppColors.primaryContainer.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Care Progress',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$completedTasks of $totalTasks items confirmed today',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMiniBadge(
                        context,
                        icon: Icons.medication_rounded,
                        label: '$takenCount/${pills.length} Pills',
                        color: AppColors.categoryMedication,
                      ),
                      const SizedBox(width: 10),
                      _buildMiniBadge(
                        context,
                        icon: Icons.calendar_today_rounded,
                        label: '$handledCount/${visits.length} Visits',
                        color: AppColors.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              selected: {_selectedFilter},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedFilter = newSelection.first;
                });
              },
              segments: const [
                ButtonSegment(
                  value: 'all',
                  label: Text('All'),
                  icon: Icon(Icons.list),
                ),
                ButtonSegment(
                  value: 'pills',
                  label: Text('Pills'),
                  icon: Icon(Icons.medication),
                ),
                ButtonSegment(
                  value: 'visits',
                  label: Text('Visits'),
                  icon: Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (_selectedFilter == 'all' || _selectedFilter == 'pills') ...[
            if (_selectedFilter == 'all')
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
                child: Text(
                  'Prescribed Medications (${pills.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ...pills.map(
              (pill) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PillWidget(
                  pillName: pill.pillName,
                  dosage: pill.dosage,
                  tablets: pill.tablets,
                  time: pill.time,
                  isTaken: pill.isTaken || _takenPills.contains(pill),
                  markedByName: pill.markedByName,
                  onMarkAsTaken: () => _onMarkAsTaken(pill),
                ),
              ),
            ),
          ],

          if (_selectedFilter == 'all' || _selectedFilter == 'visits') ...[
            if (_selectedFilter == 'all')
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
                child: Text(
                  'Scheduled Doctor Visits (${visits.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ...visits.map(
              (visit) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: VisitWidget(
                  visitName: visit.visitName,
                  doctorName: visit.doctorName,
                  day: visit.day,
                  month: visit.month,
                  time: visit.time,
                  isHandled: visit.isHandled || _handledVisits.contains(visit),
                  markedByName: visit.markedByName,
                  onMarkAsHandled: () => _onMarkAsHandled(visit),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Text(
                        'Add to Daily Care',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      tileColor: colorScheme.surfaceContainerLow,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.categoryMedication.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.medication,
                          color: AppColors.categoryMedication,
                        ),
                      ),
                      title: const Text('Add Pill', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Add a new prescribed pill'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context).pop();
                        _openAddPillDialog();
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      tileColor: colorScheme.surfaceContainerLow,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AppColors.tertiary,
                        ),
                      ),
                      title: const Text('Add Visit', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Add a new scheduled visit'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context).pop();
                        _openAddVisitDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildMiniBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
