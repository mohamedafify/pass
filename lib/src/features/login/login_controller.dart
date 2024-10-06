part of login;


class LoginController extends GetxController {
	RxBool isLoading = false.obs;

	@override
	onInit() async {
		super.onInit();

		if (authenticated()) {
			final LocalAuthentication auth = LocalAuthentication();
			final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
			final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
			if (canAuthenticate) {
				isLoading.value = true;
				bool authenticated = await auth.authenticate(localizedReason: 'Login');
				isLoading.value = false;
				if (authenticated) {
					await init(false);
				}
			} else {
				await init(false);
			}
		}

	}

	bool authenticated() {
		String? token = GetStorage().read(githubTokenKey);
		return token != null;
	}

	Future<bool> connectedToInternet() async {
		LoginProvider service = Get.find<LoginProvider>();
		Response res = await service.pingGoogle();
		return res.isOk;
	}

	Future<void> init(bool isFirstTime) async {
		// if connected to the internet start authentication process
		isLoading.value = true;
		bool connected = await connectedToInternet();
		if (connected) {
			Github? github = await Github.getInstance();
			if (github != null) {
				GithubUser? user = await github.getUser();
				isLoading.value = false;
				Get.offAllNamed(Routes.home);
				if (user != null) {
					Get.snackbar('Authenticated successfully', 'Welcome ${user.name} :)');
				}
				return;
			} else {
				isLoading.value = false;
				Get.offAllNamed(Routes.home);
				Get.snackbar('Authentication failed', 'Sry there was an error during authentication, try again later');
				return;
			}
		} else {
			if (!isFirstTime) {
				isLoading.value = false;
				Get.offAllNamed(Routes.home);
			}
			isLoading.value = false;
			Get.snackbar('Status', 'You are currently offline, please connect to the internet to sync your data');
			return;
		}
	}
}
