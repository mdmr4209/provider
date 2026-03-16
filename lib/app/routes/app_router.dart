import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../modules/auth/providers/auth_provider.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/change_password_view.dart';
import '../modules/auth/views/forget_password_view.dart';
import '../modules/auth/views/go_to_home.dart';
import '../modules/auth/views/otp_verify_view.dart';
import '../modules/auth/views/sign_up_view.dart';
import '../modules/cart/view/checkout.dart';
import '../modules/cart/view/confirm_order_view.dart';
import '../modules/cart/view/order_history.dart';
import '../modules/cart/view/order_view.dart';
import '../modules/cart/view/payment_method.dart';
import '../modules/cart/view/shipping_details.dart';
import '../modules/home/views/comment_review_view.dart';
import '../modules/home/views/filter_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/navigation.dart';
import '../modules/home/views/product_view.dart';
import '../modules/home/views/review_view.dart';
import '../modules/home/views/search_view.dart';
import '../modules/home/views/wishlist_view.dart';
import '../modules/onboarding/providers/onboarding_provider.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/views/add_new_address.dart';
import '../modules/profile/views/add_new_card_view.dart';
import '../modules/profile/views/add_promo_code_view.dart';
import '../modules/profile/views/edit_view.dart';
import '../modules/profile/views/logout.dart';
import '../modules/profile/views/my_address.dart';
import '../modules/profile/views/payment_view.dart';
import '../modules/profile/views/point_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/promo_code_view.dart';
import '../modules/profile/views/track_order.dart';

// ── Route name constants ────────────────────────────────────────────────────
abstract class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const forgetPass = '/forget-password';
  static const otpVerify = '/otp-verify';
  static const changePass = '/change-password';
  static const home = '/home';
  static const onboarding = '/onboarding';
  static const goToHome = '/go-home';
  static const commentReview = '/comment-review';
  static const filter = '/filter';
  static const product = '/product';
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
  // static const  = '/';
}

// ── Router factory ──────────────────────────────────────────────────────────
class AppRouter {
  /// Pass the [AuthProvider] so the router can listen to auth state changes
  /// and auto-redirect without any manual navigation calls inside the provider.
  static GoRouter create(
    AuthProvider auth,
    OnboardingProvider onboard,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey, // Add this line
      initialLocation: AppRoutes.home,
      // Listen to both for changes
      refreshListenable: Listenable.merge([auth, onboard]),

      redirect: (context, state) {
        if (onboard.isLoading || auth.isCheckingToken) return null;

        final bool hasOnboarded = onboard.hasCompletedOnboarding;
        final bool isLoggedIn = auth.isLoggedIn;
        final String loc = state.matchedLocation;

        // 1. Force Onboarding if not done
        if (!hasOnboarded && loc != AppRoutes.onboarding) {
          return AppRoutes.onboarding;
        }

        // 2. If finished onboarding but on onboarding page, go to login/home
        if (hasOnboarded && loc == AppRoutes.onboarding) {
          return isLoggedIn ? AppRoutes.home : AppRoutes.login;
        }

        // 3. Standard Auth Guard
        final onAuthScreen =
            loc == AppRoutes.login ||
            loc == AppRoutes.signup ||
            loc == AppRoutes.forgetPass ||
            loc == AppRoutes.otpVerify ||
            loc == AppRoutes.changePass ||
            loc == AppRoutes.home ||
            loc == AppRoutes.wishlist ||
            loc == AppRoutes.search ||
            loc == AppRoutes.addPromoCodeView ||
            loc == AppRoutes.review ||
            loc == AppRoutes.product ||
            loc == AppRoutes.filter ||
            loc == AppRoutes.profile ||
            loc == AppRoutes.commentReview ||
            loc == AppRoutes.editProfile ||
            loc == AppRoutes.logout ||
            loc == AppRoutes.points ||
            loc == AppRoutes.trackOrder ||
            loc == AppRoutes.promoCode ||
            loc == AppRoutes.address ||
            loc == AppRoutes.confirm ||
            loc == AppRoutes.orderHistory ||
            loc == AppRoutes.paymentMethod ||
            loc == AppRoutes.addAddress ||
            loc == AppRoutes.addCard ||
            loc == AppRoutes.payment ||
            loc == AppRoutes.shipping ||
            loc == AppRoutes.checkout ||
            loc == AppRoutes.order ||
            loc == AppRoutes.goToHome; // etc
        if (isLoggedIn && onAuthScreen) return AppRoutes.home;
        if (!isLoggedIn && !onAuthScreen && hasOnboarded) {
          return AppRoutes.login;
        }

        return null;
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            // navigationShell contains the currentIndex and the sub-page
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
                  path: AppRoutes.search,
                  builder: (context, state) => const SearchView(),
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
                  path: AppRoutes.wishlist,
                  builder: (context, state) => const WishlistView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile, // Define a simple profile path
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
          path: AppRoutes.forgetPass,
          name: 'forgetPassword',
          pageBuilder: (_, __) =>
              const MaterialPage(child: ForgetPasswordView()),
        ),
        GoRoute(
          path: AppRoutes.otpVerify,
          name: 'otpVerify',
          // Usage: context.go(AppRoutes.otpVerify, extra: 'Signup')
          pageBuilder: (_, state) => MaterialPage(
            child: OtpVerifyView(origin: state.extra as String?),
          ),
        ),
        GoRoute(
          path: AppRoutes.changePass,
          name: 'changePassword',
          // Usage: context.go(AppRoutes.changePass, extra: 'Forget')
          pageBuilder: (_, state) => MaterialPage(child: ChangePasswordView()),
        ),
        GoRoute(
          path: AppRoutes.goToHome,
          name: 'goToHome',
          // Usage: context.go(AppRoutes.changePass, extra: 'Forget')
          pageBuilder: (_, state) =>
              MaterialPage(child: GoToHome(origin: state.extra as String?)),
        ),

        // ── Protected ─────────────────────────────────────────────────────────
        // GoRoute(
        //   path: AppRoutes.home,
        //   name: 'home',
        //   pageBuilder: (_, __) => const MaterialPage(
        //     // child: NavBar(),  // swap in your home widget
        //     child: Navbar(),
        //   ),
        // ),
        GoRoute(
          path: AppRoutes.wishlist,
          name: 'wishlist',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: WishlistView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.search,
          name: 'search',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: SearchView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.review,
          name: 'review',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: ReviewView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.product,
          name: 'product',
          pageBuilder: (_, __) => MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: ProductView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.filter,
          name: 'filter',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: FilterView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.commentReview,
          name: 'commentReview',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: CommentReviewView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.logout,
          name: 'logout',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: Logout(),
          ),
        ),
        GoRoute(
          path: AppRoutes.orderHistory,
          name: 'orderHistory',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: OrderHistory(),
          ),
        ),
        GoRoute(
          path: AppRoutes.paymentMethod,
          name: 'paymentMethod',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: PaymentView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.address,
          name: 'address',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: MyAddress(),
          ),
        ),
        GoRoute(
          path: AppRoutes.promoCode,
          name: 'promoCode',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: PromoCodeView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.trackOrder,
          name: 'trackOrder',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: TrackOrder(),
          ),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          name: 'editProfile',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: EditView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.addCard,
          name: 'addCard',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: AddNewCardView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.addAddress,
          name: 'addAddress',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: AddNewAddress(),
          ),
        ),
        GoRoute(
          path: AppRoutes.points,
          name: 'points',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: PointView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.order,
          name: 'order',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: OrderScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.payment,
          name: 'payment',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: PaymentMethodScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.shipping,
          name: 'shipping',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: ShippingDetailsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.checkout,
          name: 'checkout',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: CheckoutScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.addPromoCodeView,
          name: 'addPromoCodeView',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: AddPromoCodeView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.confirm,
          name: 'confirm',
          pageBuilder: (_, state) => MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: ConfirmOrderView(origin: state.extra as bool?),
          ),
        ),
        // '/order': (_) => const OrderScreen(),
        //     '/checkout': (_) => const CheckoutScreen(),
        //     '/shipping': (_) => const ShippingDetailsScreen(),
        //     '/payment': (_) => const PaymentMethodScreen(),
      ],

      // ── 404 ───────────────────────────────────────────────────────────────
      errorPageBuilder: (_, state) => MaterialPage(
        child: Scaffold(
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
      ),
    );
  }
}
