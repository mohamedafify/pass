part of home;


class HomeController extends GetxController {
	RxBool isLoading = false.obs;
	Github? github;

	RxInt selectedIndex = 0.obs;
	void changeTabIndex(int index) {
		selectedIndex.value = index;
	}

	void addNewPassword() {
		final password = Get.find<PasswordsController>();
		password.addNewPassword();
	}

}
