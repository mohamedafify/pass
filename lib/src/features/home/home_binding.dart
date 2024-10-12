part of home;

class HomeBinding extends Bindings {
	@override
	void dependencies() {
		Get.put(HomeController());
		Get.put(PasswordsController());
		Get.put(SettingsController());
	}
}
