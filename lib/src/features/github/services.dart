part of github;

class GithubApiException implements Exception {
	final String message;
	final List<GithubError> errors;
	final String? documentationUrl;
	final String status;

	GithubApiException({required this.message, required this.errors, this.documentationUrl, required this.status});

	static GithubApiException fromJson(Map<String, dynamic> json) {
		return GithubApiException(
			message: json['message'],
			errors: List<Map<String, dynamic>>.from(json['errors']).map((githubError) => GithubError.fromJson(githubError)).toList(),
			documentationUrl: json['documentation_url'],
			status: json['status']
		);
	}

	@override
	String toString() => 'GithubApiException: $message';

}

class GithubError {
	String resource, code, field, message;
	GithubError({required this.resource, required this.code, required this.field, required this.message});

	static GithubError fromJson(Map<String, dynamic> json) {
		return GithubError(
			resource: json['resource'] ,
			code: json['code'],
			field: json['field'],
			message: json['message'],
		);
	}
}

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

	Future<Response> _getUser() async {
		String url = 'https://api.github.com/user';
		Map<String, String> headers = {
			'Authorization': accessToken
		};

		return await get(url, headers: headers);
	}

	Future<Response> _getRepos() async {
		String url = 'https://api.github.com/user/repos';
		Map<String, String> headers = {
			'Authorization': accessToken
		};

		return await get(url, headers: headers);
	}

	Future<Response> _createRepo({required String name, required bool private}) async {
		String url = 'https://api.github.com/user/repos';
		Map<String, String> headers = {
			'Authorization': accessToken
		};

		Map<String, dynamic> body = {
			'name': name,
			'private': private
		};

		return await post(url, body, headers: headers);
	}

}
