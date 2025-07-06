import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../widgets/prompt_card.dart';
import '../../../models/prompt_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: LucideIcons.home,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    NavigationItem(
      icon: LucideIcons.fileText,
      label: 'Prompts',
      route: '/prompts',
    ),
    NavigationItem(
      icon: LucideIcons.gitCompare,
      label: 'Compare',
      route: '/compare',
    ),
    NavigationItem(
      icon: LucideIcons.flaskConical,
      label: 'A/B Testing',
      route: '/ab-testing',
    ),
    NavigationItem(
      icon: LucideIcons.settings,
      label: 'Settings',
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Sidebar Navigation
          _buildSidebar(),
          
          // Main Content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          right: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(
                    LucideIcons.gitBranch,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const Gap(AppTheme.spacing12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prompt Manager',
                      style: AppTheme.headline.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Version Control',
                      style: AppTheme.caption1.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(
            begin: -0.3,
            duration: 600.ms,
          ),
          
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                final isSelected = index == _selectedIndex;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                      size: 20,
                    ),
                    title: Text(
                      item.label,
                      style: AppTheme.body.copyWith(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      context.go(item.route);
                    },
                  ),
                ).animate().fadeIn(delay: (100 * index).ms, duration: 600.ms).slideX(
                  begin: -0.3,
                  duration: 600.ms,
                );
              },
            ),
          ),
          
          // User Profile
          Container(
            margin: const EdgeInsets.all(AppTheme.spacing16),
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    'JD',
                    style: AppTheme.body.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: AppTheme.subheadline.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'john@example.com',
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideY(
            begin: 0.3,
            duration: 600.ms,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, John!',
                    style: AppTheme.title1.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(AppTheme.spacing8),
                  Text(
                    'Welcome back to your prompt management dashboard.',
                    style: AppTheme.body.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/prompts/create');
                },
                icon: const Icon(LucideIcons.plus),
                label: const Text('New Prompt'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms).slideY(
            begin: -0.3,
            duration: 600.ms,
          ),
          
          const Gap(AppTheme.spacing32),
          
          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Prompts',
                  value: '${MockData.samplePrompts.length}',
                  icon: LucideIcons.fileText,
                  color: AppTheme.primaryColor,
                ),
              ),
              const Gap(AppTheme.spacing16),
              Expanded(
                child: _buildStatCard(
                  title: 'Published',
                  value: '${MockData.samplePrompts.where((p) => p.status == PromptStatus.published).length}',
                  icon: LucideIcons.checkCircle,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const Gap(AppTheme.spacing16),
              Expanded(
                child: _buildStatCard(
                  title: 'A/B Tests',
                  value: '${MockData.sampleABTests.length}',
                  icon: LucideIcons.flaskConical,
                  color: AppTheme.warningColor,
                ),
              ),
              const Gap(AppTheme.spacing16),
              Expanded(
                child: _buildStatCard(
                  title: 'Total Likes',
                  value: '${MockData.samplePrompts.map((p) => p.likes).reduce((a, b) => a + b)}',
                  icon: LucideIcons.heart,
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(
            begin: 0.3,
            duration: 600.ms,
          ),
          
          const Gap(AppTheme.spacing32),
          
          // Recent Activity and Recent Prompts
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Prompts
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Recent Prompts',
                          style: AppTheme.title3.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            context.go('/prompts');
                          },
                          child: Text(
                            'View All',
                            style: AppTheme.body.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppTheme.spacing16),
                    
                    // Recent Prompts List
                    ...MockData.samplePrompts.take(3).map((prompt) {
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
              
              const Gap(AppTheme.spacing24),
              
              // Recent Activity
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activity',
                      style: AppTheme.title3.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(AppTheme.spacing16),
                    
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        child: Column(
                          children: MockData.recentActivity.take(6).map((activity) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const Gap(AppTheme.spacing12),
                                  Expanded(
                                    child: Text(
                                      activity,
                                      style: AppTheme.subheadline.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(
            begin: 0.3,
            duration: 600.ms,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const Spacer(),
                Text(
                  value,
                  style: AppTheme.title2.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(AppTheme.spacing8),
            Text(
              title,
              style: AppTheme.subheadline.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
} 