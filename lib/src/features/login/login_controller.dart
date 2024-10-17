part of login;


class LoginController extends GetxController {
	RxBool isLoading = false.obs;
	Github? github;


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
			isLoading.value = false;
			if (github != null) {
				String? repoCloned = GetStorage().read('repoCloned');
				if (repoCloned != null) {
					GithubRepo repo = GithubRepo.fromJson(jsonDecode(GetStorage().read('repoCloned')));
					isLoading.value = true;
					await repo.pull();
					isLoading.value = false;
					Get.offAllNamed(Routes.home);
				} else {
					await showRepos(github);
				}
				return;
			} else {
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

	Future<void> showRepos(Github github) async {
		isLoading.value = true;
		List<GithubRepo>? repos = await github.getRepos();
		isLoading.value = false;
		if (repos == null) {
			Get.snackbar('Error', 'Failed to get repos');
			return;
		}
		showDialog(
			context: Get.context!,
			builder: (BuildContext context) => _buildReposDialog(repos),
		);
	}

	Future<void> cloneRepo(GithubRepo repo) async {
		isLoading.value = true;
		try {
			bool cloned = await repo.clone();
			if (cloned) {
				GetStorage().write('repoCloned', repo.toJson());
				Get.offAllNamed(Routes.home);
			} else {
				Get.snackbar('Error', 'Failed to clone :(');
			}
		} catch (error) {
			Get.snackbar('Error', 'Failed to clone :(');
		} finally {
			isLoading.value = false;
		}
	}

	Future<void> createNewRepo() async {
		String newRepoName = await showDialog(
			barrierDismissible: false,
			context: Get.context!,
			builder: _buildNewRepoName
		);

		if (github == null) {
			Get.snackbar('Error', 'Failed to intialize github');
			return;
		}

		isLoading.value = true;
		try {
			GithubRepo? repo = await github!.createRepo(name: newRepoName);
			await cloneRepo(repo);
			isLoading.value = false;
		} on GithubApiException catch (error) {
			isLoading.value = false;
			Get.snackbar(error.message, error.errors[0].message);
			return;
		}
	}

}
