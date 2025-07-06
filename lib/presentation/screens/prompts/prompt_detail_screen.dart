import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/prompt_model.dart';

class PromptDetailScreen extends StatefulWidget {
  final String promptId;

  const PromptDetailScreen({
    super.key,
    required this.promptId,
  });

  @override
  State<PromptDetailScreen> createState() => _PromptDetailScreenState();
}

class _PromptDetailScreenState extends State<PromptDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  PromptModel? _prompt;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPrompt();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadPrompt() {
    _prompt = MockData.samplePrompts.firstWhere(
      (p) => p.id == widget.promptId,
      orElse: () => MockData.samplePrompts.first,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_prompt == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Tab Bar
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Execution History'),
                Tab(text: 'Configuration'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildExecutionHistoryTab(),
                _buildConfigurationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/prompts'),
                icon: const Icon(LucideIcons.arrowLeft),
              ),
              const Gap(AppTheme.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _prompt!.title,
                      style: AppTheme.title2.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(AppTheme.spacing4),
                    Text(
                      _prompt!.description,
                      style: AppTheme.subheadline.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    icon: Icon(
                      _isFavorite ? LucideIcons.heart : LucideIcons.heart,
                      color: _isFavorite ? AppTheme.errorColor : AppTheme.textTertiary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement fork
                    },
                    icon: const Icon(LucideIcons.gitFork),
                  ),
                  IconButton(
                    onPressed: () {
                      context.go('/prompts/${widget.promptId}/edit');
                    },
                    icon: const Icon(LucideIcons.edit),
                  ),
                  const Gap(AppTheme.spacing8),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/prompts/${widget.promptId}/versions');
                    },
                    icon: const Icon(LucideIcons.gitBranch),
                    label: const Text('Versions'),
                  ),
                ],
              ),
            ],
          ),
          const Gap(AppTheme.spacing16),
          
          // Status and metadata
          Row(
            children: [
              _buildStatusBadge(_prompt!.status),
              const Gap(AppTheme.spacing12),
              _buildVersionBadge(_prompt!.version),
              const Gap(AppTheme.spacing12),
              Row(
                children: [
                  const Icon(LucideIcons.user, size: 16, color: AppTheme.textTertiary),
                  const Gap(AppTheme.spacing4),
                  Text(
                    _prompt!.author,
                    style: AppTheme.caption1.copyWith(color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const Gap(AppTheme.spacing12),
              Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 16, color: AppTheme.textTertiary),
                  const Gap(AppTheme.spacing4),
                  Text(
                    DateFormat('MMM d, yyyy').format(_prompt!.updatedAt),
                    style: AppTheme.caption1.copyWith(color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(LucideIcons.heart, size: 16, color: AppTheme.errorColor),
                  const Gap(AppTheme.spacing4),
                  Text('${_prompt!.likes}'),
                  const Gap(AppTheme.spacing12),
                  const Icon(LucideIcons.gitFork, size: 16, color: AppTheme.textTertiary),
                  const Gap(AppTheme.spacing4),
                  Text('${_prompt!.forks}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt Content
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Prompt Content',
                        style: AppTheme.headline.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _prompt!.content));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied to clipboard')),
                          );
                        },
                        icon: const Icon(LucideIcons.copy, size: 20),
                        tooltip: 'Copy to clipboard',
                      ),
                    ],
                  ),
                  const Gap(AppTheme.spacing16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Text(
                      _prompt!.content,
                      style: AppTheme.body.copyWith(
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing24),
          
          // Tags
          if (_prompt!.tags.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags',
                      style: AppTheme.headline.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(AppTheme.spacing16),
                    Wrap(
                      spacing: AppTheme.spacing8,
                      runSpacing: AppTheme.spacing8,
                      children: _prompt!.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing12,
                            vertical: AppTheme.spacing6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            tag,
                            style: AppTheme.subheadline.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(AppTheme.spacing24),
          ],
          
          // Quick Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: AppTheme.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement test execution
                          },
                          icon: const Icon(LucideIcons.play),
                          label: const Text('Test Prompt'),
                        ),
                      ),
                      const Gap(AppTheme.spacing12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.go('/compare');
                          },
                          icon: const Icon(LucideIcons.gitCompare),
                          label: const Text('Compare'),
                        ),
                      ),
                      const Gap(AppTheme.spacing12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement A/B test creation
                          },
                          icon: const Icon(LucideIcons.flaskConical),
                          label: const Text('A/B Test'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Execution History',
            style: AppTheme.title3.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(AppTheme.spacing16),
          
          if (_prompt!.executionHistory.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        LucideIcons.history,
                        size: 48,
                        color: AppTheme.textTertiary,
                      ),
                      const Gap(AppTheme.spacing16),
                      Text(
                        'No execution history yet',
                        style: AppTheme.headline.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Gap(AppTheme.spacing8),
                      Text(
                        'Run this prompt to see execution results here',
                        style: AppTheme.subheadline.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ..._prompt!.executionHistory.map((execution) {
              return Card(
                margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.play,
                            size: 16,
                            color: AppTheme.secondaryColor,
                          ),
                          const Gap(AppTheme.spacing8),
                          Text(
                            DateFormat('MMM d, yyyy HH:mm').format(execution.executedAt),
                            style: AppTheme.subheadline.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (execution.rating != null) ...[
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < execution.rating!.floor()
                                      ? LucideIcons.star
                                      : LucideIcons.star,
                                  size: 16,
                                  color: index < execution.rating!.floor()
                                      ? AppTheme.warningColor
                                      : AppTheme.textTertiary,
                                );
                              }),
                            ),
                          ],
                        ],
                      ),
                      const Gap(AppTheme.spacing12),
                      
                      // Input
                      Text(
                        'Input:',
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(AppTheme.spacing4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.spacing12),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Text(
                          execution.input,
                          style: AppTheme.subheadline,
                        ),
                      ),
                      
                      const Gap(AppTheme.spacing12),
                      
                      // Output
                      Text(
                        'Output:',
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(AppTheme.spacing4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.spacing12),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Text(
                          execution.output,
                          style: AppTheme.subheadline,
                        ),
                      ),
                      
                      const Gap(AppTheme.spacing12),
                      
                      // Metadata
                      Row(
                        children: [
                          Text(
                            'Duration: ${execution.executionTime.inMilliseconds}ms',
                            style: AppTheme.caption1.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                          ),
                          const Gap(AppTheme.spacing16),
                          Text(
                            'Model: ${execution.modelConfig.modelName}',
                            style: AppTheme.caption1.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      
                      if (execution.feedback != null) ...[
                        const Gap(AppTheme.spacing8),
                        Text(
                          'Feedback: ${execution.feedback}',
                          style: AppTheme.caption1.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildConfigurationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Model Configuration',
            style: AppTheme.title3.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(AppTheme.spacing16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                children: [
                  _buildConfigRow('Model', _prompt!.modelConfig.modelName),
                  _buildConfigRow('Temperature', '${_prompt!.modelConfig.temperature}'),
                  _buildConfigRow('Max Tokens', '${_prompt!.modelConfig.maxTokens}'),
                  _buildConfigRow('Top P', '${_prompt!.modelConfig.topP}'),
                  _buildConfigRow('Presence Penalty', '${_prompt!.modelConfig.presencePenalty}'),
                  _buildConfigRow('Frequency Penalty', '${_prompt!.modelConfig.frequencyPenalty}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTheme.subheadline.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTheme.subheadline.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(PromptStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case PromptStatus.published:
        color = AppTheme.secondaryColor;
        text = 'Published';
        break;
      case PromptStatus.draft:
        color = AppTheme.warningColor;
        text = 'Draft';
        break;
      case PromptStatus.testing:
        color = AppTheme.primaryColor;
        text = 'Testing';
        break;
      case PromptStatus.archived:
        color = AppTheme.textTertiary;
        text = 'Archived';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        text,
        style: AppTheme.caption1.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVersionBadge(String version) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.textTertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        version,
        style: AppTheme.caption1.copyWith(
          color: AppTheme.textTertiary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 