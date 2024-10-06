part of routes;

class Pages {
	static const initial = Routes.login;
	static const _transition = Transition.cupertino;

	static final routes = [
		GetPage(
			name: Routes.home,
			page: () => const HomeScreen(),
			binding: HomeBinding(),
			transition: _transition
		),
		GetPage(
			name: Routes.login,
			page: () => const LoginScreen(),
			binding: LoginBinding(),
			transition: _transition
		),
	];
}
