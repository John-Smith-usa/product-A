class PromptModel {
  final String id;
  final String title;
  final String content;
  final String description;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String version;
  final List<String> tags;
  final PromptStatus status;
  final ModelConfig modelConfig;
  final List<PromptExecution> executionHistory;
  final int likes;
  final int forks;
  final String? parentId;

  const PromptModel({
    required this.id,
    required this.title,
    required this.content,
    required this.description,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.tags,
    required this.status,
    required this.modelConfig,
    required this.executionHistory,
    this.likes = 0,
    this.forks = 0,
    this.parentId,
  });

  PromptModel copyWith({
    String? id,
    String? title,
    String? content,
    String? description,
    String? author,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? version,
    List<String>? tags,
    PromptStatus? status,
    ModelConfig? modelConfig,
    List<PromptExecution>? executionHistory,
    int? likes,
    int? forks,
    String? parentId,
  }) {
    return PromptModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      description: description ?? this.description,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      modelConfig: modelConfig ?? this.modelConfig,
      executionHistory: executionHistory ?? this.executionHistory,
      likes: likes ?? this.likes,
      forks: forks ?? this.forks,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PromptModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum PromptStatus { draft, published, archived, testing }

class ModelConfig {
  final String modelName;
  final double temperature;
  final int maxTokens;
  final double topP;
  final double presencePenalty;
  final double frequencyPenalty;

  const ModelConfig({
    required this.modelName,
    required this.temperature,
    required this.maxTokens,
    required this.topP,
    required this.presencePenalty,
    required this.frequencyPenalty,
  });
}

class PromptExecution {
  final String id;
  final String promptId;
  final String input;
  final String output;
  final DateTime executedAt;
  final Duration executionTime;
  final ModelConfig modelConfig;
  final double? rating;
  final String? feedback;

  const PromptExecution({
    required this.id,
    required this.promptId,
    required this.input,
    required this.output,
    required this.executedAt,
    required this.executionTime,
    required this.modelConfig,
    this.rating,
    this.feedback,
  });
}

class PromptVersion {
  final String id;
  final String promptId;
  final String version;
  final String content;
  final String commitMessage;
  final String author;
  final DateTime createdAt;
  final String? parentVersionId;
  final List<String> changedFiles;

  const PromptVersion({
    required this.id,
    required this.promptId,
    required this.version,
    required this.content,
    required this.commitMessage,
    required this.author,
    required this.createdAt,
    this.parentVersionId,
    required this.changedFiles,
  });
}

class ABTest {
  final String id;
  final String name;
  final String description;
  final List<String> promptIds;
  final DateTime startDate;
  final DateTime? endDate;
  final ABTestStatus status;
  final Map<String, ABTestResult> results;
  final double progress; // 0.0 to 1.0
  final int totalParticipants;
  final double variantASuccessRate; // 0.0 to 1.0
  final double variantBSuccessRate; // 0.0 to 1.0
  final double variantAAvgResponseTime; // in seconds
  final double variantBAvgResponseTime; // in seconds

  const ABTest({
    required this.id,
    required this.name,
    required this.description,
    required this.promptIds,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.results,
    required this.progress,
    required this.totalParticipants,
    required this.variantASuccessRate,
    required this.variantBSuccessRate,
    required this.variantAAvgResponseTime,
    required this.variantBAvgResponseTime,
  });
}

enum ABTestStatus { draft, running, completed, paused, cancelled }

class ABTestResult {
  final String promptId;
  final int executionCount;
  final double averageRating;
  final Duration averageExecutionTime;
  final double successRate;

  const ABTestResult({
    required this.promptId,
    required this.executionCount,
    required this.averageRating,
    required this.averageExecutionTime,
    required this.successRate,
  });
} 