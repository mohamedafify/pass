part of settings;


class SettingsController extends GetxController {
	String? privateKey;
	String? publicKey;
	String? privateKeyPassphrase;

	RxBool privateKeySet = false.obs;
	RxBool publicKeySet = false.obs;

	@override
	onInit() {
		super.onInit();
		privateKeyPassphrase = GetStorage().read('privateKeyPassphrase');
		privateKey = GetStorage().read('privateKey');
		if (privateKey != null) {
			privateKeySet.value = true;
		}
		publicKey = GetStorage().read('publicKey');
		if (publicKey != null) {
			publicKeySet.value = true;
		}
	}

	void pickPublicKey() async {
		FilePickerResult? pickedPublicKey = await FilePicker.platform.pickFiles();
		if (pickedPublicKey != null) {
			File publickeyFile = File(pickedPublicKey.files.single.path!);
			String tempPublicKey = await publickeyFile.readAsString();
			bool isValid = GPG.validatePublicKey(tempPublicKey);
			if (isValid) {
				publicKey = tempPublicKey;
				publicKeySet.value = true;
				GetStorage().write('publicKey', publicKey);
			} else {
				Get.snackbar('Error', 'Public key is not valid');
			}
		}
	}

	void pickPrivateKey() async {
		FilePickerResult? pickedPrivateKey = await FilePicker.platform.pickFiles();
		if (pickedPrivateKey != null) {
			File privatekeyFile = File(pickedPrivateKey.files.single.path!);
			String tempPrivateKey = await privatekeyFile.readAsString();
			bool isValid = GPG.validatePrivateKey(tempPrivateKey);
			if (isValid) {
				String? passphrase = await showDialog(
					barrierDismissible: false,
					context: Get.context!,
					builder: _buildSetPrivateKeyPassphrase
				);
				if (passphrase != null) {
					privateKeyPassphrase = passphrase;
					GetStorage().write('privateKeyPassphrase', passphrase);
					privateKey = tempPrivateKey;
					privateKeySet.value = true;
					GetStorage().write('privateKey', privateKey);
				}
			} else {
				Get.snackbar('Error', 'Private key is not valid');
			}
		}
	}

	Future<void> wipe() async {
		Directory? storageDirectory = await getExternalStorageDirectory();
		if (storageDirectory != null) {
			String? repoName = GetStorage().read('repoCloned');
			if (repoName != null) {
				Directory repoDirectory = Directory.fromUri(Uri.parse('${storageDirectory.path}/$repoName'));
				bool exists = await repoDirectory.exists();
				if (exists) {
					await repoDirectory.delete(recursive: true);
				}
			}
		}
		GetStorage().erase();
	}
}
