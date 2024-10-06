class GitRepo {
	String name;
	String cloneUrl;
	GitRepo({required this.name, required this.cloneUrl});

	void clone() {
		//TODO use cloneUrl to get repo
		throw UnimplementedError();
	}
}
