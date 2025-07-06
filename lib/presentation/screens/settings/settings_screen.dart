import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _autoSave = true;
  bool _analytics = false;
  String _language = 'English';
  String _defaultModel = 'gpt-4';
  double _autoSaveInterval = 30;

  final List<String> _languages = ['English', 'Japanese', 'Spanish', 'French', 'German'];
  final List<String> _models = ['gpt-4', 'gpt-3.5-turbo', 'claude-3-opus', 'claude-3-sonnet'];

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
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile
                  _buildUserProfileSection(),
                  
                  const Gap(AppTheme.spacing24),
                  
                  // Appearance
                  _buildAppearanceSection(),
                  
                  const Gap(AppTheme.spacing24),
                  
                  // Editor Settings
                  _buildEditorSection(),
                  
                  const Gap(AppTheme.spacing24),
                  
                  // Model Defaults
                  _buildModelDefaultsSection(),
                  
                  const Gap(AppTheme.spacing24),
                  
                  // Privacy & Security
                  _buildPrivacySection(),
                  
                  const Gap(AppTheme.spacing24),
                  
                  // Data Management
                  _buildDataManagementSection(),
                  
                  const Gap(AppTheme.spacing24),
                  
                  // About
                  _buildAboutSection(),
                ],
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
            onPressed: () => context.go('/'),
            icon: const Icon(LucideIcons.arrowLeft),
          ),
          const Gap(AppTheme.spacing16),
          Expanded(
            child: Text(
              'Settings',
              style: AppTheme.title2.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings saved successfully!'),
                ),
              );
            },
            icon: const Icon(LucideIcons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Profile',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing16),
            
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    LucideIcons.user,
                    size: 30,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Gap(AppTheme.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: AppTheme.subheadline.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(AppTheme.spacing4),
                      Text(
                        'john.doe@example.com',
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Gap(AppTheme.spacing4),
                      Text(
                        'Premium Plan',
                        style: AppTheme.caption1.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Edit profile
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing16),
            
            // Theme toggle
            _buildSettingRow(
              'Dark Mode',
              'Use dark theme for reduced eye strain',
              LucideIcons.moon,
              Switch(
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Language
            _buildSettingRow(
              'Language',
              'Application language',
              LucideIcons.globe,
              DropdownButton<String>(
                value: _language,
                items: _languages.map((lang) {
                  return DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                },
                underline: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Editor Settings',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing16),
            
            // Auto-save
            _buildSettingRow(
              'Auto-save',
              'Automatically save changes while editing',
              LucideIcons.save,
              Switch(
                value: _autoSave,
                onChanged: (value) {
                  setState(() {
                    _autoSave = value;
                  });
                },
              ),
            ),
            
            if (_autoSave) ...[
              const Gap(AppTheme.spacing16),
              
              // Auto-save interval
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 20,
                        color: AppTheme.textTertiary,
                      ),
                      const Gap(AppTheme.spacing12),
                      Text(
                        'Auto-save interval',
                        style: AppTheme.subheadline.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_autoSaveInterval.round()}s',
                        style: AppTheme.subheadline.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppTheme.spacing8),
                  Slider(
                    value: _autoSaveInterval,
                    min: 10,
                    max: 120,
                    divisions: 11,
                    onChanged: (value) {
                      setState(() {
                        _autoSaveInterval = value;
                      });
                    },
                  ),
                  Text(
                    'How often to automatically save changes',
                    style: AppTheme.caption1.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModelDefaultsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model Defaults',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing16),
            
            // Default model
            _buildSettingRow(
              'Default Model',
              'Default model for new prompts',
              LucideIcons.cpu,
              DropdownButton<String>(
                value: _defaultModel,
                items: _models.map((model) {
                  return DropdownMenuItem(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _defaultModel = value!;
                  });
                },
                underline: const SizedBox(),
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // API Keys management
            _buildSettingRow(
              'API Keys',
              'Manage your AI model API keys',
              LucideIcons.key,
              TextButton(
                onPressed: () {
                  _showApiKeysDialog();
                },
                child: const Text('Manage'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy & Security',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing16),
            
            // Notifications
            _buildSettingRow(
              'Notifications',
              'Receive notifications about test results',
              LucideIcons.bell,
              Switch(
                value: _notifications,
                onChanged: (value) {
                  setState(() {
                    _notifications = value;
                  });
                },
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Analytics
            _buildSettingRow(
              'Usage Analytics',
              'Help improve the app by sharing anonymous usage data',
              LucideIcons.barChart,
              Switch(
                value: _analytics,
                onChanged: (value) {
                  setState(() {
                    _analytics = value;
                  });
                },
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Change password
            _buildSettingRow(
              'Change Password',
              'Update your account password',
              LucideIcons.lock,
              TextButton(
                onPressed: () {
                  // TODO: Change password
                },
                child: const Text('Change'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Management',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing16),
            
            // Export data
            _buildSettingRow(
              'Export Data',
              'Download your prompts and test results',
              LucideIcons.download,
              TextButton(
                onPressed: () {
                  _showExportDialog();
                },
                child: const Text('Export'),
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Import data
            _buildSettingRow(
              'Import Data',
              'Import prompts from file or another system',
              LucideIcons.upload,
              TextButton(
                onPressed: () {
                  _showImportDialog();
                },
                child: const Text('Import'),
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Clear cache
            _buildSettingRow(
              'Clear Cache',
              'Free up storage space by clearing cached data',
              LucideIcons.trash2,
              TextButton(
                onPressed: () {
                  _showClearCacheDialog();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.errorColor,
                ),
                child: const Text('Clear'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: AppTheme.headline.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppTheme.spacing16),
            
            // Version
            _buildSettingRow(
              'Version',
              'Current app version',
              LucideIcons.info,
              Text(
                '1.0.0',
                style: AppTheme.subheadline.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Terms of Service
            _buildSettingRow(
              'Terms of Service',
              'Read our terms and conditions',
              LucideIcons.fileText,
              TextButton(
                onPressed: () {
                  // TODO: Show terms
                },
                child: const Text('View'),
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Privacy Policy
            _buildSettingRow(
              'Privacy Policy',
              'Learn how we protect your data',
              LucideIcons.shield,
              TextButton(
                onPressed: () {
                  // TODO: Show privacy policy
                },
                child: const Text('View'),
              ),
            ),
            
            const Gap(AppTheme.spacing16),
            
            // Support
            _buildSettingRow(
              'Support',
              'Get help or report issues',
              LucideIcons.helpCircle,
              TextButton(
                onPressed: () {
                  // TODO: Show support
                },
                child: const Text('Contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(
    String title,
    String description,
    IconData icon,
    Widget trailing,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.textTertiary,
        ),
        const Gap(AppTheme.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.subheadline.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(AppTheme.spacing2),
              Text(
                description,
                style: AppTheme.caption1.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  void _showApiKeysDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Keys'),
        content: const SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'OpenAI API Key',
                  hintText: 'sk-...',
                ),
                obscureText: true,
              ),
              Gap(AppTheme.spacing16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Anthropic API Key',
                  hintText: 'sk-ant-...',
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('API keys saved successfully!'),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Choose what data to export:',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data export started! Check downloads folder.'),
                ),
              );
            },
            child: const Text('Export All'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text(
          'Select a file to import prompts and configurations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File imported successfully!'),
                ),
              );
            },
            child: const Text('Choose File'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'Are you sure you want to clear all cached data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
} 