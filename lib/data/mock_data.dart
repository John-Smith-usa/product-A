import '../models/task_model.dart';
import '../models/project_model.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';

class MockData {
  // Mock Users
  static final List<UserModel> users = [
    UserModel(
      id: 'user_1',
      email: 'john.doe@example.com',
      firstName: 'John',
      lastName: 'Doe',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      role: UserRole.owner,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      preferences: const UserPreferences(
        darkMode: false,
        pushNotifications: true,
        emailNotifications: true,
        language: 'en',
        timeZone: 'America/New_York',
        showCompletedTasks: true,
      ),
    ),
    UserModel(
      id: 'user_2',
      email: 'sarah.johnson@example.com',
      firstName: 'Sarah',
      lastName: 'Johnson',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      role: UserRole.admin,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      lastLoginAt: DateTime.now().subtract(const Duration(minutes: 30)),
      preferences: const UserPreferences(
        darkMode: true,
        pushNotifications: true,
        emailNotifications: false,
        language: 'en',
        timeZone: 'America/Los_Angeles',
        showCompletedTasks: false,
      ),
    ),
    UserModel(
      id: 'user_3',
      email: 'mike.chen@example.com',
      firstName: 'Mike',
      lastName: 'Chen',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      role: UserRole.member,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 8)),
      preferences: const UserPreferences(),
    ),
    UserModel(
      id: 'user_4',
      email: 'emma.wilson@example.com',
      firstName: 'Emma',
      lastName: 'Wilson',
      role: UserRole.member,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
      preferences: const UserPreferences(
        darkMode: true,
        pushNotifications: false,
      ),
    ),
  ];

  // Mock Projects
  static final List<ProjectModel> projects = [
    ProjectModel(
      id: 'project_1',
      name: 'Mobile App Redesign',
      description: 'Complete redesign of the mobile application with improved user experience and modern UI components.',
      status: ProjectStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      ownerId: 'user_1',
      memberIds: ['user_1', 'user_2', 'user_3'],
      taskIds: ['task_1', 'task_2', 'task_3', 'task_4'],
      color: '#007AFF',
    ),
    ProjectModel(
      id: 'project_2',
      name: 'Backend API Development',
      description: 'Development of RESTful API endpoints for the new features and performance improvements.',
      status: ProjectStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      dueDate: DateTime.now().add(const Duration(days: 45)),
      ownerId: 'user_2',
      memberIds: ['user_2', 'user_3', 'user_4'],
      taskIds: ['task_5', 'task_6', 'task_7'],
      color: '#34C759',
    ),
    ProjectModel(
      id: 'project_3',
      name: 'Marketing Campaign Q1',
      description: 'Launch marketing campaign for the first quarter with focus on digital channels.',
      status: ProjectStatus.onHold,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 75)),
      ownerId: 'user_4',
      memberIds: ['user_4', 'user_1'],
      taskIds: ['task_8', 'task_9'],
      color: '#FF9500',
    ),
    ProjectModel(
      id: 'project_4',
      name: 'Website Migration',
      description: 'Migration of existing website to new hosting platform with improved performance.',
      status: ProjectStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ownerId: 'user_3',
      memberIds: ['user_3', 'user_2'],
      taskIds: ['task_10', 'task_11', 'task_12'],
      color: '#8E8E93',
    ),
  ];

  // Mock Tasks
  static final List<TaskModel> tasks = [
    TaskModel(
      id: 'task_1',
      title: 'Design new login screen',
      description: 'Create wireframes and mockups for the new login screen with social authentication options.',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      dueDate: DateTime.now().add(const Duration(days: 2)),
      projectId: 'project_1',
      assignedUserId: 'user_2',
      authorId: 'user_1',
      tags: ['design', 'ui/ux', 'authentication'],
      comments: [
        TaskComment(
          id: 'comment_1',
          taskId: 'task_1',
          content: 'I\'ve started working on the wireframes. Should be ready for review tomorrow.',
          authorId: 'user_2',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    ),
    TaskModel(
      id: 'task_2',
      title: 'Implement dark mode toggle',
      description: 'Add dark mode support throughout the application with smooth transitions.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      projectId: 'project_1',
      assignedUserId: 'user_3',
      authorId: 'user_1',
      tags: ['development', 'ui', 'feature'],
    ),
    TaskModel(
      id: 'task_3',
      title: 'User testing for navigation',
      description: 'Conduct user testing sessions to validate the new navigation structure.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().add(const Duration(days: 10)),
      projectId: 'project_1',
      assignedUserId: 'user_4',
      authorId: 'user_2',
      tags: ['testing', 'ux', 'research'],
    ),
    TaskModel(
      id: 'task_4',
      title: 'Update app icons',
      description: 'Create and implement new app icons for iOS and Android platforms.',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      projectId: 'project_1',
      assignedUserId: 'user_2',
      authorId: 'user_1',
      tags: ['design', 'icons', 'branding'],
    ),
    TaskModel(
      id: 'task_5',
      title: 'Authentication API endpoints',
      description: 'Develop secure authentication endpoints with JWT token support.',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
      projectId: 'project_2',
      assignedUserId: 'user_3',
      authorId: 'user_2',
      tags: ['backend', 'api', 'security', 'authentication'],
    ),
    TaskModel(
      id: 'task_6',
      title: 'Database optimization',
      description: 'Optimize database queries and add proper indexing for better performance.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      dueDate: DateTime.now().add(const Duration(days: 8)),
      projectId: 'project_2',
      assignedUserId: 'user_4',
      authorId: 'user_2',
      tags: ['database', 'performance', 'optimization'],
    ),
    TaskModel(
      id: 'task_7',
      title: 'API documentation',
      description: 'Create comprehensive API documentation with examples and best practices.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now().add(const Duration(days: 15)),
      projectId: 'project_2',
      assignedUserId: 'user_2',
      authorId: 'user_3',
      tags: ['documentation', 'api'],
    ),
    TaskModel(
      id: 'task_8',
      title: 'Social media content calendar',
      description: 'Plan and create content calendar for social media campaigns.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 20)),
      projectId: 'project_3',
      assignedUserId: 'user_4',
      authorId: 'user_4',
      tags: ['marketing', 'social-media', 'content'],
    ),
    TaskModel(
      id: 'task_9',
      title: 'Email marketing templates',
      description: 'Design responsive email templates for marketing campaigns.',
      priority: TaskPriority.low,
      status: TaskStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 25)),
      projectId: 'project_3',
      assignedUserId: 'user_1',
      authorId: 'user_4',
      tags: ['marketing', 'email', 'design'],
    ),
    TaskModel(
      id: 'task_10',
      title: 'Server setup and configuration',
      description: 'Set up and configure new server environment for website migration.',
      priority: TaskPriority.high,
      status: TaskStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      dueDate: DateTime.now().subtract(const Duration(days: 20)),
      projectId: 'project_4',
      assignedUserId: 'user_3',
      authorId: 'user_3',
      tags: ['infrastructure', 'server', 'migration'],
    ),
    TaskModel(
      id: 'task_11',
      title: 'Content migration script',
      description: 'Develop automated script to migrate existing content to new platform.',
      priority: TaskPriority.high,
      status: TaskStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now().subtract(const Duration(days: 12)),
      dueDate: DateTime.now().subtract(const Duration(days: 15)),
      projectId: 'project_4',
      assignedUserId: 'user_2',
      authorId: 'user_3',
      tags: ['migration', 'automation', 'content'],
    ),
    TaskModel(
      id: 'task_12',
      title: 'DNS and SSL setup',
      description: 'Configure DNS settings and SSL certificates for the new hosting environment.',
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 65)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      dueDate: DateTime.now().subtract(const Duration(days: 12)),
      projectId: 'project_4',
      assignedUserId: 'user_3',
      authorId: 'user_2',
      tags: ['infrastructure', 'dns', 'ssl', 'security'],
    ),
    // Personal tasks (no project)
    TaskModel(
      id: 'task_13',
      title: 'Review team performance',
      description: 'Conduct quarterly performance reviews for team members.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
      assignedUserId: 'user_1',
      authorId: 'user_1',
      tags: ['management', 'reviews', 'hr'],
    ),
    TaskModel(
      id: 'task_14',
      title: 'Prepare monthly report',
      description: 'Compile and prepare monthly progress report for stakeholders.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(hours: 6)), // Due today
      assignedUserId: 'user_1',
      authorId: 'user_1',
      tags: ['reporting', 'management'],
    ),
    TaskModel(
      id: 'task_15',
      title: 'Grocery shopping',
      description: 'Buy groceries for the week including vegetables, fruits, and dairy products.',
      priority: TaskPriority.low,
      status: TaskStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      dueDate: DateTime.now().add(const Duration(hours: 4)), // Due today
      assignedUserId: 'user_1',
      authorId: 'user_1',
      tags: ['personal', 'errands'],
    ),
  ];

  // Mock Notifications
  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_1',
      userId: 'user_1',
      type: NotificationType.taskDue,
      title: 'Task Due Soon',
      message: 'Your task "Prepare monthly report" is due in 6 hours.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      actionUrl: '/tasks/task_14',
      metadata: {'taskId': 'task_14'},
    ),
    NotificationModel(
      id: 'notif_2',
      userId: 'user_1',
      type: NotificationType.taskCommented,
      title: 'New Comment',
      message: 'Sarah Johnson commented on "Design new login screen".',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionUrl: '/tasks/task_1',
      metadata: {'taskId': 'task_1', 'commentId': 'comment_1'},
    ),
    NotificationModel(
      id: 'notif_3',
      userId: 'user_1',
      type: NotificationType.taskCompleted,
      title: 'Task Completed',
      message: 'Mike Chen completed "Server setup and configuration".',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: true,
      actionUrl: '/tasks/task_10',
      metadata: {'taskId': 'task_10'},
    ),
    NotificationModel(
      id: 'notif_4',
      userId: 'user_1',
      type: NotificationType.projectUpdate,
      title: 'Project Update',
      message: 'Mobile App Redesign project has been updated.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionUrl: '/projects/project_1',
      metadata: {'projectId': 'project_1'},
    ),
    NotificationModel(
      id: 'notif_5',
      userId: 'user_1',
      type: NotificationType.taskAssigned,
      title: 'New Task Assigned',
      message: 'You have been assigned to "Email marketing templates".',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      actionUrl: '/tasks/task_9',
      metadata: {'taskId': 'task_9'},
    ),
  ];

  // Current user (for authentication state)
  static UserModel get currentUser => users.first;

  // Helper methods
  static List<TaskModel> getTasksForProject(String projectId) {
    return tasks.where((task) => task.projectId == projectId).toList();
  }

  static List<TaskModel> getTasksForUser(String userId) {
    return tasks.where((task) => task.assignedUserId == userId).toList();
  }

  static List<TaskModel> getTasksDueToday() {
    return tasks.where((task) => task.isDueToday && task.status != TaskStatus.completed).toList();
  }

  static List<TaskModel> getOverdueTasks() {
    return tasks.where((task) => task.isOverdue).toList();
  }

  static List<TaskModel> getTasksDueSoon() {
    return tasks.where((task) => task.isDueSoon && task.status != TaskStatus.completed).toList();
  }

  static List<NotificationModel> getUnreadNotifications(String userId) {
    return notifications.where((notif) => notif.userId == userId && !notif.isRead).toList();
  }

  static UserModel? getUserById(String userId) {
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  static ProjectModel? getProjectById(String projectId) {
    try {
      return projects.firstWhere((project) => project.id == projectId);
    } catch (e) {
      return null;
    }
  }

  static TaskModel? getTaskById(String taskId) {
    try {
      return tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  static List<ProjectModel> getActiveProjects() {
    return projects.where((project) => project.status == ProjectStatus.active).toList();
  }

  static Map<String, int> getDashboardStats() {
    final activeTasks = tasks.where((task) => task.status != TaskStatus.completed && task.status != TaskStatus.cancelled).length;
    final completedTasks = tasks.where((task) => task.status == TaskStatus.completed).length;
    final activeProjects = projects.where((project) => project.status == ProjectStatus.active).length;
    final overdueTasks = getOverdueTasks().length;

    return {
      'activeTasks': activeTasks,
      'completedTasks': completedTasks,
      'activeProjects': activeProjects,
      'overdueTasks': overdueTasks,
    };
  }
} 