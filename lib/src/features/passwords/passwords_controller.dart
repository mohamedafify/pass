part of passwords;


class PasswordsController extends GetxController {
	Directory? passDirectory;
	RxBool showBack = false.obs;
	TextEditingController searchController = TextEditingController();
	List<FileSystemEntity> rootDirectory = List<FileSystemEntity>.empty();
	RxList<FileSystemEntity> currentDirectory = List<FileSystemEntity>.empty().obs;
	RxString currentPath = "".obs;

	@override
	onInit() async {
		super.onInit();

		Directory? storageDirectory = await getExternalStorageDirectory();
		if (storageDirectory != null) {
			Github? github = await Github.getInstance();
			if (github != null) {
				GithubRepo repo = GithubRepo.fromJson(jsonDecode(GetStorage().read('repoCloned')));
				passDirectory = Directory.fromUri(Uri.parse(repo.repoPath!));
				if (await passDirectory!.exists()) {
					currentDirectory.value = passDirectory!.listSync().where((element) { return !element.path.contains('.git'); }).toList();
 					rootDirectory = currentDirectory.value;
					currentPath.value = passDirectory!.path;
				}
			}
		}
	}

	void search(String? text) async {
		if (text == null || text.isEmpty) {
			currentDirectory.value = rootDirectory;
			return;
		}

		List<FileSystemEntity> result = [];
		await for (FileSystemEntity entity in Stream.fromIterable(rootDirectory)) {
			if (!entity.path.contains('.git') && entity.path.toLowerCase().contains(text.toLowerCase())) {
				result.add(entity);
			}
		}

		currentDirectory.value = result;
	}

	void clearSearch() {
		searchController.clear();
		FocusScope.of(Get.context!).unfocus();
		currentDirectory.value = rootDirectory;
	}

	void handleBack() async {
		if (searchController.text.isNotEmpty) {
			search(searchController.text);
		}
		openDirectory(Directory(currentPath.value).parent);
		updateBackButton();
	}

	String getFileExtension(FileSystemEntity file) {
		return file.path.split("/").last.split('.').last;
	}

	void openDirectory(Directory directory) {
		currentDirectory.value = directory.listSync().where((element) { return !element.path.contains('.git'); }).toList();
		currentPath.value = directory.path;
	}

	Future<void> handleOpenFile(FileSystemEntity entry) async {
		if (entry is Directory) {
			openDirectory(entry);
			updateBackButton();
		} else if (entry is File) {
			String ext = getFileExtension(entry);
			if (ext == 'gpg') {
				SettingsController settings = Get.find<SettingsController>();
				if (settings.publicKey == null) {
					Get.snackbar('GPG key error', 'You must setup your public key first');
					return;
				}
				if (settings.privateKey == null) {
					Get.snackbar('GPG key error', 'You must setup your private key first');
					return;
				}
				if (settings.privateKeyPassphrase == null) {
					Get.snackbar('GPG key error', 'private key passphrase is not set');
					return;
				}
				GPG gpg = GPG(
					passphrase: settings.privateKeyPassphrase!,
					publickey: settings.publicKey!,
					privatekey: settings.privateKey!,
				);
				try {
 					String password = await gpg.decryptFile(file: entry);
 					showDialog(context: Get.context!, builder: (context) => _buildDecryptedPassword(password));
				} catch (error) {
 					Get.snackbar('GPG error', 'Please make sure you setup public and private key correctly with the passphrase');
				}
			}
		}
	}

	void updateBackButton() {
		showBack.value = currentPath.value != passDirectory!.path;
	}

}
