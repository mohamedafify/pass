part of github;

class GithubRepo extends GitRepo {
	bool private;
	String apiUrl;
	String htmlUrl;
	String sshUrl;

	GithubRepo({
		required this.private,
		required this.apiUrl,
		required this.htmlUrl,
		required this.sshUrl,
		required super.name,
		required super.cloneUrl
	});

	static GithubRepo fromJson(Map<String, dynamic> json, String token) {
		// append token to clone url
		String url = json['clone_url'];
		var arr = url.split('https://');
		String cloneUrl = 'https://$token@${arr[1]}';

		return GithubRepo(
			name: json['name'],
			private: json['private'],
			apiUrl: json['url'],
			htmlUrl: json['html_url'],
			cloneUrl: cloneUrl,
			sshUrl: json['ssh_url'],
		);
	}
}
