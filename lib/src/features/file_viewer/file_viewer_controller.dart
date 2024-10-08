part of file_viewer;

class FileViewerController extends GetxController {

	final FileManagerController fileManager = FileManagerController();
	Directory? directory;
	RxBool showBack = false.obs;

 	@override
 	onInit() async {
 		super.onInit();
		directory = await getExternalStorageDirectory();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (directory != null) {
				fileManager.openDirectory(directory!);
			}
		});
	}

	void handleBack() async {
		await fileManager.goToParentDirectory();
		updateBackButton();
	}

	void handleOpenFile(entry) {
		if (FileManager.isDirectory(entry)) {
			fileManager.openDirectory(entry);
			updateBackButton();
		}
	}

	void updateBackButton() {
		showBack.value = fileManager.getCurrentPath != directory!.path;
	}
}
