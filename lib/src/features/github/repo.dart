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
		required super.cloneUrl,
		required super.token,
		super.repoPath
	});

	static GithubRepo fromJson(Map<String, dynamic> json, { String? token }) {
		return GithubRepo(
			name: json['name'],
			private: json['private'],
			apiUrl: json['url'],
			htmlUrl: json['html_url'],
			cloneUrl: json['clone_url'],
			sshUrl: json['ssh_url'],
			repoPath: json['repo_path'],
			token: token ?? json['token'],
		);
	}

	String toJson() {
		Map<String, dynamic> json = {
			"name": name,
			"private": private,
			"url": apiUrl,
			"html_url": htmlUrl,
			"clone_url": cloneUrl,
			"ssh_url": sshUrl,
			"token": token,
			"repo_path": repoPath,
		};
		return jsonEncode(json);
	}
}
