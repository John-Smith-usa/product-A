import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../widgets/prompt_card.dart';

class PromptsScreen extends StatefulWidget {
  const PromptsScreen({super.key});

  @override
  State<PromptsScreen> createState() => _PromptsScreenState();
}

class _PromptsScreenState extends State<PromptsScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'all';
  List<String> _selectedTags = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.borderColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/dashboard'),
                      icon: const Icon(LucideIcons.arrowLeft),
                    ),
                    const Gap(AppTheme.spacing16),
                    Text(
                      'Prompts',
                      style: AppTheme.title2.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go('/prompts/create');
                      },
                      icon: const Icon(LucideIcons.plus),
                      label: const Text('New Prompt'),
                    ),
                  ],
                ),
                const Gap(AppTheme.spacing16),
                
                // Search and Filters
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search prompts...',
                          prefixIcon: const Icon(LucideIcons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const Gap(AppTheme.spacing16),
                    DropdownButton<String>(
                      value: _selectedFilter,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(value: 'published', child: Text('Published')),
                        DropdownMenuItem(value: 'draft', child: Text('Draft')),
                        DropdownMenuItem(value: 'testing', child: Text('Testing')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags Filter
                  Text(
                    'Filter by tags:',
                    style: AppTheme.subheadline.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing12),
                  Wrap(
                    spacing: AppTheme.spacing8,
                    runSpacing: AppTheme.spacing8,
                    children: MockData.popularTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                            } else {
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const Gap(AppTheme.spacing32),
                  
                  // Prompts List
                  Text(
                    'Prompts (${MockData.samplePrompts.length})',
                    style: AppTheme.title3.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing16),
                  
                  ...MockData.samplePrompts.map((prompt) {
                    return PromptCard(
                      prompt: prompt,
                      onTap: () {
                        context.go('/prompts/${prompt.id}');
                      },
                      onFavorite: () {
                        // TODO: Implement favorite
                      },
                      onFork: () {
                        // TODO: Implement fork
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 