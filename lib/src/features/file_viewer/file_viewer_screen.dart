library file_viewer;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_manager/file_manager.dart';
import 'package:path_provider/path_provider.dart';

part 'file_viewer_binding.dart';
part 'file_viewer_controller.dart';

class FileViewerScreen extends GetView<FileViewerController> {
	const FileViewerScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Scaffold(
				appBar: AppBar(
					leading: Obx(
						() => controller.showBack.value ?
						IconButton(
							icon: const Icon(Icons.arrow_back),
							onPressed: controller.handleBack,
						) : Container()
					),
				),
				body: FileManager(
					controller: controller.fileManager,
					builder: (context, snapshot) {
						final List<FileSystemEntity> entities = snapshot;
						return ListView.builder(
							itemCount: entities.length,
							itemBuilder: (context, index) {
								return Card(
									child: ListTile(
										leading: FileManager.isFile(entities[index]) ? const Icon(Icons.feed_outlined) : const Icon(Icons.folder),
										title: Text(FileManager.basename(entities[index])),
										onTap: () { controller.handleOpenFile(entities[index]); },
									),
								);
							},
						);
					},
				),
			),
		);
	}

}
