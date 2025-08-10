enum ProjectStatus { active, onHold, completed, archived }

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final String ownerId;
  final List<String> memberIds;
  final List<String> taskIds;
  final String? color; // Hex color for project identification

  const ProjectModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    required this.ownerId,
    this.memberIds = const [],
    this.taskIds = const [],
    this.color,
  });

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    String? ownerId,
    List<String>? memberIds,
    List<String>? taskIds,
    String? color,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      ownerId: ownerId ?? this.ownerId,
      memberIds: memberIds ?? this.memberIds,
      taskIds: taskIds ?? this.taskIds,
      color: color ?? this.color,
    );
  }

  double getCompletionPercentage(List<String> completedTaskIds) {
    if (taskIds.isEmpty) return 0.0;
    final completedCount = taskIds.where((id) => completedTaskIds.contains(id)).length;
    return completedCount / taskIds.length;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 