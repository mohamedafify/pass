part of git;

class GitRepo {
	String name;
	String cloneUrl;

	GitRepo({required this.name, required this.cloneUrl});

	Future<bool> clone() async {
		Directory tempDirectory = await getTemporaryDirectory();
 		String tempPath = tempDirectory.path;
 		String newRepoPath = '$tempPath/$name';
 		Directory repoDirectory = await Directory.fromUri(Uri.parse(newRepoPath)).create();
 		final git = Git();
 		bool cloned = await git.clone(cloneUrl, repoDirectory.path);
 		return cloned;
	}
}
