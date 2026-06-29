import os

# 1. Update app_router.dart
router_path = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\routes\app_router.dart'
with open(router_path, 'r', encoding='utf-8') as f:
    content = f.read()

# remove imports
content = content.replace("import '../features/shared/onboarding/controllers/onboarding_controller.dart';\n", "")
content = content.replace("import '../features/shared/onboarding/views/onboarding_view.dart';\n", "")

# remove route constant
content = content.replace("  static const onboarding = '/onboarding';\n", "")

# remove route builder block
route_block = """        GoRoute(
          path: AppRoutes.onboarding,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: OnboardingView(),
          ),
        ),
"""
content = content.replace(route_block, "")

# fix AppRouter.create signature and body
old_create = """  static GoRouter create(
    AuthController auth,
    OnboardingController onboard,
    GlobalKey<NavigatorState> navigatorKey,
  ) {"""
new_create = """  static GoRouter create(
    AuthController auth,
    GlobalKey<NavigatorState> navigatorKey,
  ) {"""
content = content.replace(old_create, new_create)

content = content.replace("refreshListenable: Listenable.merge([auth, onboard]),", "refreshListenable: auth,")

old_redirect = """      redirect: (context, state) {
        if (onboard.isLoading || auth.isCheckingToken) return null;
        final bool hasOnboarded = onboard.hasCompletedOnboarding;
        final bool isLoggedIn = auth.isLoggedIn;
        final String loc = state.matchedLocation;

        if (loc == AppRoutes.splash) return null;
        if (!hasOnboarded && loc != AppRoutes.onboarding) {
          return AppRoutes.onboarding;
        }
        if (hasOnboarded && loc == AppRoutes.onboarding) {
          return isLoggedIn ? AppRoutes.home : AppRoutes.login;
        }

        final bool isPublicOnlyScreen =
            loc == AppRoutes.login ||
            loc == AppRoutes.signup ||
            loc == AppRoutes.forgetPass;"""

new_redirect = """      redirect: (context, state) {
        if (auth.isCheckingToken) return null;
        final bool isLoggedIn = auth.isLoggedIn;
        final String loc = state.matchedLocation;

        if (loc == AppRoutes.splash) return null;

        final bool isPublicOnlyScreen =
            loc == AppRoutes.login ||
            loc == AppRoutes.signup ||
            loc == AppRoutes.forgetPass;"""

content = content.replace(old_redirect, new_redirect)

with open(router_path, 'w', encoding='utf-8') as f:
    f.write(content)

# 2. Update splash_screen.dart
splash_path = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\features\shared\auth\views\splash_screen.dart'
with open(splash_path, 'r', encoding='utf-8') as f:
    splash_content = f.read()

splash_content = splash_content.replace("context.go(AppRoutes.login);", "context.go(AppRoutes.signup);")
with open(splash_path, 'w', encoding='utf-8') as f:
    f.write(splash_content)

print("Updated app_router.dart and splash_screen.dart successfully.")
