part of github;

class GithubService extends GetConnect {
	late String accessToken;

	GithubService({required String accessToken}) {
		this.accessToken = 'bearer $accessToken';
	}

	Future<bool> _hasValidToken() async {
		String url = 'https://api.github.com/rate_limit';
		Map<String, String> headers = {
			'Authorization': accessToken
		};
		Response<dynamic> response = await get(url, headers: headers);
		return response.isOk;
	}

	Future<GithubUser?> _getUser() async {
		String url = 'https://api.github.com/user';
		Map<String, String> headers = {
			'Authorization': accessToken
		};
		Response<dynamic> response = await get(url, headers: headers);
		if (response.isOk) {
			return GithubUser(name: response.body['name'], email: response.body['email']);
		}
		return null;
	}

}
