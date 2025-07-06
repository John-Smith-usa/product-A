import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/prompt_model.dart';

class VersionHistoryScreen extends StatefulWidget {
  final String promptId;

  const VersionHistoryScreen({
    super.key,
    required this.promptId,
  });

  @override
  State<VersionHistoryScreen> createState() => _VersionHistoryScreenState();
}

class _VersionHistoryScreenState extends State<VersionHistoryScreen> {
  List<PromptVersion> _versions = [];
  PromptModel? _prompt;
  PromptVersion? _selectedVersion;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Load prompt
    _prompt = MockData.samplePrompts.firstWhere(
      (p) => p.id == widget.promptId,
      orElse: () => MockData.samplePrompts.first,
    );
    
    // Load versions
    _versions = MockData.sampleVersions.where(
      (v) => v.promptId == widget.promptId,
    ).toList();
    
    // Sort by creation date (newest first)
    _versions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    setState(() {});
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
            child: Row(
              children: [
                // Version List
                _buildVersionList(),
                
                // Divider
                const VerticalDivider(width: 1),
                
                // Version Details
                Expanded(
                  child: _buildVersionDetails(),
                ),
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
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/prompts/${widget.promptId}'),
            icon: const Icon(LucideIcons.arrowLeft),
          ),
          const Gap(AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version History',
                  style: AppTheme.title2.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_prompt != null) ...[
                  const Gap(AppTheme.spacing4),
                  Text(
                    _prompt!.title,
                    style: AppTheme.subheadline.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              context.go('/prompts/${widget.promptId}/edit');
            },
            icon: const Icon(LucideIcons.edit),
            label: const Text('Edit'),
          ),
          const Gap(AppTheme.spacing12),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement create new version
            },
            icon: const Icon(LucideIcons.plus),
            label: const Text('New Version'),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionList() {
    return Container(
      width: 400,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing20),
            child: Row(
              children: [
                Text(
                  'Versions (${_versions.length})',
                  style: AppTheme.headline.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // TODO: Implement refresh
                  },
                  icon: const Icon(LucideIcons.refreshCw, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              itemCount: _versions.length,
              itemBuilder: (context, index) {
                final version = _versions[index];
                final isSelected = _selectedVersion?.id == version.id;
                final isLatest = index == 0;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                  child: Card(
                    elevation: isSelected ? 4 : 0,
                    color: isSelected 
                        ? AppTheme.primaryColor.withOpacity(0.1)
                        : AppTheme.surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      side: BorderSide(
                        color: isSelected 
                            ? AppTheme.primaryColor
                            : AppTheme.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedVersion = version;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacing6,
                                    vertical: AppTheme.spacing2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isLatest 
                                        ? AppTheme.secondaryColor.withOpacity(0.1)
                                        : AppTheme.textTertiary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                  ),
                                  child: Text(
                                    version.version,
                                    style: AppTheme.caption1.copyWith(
                                      color: isLatest 
                                          ? AppTheme.secondaryColor
                                          : AppTheme.textTertiary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (isLatest) ...[
                                  const Gap(AppTheme.spacing8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacing6,
                                      vertical: AppTheme.spacing2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                    ),
                                    child: Text(
                                      'LATEST',
                                      style: AppTheme.caption2.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                PopupMenuButton(
                                  icon: const Icon(LucideIcons.moreVertical, size: 16),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'compare',
                                      child: Row(
                                        children: [
                                          Icon(LucideIcons.gitCompare, size: 16),
                                          Gap(AppTheme.spacing8),
                                          Text('Compare'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'revert',
                                      child: Row(
                                        children: [
                                          Icon(LucideIcons.rotateCcw, size: 16),
                                          Gap(AppTheme.spacing8),
                                          Text('Revert to this'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'tag',
                                      child: Row(
                                        children: [
                                          Icon(LucideIcons.tag, size: 16),
                                          Gap(AppTheme.spacing8),
                                          Text('Create tag'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            const Gap(AppTheme.spacing8),
                            
                            Text(
                              version.commitMessage,
                              style: AppTheme.subheadline.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const Gap(AppTheme.spacing8),
                            
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.user,
                                  size: 14,
                                  color: AppTheme.textTertiary,
                                ),
                                const Gap(AppTheme.spacing4),
                                Text(
                                  version.author,
                                  style: AppTheme.caption1.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const Gap(AppTheme.spacing12),
                                Icon(
                                  LucideIcons.calendar,
                                  size: 14,
                                  color: AppTheme.textTertiary,
                                ),
                                const Gap(AppTheme.spacing4),
                                Text(
                                  DateFormat('MMM d, HH:mm').format(version.createdAt),
                                  style: AppTheme.caption1.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            
                            const Gap(AppTheme.spacing8),
                            
                            // Changed files
                            if (version.changedFiles.isNotEmpty) ...[
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.file,
                                    size: 14,
                                    color: AppTheme.textTertiary,
                                  ),
                                  const Gap(AppTheme.spacing4),
                                  Expanded(
                                    child: Text(
                                      '${version.changedFiles.length} file${version.changedFiles.length > 1 ? 's' : ''} changed',
                                      style: AppTheme.caption1.copyWith(
                                        color: AppTheme.textTertiary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionDetails() {
    if (_selectedVersion == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.gitBranch,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const Gap(AppTheme.spacing16),
            Text(
              'Select a version to view details',
              style: AppTheme.headline.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const Gap(AppTheme.spacing8),
            Text(
              'Choose a version from the list to see the changes',
              style: AppTheme.subheadline.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Version header
          Row(
            children: [
              Text(
                _selectedVersion!.version,
                style: AppTheme.title3.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(AppTheme.spacing12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  DateFormat('MMM d, yyyy HH:mm').format(_selectedVersion!.createdAt),
                  style: AppTheme.caption1.copyWith(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/compare');
                },
                icon: const Icon(LucideIcons.gitCompare),
                label: const Text('Compare'),
              ),
            ],
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Commit message
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commit Message',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing8),
                  Text(
                    _selectedVersion!.commitMessage,
                    style: AppTheme.body.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Author and metadata
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Version Information',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing12),
                  
                  _buildInfoRow('Author', _selectedVersion!.author),
                  _buildInfoRow('Created', DateFormat('EEEE, MMMM d, yyyy \'at\' HH:mm').format(_selectedVersion!.createdAt)),
                  _buildInfoRow('Version', _selectedVersion!.version),
                  if (_selectedVersion!.parentVersionId != null)
                    _buildInfoRow('Parent Version', _selectedVersion!.parentVersionId!),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Changed files
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Changed Files (${_selectedVersion!.changedFiles.length})',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing12),
                  
                  ...(_selectedVersion!.changedFiles.map((file) {
                    IconData icon;
                    Color color;
                    
                    if (file.endsWith('.txt')) {
                      icon = LucideIcons.fileText;
                      color = AppTheme.primaryColor;
                    } else if (file.endsWith('.json')) {
                      icon = LucideIcons.braces;
                      color = AppTheme.warningColor;
                    } else if (file.endsWith('.md')) {
                      icon = LucideIcons.fileText;
                      color = AppTheme.secondaryColor;
                    } else {
                      icon = LucideIcons.file;
                      color = AppTheme.textTertiary;
                    }
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                      padding: const EdgeInsets.all(AppTheme.spacing12),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, size: 16, color: color),
                          const Gap(AppTheme.spacing8),
                          Expanded(
                            child: Text(
                              file,
                              style: AppTheme.subheadline.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing6,
                              vertical: AppTheme.spacing2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Text(
                              'Modified',
                              style: AppTheme.caption2.copyWith(
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Content Preview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content Preview',
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
                      _selectedVersion!.content,
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
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
} 