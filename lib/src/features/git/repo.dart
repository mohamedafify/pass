part of git;

class GitRepo {
	String name;
	String cloneUrl;
	String token;

	GitRepo({required this.name, required this.cloneUrl, required this.token});

	Future<bool> clone() async {
		Directory tempDirectory = await getTemporaryDirectory();
 		String tempPath = tempDirectory.path;
 		String newRepoPath = '$tempPath/$name';
		Directory newRepoDirectory = Directory.fromUri(Uri.parse(newRepoPath));
		if (await newRepoDirectory.exists()) {
			Get.snackbar('Clone', 'Repository already exists');
			return false;
		} else {
			newRepoDirectory = await newRepoDirectory.create();
		}
 		final git = Git();
 		bool cloned = await git.clone(cloneUrl, newRepoDirectory.path, token);
 		return cloned;
	}
}
