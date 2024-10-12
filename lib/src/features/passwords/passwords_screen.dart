library passwords;

import 'dart:developer';
import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passwordstore/src/constants/constants.dart';
import 'package:passwordstore/src/features/gpg/gpg.dart';
import 'package:passwordstore/src/features/settings/settings_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'passwords_controller.dart';

class PasswordsScreen extends GetView<PasswordsController> {
	const PasswordsScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Scaffold(
				appBar: AppBar(
					leading: Obx(() => controller.showBack.value ? IconButton(
						icon: const Icon(Icons.arrow_back),
						onPressed: controller.handleBack,
					) : Container()
				)),
				body: Container(
					padding: const EdgeInsets.symmetric(horizontal: kSpacing),
					child:FileManager(
						controller: controller.fileManager,
						builder: (context, snapshot) {
							final List<FileSystemEntity> entities = snapshot;
							return ListView.builder(
								itemCount: entities.length,
								shrinkWrap: true,
								itemBuilder: (BuildContext context, int index) => _buildPassword(entities, index),
							);
						},
					)
				),
			)
		);
	}

	Widget _buildPassword(List<FileSystemEntity> entities, int index) {
		String item = basename(entities[index].path);
		return Card(
			child: ListTile(
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(kBorderRadius)
				),
				style: ListTileStyle.drawer,
				onTap: () { controller.handleOpenFile(entities[index]); },
				title: Text(item)
			)
		);
	}

}

Widget _buildDecryptedPassword(String encyptedText) {
	String password = encyptedText.split('\n')[0];
	String username = encyptedText.split('\n')[1];
	return Dialog(
		child: Container(
			padding: const EdgeInsets.all(kSpacing),
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					TextField(
						enabled: false,
						decoration: const InputDecoration(
							label: Text('Username'),
						),
						controller: TextEditingController(text: username),
					),
					const SizedBox(height: kSmallSpacing),
					Row(
						children: [
							Expanded(child:TextField(
								enabled: false,
								decoration: const InputDecoration(
									label: Text('Password'),
								),
								controller: TextEditingController(text: password),
							)),
							IconButton(
								padding: EdgeInsets.zero,
								icon: const Icon(Icons.copy, size: 20),
								onPressed: () {
									Clipboard.setData(ClipboardData(text: password));
								},
							),
						],
					),
				],
			)
		),
	);
}
