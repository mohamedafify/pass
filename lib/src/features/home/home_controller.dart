part of home;


class HomeController extends GetxController {
	RxBool isLoading = false.obs;
	Github? github;

	RxInt selectedIndex = 0.obs;
	void changeTabIndex(int index) {
		selectedIndex.value = index;
	}

	@override
	onInit() async {
		super.onInit();
		Github? github = await Github.getInstance();

		if (github != null) {
			GithubRepo repo = GithubRepo.fromJson(jsonDecode(GetStorage().read('repoCloned')));
		}
	}

}
