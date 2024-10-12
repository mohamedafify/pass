part of passwords;


class PasswordsController extends GetxController {
	final FileManagerController fileManager = FileManagerController();
	Directory? passDirectory;
	RxBool showBack = false.obs;

	@override
	onInit() async {
		super.onInit();

		Directory? storageDirectory = await getExternalStorageDirectory();
		if (storageDirectory != null) {
			String repoCloned = GetStorage().read('repoCloned');
			passDirectory = Directory.fromUri(Uri.parse("${storageDirectory.path}/$repoCloned"));
			if (await passDirectory!.exists()) {
				WidgetsBinding.instance.addPostFrameCallback((_) {
					fileManager.openDirectory(passDirectory!);
				});
			}
		}
	}

	void handleBack() async {
		await fileManager.goToParentDirectory();
		updateBackButton();
	}

	Future<void> handleOpenFile(FileSystemEntity entry) async {
		if (FileManager.isDirectory(entry)) {
			fileManager.openDirectory(entry);
			fileManager.setCurrentPath = entry.path;
			updateBackButton();
		} else if (FileManager.isFile(entry)) {
			String ext = FileManager.getFileExtension(entry);
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
		showBack.value = fileManager.getCurrentPath != passDirectory!.path;
	}

}
