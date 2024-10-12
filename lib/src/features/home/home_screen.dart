library home;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:passwordstore/src/features/github/github.dart';
import 'package:passwordstore/src/features/passwords/passwords_screen.dart';
import 'package:passwordstore/src/features/settings/settings_screen.dart';
import 'package:passwordstore/src/shared_components/loading.dart';

part 'home_binding.dart';
part 'home_service.dart';
part 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
	const HomeScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Scaffold(
//  				floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//  				floatingActionButton: FloatingActionButton(
//  					elevation: 2,
//  					shape: const CircleBorder(),
//  					child: const Icon(Icons.add),
//  					onPressed: () { },
//  				),
				bottomNavigationBar: Obx(()=>BottomNavigationBar(
					currentIndex: controller.selectedIndex.value,
					onTap: (index) {
						controller.changeTabIndex(index);
					},
					items: const <BottomNavigationBarItem>[
						BottomNavigationBarItem(icon: Icon(Icons.password), label: "Passwords"),
						BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
					],
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

