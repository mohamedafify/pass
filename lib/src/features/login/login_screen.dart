library login;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passwordstore/src/config/routes.dart';
import 'package:passwordstore/src/constants/constants.dart';
import 'package:passwordstore/src/features/github/github.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passwordstore/src/shared_components/loading.dart';

part 'login_binding.dart';
part 'login_service.dart';
part 'login_controller.dart';

class LoginScreen extends GetView<LoginController> {
	const LoginScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Scaffold(
				body: Stack(
					children: [
						Center(
							child: InkWell(
								focusColor: Colors.transparent,
								hoverColor: Colors.transparent,
								splashColor: Colors.transparent,
								overlayColor: const MaterialStatePropertyAll(Colors.transparent),
								highlightColor: Colors.transparent,
								onTap: () { controller.init(true); },
								child: Container(
									padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
									decoration: BoxDecoration(
										color: Colors.black,
										borderRadius: BorderRadius.circular(17)
									),
									child: const Row(
										mainAxisSize: MainAxisSize.min,
										mainAxisAlignment: MainAxisAlignment.spaceEvenly,
										children: [
											FaIcon(FontAwesomeIcons.github, color: Colors.white),
											SizedBox(width: 10),
											Text("Login")
										]
									)
								)
							)
						),
						Obx(() => showLoading()),
					],
				),
			),
		);
	}

	Widget showLoading() {
		return controller.isLoading.value ? Loading() : Container();
	}
}
