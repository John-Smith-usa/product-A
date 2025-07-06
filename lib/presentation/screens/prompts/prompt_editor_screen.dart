import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/prompt_model.dart';

class PromptEditorScreen extends StatefulWidget {
  final String? promptId;

  const PromptEditorScreen({
    super.key,
    this.promptId,
  });

  @override
  State<PromptEditorScreen> createState() => _PromptEditorScreenState();
}

class _PromptEditorScreenState extends State<PromptEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  
  PromptStatus _selectedStatus = PromptStatus.draft;
  String _selectedModel = 'gpt-4';
  double _temperature = 0.7;
  int _maxTokens = 1000;
  double _topP = 0.9;
  double _presencePenalty = 0.0;
  double _frequencyPenalty = 0.0;
  
  List<String> _tags = [];
  bool _isLoading = false;
  PromptModel? _existingPrompt;

  final List<String> _availableModels = [
    'gpt-4',
    'gpt-3.5-turbo',
    'claude-3-opus',
    'claude-3-sonnet',
    'claude-3-haiku',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.promptId != null) {
      _loadExistingPrompt();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _loadExistingPrompt() {
    _existingPrompt = MockData.samplePrompts.firstWhere(
      (p) => p.id == widget.promptId,
      orElse: () => MockData.samplePrompts.first,
    );
    
    if (_existingPrompt != null) {
      _titleController.text = _existingPrompt!.title;
      _descriptionController.text = _existingPrompt!.description;
      _contentController.text = _existingPrompt!.content;
      _selectedStatus = _existingPrompt!.status;
      _tags = List.from(_existingPrompt!.tags);
      
      // Load model config
      _selectedModel = _existingPrompt!.modelConfig.modelName;
      _temperature = _existingPrompt!.modelConfig.temperature;
      _maxTokens = _existingPrompt!.modelConfig.maxTokens;
      _topP = _existingPrompt!.modelConfig.topP;
      _presencePenalty = _existingPrompt!.modelConfig.presencePenalty;
      _frequencyPenalty = _existingPrompt!.modelConfig.frequencyPenalty;
    }
    setState(() {});
  }

  Future<void> _savePrompt() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.promptId == null 
                ? 'Prompt created successfully!' 
                : 'Prompt updated successfully!',
          ),
        ),
      );
      context.go('/prompts');
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information
                    _buildBasicInfoSection(),
                    
                    const Gap(AppTheme.spacing32),
                    
                    // Prompt Content
                    _buildContentSection(),
                    
                    const Gap(AppTheme.spacing32),
                    
                    // Tags
                    _buildTagsSection(),
                    
                    const Gap(AppTheme.spacing32),
                    
                    // Model Configuration
                    _buildModelConfigSection(),
                    
                    const Gap(AppTheme.spacing40),
                  ],
                ),
              ),
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
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/prompts'),
            icon: const Icon(LucideIcons.arrowLeft),
          ),
          const Gap(AppTheme.spacing16),
          Expanded(
            child: Text(
              widget.promptId == null ? 'Create New Prompt' : 'Edit Prompt',
              style: AppTheme.title2.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () => context.go('/prompts'),
            child: const Text('Cancel'),
          ),
          const Gap(AppTheme.spacing12),
          ElevatedButton(
            onPressed: _isLoading ? null : _savePrompt,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.promptId == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing20),
            
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a descriptive title for your prompt',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe what this prompt does and how it should be used',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Status
            DropdownButtonFormField<PromptStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
              ),
              items: PromptStatus.values.map((status) {
                String statusText;
                switch (status) {
                  case PromptStatus.draft:
                    statusText = 'Draft';
                    break;
                  case PromptStatus.published:
                    statusText = 'Published';
                    break;
                  case PromptStatus.testing:
                    statusText = 'Testing';
                    break;
                  case PromptStatus.archived:
                    statusText = 'Archived';
                    break;
                }
                return DropdownMenuItem(
                  value: status,
                  child: Text(statusText),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Card(
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
                Text(
                  '${_contentController.text.length} characters',
                  style: AppTheme.caption1.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
            const Gap(AppTheme.spacing20),
            
            TextFormField(
              controller: _contentController,
              maxLines: 15,
              decoration: const InputDecoration(
                hintText: 'Enter your prompt content here...\n\nTip: Be specific and clear about what you want the AI to do. Include context, examples, and constraints as needed.',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              style: AppTheme.body.copyWith(
                fontFamily: 'monospace',
                height: 1.5,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the prompt content';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {}); // Update character count
              },
            ),
            
            const Gap(AppTheme.spacing12),
            
            Text(
              'Tips: Use clear instructions, provide context, and include examples when possible.',
              style: AppTheme.caption1.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Card(
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
            const Gap(AppTheme.spacing20),
            
            // Add tag input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      hintText: 'Add a tag...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                const Gap(AppTheme.spacing12),
                ElevatedButton.icon(
                  onPressed: _addTag,
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Current tags
            if (_tags.isNotEmpty) ...[
              Wrap(
                spacing: AppTheme.spacing8,
                runSpacing: AppTheme.spacing8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(LucideIcons.x, size: 16),
                    onDeleted: () => _removeTag(tag),
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    labelStyle: AppTheme.subheadline.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }).toList(),
              ),
            ] else ...[
              Text(
                'No tags added yet. Tags help organize and discover prompts.',
                style: AppTheme.subheadline.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
            
            const Gap(AppTheme.spacing16),
            
            // Suggested tags
            Text(
              'Suggested tags:',
              style: AppTheme.caption1.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing8),
            Wrap(
              spacing: AppTheme.spacing8,
              runSpacing: AppTheme.spacing8,
              children: MockData.popularTags.take(8).map((tag) {
                if (_tags.contains(tag)) return const SizedBox.shrink();
                return ActionChip(
                  label: Text(tag),
                  onPressed: () {
                    setState(() {
                      _tags.add(tag);
                    });
                  },
                  backgroundColor: AppTheme.backgroundColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelConfigSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model Configuration',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing20),
            
            // Model selection
            DropdownButtonFormField<String>(
              value: _selectedModel,
              decoration: const InputDecoration(
                labelText: 'Model',
              ),
              items: _availableModels.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedModel = value!;
                });
              },
            ),
            
            const Gap(AppTheme.spacing24),
            
            // Temperature
            _buildSliderConfig(
              'Temperature',
              'Controls randomness in responses (0.0 = deterministic, 1.0 = creative)',
              _temperature,
              0.0,
              1.0,
              (value) => setState(() => _temperature = value),
            ),
            
            const Gap(AppTheme.spacing20),
            
            // Max Tokens
            _buildSliderConfig(
              'Max Tokens',
              'Maximum number of tokens in the response',
              _maxTokens.toDouble(),
              100,
              4000,
              (value) => setState(() => _maxTokens = value.round()),
              isInteger: true,
            ),
            
            const Gap(AppTheme.spacing20),
            
            // Top P
            _buildSliderConfig(
              'Top P',
              'Controls diversity of responses (lower = more focused)',
              _topP,
              0.0,
              1.0,
              (value) => setState(() => _topP = value),
            ),
            
            const Gap(AppTheme.spacing20),
            
            // Presence Penalty
            _buildSliderConfig(
              'Presence Penalty',
              'Reduces repetition of topics (-2.0 to 2.0)',
              _presencePenalty,
              -2.0,
              2.0,
              (value) => setState(() => _presencePenalty = value),
            ),
            
            const Gap(AppTheme.spacing20),
            
            // Frequency Penalty
            _buildSliderConfig(
              'Frequency Penalty',
              'Reduces repetition of tokens (-2.0 to 2.0)',
              _frequencyPenalty,
              -2.0,
              2.0,
              (value) => setState(() => _frequencyPenalty = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderConfig(
    String label,
    String description,
    double value,
    double min,
    double max,
    Function(double) onChanged, {
    bool isInteger = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTheme.subheadline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              isInteger ? value.round().toString() : value.toStringAsFixed(2),
              style: AppTheme.subheadline.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Gap(AppTheme.spacing4),
        Text(
          description,
          style: AppTheme.caption1.copyWith(
            color: AppTheme.textTertiary,
          ),
        ),
        const Gap(AppTheme.spacing8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: isInteger ? (max - min).round() : 100,
          onChanged: onChanged,
        ),
      ],
    );
  }
} 