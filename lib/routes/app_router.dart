import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/design_system.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/views/auth_view.dart';
import '../features/auth/views/change_password_view.dart';
import '../features/auth/views/forget_password_view.dart';
import '../features/auth/views/go_to_home.dart';
import '../features/auth/views/otp_verify_view.dart';
import '../features/auth/views/sign_up_view.dart';
import '../features/auth/views/role_selection_view.dart';
import '../features/auth/views/name_input_view.dart';
import '../features/auth/views/splash_screen.dart';
import '../features/auth/views/setup/setup_views.dart';
import '../features/circle/views/circle_view.dart';
import '../features/home/views/home_view.dart';
import '../features/home/views/navigation.dart';
import '../features/home/views/breathing_view.dart';
import '../features/home/views/write_journal_view.dart';
import '../features/onboarding/controllers/onboarding_controller.dart';
import '../features/onboarding/views/onboarding_view.dart';
import '../features/profile/views/add_new_address.dart';
import '../features/profile/views/add_new_card_view.dart';
import '../features/profile/views/add_promo_code_view.dart';
import '../features/profile/views/edit_view.dart';
import '../features/profile/views/logout.dart';
import '../features/profile/views/my_address.dart';
import '../features/profile/views/payment_view.dart';
import '../features/profile/views/point_view.dart';
import '../features/profile/views/profile_view.dart';
import '../features/profile/views/promo_code_view.dart';
import '../features/profile/views/settings_view.dart';
import '../features/profile/views/track_order.dart';

enum TransitionType { fadeThrough, slideHorizontal, slideLeft, slideRight, slideUp, none }

abstract class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const roleSelection = '/role-selection';
  static const nameInput = '/name-input';
  static const forgetPass = '/forget-password';
  static const otpVerify = '/otp-verify';
  static const changePass = '/change-password';
  static const home = '/home';
  static const circle = '/circle';
  static const coaches = '/coaches';
  static const inbox = '/inbox';
  static const onboarding = '/onboarding';
  static const goToHome = '/go-home';
  static const settings = '/settings';
  static const breathing = '/breathing';
  static const writeJournal = '/write-journal';
  static const setup1 = '/setup1';
  static const setup2 = '/setup2';
  static const setup3 = '/setup3';
  static const setup4 = '/setup4';
  static const setup5 = '/setup5';
  static const setup6 = '/setup6';
  static const setup7 = '/setup7';
  static const setup8 = '/setup8';
  static const setup9 = '/setup9';
  static const setup10 = '/setup10';
  static const setup11 = '/setup11';
  static const setup12 = '/setup12';
  static const setup13 = '/setup13';
  static const setupComplete = '/setup-complete';
  static const logout = '/logout';
  static const paymentMethod = '/paymentMethod';
  static const address = '/address';
  static const promoCode = '/promoCode';
  static const trackOrder = '/trackOrder';
  static const editProfile = '/editProfile';
  static const addCard = '/addCard';
  static const addAddress = '/addAddress';
  static const points = '/points';
  static const addPromoCodeView = '/addPromoCodeView';
  static const orderHistory = '/orderHistory';
  static const wishlist = '/wishlist';
  static const filter = '/filter';
  static const search = '/search';
  static const review = '/review';
  static const order = '/order';
  static const checkout = '/checkout';
  static const shipping = '/shipping';
  static const payment = '/payment';
  static const confirm = '/confirm';
  static const profile = '/profile';
}

class AppRouter {
  static CustomTransitionPage _buildPageWithTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    TransitionType type = TransitionType.fadeThrough,
  }) {
    final designSystem = Theme.of(context).extension<AppDesignSystem>();
    final duration = designSystem?.navDuration ?? const Duration(milliseconds: 400);

    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (type) {
          case TransitionType.fadeThrough:
            final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: curve,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(curve),
                child: child,
              ),
            );
          case TransitionType.slideHorizontal:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          case TransitionType.slideLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          case TransitionType.slideRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          case TransitionType.slideUp:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutQuart)),
              child: child,
            );
          case TransitionType.none:
            return child;
        }
      },
    );
  }

  static GoRouter create(
    AuthController auth,
    OnboardingController onboard,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: AppRoutes.splash,
      refreshListenable: Listenable.merge([auth, onboard]),
      redirect: (context, state) {
        if (onboard.isLoading || auth.isCheckingToken) return null;
        final bool hasOnboarded = onboard.hasCompletedOnboarding;
        final bool isLoggedIn = auth.isLoggedIn;
        final String loc = state.matchedLocation;

        if (loc == AppRoutes.splash) return null;
        if (!hasOnboarded && loc != AppRoutes.onboarding) return AppRoutes.onboarding;
        if (hasOnboarded && loc == AppRoutes.onboarding) return isLoggedIn ? AppRoutes.home : AppRoutes.login;

        final bool isPublicOnlyScreen = loc == AppRoutes.login || loc == AppRoutes.signup || loc == AppRoutes.forgetPass;
        if (isLoggedIn && isPublicOnlyScreen) return AppRoutes.home;

        final bool isAuthScreen = loc == AppRoutes.home || loc == AppRoutes.circle || loc == AppRoutes.profile || loc == AppRoutes.breathing || loc == AppRoutes.writeJournal || loc.startsWith('/setup');
        if (!isLoggedIn && isAuthScreen) return AppRoutes.login;

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const SplashScreen(),
          ),
        ),
        StatefulShellRoute(
          builder: (context, state, navigationShell) => Navbar(navigationShell: navigationShell),
          navigatorContainerBuilder: (context, navigationShell, children) {
            return _DirectionalBranchContainer(
              navigationShell: navigationShell,
              children: children,
            );
          },
          branches: [
            StatefulShellBranch(routes: [GoRoute(path: AppRoutes.home, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const HomeView()))]),
            StatefulShellBranch(routes: [GoRoute(path: AppRoutes.circle, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const CircleView()))]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: AppRoutes.coaches,
                pageBuilder: (context, state) => _buildPageWithTransition(
                  context: context,
                  state: state,
                  child: const Center(child: Text('Coaches')),
                ),
              )
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: AppRoutes.inbox,
                pageBuilder: (context, state) => _buildPageWithTransition(
                  context: context,
                  state: state,
                  child: const Center(child: Text('Inbox')),
                ),
              )
            ]),
            StatefulShellBranch(routes: [GoRoute(path: AppRoutes.profile, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const ProfileView()))]),
          ],
        ),
        GoRoute(path: AppRoutes.onboarding, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const OnboardingView())),
        GoRoute(path: AppRoutes.login, name: 'login', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const AuthView())),
        GoRoute(path: AppRoutes.signup, name: 'signup', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const SignUpView())),
        GoRoute(path: AppRoutes.roleSelection, name: 'roleSelection', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const RoleSelectionView())),
        GoRoute(path: AppRoutes.nameInput, name: 'nameInput', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: NameInputView(role: state.extra as String? ?? 'User'))),

        // Setup Flow (Horizontal Slides)
        GoRoute(path: AppRoutes.setup1, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup1View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup2, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup2View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup3, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup3View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup4, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup4View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup5, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup5View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup6, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup6View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup7, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup7View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup8, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup8View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup9, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup9View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup10, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup10View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup11, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup11View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup12, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup12View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setup13, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Setup13View(), type: TransitionType.slideHorizontal)),
        GoRoute(path: AppRoutes.setupComplete, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const SetupCompleteView(), type: TransitionType.slideHorizontal)),

        GoRoute(path: AppRoutes.forgetPass, name: 'forgetPassword', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const ForgetPasswordView())),
        GoRoute(path: AppRoutes.otpVerify, name: 'otpVerify', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: OtpVerifyView(origin: state.extra as String?))),
        GoRoute(path: AppRoutes.changePass, name: 'changePassword', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const ChangePasswordView())),
        GoRoute(path: AppRoutes.goToHome, name: 'goToHome', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: GoToHome(origin: state.extra as String?))),

        GoRoute(path: AppRoutes.logout, name: 'logout', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const Logout())),
        GoRoute(path: AppRoutes.paymentMethod, name: 'paymentMethod', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const PaymentView())),
        GoRoute(path: AppRoutes.address, name: 'address', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const MyAddress())),
        GoRoute(path: AppRoutes.promoCode, name: 'promoCode', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const PromoCodeView())),
        GoRoute(path: AppRoutes.trackOrder, name: 'trackOrder', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const TrackOrder())),
        GoRoute(path: AppRoutes.editProfile, name: 'editProfile', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const EditView())),
        GoRoute(path: AppRoutes.addCard, name: 'addCard', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const AddNewCardView())),
        GoRoute(path: AppRoutes.addAddress, name: 'addAddress', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const AddNewAddress())),
        GoRoute(path: AppRoutes.points, name: 'points', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const PointView())),
        GoRoute(path: AppRoutes.addPromoCodeView, name: 'addPromoCodeView', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const AddPromoCodeView())),
        GoRoute(path: AppRoutes.settings, name: 'settings', pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const SettingsView())),

        // Special Views (Slide Up)
        GoRoute(
          path: AppRoutes.breathing,
          name: 'breathing',
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>? ?? {};
            return _buildPageWithTransition(context: context, state: state, child: BreathingView(title: extras['title'] ?? 'Take a Breath', subtitle: extras['subtitle'] ?? 'Let\'s breathe together.'), type: TransitionType.slideUp);
          },
        ),
        GoRoute(path: AppRoutes.writeJournal, pageBuilder: (context, state) => _buildPageWithTransition(context: context, state: state, child: const WriteJournalView(), type: TransitionType.slideUp)),
      ],
      errorPageBuilder: (context, state) => MaterialPage(child: Scaffold(body: Center(child: Text('Page not found: ${state.error}')))),
    );
  }
}

class _DirectionalBranchContainer extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  const _DirectionalBranchContainer({
    required this.navigationShell,
    required this.children,
  });

  @override
  State<_DirectionalBranchContainer> createState() => _DirectionalBranchContainerState();
}

class _DirectionalBranchContainerState extends State<_DirectionalBranchContainer> {
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.navigationShell.currentIndex;
  }

  @override
  void didUpdateWidget(_DirectionalBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex != widget.navigationShell.currentIndex) {
      _previousIndex = oldWidget.navigationShell.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = widget.navigationShell.currentIndex;

    return Stack(
      children: List.generate(widget.children.length, (index) {
        final bool isActive = index == currentIndex;
        
        return IgnorePointer(
          ignoring: !isActive,
          child: AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedSlide(
              offset: isActive
                  ? Offset.zero
                  : Offset(index < currentIndex ? -0.1 : 0.1, 0.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: widget.children[index],
            ),
          ),
        );
      }),
    );
  }
}
