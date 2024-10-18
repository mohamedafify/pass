part of git;

class GitRepo {
	String name;
	String cloneUrl;
	String token;
	String? repoPath;

	GitRepo({required this.name, required this.cloneUrl, required this.token, this.repoPath});

	Future<bool> clone() async {
		Directory? storageDirectory = await getExternalStorageDirectory();
		if (storageDirectory != null) {
			String tempPath = storageDirectory.path;
			String newRepoPath = '$tempPath/$name';
			Directory newRepoDirectory = Directory.fromUri(Uri.parse(newRepoPath));
			if (await newRepoDirectory.exists()) {
				Get.snackbar('Clone', 'Repository already exists');
				return false;
			} else {
				newRepoDirectory = await newRepoDirectory.create();
			}
			bool cloned = await Git.clone(cloneUrl, newRepoDirectory.path, token);
			repoPath = newRepoDirectory.path;
			return cloned;
		} else {
			throw Exception('Failed to get directory');
		}
	}

	Future<void> pull({ String branchName = 'main' }) async {
		Directory? storageDirectory = await getExternalStorageDirectory();
		if (storageDirectory != null) {
			if (repoPath != null) {
				await Git.pull(branchName, token, repoPath!);
			} else {
				throw Exception("repo path is null");
			}
		} else {
			throw Exception('Failed to get directory');
		}
	}
}
