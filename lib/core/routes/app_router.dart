import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: OnboardingScheduleRoute.page),
    AutoRoute(page: OnboardingCommunityRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: VerifyEmailRoute.page),
    AutoRoute(page: AccountReadyRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
  ];
}
