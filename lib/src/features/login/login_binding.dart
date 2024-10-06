part of login;

class LoginBinding extends Bindings {
	@override
	void dependencies() {
		Get.put(LoginController());
		Get.put(LoginProvider());
	}
}
