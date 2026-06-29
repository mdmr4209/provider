import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/design_system.dart';
import '../features/shared/auth/controllers/auth_controller.dart';
import '../features/shared/auth/views/auth_view.dart';
import '../features/shared/auth/views/change_password_view.dart';
import '../features/shared/auth/views/forget_password_view.dart';
import '../features/shared/auth/views/go_to_home.dart';
import '../features/shared/auth/views/name_input_view.dart';
import '../features/shared/auth/views/otp_verify_view.dart';
import '../features/shared/auth/views/role_selection_view.dart';
import '../features/shared/auth/views/setup/seeker/seeker_setup_views.dart';
import '../features/shared/auth/views/setup/coach/coach_setup_views.dart';
import '../features/shared/auth/views/sign_up_view.dart';
import '../features/shared/auth/views/splash_screen.dart';
import '../features/seeker/circle/views/circle_view.dart';
import '../features/seeker/circle/views/create_post_view.dart';
import '../features/seeker/circle/views/find_friends_view.dart';
import '../features/seeker/circle/views/friends_view.dart';
import '../features/seeker/find_coach/views/find_coaches_view.dart';
import '../features/seeker/home/views/breathing_view.dart';
import '../features/seeker/home/views/home_view.dart';
import '../features/shared/widgets/navbar.dart';
import '../features/seeker/home/views/notifications_view.dart';
import '../features/seeker/home/views/write_journal_view.dart';
import '../features/seeker/inbox/views/call_view.dart';
import '../features/seeker/inbox/views/chat_view.dart';
import '../features/seeker/inbox/views/inbox_view.dart';
import '../features/seeker/profile/views/block_list_view.dart';
import '../features/seeker/inbox/views/bookings_view.dart';
import '../features/seeker/profile/views/edit_view.dart';
import '../features/seeker/inbox/views/give_review_view.dart';
import '../features/seeker/profile/views/help_support_view.dart';
import '../features/seeker/profile/views/logout.dart';
import '../features/seeker/profile/views/payment_view.dart';
import '../features/seeker/profile/views/point_view.dart';
import '../features/coach/inbox/views/coach_find_friends_view.dart';
import '../features/seeker/profile/views/profile_view.dart';
import '../features/seeker/profile/views/report_to_admin_view.dart';
import '../features/seeker/profile/views/reset_password_view.dart';
import '../features/seeker/profile/views/settings.dart';
import '../features/seeker/profile/views/subscription_plan_view.dart';
import '../features/seeker/profile/views/theme_view.dart';
import '../features/coach/profile/views/coach_settings_view.dart';
import 'package:provider/provider.dart';
import '../features/coach/home/views/coach_home_view.dart';
import '../features/coach/home/views/earnings_view.dart';
import '../features/coach/home/views/session_list_view.dart';
import '../features/coach/circle/views/coach_circle_view.dart';
import '../features/coach/bid_board/views/coach_bid_board_view.dart';
import '../features/coach/inbox/views/coach_inbox_view.dart';

enum TransitionType {
  fadeThrough,
  slideHorizontal,
  slideLeft,
  slideRight,
  slideUp,
  none,
}

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
  static const createPost = '/create-post';
  static const coaches = '/coaches';
  static const inbox = '/inbox';
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
  static const coachWelcome = '/coach-welcome';
  static const coachBasics = '/coach-basics';
  static const coachMatch = '/coach-match';
  static const coachStyle = '/coach-style';
  static const coachPitchBio = '/coach-pitch-bio';
  static const coachAvailability = '/coach-availability';
  static const coachRatesServices = '/coach-rates-services';
  static const coachSetupComplete = '/coach-setup-complete';
  static const coachEarnings = '/coach-earnings';
  static const coachSessions = '/coach-sessions';
  static const findFriends = '/find-friends';
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
  static const theme = '/theme';
  static const resetPassword = '/resetPassword';
  static const subscriptionPlan = '/subscriptionPlan';
  static const blockList = '/blockList';
  static const helpSupport = '/helpSupport';
  static const friendsCircle = '/friendsCircle';
  static const chat = '/chat';
  static const call = '/call';
  static const coachFindFriends = '/coachFindFriends';
  static const reportToAdmin = '/reportToAdmin';
  static const bookings = '/bookings';
  static const notification = '/notification';
}

class AppRouter {
  static CustomTransitionPage _buildPageWithTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    TransitionType type = TransitionType.fadeThrough,
  }) {
    final designSystem = Theme.of(context).extension<AppDesignSystem>();
    final duration =
        designSystem?.navDuration ?? const Duration(milliseconds: 400);

    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (type) {
          case TransitionType.fadeThrough:
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curve,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(curve),
                child: child,
              ),
            );
          case TransitionType.slideHorizontal:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          case TransitionType.slideLeft:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          case TransitionType.slideRight:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          case TransitionType.slideUp:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutQuart,
                    ),
                  ),
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
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: AppRoutes.splash,
      refreshListenable: auth,
      redirect: (context, state) {
        if (auth.isCheckingToken) return null;
        final bool isLoggedIn = auth.isLoggedIn;
        final String loc = state.matchedLocation;

        if (loc == AppRoutes.splash) return null;

        final bool isPublicOnlyScreen =
            loc == AppRoutes.login ||
            loc == AppRoutes.signup ||
            loc == AppRoutes.forgetPass;
        if (isLoggedIn && isPublicOnlyScreen) return AppRoutes.home;

        final bool isAuthScreen =
            loc == AppRoutes.home ||
            loc == AppRoutes.circle ||
            loc == AppRoutes.profile ||
            loc == AppRoutes.breathing ||
            loc == AppRoutes.writeJournal ||
            loc.startsWith('/setup') ||
            loc.startsWith('/coach-');
        if (!isLoggedIn && isAuthScreen) return AppRoutes.login;

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.coachEarnings,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const EarningsView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.coachSessions,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const SessionListView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.coachFindFriends,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachFindFriendsView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.splash,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const SplashScreen(),
          ),
        ),
        StatefulShellRoute(
          builder: (context, state, navigationShell) =>
              Navbar(navigationShell: navigationShell),
          navigatorContainerBuilder: (context, navigationShell, children) {
            return _DirectionalBranchContainer(
              navigationShell: navigationShell,
              children: children,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  pageBuilder: (context, state) {
                    final isCoach =
                        context.read<AuthController>().selectedRole == 'Coach';
                    return _buildPageWithTransition(
                      context: context,
                      state: state,
                      child: isCoach ? const CoachHomeView() : const HomeView(),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.circle,
                  pageBuilder: (context, state) {
                    final isCoach =
                        context.read<AuthController>().selectedRole == 'Coach';
                    return _buildPageWithTransition(
                      context: context,
                      state: state,
                      child: isCoach
                          ? const CoachCircleView()
                          : const CircleView(),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.coaches,
                  pageBuilder: (context, state) {
                    final isCoach =
                        context.read<AuthController>().selectedRole == 'Coach';
                    return _buildPageWithTransition(
                      context: context,
                      state: state,
                      child: isCoach
                          ? const CoachBidBoardView()
                          : const FindCoachesView(),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.inbox,
                  pageBuilder: (context, state) {
                    final isCoach =
                        context.read<AuthController>().selectedRole == 'Coach';
                    return _buildPageWithTransition(
                      context: context,
                      state: state,
                      child: isCoach
                          ? const CoachInboxView()
                          : const InboxView(),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  pageBuilder: (context, state) {
                    final isCoach =
                        context.read<AuthController>().selectedRole == 'Coach';
                    return _buildPageWithTransition(
                      context: context,
                      state: state,
                      child: isCoach
                          ? const CoachSettingsView()
                          : const ProfileView(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const AuthView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.signup,
          name: 'signup',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const SignUpView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.roleSelection,
          name: 'roleSelection',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const RoleSelectionView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.nameInput,
          name: 'nameInput',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: NameInputView(role: state.extra as String? ?? 'User'),
          ),
        ),
        GoRoute(
          path: AppRoutes.createPost,
          name: 'createPost',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CreatePostView(),
          ),
        ),

        // Setup Flow (Horizontal Slides)
        GoRoute(
          path: AppRoutes.setup1,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup1View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup2,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup2View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup3,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup3View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup4,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup4View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup5,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup5View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup6,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup6View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup7,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup7View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup8,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup8View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup9,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup9View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup10,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup10View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup11,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup11View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup12,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup12View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setup13,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Setup13View(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.setupComplete,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const SetupCompleteView(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.coachWelcome,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachWelcomeView(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.coachBasics,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachBasicsView(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.coachMatch,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachMatchView(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.coachStyle,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachStyleView(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.coachPitchBio,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachPitchBioView(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.coachAvailability,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachAvailabilityView(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.coachRatesServices,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachRatesServicesView(),
            type: TransitionType.slideHorizontal,
          ),
        ),
        GoRoute(
          path: AppRoutes.coachSetupComplete,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const CoachSetupCompleteView(),
            type: TransitionType.slideHorizontal,
          ),
        ),

        GoRoute(
          path: AppRoutes.forgetPass,
          name: 'forgetPassword',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const ForgetPasswordView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.otpVerify,
          name: 'otpVerify',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: OtpVerifyView(origin: state.extra as String?),
          ),
        ),
        GoRoute(
          path: AppRoutes.changePass,
          name: 'changePassword',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: ChangePasswordView(origin: state.extra as String?),
          ),
        ),
        GoRoute(
          path: AppRoutes.goToHome,
          name: 'goToHome',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: GoToHome(origin: state.extra as String?),
          ),
        ),

        GoRoute(
          path: AppRoutes.logout,
          name: 'logout',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Logout(),
          ),
        ),
        GoRoute(
          path: AppRoutes.paymentMethod,
          name: 'paymentMethod',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const PaymentView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.theme,
          name: 'theme',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const ThemeView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          name: 'editProfile',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const EditView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.points,
          name: 'points',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const PointView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: SettingsView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          name: 'resetPassword',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: ResetPasswordView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.subscriptionPlan,
          name: 'subscriptionPlan',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: SubscriptionPlanView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.blockList,
          name: 'blockList',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const BlockListView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.helpSupport,
          name: 'helpSupport',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const HelpSupportView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.friendsCircle,
          name: 'friendsCircle',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const FriendsView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.chat,
          name: 'chat',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return _buildPageWithTransition(
              context: context,
              state: state,
              child: ChatView(
                name: extra['name'] ?? 'Miles Esther',
                avatar: extra['avatar'] ?? 'https://i.pravatar.cc/150?u=miles',
                isCoach: extra['isCoach'] ?? false,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.call,
          name: 'call',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return _buildPageWithTransition(
              context: context,
              state: state,
              child: CallView(
                name: extra['name'] ?? 'Coach Pearl',
                avatar: extra['avatar'] ?? 'https://i.pravatar.cc/150?u=coach',
                rate: extra['rate'] ?? '2\$/Min',
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.findFriends,
          name: 'findFriends',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const FindFriendsView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.reportToAdmin,
          name: 'reportToAdmin',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: ReportToAdminView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.review,
          name: 'review',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return _buildPageWithTransition(
              context: context,
              state: state,
              child: GiveReviewView(
                coachName: extra['name'] ?? 'Coach Pearl',
                coachAvatar:
                    extra['avatar'] ??
                    'https://i.pravatar.cc/150?u=coach_pearl',
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.bookings,
          name: 'bookings',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const BookingsView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.notification,
          name: 'notification',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const NotificationsView(),
          ),
        ),

        // Special Views (Slide Up)
        GoRoute(
          path: AppRoutes.breathing,
          name: 'breathing',
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>? ?? {};
            return _buildPageWithTransition(
              context: context,
              state: state,
              child: BreathingView(
                title: extras['title'] ?? 'Take a Breath',
                subtitle: extras['subtitle'] ?? 'Let\'s breathe together.',
              ),
              type: TransitionType.slideUp,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.writeJournal,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const WriteJournalView(),
            type: TransitionType.slideUp,
          ),
        ),
      ],
      errorPageBuilder: (context, state) => MaterialPage(
        child: Scaffold(
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
      ),
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
  State<_DirectionalBranchContainer> createState() =>
      _DirectionalBranchContainerState();
}

class _DirectionalBranchContainerState
    extends State<_DirectionalBranchContainer> {
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
