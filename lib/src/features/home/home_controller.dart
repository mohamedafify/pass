part of home;


class HomeController extends GetxController {
	RxBool isLoading = false.obs;
	Github? github;

	@override
	onInit() async {
		super.onInit();
	}

	showRepos() async {
		isLoading.value = true;
		github = await Github.getInstance();
		if (github != null) {
			List<GithubRepo>? repos = await github!.getRepos();
			isLoading.value = false;
			if (repos == null) {
				Get.snackbar('Error', 'Failed to get repos');
				return;
			}
			showDialog(
				context: Get.context!,
				builder: (BuildContext context) => _buildReposDialog(repos),
			);
		} else {
			isLoading.value = false;
			Get.snackbar('Error', 'Failed to connect with github');
		}
	}

	void cloneRepo(GithubRepo repo) {
		repo.clone();
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
			isLoading.value = false;
			inspect(repo);
		} on GithubApiException catch (error) {
			isLoading.value = false;
 			Get.snackbar(error.message, error.errors[0].message);
			return;
		}
	}

}
