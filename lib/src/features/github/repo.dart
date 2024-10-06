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

	static GithubRepo fromJson(Map<String, dynamic> json) {
		return GithubRepo(
			name: json['name'],
			private: json['private'],
			apiUrl: json['url'],
			htmlUrl: json['html_url'],
			cloneUrl: json['clone_url'],
			sshUrl: json['ssh_url'],
		);
	}
}
