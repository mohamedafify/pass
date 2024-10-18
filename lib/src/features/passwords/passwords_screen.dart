library passwords;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passwordstore/src/constants/constants.dart';
import 'package:passwordstore/src/features/github/github.dart';
import 'package:passwordstore/src/features/gpg/gpg.dart';
import 'package:passwordstore/src/features/home/home_screen.dart';
import 'package:passwordstore/src/features/settings/settings_screen.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'passwords_controller.dart';

class PasswordsScreen extends GetView<PasswordsController> {
	const PasswordsScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return PopScope(
			canPop: false,
			onPopInvoked: ((didPop) {
				final homeController = Get.find<HomeController>();
				// disable backing from settings page
				homeController.selectedIndex.value == 0 &&
					controller.showBack.value ? controller.handleBack() : null; 
			}) ,
			child: SafeArea(
				child: Scaffold(
					appBar: PreferredSize(
						preferredSize: const Size(double.infinity, 50),
						child: Container(
							margin: const EdgeInsets.fromLTRB(kSpacing, 0, kSpacing, 0),
							child: Row(
								children: [
									Obx(() => controller.showBack.value ?  IconButton(
										padding: EdgeInsets.zero,
										icon: const Icon(Icons.arrow_back),
										onPressed: controller.handleBack,
									) : Container()),
									Expanded(child:SearchBar(
										controller: controller.searchController,
										onChanged: controller.search,
										leading: const Icon(Icons.search),
										trailing: [
											IconButton(
												padding: EdgeInsets.zero,
												onPressed: controller.clearSearch,
												icon: const Icon(Icons.close)
											)
										],
										shape: MaterialStatePropertyAll(RoundedRectangleBorder(
											borderRadius: BorderRadius.circular(kSpacing)
										)),
									)),
								],
							)
						),
					),
					body: Container(
						padding: const EdgeInsets.symmetric(horizontal: kSpacing),
						child: Obx(()=>ListView.builder(
							itemCount: controller.currentDirectory.value.length,
							shrinkWrap: true,
							itemBuilder: (BuildContext context, int index) => _buildPassword(controller.currentDirectory.value, index),
						))
					),
				)
			)
		);
	}

	Widget _buildPassword(List<FileSystemEntity> entities, int index) {
		String item = path.basenameWithoutExtension(entities[index].path);
		return Card(
			child: ListTile(
				leading: (entities[index] is Directory) ? const Icon(Icons.folder) : const Icon(Icons.password),
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
