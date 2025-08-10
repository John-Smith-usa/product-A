import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/task_model.dart';
import '../../../models/project_model.dart';
import '../../../models/user_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final UserModel currentUser = MockData.currentUser;
  late Map<String, int> stats;
  late List<TaskModel> recentTasks;
  late List<TaskModel> todayTasks;
  late List<TaskModel> overdueTasks;
  late List<ProjectModel> activeProjects;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    stats = MockData.getDashboardStats();
    recentTasks = MockData.getTasksForUser(currentUser.id)
        .where((task) => task.status != TaskStatus.completed)
        .take(5)
        .toList();
    todayTasks = MockData.getTasksDueToday();
    overdueTasks = MockData.getOverdueTasks();
    activeProjects = MockData.getActiveProjects().take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
            pinned: true,
            stretch: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing24,
                  AppTheme.spacing64,
                  AppTheme.spacing24,
                  AppTheme.spacing16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        // User Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor,
                            boxShadow: AppTheme.lightShadow,
                          ),
                          child: currentUser.avatarUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    currentUser.avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _buildInitialsAvatar(),
                                  ),
                                )
                              : _buildInitialsAvatar(),
                        ),
                        const Gap(AppTheme.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good ${_getGreeting()}',
                                style: AppTheme.footnote.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                currentUser.firstName,
                                style: AppTheme.title2.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notifications Button
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            boxShadow: AppTheme.lightShadow,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/notifications');
                            },
                            icon: Stack(
                              children: [
                                const Icon(LucideIcons.bell, size: 22),
                                if (MockData.getUnreadNotifications(currentUser.id).isNotEmpty)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.errorColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Dashboard Content
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Stats
                _buildQuickStats(),
                const Gap(AppTheme.spacing32),
                
                // Today's Tasks
                _buildTodaySection(),
                const Gap(AppTheme.spacing32),
                
                // Active Projects
                _buildActiveProjects(),
                const Gap(AppTheme.spacing32),
                
                // Recent Tasks
                _buildRecentTasks(),
                const Gap(AppTheme.spacing32),
                
                // Quick Actions
                _buildQuickActions(),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/task-create');
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Center(
      child: Text(
        currentUser.initials,
        style: AppTheme.headline.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppTheme.title3.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        const Gap(AppTheme.spacing16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Active Tasks',
                stats['activeTasks']!,
                LucideIcons.checkSquare,
                AppTheme.primaryColor,
              ),
            ),
            const Gap(AppTheme.spacing12),
            Expanded(
              child: _buildStatCard(
                'Completed',
                stats['completedTasks']!,
                LucideIcons.checkCircle,
                AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
        const Gap(AppTheme.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Projects',
                stats['activeProjects']!,
                LucideIcons.folder,
                AppTheme.warningColor,
              ),
            ),
            const Gap(AppTheme.spacing12),
            Expanded(
              child: _buildStatCard(
                'Overdue',
                stats['overdueTasks']!,
                LucideIcons.alertCircle,
                AppTheme.errorColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Text(
                value.toString(),
                style: AppTheme.title2.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(AppTheme.spacing8),
          Text(
            title,
            style: AppTheme.footnote.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Today',
              style: AppTheme.title3.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/tasks');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const Gap(AppTheme.spacing16),
        if (todayTasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.lightShadow,
            ),
            child: Column(
              children: [
                Icon(
                  LucideIcons.checkCircle,
                  color: AppTheme.secondaryColor,
                  size: 48,
                ),
                const Gap(AppTheme.spacing12),
                Text(
                  'All caught up for today!',
                  style: AppTheme.headline.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Gap(AppTheme.spacing4),
                Text(
                  'Great job! You have no tasks due today.',
                  style: AppTheme.footnote.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...todayTasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
                child: _buildTaskCard(task),
              )),
      ],
    );
  }

  Widget _buildActiveProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Active Projects',
              style: AppTheme.title3.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/projects');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const Gap(AppTheme.spacing16),
        ...activeProjects.map((project) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
              child: _buildProjectCard(project),
            )),
      ],
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    final projectTasks = MockData.getTasksForProject(project.id);
    final completedTasks = projectTasks.where((t) => t.status == TaskStatus.completed).toList();
    final progress = projectTasks.isEmpty ? 0.0 : completedTasks.length / projectTasks.length;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/project-detail', arguments: project.id);
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: AppTheme.lightShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(int.parse(project.color!.replaceFirst('#', '0xFF'))),
                    shape: BoxShape.circle,
                  ),
                ),
                const Gap(AppTheme.spacing8),
                Expanded(
                  child: Text(
                    project.name,
                    style: AppTheme.headline.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: AppTheme.footnote.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const Gap(AppTheme.spacing8),
            Text(
              project.description,
              style: AppTheme.footnote.copyWith(
                color: AppTheme.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(AppTheme.spacing12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(int.parse(project.color!.replaceFirst('#', '0xFF'))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Tasks',
              style: AppTheme.title3.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/tasks');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const Gap(AppTheme.spacing16),
        ...recentTasks.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
              child: _buildTaskCard(task),
            )),
      ],
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    final project = task.projectId != null ? MockData.getProjectById(task.projectId!) : null;
    final assignedUser = task.assignedUserId != null ? MockData.getUserById(task.assignedUserId!) : null;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/task-detail', arguments: task.id);
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: AppTheme.lightShadow,
          border: task.isOverdue
              ? Border.all(color: AppTheme.errorColor.withOpacity(0.3))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getPriorityColor(task.priority),
                      width: 2,
                    ),
                  ),
                  child: task.status == TaskStatus.completed
                      ? Icon(
                          LucideIcons.check,
                          size: 12,
                          color: _getPriorityColor(task.priority),
                        )
                      : null,
                ),
                const Gap(AppTheme.spacing12),
                Expanded(
                  child: Text(
                    task.title,
                    style: AppTheme.callout.copyWith(
                      color: AppTheme.textPrimary,
                      decoration: task.status == TaskStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                if (task.isOverdue)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing6,
                      vertical: AppTheme.spacing2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Text(
                      'Overdue',
                      style: AppTheme.caption2.copyWith(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            if (project != null || task.dueDate != null) ...[
              const Gap(AppTheme.spacing8),
              Row(
                children: [
                  if (project != null) ...[
                    Icon(
                      LucideIcons.folder,
                      size: 14,
                      color: AppTheme.textTertiary,
                    ),
                    const Gap(AppTheme.spacing4),
                    Text(
                      project.name,
                      style: AppTheme.caption1.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      const Gap(AppTheme.spacing8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppTheme.textTertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(AppTheme.spacing8),
                    ],
                  ],
                  if (task.dueDate != null) ...[
                    Icon(
                      LucideIcons.calendar,
                      size: 14,
                      color: AppTheme.textTertiary,
                    ),
                    const Gap(AppTheme.spacing4),
                    Text(
                      _formatDueDate(task.dueDate!),
                      style: AppTheme.caption1.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.title3.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        const Gap(AppTheme.spacing16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'New Task',
                LucideIcons.plus,
                AppTheme.primaryColor,
                () => Navigator.of(context).pushNamed('/task-create'),
              ),
            ),
            const Gap(AppTheme.spacing12),
            Expanded(
              child: _buildActionButton(
                'New Project',
                LucideIcons.folderPlus,
                AppTheme.warningColor,
                () => Navigator.of(context).pushNamed('/project-create'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const Gap(AppTheme.spacing8),
          Text(
            title,
            style: AppTheme.footnote.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppTheme.errorColor;
      case TaskPriority.medium:
        return AppTheme.warningColor;
      case TaskPriority.low:
        return AppTheme.secondaryColor;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    
    final difference = taskDate.difference(today).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference < 0) return '${-difference} days ago';
    
    return 'In $difference days';
  }
} 