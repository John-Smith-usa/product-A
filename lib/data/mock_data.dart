import '../models/prompt_model.dart';

class MockData {
  static List<PromptModel> get samplePrompts => [
    PromptModel(
      id: '1',
      title: 'Customer Service Chatbot',
      content: '''You are a helpful customer service assistant. Your role is to:
1. Greet customers warmly and professionally
2. Listen to their concerns and questions
3. Provide accurate and helpful information
4. Escalate complex issues to human agents when needed
5. Always maintain a positive and empathetic tone

When a customer contacts you, start by asking how you can help them today.''',
      description: 'A comprehensive prompt for customer service chatbot interactions with clear guidelines and escalation procedures.',
      author: 'Sarah Johnson',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      version: 'v1.2.0',
      tags: ['customer-service', 'chatbot', 'support'],
      status: PromptStatus.published,
      modelConfig: const ModelConfig(
        modelName: 'gpt-4',
        temperature: 0.7,
        maxTokens: 1000,
        topP: 0.9,
        presencePenalty: 0.0,
        frequencyPenalty: 0.0,
      ),
      executionHistory: [
        PromptExecution(
          id: 'ex1',
          promptId: '1',
          input: 'Hello, I need help with my order',
          output: 'Hello! I\'d be happy to help you with your order. Could you please provide me with your order number so I can look up the details for you?',
          executedAt: DateTime.now().subtract(const Duration(hours: 2)),
          executionTime: const Duration(milliseconds: 1200),
          modelConfig: const ModelConfig(
            modelName: 'gpt-4',
            temperature: 0.7,
            maxTokens: 1000,
            topP: 0.9,
            presencePenalty: 0.0,
            frequencyPenalty: 0.0,
          ),
          rating: 4.5,
          feedback: 'Very helpful and professional response',
        ),
      ],
      likes: 45,
      forks: 12,
    ),
    PromptModel(
      id: '2',
      title: 'Technical Documentation Writer',
      content: '''You are a technical documentation specialist. Your task is to:
1. Write clear, concise, and comprehensive documentation
2. Use proper formatting and structure
3. Include code examples where appropriate
4. Explain complex concepts in simple terms
5. Ensure accuracy and consistency

Focus on creating documentation that is accessible to both beginners and experienced developers.''',
      description: 'Specialized prompt for generating high-quality technical documentation with proper structure and examples.',
      author: 'Mike Chen',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      version: 'v2.1.0',
      tags: ['documentation', 'technical-writing', 'developer-tools'],
      status: PromptStatus.published,
      modelConfig: const ModelConfig(
        modelName: 'gpt-4',
        temperature: 0.3,
        maxTokens: 2000,
        topP: 0.8,
        presencePenalty: 0.1,
        frequencyPenalty: 0.1,
      ),
      executionHistory: [],
      likes: 73,
      forks: 28,
    ),
    PromptModel(
      id: '3',
      title: 'Code Review Assistant',
      content: '''You are a senior software engineer conducting code reviews. Your responsibilities include:
1. Analyzing code for bugs, security issues, and performance problems
2. Checking adherence to coding standards and best practices
3. Suggesting improvements and optimizations
4. Providing constructive feedback
5. Highlighting both positive aspects and areas for improvement

Be thorough but constructive in your reviews.''',
      description: 'Comprehensive code review assistant that provides detailed feedback on code quality, security, and best practices.',
      author: 'Alex Rodriguez',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      version: 'v1.0.0',
      tags: ['code-review', 'development', 'quality-assurance'],
      status: PromptStatus.testing,
      modelConfig: const ModelConfig(
        modelName: 'gpt-4',
        temperature: 0.2,
        maxTokens: 1500,
        topP: 0.7,
        presencePenalty: 0.0,
        frequencyPenalty: 0.0,
      ),
      executionHistory: [],
      likes: 31,
      forks: 8,
    ),
    PromptModel(
      id: '4',
      title: 'Creative Writing Assistant',
      content: '''You are a creative writing mentor helping authors develop their stories. Your role is to:
1. Provide inspiration and creative ideas
2. Help with plot development and character creation
3. Suggest improvements to narrative structure
4. Offer feedback on writing style and voice
5. Encourage creativity while maintaining quality

Help writers unlock their creative potential.''',
      description: 'A creative writing assistant that helps authors develop compelling stories and improve their writing craft.',
      author: 'Emma Thompson',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      version: 'v1.5.0',
      tags: ['creative-writing', 'storytelling', 'content-creation'],
      status: PromptStatus.draft,
      modelConfig: const ModelConfig(
        modelName: 'gpt-4',
        temperature: 0.9,
        maxTokens: 1200,
        topP: 0.95,
        presencePenalty: 0.2,
        frequencyPenalty: 0.2,
      ),
      executionHistory: [],
      likes: 18,
      forks: 5,
    ),
    PromptModel(
      id: '5',
      title: 'Data Analysis Helper',
      content: '''You are a data analysis expert helping users interpret and analyze data. Your tasks include:
1. Explaining statistical concepts clearly
2. Suggesting appropriate analysis methods
3. Interpreting results and findings
4. Identifying patterns and trends
5. Recommending data visualization approaches

Make complex data insights accessible to non-technical users.''',
      description: 'Expert data analysis assistant that helps users understand and interpret complex data sets and statistical results.',
      author: 'David Kim',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      updatedAt: DateTime.now().subtract(const Duration(days: 8)),
      version: 'v3.0.0',
      tags: ['data-analysis', 'statistics', 'visualization'],
      status: PromptStatus.published,
      modelConfig: const ModelConfig(
        modelName: 'gpt-4',
        temperature: 0.4,
        maxTokens: 1800,
        topP: 0.8,
        presencePenalty: 0.0,
        frequencyPenalty: 0.0,
      ),
      executionHistory: [],
      likes: 92,
      forks: 34,
    ),
  ];

  static List<PromptVersion> get sampleVersions => [
    PromptVersion(
      id: 'v1',
      promptId: '1',
      version: 'v1.2.0',
      content: 'Updated customer service prompt with better escalation procedures',
      commitMessage: 'Add escalation procedures and improve greeting',
      author: 'Sarah Johnson',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      parentVersionId: 'v2',
      changedFiles: ['prompt.txt', 'config.json'],
    ),
    PromptVersion(
      id: 'v2',
      promptId: '1',
      version: 'v1.1.0',
      content: 'Added empathy guidelines to customer service prompt',
      commitMessage: 'Enhance empathy in customer interactions',
      author: 'Sarah Johnson',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      parentVersionId: 'v3',
      changedFiles: ['prompt.txt'],
    ),
    PromptVersion(
      id: 'v3',
      promptId: '1',
      version: 'v1.0.0',
      content: 'Initial customer service chatbot prompt',
      commitMessage: 'Initial commit: basic customer service prompt',
      author: 'Sarah Johnson',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      parentVersionId: null,
      changedFiles: ['prompt.txt', 'config.json', 'README.md'],
    ),
  ];

  static List<ABTest> get sampleABTests => [
    ABTest(
      id: 'ab1',
      name: 'Customer Service Tone Comparison',
      description: 'Testing formal vs casual tone in customer service interactions',
      promptIds: ['1', '2'],
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().subtract(const Duration(days: 1)),
      status: ABTestStatus.completed,
      progress: 1.0,
      totalParticipants: 298,
      variantASuccessRate: 0.85,
      variantBSuccessRate: 0.78,
      variantAAvgResponseTime: 1.2,
      variantBAvgResponseTime: 1.1,
      results: {
        '1': const ABTestResult(
          promptId: '1',
          executionCount: 150,
          averageRating: 4.2,
          averageExecutionTime: Duration(milliseconds: 1200),
          successRate: 0.85,
        ),
        '2': const ABTestResult(
          promptId: '2',
          executionCount: 148,
          averageRating: 3.8,
          averageExecutionTime: Duration(milliseconds: 1100),
          successRate: 0.78,
        ),
      },
    ),
    ABTest(
      id: 'ab2',
      name: 'Technical Documentation Clarity',
      description: 'Comparing different approaches to technical explanation',
      promptIds: ['2', '3'],
      startDate: DateTime.now().subtract(const Duration(days: 3)),
      endDate: null,
      status: ABTestStatus.running,
      progress: 0.67,
      totalParticipants: 87,
      variantASuccessRate: 0.82,
      variantBSuccessRate: 0.79,
      variantAAvgResponseTime: 1.8,
      variantBAvgResponseTime: 1.65,
      results: {
        '2': const ABTestResult(
          promptId: '2',
          executionCount: 45,
          averageRating: 4.1,
          averageExecutionTime: Duration(milliseconds: 1800),
          successRate: 0.82,
        ),
        '3': const ABTestResult(
          promptId: '3',
          executionCount: 42,
          averageRating: 3.9,
          averageExecutionTime: Duration(milliseconds: 1650),
          successRate: 0.79,
        ),
      },
    ),
    ABTest(
      id: 'ab3',
      name: 'Creative Writing Style Test',
      description: 'Comparing descriptive vs dialogue-heavy writing styles',
      promptIds: ['4', '5'],
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: null,
      status: ABTestStatus.paused,
      progress: 0.25,
      totalParticipants: 32,
      variantASuccessRate: 0.75,
      variantBSuccessRate: 0.81,
      variantAAvgResponseTime: 2.1,
      variantBAvgResponseTime: 1.9,
      results: {
        '4': const ABTestResult(
          promptId: '4',
          executionCount: 16,
          averageRating: 3.9,
          averageExecutionTime: Duration(milliseconds: 2100),
          successRate: 0.75,
        ),
        '5': const ABTestResult(
          promptId: '5',
          executionCount: 16,
          averageRating: 4.1,
          averageExecutionTime: Duration(milliseconds: 1900),
          successRate: 0.81,
        ),
      },
    ),
  ];

  static List<String> get popularTags => [
    'customer-service',
    'technical-writing',
    'code-review',
    'creative-writing',
    'data-analysis',
    'chatbot',
    'documentation',
    'development',
    'content-creation',
    'analytics',
    'support',
    'quality-assurance',
    'storytelling',
    'statistics',
    'automation',
  ];

  static List<String> get recentActivity => [
    'Sarah Johnson updated Customer Service Chatbot to v1.2.0',
    'Mike Chen forked Technical Documentation Writer',
    'Alex Rodriguez started A/B test for Code Review Assistant',
    'Emma Thompson created new Creative Writing Assistant prompt',
    'David Kim published Data Analysis Helper v3.0.0',
    'Sarah Johnson received 5 new likes on Customer Service Chatbot',
    'Mike Chen added new tags to Technical Documentation Writer',
    'Alex Rodriguez completed code review for 3 prompts',
  ];
} 