enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed, cancelled }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final String? projectId;
  final String? assignedUserId;
  final List<String> tags;
  final List<TaskComment> comments;
  final List<TaskAttachment> attachments;
  final String authorId;

  const TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.projectId,
    this.assignedUserId,
    this.tags = const [],
    this.comments = const [],
    this.attachments = const [],
    required this.authorId,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    String? projectId,
    String? assignedUserId,
    List<String>? tags,
    List<TaskComment>? comments,
    List<TaskAttachment>? attachments,
    String? authorId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      projectId: projectId ?? this.projectId,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      tags: tags ?? this.tags,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
      authorId: authorId ?? this.authorId,
    );
  }

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final today = DateTime.now();
    return dueDate!.year == today.year &&
           dueDate!.month == today.month &&
           dueDate!.day == today.day;
  }

  bool get isDueSoon {
    if (dueDate == null) return false;
    final daysDifference = dueDate!.difference(DateTime.now()).inDays;
    return daysDifference <= 3 && daysDifference >= 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class TaskComment {
  final String id;
  final String taskId;
  final String content;
  final String authorId;
  final DateTime createdAt;
  final List<String> mentionedUserIds;

  const TaskComment({
    required this.id,
    required this.taskId,
    required this.content,
    required this.authorId,
    required this.createdAt,
    this.mentionedUserIds = const [],
  });
}

class TaskAttachment {
  final String id;
  final String taskId;
  final String fileName;
  final String fileType;
  final int fileSize; // in bytes
  final String fileUrl;
  final DateTime uploadedAt;
  final String uploadedBy;

  const TaskAttachment({
    required this.id,
    required this.taskId,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.fileUrl,
    required this.uploadedAt,
    required this.uploadedBy,
  });

  String get fileSizeFormatted {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
} 