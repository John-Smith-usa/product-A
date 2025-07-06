import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/prompt_model.dart';

class PromptCard extends StatelessWidget {
  final PromptModel prompt;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onFork;
  final bool isFavorite;
  final bool showStats;

  const PromptCard({
    super.key,
    required this.prompt,
    this.onTap,
    this.onFavorite,
    this.onFork,
    this.isFavorite = false,
    this.showStats = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        side: const BorderSide(
          color: AppTheme.borderColor,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and actions
              Row(
                children: [
                  _buildStatusBadge(prompt.status),
                  const Spacer(),
                  if (onFavorite != null)
                    IconButton(
                      onPressed: onFavorite,
                      icon: Icon(
                        isFavorite ? LucideIcons.heart : LucideIcons.heart,
                        color: isFavorite ? AppTheme.errorColor : AppTheme.textTertiary,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(24, 24),
                      ),
                    ),
                  if (onFork != null)
                    IconButton(
                      onPressed: onFork,
                      icon: const Icon(
                        LucideIcons.gitFork,
                        color: AppTheme.textTertiary,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(24, 24),
                      ),
                    ),
                ],
              ),
              
              const Gap(AppTheme.spacing8),
              
              // Title and description
              Text(
                prompt.title,
                style: AppTheme.headline.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Gap(AppTheme.spacing8),
              
              Text(
                prompt.description,
                style: AppTheme.subheadline.copyWith(
                  color: AppTheme.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Gap(AppTheme.spacing12),
              
              // Tags
              if (prompt.tags.isNotEmpty)
                Wrap(
                  spacing: AppTheme.spacing8,
                  runSpacing: AppTheme.spacing4,
                  children: prompt.tags.take(3).map((tag) {
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
              
              const Gap(AppTheme.spacing16),
              
              // Footer with author and stats
              Row(
                children: [
                  // Author info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Text(
                          prompt.author[0].toUpperCase(),
                          style: AppTheme.caption1.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Gap(AppTheme.spacing8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prompt.author,
                            style: AppTheme.caption1.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy').format(prompt.updatedAt),
                            style: AppTheme.caption2.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Stats
                  if (showStats)
                    Row(
                      children: [
                        _buildStatItem(
                          icon: LucideIcons.heart,
                          count: prompt.likes,
                          color: AppTheme.errorColor,
                        ),
                        const Gap(AppTheme.spacing12),
                        _buildStatItem(
                          icon: LucideIcons.gitFork,
                          count: prompt.forks,
                          color: AppTheme.textTertiary,
                        ),
                        const Gap(AppTheme.spacing12),
                        _buildVersionBadge(prompt.version),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
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

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const Gap(AppTheme.spacing4),
        Text(
          count.toString(),
          style: AppTheme.caption1.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVersionBadge(String version) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing6,
        vertical: AppTheme.spacing2,
      ),
      decoration: BoxDecoration(
        color: AppTheme.textTertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        version,
        style: AppTheme.caption2.copyWith(
          color: AppTheme.textTertiary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 