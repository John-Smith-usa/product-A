import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/prompt_model.dart';

class ABTestingScreen extends StatefulWidget {
  const ABTestingScreen({super.key});

  @override
  State<ABTestingScreen> createState() => _ABTestingScreenState();
}

class _ABTestingScreenState extends State<ABTestingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<ABTest> _abTests = [];
  ABTest? _selectedTest;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    _abTests = MockData.sampleABTests;
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
          
          // Filters
          _buildFilters(),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTestsTab(),
                _buildTestResultsTab(),
                _buildCreateTestTab(),
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
            onPressed: () => context.go('/'),
            icon: const Icon(LucideIcons.arrowLeft),
          ),
          const Gap(AppTheme.spacing16),
          Expanded(
            child: Text(
              'A/B Testing',
              style: AppTheme.title2.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _tabController.animateTo(2);
            },
            icon: const Icon(LucideIcons.plus),
            label: const Text('New Test'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
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
          // Tab bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(LucideIcons.flaskConical),
                text: 'Active Tests',
              ),
              Tab(
                icon: Icon(LucideIcons.barChart),
                text: 'Results',
              ),
              Tab(
                icon: Icon(LucideIcons.plus),
                text: 'Create Test',
              ),
            ],
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Filter chips
          Row(
            children: [
              Text(
                'Filter:',
                style: AppTheme.subheadline.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(AppTheme.spacing12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'All Tests'),
                      _buildFilterChip('running', 'Running'),
                      _buildFilterChip('completed', 'Completed'),
                      _buildFilterChip('paused', 'Paused'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Container(
      margin: const EdgeInsets.only(right: AppTheme.spacing8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? value : 'all';
          });
        },
      ),
    );
  }

  Widget _buildActiveTestsTab() {
    final filteredTests = _abTests.where((test) {
      if (_selectedFilter == 'all') return true;
      return test.status.name == _selectedFilter;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active Tests',
                  '${_abTests.where((t) => t.status == ABTestStatus.running).length}',
                  LucideIcons.play,
                  AppTheme.primaryColor,
                ),
              ),
              const Gap(AppTheme.spacing16),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  '${_abTests.where((t) => t.status == ABTestStatus.completed).length}',
                  LucideIcons.checkCircle,
                  AppTheme.secondaryColor,
                ),
              ),
              const Gap(AppTheme.spacing16),
              Expanded(
                child: _buildStatCard(
                  'Total Tests',
                  '${_abTests.length}',
                  LucideIcons.flaskConical,
                  AppTheme.warningColor,
                ),
              ),
            ],
          ),
          
          const Gap(AppTheme.spacing24),
          
          // Tests list
          Text(
            'Test Results',
            style: AppTheme.headline.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          if (filteredTests.isEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        LucideIcons.flaskConical,
                        size: 48,
                        color: AppTheme.textTertiary,
                      ),
                      const Gap(AppTheme.spacing16),
                      Text(
                        'No tests found',
                        style: AppTheme.headline.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Gap(AppTheme.spacing8),
                      Text(
                        'Create your first A/B test to start comparing prompts',
                        style: AppTheme.subheadline.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            ...filteredTests.map((test) => _buildTestCard(test)),
          ],
        ],
      ),
    );
  }

  Widget _buildTestResultsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Results Analysis',
            style: AppTheme.headline.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Results summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Summary',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing16),
                  
                  // Mock performance metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Average Response Time',
                          '1.2s',
                          LucideIcons.clock,
                          AppTheme.primaryColor,
                        ),
                      ),
                      const Gap(AppTheme.spacing12),
                      Expanded(
                        child: _buildMetricCard(
                          'Success Rate',
                          '87.5%',
                          LucideIcons.target,
                          AppTheme.secondaryColor,
                        ),
                      ),
                      const Gap(AppTheme.spacing12),
                      Expanded(
                        child: _buildMetricCard(
                          'User Satisfaction',
                          '4.2/5',
                          LucideIcons.star,
                          AppTheme.warningColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          // Individual test results
          ..._abTests.where((test) => test.status == ABTestStatus.completed)
              .map((test) => _buildTestResultCard(test)),
        ],
      ),
    );
  }

  Widget _buildCreateTestTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create New A/B Test',
            style: AppTheme.headline.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const Gap(AppTheme.spacing16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Configuration',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing16),
                  
                  // Test name
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Test Name',
                      hintText: 'Enter a descriptive name for your test',
                    ),
                  ),
                  
                  const Gap(AppTheme.spacing16),
                  
                  // Description
                  TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe what you want to test',
                      alignLabelWithHint: true,
                    ),
                  ),
                  
                  const Gap(AppTheme.spacing16),
                  
                  // Variant A
                  Text(
                    'Variant A (Control)',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Prompt',
                      border: OutlineInputBorder(),
                    ),
                    items: MockData.samplePrompts.map((prompt) {
                      return DropdownMenuItem(
                        value: prompt.id,
                        child: Text(prompt.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle variant A selection
                    },
                  ),
                  
                  const Gap(AppTheme.spacing16),
                  
                  // Variant B
                  Text(
                    'Variant B (Test)',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Prompt',
                      border: OutlineInputBorder(),
                    ),
                    items: MockData.samplePrompts.map((prompt) {
                      return DropdownMenuItem(
                        value: prompt.id,
                        child: Text(prompt.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle variant B selection
                    },
                  ),
                  
                  const Gap(AppTheme.spacing16),
                  
                  // Test settings
                  Text(
                    'Test Settings',
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppTheme.spacing8),
                  
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Traffic Split (%)',
                            hintText: '50',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const Gap(AppTheme.spacing16),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Duration (days)',
                            hintText: '7',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  
                  const Gap(AppTheme.spacing24),
                  
                  // Create button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement test creation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('A/B Test created successfully!'),
                          ),
                        );
                      },
                      child: const Text('Create Test'),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Gap(AppTheme.spacing8),
                Text(
                  title,
                  style: AppTheme.subheadline.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const Gap(AppTheme.spacing8),
            Text(
              value,
              style: AppTheme.title3.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Gap(AppTheme.spacing8),
          Text(
            title,
            style: AppTheme.caption1.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const Gap(AppTheme.spacing4),
          Text(
            value,
            style: AppTheme.headline.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(ABTest test) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.name,
                        style: AppTheme.subheadline.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(AppTheme.spacing4),
                      Text(
                        test.description,
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(test.status),
              ],
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Progress bar
            if (test.status == ABTestStatus.running) ...[
              Row(
                children: [
                  Text(
                    'Progress:',
                    style: AppTheme.caption1.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Gap(AppTheme.spacing8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: test.progress,
                      backgroundColor: AppTheme.borderColor,
                      valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                    ),
                  ),
                  const Gap(AppTheme.spacing8),
                  Text(
                    '${(test.progress * 100).toInt()}%',
                    style: AppTheme.caption1.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const Gap(AppTheme.spacing16),
            ],
            
            // Test details
            Row(
              children: [
                Icon(
                  LucideIcons.users,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
                const Gap(AppTheme.spacing4),
                Text(
                  '${test.totalParticipants} participants',
                  style: AppTheme.caption1.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Gap(AppTheme.spacing16),
                Icon(
                  LucideIcons.calendar,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
                const Gap(AppTheme.spacing4),
                Text(
                  DateFormat('MMM d, yyyy').format(test.startDate),
                  style: AppTheme.caption1.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Show test details
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultCard(ABTest test) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    test.name,
                    style: AppTheme.subheadline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildStatusBadge(test.status),
              ],
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Results comparison
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Variant A (Control)',
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(AppTheme.spacing8),
                      Text(
                        'Success Rate: ${(test.variantASuccessRate * 100).toInt()}%',
                        style: AppTheme.subheadline.copyWith(
                          color: AppTheme.errorColor,
                        ),
                      ),
                      Text(
                        'Avg Response Time: ${test.variantAAvgResponseTime.toStringAsFixed(1)}s',
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
                        'Variant B (Test)',
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(AppTheme.spacing8),
                      Text(
                        'Success Rate: ${(test.variantBSuccessRate * 100).toInt()}%',
                        style: AppTheme.subheadline.copyWith(
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      Text(
                        'Avg Response Time: ${test.variantBAvgResponseTime.toStringAsFixed(1)}s',
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Winner indicator
            if (test.variantBSuccessRate > test.variantASuccessRate) ...[
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.trophy,
                      color: AppTheme.secondaryColor,
                      size: 16,
                    ),
                    const Gap(AppTheme.spacing8),
                    Text(
                      'Variant B is performing better!',
                      style: AppTheme.subheadline.copyWith(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ABTestStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case ABTestStatus.running:
        color = AppTheme.primaryColor;
        text = 'Running';
        break;
      case ABTestStatus.completed:
        color = AppTheme.secondaryColor;
        text = 'Completed';
        break;
      case ABTestStatus.paused:
        color = AppTheme.warningColor;
        text = 'Paused';
        break;
      case ABTestStatus.draft:
        color = AppTheme.textTertiary;
        text = 'Draft';
        break;
      case ABTestStatus.cancelled:
        color = AppTheme.errorColor;
        text = 'Cancelled';
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
} 