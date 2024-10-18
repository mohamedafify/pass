library settings;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passwordstore/src/features/github/github.dart';
import 'package:passwordstore/src/features/gpg/gpg.dart';
import 'package:passwordstore/src/features/passwords/passwords_screen.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passwordstore/src/constants/constants.dart';
import 'package:path_provider/path_provider.dart';

part 'settings_controller.dart';



class SettingsScreen extends GetView<SettingsController> {
	const SettingsScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Container(
				padding: const EdgeInsets.all(kSpacing),
				child: Column(
					children: [
						Row(
							children: [
								Expanded(child:TextButton.icon(
									onPressed: controller.pickPublicKey,
									icon: const Icon(Icons.public),
									label: const Text('Set public key')
								)),
								Obx(() =>  Icon(Icons.done, color: controller.publicKeySet.value ? Colors.green : Colors.grey)),
							],
						),
						Row(
							children: [
								Expanded(child:TextButton.icon(
									onPressed: controller.pickPrivateKey,
									icon: const Icon(Icons.key),
									label: const Text('Set private key')
								)),
								Obx(() =>  Icon(Icons.done, color: controller.privateKeySet.value ? Colors.green : Colors.grey)),
							],
						),
 						TextButton.icon(onPressed: controller.pull, icon: const Icon(Icons.sync), label: const Text('Get updates')),
					]
				)
			)
		);
	}
}

Dialog _buildSetPrivateKeyPassphrase(BuildContext context) {
	TextEditingController newRepoController = TextEditingController();
	GlobalKey<FormState> newRepoFormKey = GlobalKey<FormState>();
	return Dialog(
		child: Form(
			key: newRepoFormKey,
			child:Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(
						margin: const EdgeInsets.fromLTRB(kSpacing, kSpacing, kSpacing, 0),
						child: TextFormField(
							decoration: const InputDecoration(
								labelText: "Passphrase",
							),
							autovalidateMode: AutovalidateMode.onUserInteraction,
							validator: (value) {
								if (value != null) { 
									return value.isEmpty ? "Required" : null;
								} else {
									return "Required";
								}
							},
							controller: newRepoController,
						),
					),
					Row(
						children: [
							Expanded(
								child: Container(
									margin: const EdgeInsets.symmetric(horizontal: kSpacing, vertical: kSmallSpacing),
									child: TextButton.icon(
										style: const ButtonStyle(
											backgroundColor: MaterialStatePropertyAll(green),
										),
										label: const Text("Confirm"),
										onPressed: () { 
											if (newRepoFormKey.currentState!.validate()) {
												Get.back(result: newRepoController.text);
											}
										},
										icon: const Icon(Icons.done)
									)
								)
							),
							Expanded(
								child: Container(
									margin: const EdgeInsets.symmetric(horizontal: kSpacing, vertical: kSmallSpacing),
									child: TextButton.icon(
										style: const ButtonStyle(
											backgroundColor: MaterialStatePropertyAll(red),
										),
										label: const Text("Cancel"),
										onPressed: (){ Get.back(); },
										icon: const Icon(Icons.close)
									)
								)
							),
						],
					)
				],
			)
		),
	);
}
