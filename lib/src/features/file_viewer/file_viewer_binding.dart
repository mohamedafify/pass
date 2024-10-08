part of file_viewer;

class FileViewerBinding extends Bindings {
	@override
	void dependencies() {
		Get.put(FileViewerController());
	}
}
