library home;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passwordstore/src/constants/constants.dart';

import 'package:passwordstore/src/features/github/github.dart';
import 'package:passwordstore/src/features/passwords/passwords_screen.dart';
import 'package:passwordstore/src/features/settings/settings_screen.dart';
import 'package:passwordstore/src/shared_components/floating_action_button.dart';

part 'home_binding.dart';
part 'home_service.dart';
part 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
	const HomeScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Scaffold(
				floatingActionButtonAnimator: NoScalingAnimation(context: context),
  				floatingActionButtonLocation: FixedCenterDockedFabLocation(context: context),
  				floatingActionButton: FloatingActionButton(
  					elevation: 2,
  					shape: const CircleBorder(),
  					onPressed: controller.addNewPassword,
  					child: const Icon(Icons.add),
  				),
				bottomNavigationBar: Obx(()=> BottomAppBar(
					shape: const CircularNotchedRectangle(),
					notchMargin: 10,
					height: 55,
					padding: EdgeInsets.zero,
					child: Row(
						mainAxisSize: MainAxisSize.max,
						mainAxisAlignment: MainAxisAlignment.spaceAround,
						children: [
							IconButton(onPressed: (){ controller.selectedIndex.value = 0; }, icon: Icon(Icons.password, color: controller.selectedIndex.value == 0 ? green : white,)),
							IconButton(onPressed: (){ controller.selectedIndex.value = 1; }, icon: Icon(Icons.settings, color: controller.selectedIndex.value == 1 ? green : white,)),
						],
					),
				)),
				body: Obx(()=>IndexedStack(
					index: controller.selectedIndex.value,
					children: const [
						PasswordsScreen(),
						SettingsScreen(),
					],
				)),
			),
		);
	}

}

