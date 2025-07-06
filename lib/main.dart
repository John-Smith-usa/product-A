import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/prompts/prompts_screen.dart';
import 'presentation/screens/prompts/prompt_detail_screen.dart';
import 'presentation/screens/prompts/prompt_editor_screen.dart';
import 'presentation/screens/versions/version_history_screen.dart';
import 'presentation/screens/compare/compare_screen.dart';
import 'presentation/screens/ab_testing/ab_testing_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PromptManagerApp(),
    ),
  );
}

class PromptManagerApp extends ConsumerWidget {
  const PromptManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Prompt Manager',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    // Authentication Routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    
    // Main App Routes
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/prompts',
      name: 'prompts',
      builder: (context, state) => const PromptsScreen(),
      routes: [
        GoRoute(
          path: '/create',
          name: 'create-prompt',
          builder: (context, state) => const PromptEditorScreen(),
        ),
        GoRoute(
          path: '/:id',
          name: 'prompt-detail',
          builder: (context, state) => PromptDetailScreen(
            promptId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              path: '/edit',
              name: 'edit-prompt',
              builder: (context, state) => PromptEditorScreen(
                promptId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: '/versions',
              name: 'version-history',
              builder: (context, state) => VersionHistoryScreen(
                promptId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/compare',
      name: 'compare',
      builder: (context, state) => const CompareScreen(),
    ),
    GoRoute(
      path: '/ab-testing',
      name: 'ab-testing',
      builder: (context, state) => const ABTestingScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
