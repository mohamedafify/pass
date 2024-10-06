part of login;

class LoginProvider extends GetConnect {
	Future<Response> pingGoogle() async {
		return await get('https://www.google.com');
	}
}
