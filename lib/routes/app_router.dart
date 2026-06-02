import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
import '../features/cart/views/checkout.dart';
import '../features/cart/views/confirm_order_view.dart';
import '../features/cart/views/order_history.dart';
import '../features/cart/views/order_view.dart';
import '../features/cart/views/payment_method.dart';
import '../features/cart/views/shipping_details.dart';
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

// ── Route name constants ────────────────────────────────────────────────────
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
  static const onboarding = '/onboarding';
  static const goToHome = '/go-home';
  static const commentReview = '/comment-review';
  static const filter = '/filter';
  static const review = '/review';
  static const search = '/search';
  static const wishlist = '/wishlist';
  static const orderHistory = '/orderHistory';
  static const paymentMethod = '/paymentMethod';
  static const address = '/address';
  static const promoCode = '/promoCode';
  static const trackOrder = '/trackOrder';
  static const points = '/points';
  static const logout = '/logout';
  static const addCard = '/addCard';
  static const addAddress = '/addAddress';
  static const editProfile = '/editProfile';
  static const order = '/order';
  static const payment = '/payment';
  static const shipping = '/shipping';
  static const profile = '/profile';
  static const confirm = '/confirm';
  static const checkout = '/checkout';
  static const addPromoCodeView = '/addPromoCodeView';
  static const settings = '/settings';
  static const breathing = '/breathing';
  static const writeJournal = '/write-journal';

  // Setup Routes
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
}

// ── Router factory ──────────────────────────────────────────────────────────
class AppRouter {
  static GoRouter create(
    AuthController auth,
    OnboardingController onboard,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: AppRoutes.splash,
      refreshListenable: Listenable.merge([auth, onboard]),
      debugLogDiagnostics: true,

      redirect: (context, state) {
        if (onboard.isLoading || auth.isCheckingToken) return null;

        final bool hasOnboarded = onboard.hasCompletedOnboarding;
        final bool isLoggedIn = auth.isLoggedIn;
        final String loc = state.matchedLocation;

        // Always allow splash screen
        if (loc == AppRoutes.splash) {
          return null;
        }

        if (!hasOnboarded && loc != AppRoutes.onboarding) {
          return AppRoutes.onboarding;
        }

        if (hasOnboarded && loc == AppRoutes.onboarding) {
          return isLoggedIn ? AppRoutes.home : AppRoutes.login;
        }

        final bool isPublicOnlyScreen =
            loc == AppRoutes.login ||
            loc == AppRoutes.signup ||
            loc == AppRoutes.forgetPass;

        if (isLoggedIn && isPublicOnlyScreen) {
          return AppRoutes.home;
        }

        final bool isAuthScreen =
            loc == AppRoutes.home ||
            loc == AppRoutes.roleSelection ||
            loc == AppRoutes.nameInput ||
            loc == AppRoutes.profile ||
            loc == AppRoutes.wishlist ||
            loc == AppRoutes.search ||
            loc == AppRoutes.order ||
            loc == AppRoutes.checkout ||
            loc == AppRoutes.setupComplete ||
            loc == AppRoutes.breathing ||
            loc == AppRoutes.writeJournal ||
            loc.startsWith('/setup');

        if (!isLoggedIn && isAuthScreen) {
          return AppRoutes.login;
        }

        return null;
      },
      routes: [
        // ── Splash Screen ──────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Navbar(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  builder: (context, state) => const HomeView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.order,
                  builder: (context, state) => const OrderScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (context, state) => const ProfileView(),
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingView(),
        ),

        // ── Auth ──────────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (_, __) => const NoTransitionPage(child: AuthView()),
        ),
        GoRoute(
          path: AppRoutes.signup,
          name: 'signup',
          pageBuilder: (_, __) => const MaterialPage(child: SignUpView()),
        ),
        GoRoute(
          path: AppRoutes.roleSelection,
          name: 'roleSelection',
          pageBuilder: (_, __) =>
              const MaterialPage(child: RoleSelectionView()),
        ),
        GoRoute(
          path: AppRoutes.nameInput,
          name: 'nameInput',
          pageBuilder: (_, state) => MaterialPage(
            child: NameInputView(role: state.extra as String? ?? 'User'),
          ),
        ),

        // Setup Routes
        GoRoute(
          path: AppRoutes.setup1,
          builder: (context, state) => const Setup1View(),
        ),
        GoRoute(
          path: AppRoutes.setup2,
          builder: (context, state) => const Setup2View(),
        ),
        GoRoute(
          path: AppRoutes.setup3,
          builder: (context, state) => const Setup3View(),
        ),
        GoRoute(
          path: AppRoutes.setup4,
          builder: (context, state) => const Setup4View(),
        ),
        GoRoute(
          path: AppRoutes.setup5,
          builder: (context, state) => const Setup5View(),
        ),
        GoRoute(
          path: AppRoutes.setup6,
          builder: (context, state) => const Setup6View(),
        ),
        GoRoute(
          path: AppRoutes.setup7,
          builder: (context, state) => const Setup7View(),
        ),
        GoRoute(
          path: AppRoutes.setup8,
          builder: (context, state) => const Setup8View(),
        ),
        GoRoute(
          path: AppRoutes.setup9,
          builder: (context, state) => const Setup9View(),
        ),
        GoRoute(
          path: AppRoutes.setup10,
          builder: (context, state) => const Setup10View(),
        ),
        GoRoute(
          path: AppRoutes.setup11,
          builder: (context, state) => const Setup11View(),
        ),
        GoRoute(
          path: AppRoutes.setup12,
          builder: (context, state) => const Setup12View(),
        ),
        GoRoute(
          path: AppRoutes.setup13,
          builder: (context, state) => const Setup13View(),
        ),
        GoRoute(
          path: AppRoutes.setupComplete,
          builder: (context, state) => const SetupCompleteView(),
        ),

        GoRoute(
          path: AppRoutes.forgetPass,
          name: 'forgetPassword',
          pageBuilder: (_, __) =>
              const MaterialPage(child: ForgetPasswordView()),
        ),
        GoRoute(
          path: AppRoutes.otpVerify,
          name: 'otpVerify',
          pageBuilder: (_, state) => MaterialPage(
            child: OtpVerifyView(origin: state.extra as String?),
          ),
        ),
        GoRoute(
          path: AppRoutes.changePass,
          name: 'changePassword',
          pageBuilder: (_, state) => MaterialPage(child: ChangePasswordView()),
        ),
        GoRoute(
          path: AppRoutes.goToHome,
          name: 'goToHome',
          pageBuilder: (_, state) =>
              MaterialPage(child: GoToHome(origin: state.extra as String?)),
        ),

        // ── Protected ─────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.logout,
          name: 'logout',
          pageBuilder: (_, __) => const MaterialPage(child: Logout()),
        ),
        GoRoute(
          path: AppRoutes.orderHistory,
          name: 'orderHistory',
          pageBuilder: (_, __) => const MaterialPage(child: OrderHistory()),
        ),
        GoRoute(
          path: AppRoutes.paymentMethod,
          name: 'paymentMethod',
          pageBuilder: (_, __) => const MaterialPage(child: PaymentView()),
        ),
        GoRoute(
          path: AppRoutes.address,
          name: 'address',
          pageBuilder: (_, __) => const MaterialPage(child: MyAddress()),
        ),
        GoRoute(
          path: AppRoutes.promoCode,
          name: 'promoCode',
          pageBuilder: (_, __) => const MaterialPage(child: PromoCodeView()),
        ),
        GoRoute(
          path: AppRoutes.trackOrder,
          name: 'trackOrder',
          pageBuilder: (_, __) => const MaterialPage(child: TrackOrder()),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          name: 'editProfile',
          pageBuilder: (_, __) => const MaterialPage(child: EditView()),
        ),
        GoRoute(
          path: AppRoutes.addCard,
          name: 'addCard',
          pageBuilder: (_, __) => const MaterialPage(child: AddNewCardView()),
        ),
        GoRoute(
          path: AppRoutes.addAddress,
          name: 'addAddress',
          pageBuilder: (_, __) => const MaterialPage(child: AddNewAddress()),
        ),
        GoRoute(
          path: AppRoutes.points,
          name: 'points',
          pageBuilder: (_, __) => const MaterialPage(child: PointView()),
        ),
        GoRoute(
          path: AppRoutes.payment,
          name: 'payment',
          pageBuilder: (_, __) =>
              const MaterialPage(child: PaymentMethodScreen()),
        ),
        GoRoute(
          path: AppRoutes.shipping,
          name: 'shipping',
          pageBuilder: (_, __) =>
              const MaterialPage(child: ShippingDetailsScreen()),
        ),
        GoRoute(
          path: AppRoutes.checkout,
          name: 'checkout',
          pageBuilder: (_, __) => const MaterialPage(child: CheckoutScreen()),
        ),
        GoRoute(
          path: AppRoutes.addPromoCodeView,
          name: 'addPromoCodeView',
          pageBuilder: (_, __) => const MaterialPage(child: AddPromoCodeView()),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          pageBuilder: (_, __) => const MaterialPage(child: SettingsView()),
        ),
        GoRoute(
          path: AppRoutes.confirm,
          name: 'confirm',
          pageBuilder: (_, state) => MaterialPage(
            child: ConfirmOrderView(origin: state.extra as bool?),
          ),
        ),
        GoRoute(
          path: AppRoutes.breathing,
          name: 'breathing',
          pageBuilder: (context, state) {
            final Map<String, dynamic> extras =
                state.extra as Map<String, dynamic>? ?? {};
            return MaterialPage(
              child: BreathingView(
                title: extras['title'] ?? 'Take a Breath',
                subtitle: extras['subtitle'] ?? 'Let\'s breathe together.',
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.writeJournal,
          builder: (context, state) => const WriteJournalView(),
        ),
      ],

      errorPageBuilder: (_, state) => MaterialPage(
        child: Scaffold(
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
      ),
    );
  }
}
