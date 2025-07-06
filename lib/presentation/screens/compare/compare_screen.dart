import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/prompt_model.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String? _leftPromptId;
  String? _rightPromptId;
  String _selectedView = 'side-by-side';
  bool _showDifferences = true;

  PromptModel? get _leftPrompt => _leftPromptId != null 
    ? MockData.samplePrompts.firstWhere(
        (p) => p.id == _leftPromptId, 
        orElse: () => MockData.samplePrompts.first
      )
    : null;
    
  PromptModel? get _rightPrompt => _rightPromptId != null 
    ? MockData.samplePrompts.firstWhere(
        (p) => p.id == _rightPromptId, 
        orElse: () => MockData.samplePrompts.first
      )
    : null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Load default prompts for comparison
    final prompts = MockData.samplePrompts;
    if (prompts.isNotEmpty) {
      _leftPromptId = prompts.first.id;
      _rightPromptId = prompts.length > 1 ? prompts[1].id : prompts.first.id;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Compare'),
        leading: IconButton(
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Controls
          _buildControls(),
          
          // Content
          Expanded(
            child: _buildContent(),
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
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/prompts'),
            icon: const Icon(LucideIcons.arrowLeft),
          ),
          const Gap(AppTheme.spacing16),
          Expanded(
            child: Text(
              'Compare Prompts',
              style: AppTheme.title2.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement export diff
            },
            icon: const Icon(LucideIcons.download),
            label: const Text('Export Diff'),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Column(
        children: [
          // Prompt selectors
          Row(
            children: [
              Expanded(
                child: _buildPromptSelector(
                  'Left Prompt',
                  _leftPromptId,
                  (promptId) => setState(() => _leftPromptId = promptId),
                ),
              ),
              const Gap(AppTheme.spacing16),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(
                  LucideIcons.gitCompare,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const Gap(AppTheme.spacing16),
              Expanded(
                child: _buildPromptSelector(
                  'Right Prompt',
                  _rightPromptId,
                  (promptId) => setState(() => _rightPromptId = promptId),
                ),
              ),
            ],
          ),
          
          const Gap(AppTheme.spacing16),
          
          // View options
          Row(
            children: [
              Text(
                'View:',
                style: AppTheme.subheadline.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(AppTheme.spacing12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'side-by-side',
                    label: Text('Side by Side'),
                    icon: Icon(LucideIcons.columns),
                  ),
                  ButtonSegment(
                    value: 'unified',
                    label: Text('Unified'),
                    icon: Icon(LucideIcons.alignJustify),
                  ),
                ],
                selected: {_selectedView},
                onSelectionChanged: (Set<String> value) {
                  setState(() {
                    _selectedView = value.first;
                  });
                },
              ),
              const Gap(AppTheme.spacing24),
              Row(
                children: [
                  Checkbox(
                    value: _showDifferences,
                    onChanged: (value) {
                      setState(() {
                        _showDifferences = value!;
                      });
                    },
                  ),
                  const Gap(AppTheme.spacing8),
                  Text(
                    'Highlight differences',
                    style: AppTheme.subheadline,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromptSelector(
    String label,
    String? selectedPromptId,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.subheadline.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(AppTheme.spacing8),
        DropdownButtonFormField<String>(
          value: selectedPromptId,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacing12,
              vertical: AppTheme.spacing8,
            ),
          ),
          items: MockData.samplePrompts.map((prompt) {
            return DropdownMenuItem(
              value: prompt.id,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    prompt.title,
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${prompt.version} • ${prompt.author}',
                    style: AppTheme.caption1.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (promptId) {
            if (promptId != null) {
              onChanged(promptId);
            }
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_leftPrompt == null || _rightPrompt == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return _selectedView == 'side-by-side'
        ? _buildSideBySideView()
        : _buildUnifiedView();
  }

  Widget _buildSideBySideView() {
    return Row(
      children: [
        Expanded(
          child: _buildPromptPanel(_leftPrompt!, isLeft: true),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _buildPromptPanel(_rightPrompt!, isLeft: false),
        ),
      ],
    );
  }

  Widget _buildPromptPanel(PromptModel prompt, {required bool isLeft}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompt.title,
                    style: AppTheme.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing8),
                  Row(
                    children: [
                      _buildVersionBadge(prompt.version),
                      const Gap(AppTheme.spacing8),
                      _buildStatusBadge(prompt.status),
                      const Spacer(),
                      Text(
                        DateFormat('MMM d, yyyy').format(prompt.updatedAt),
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppTheme.spacing8),
                  Text(
                    prompt.description,
                    style: AppTheme.subheadline.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Content
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Text(
                      prompt.content,
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
          
          const Gap(AppTheme.spacing16),
          
          // Model Config
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model Configuration',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing12),
                  _buildConfigRow('Model', prompt.modelConfig.modelName),
                  _buildConfigRow('Temperature', '${prompt.modelConfig.temperature}'),
                  _buildConfigRow('Max Tokens', '${prompt.modelConfig.maxTokens}'),
                  _buildConfigRow('Top P', '${prompt.modelConfig.topP}'),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Tags
          if (prompt.tags.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags',
                      style: AppTheme.subheadline.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(AppTheme.spacing12),
                    Wrap(
                      spacing: AppTheme.spacing8,
                      runSpacing: AppTheme.spacing8,
                      children: prompt.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing8,
                            vertical: AppTheme.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            tag,
                            style: AppTheme.caption1.copyWith(
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
          ],
        ],
      ),
    );
  }

  Widget _buildUnifiedView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comparison Summary',
                    style: AppTheme.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Left: ${_leftPrompt!.title}',
                              style: AppTheme.subheadline.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Version: ${_leftPrompt!.version}',
                              style: AppTheme.caption1.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(AppTheme.spacing16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Right: ${_rightPrompt!.title}',
                              style: AppTheme.subheadline.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Version: ${_rightPrompt!.version}',
                              style: AppTheme.caption1.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Differences
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content Differences',
                    style: AppTheme.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing16),
                  
                  // Mock diff view
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Added lines
                        if (_showDifferences) ...[
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacing8),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 30,
                                  child: Text(
                                    '+',
                                    style: AppTheme.body.copyWith(
                                      fontFamily: 'monospace',
                                      color: AppTheme.secondaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'This line was added in the right prompt',
                                    style: AppTheme.body.copyWith(
                                      fontFamily: 'monospace',
                                      color: AppTheme.secondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(AppTheme.spacing8),
                        ],
                        
                        // Removed lines
                        if (_showDifferences) ...[
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacing8),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 30,
                                  child: Text(
                                    '-',
                                    style: AppTheme.body.copyWith(
                                      fontFamily: 'monospace',
                                      color: AppTheme.errorColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'This line was removed from the left prompt',
                                    style: AppTheme.body.copyWith(
                                      fontFamily: 'monospace',
                                      color: AppTheme.errorColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(AppTheme.spacing8),
                        ],
                        
                        // Unchanged lines
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              child: Text(
                                ' ',
                                style: AppTheme.body.copyWith(
                                  fontFamily: 'monospace',
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'This line is the same in both prompts',
                                style: AppTheme.body.copyWith(
                                  fontFamily: 'monospace',
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Model Config Differences
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model Configuration Differences',
                    style: AppTheme.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing16),
                  
                  _buildConfigComparison('Model', 
                    _leftPrompt!.modelConfig.modelName, 
                    _rightPrompt!.modelConfig.modelName),
                  _buildConfigComparison('Temperature', 
                    '${_leftPrompt!.modelConfig.temperature}', 
                    '${_rightPrompt!.modelConfig.temperature}'),
                  _buildConfigComparison('Max Tokens', 
                    '${_leftPrompt!.modelConfig.maxTokens}', 
                    '${_rightPrompt!.modelConfig.maxTokens}'),
                  _buildConfigComparison('Top P', 
                    '${_leftPrompt!.modelConfig.topP}', 
                    '${_rightPrompt!.modelConfig.topP}'),
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
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTheme.caption1.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.caption1.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigComparison(String label, String leftValue, String rightValue) {
    final isDifferent = leftValue != rightValue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: isDifferent 
            ? AppTheme.warningColor.withOpacity(0.1)
            : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: isDifferent 
              ? AppTheme.warningColor.withOpacity(0.3)
              : AppTheme.borderColor,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTheme.subheadline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: isDifferent 
                        ? AppTheme.errorColor.withOpacity(0.1)
                        : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    leftValue,
                    style: AppTheme.subheadline.copyWith(
                      color: isDifferent 
                          ? AppTheme.errorColor
                          : AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Gap(AppTheme.spacing8),
                Icon(
                  LucideIcons.arrowRight,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
                const Gap(AppTheme.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: isDifferent 
                        ? AppTheme.secondaryColor.withOpacity(0.1)
                        : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    rightValue,
                    style: AppTheme.subheadline.copyWith(
                      color: isDifferent 
                          ? AppTheme.secondaryColor
                          : AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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