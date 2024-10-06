library home;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passwordstore/src/constants/constants.dart';

part 'home_binding.dart';
part 'home_service.dart';
part 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
	const HomeScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: true,
				),
				floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
				floatingActionButton: FloatingActionButton(
					elevation: 2,
					shape: const CircleBorder(),
					child: const Icon(Icons.add),
					onPressed: () { },
				),
				bottomNavigationBar: BottomAppBar(
					elevation: 7,
					padding: const EdgeInsets.symmetric(horizontal: kSpacing),
 					height: 60,
					child: Row(
						mainAxisAlignment: MainAxisAlignment.spaceAround,
						children: [
							_buildBottomAppBarItem(label: "Home", icon: Icons.home, onPressed: (){}),
 							_buildBottomAppBarItem(label: "Items", icon: Icons.list, onPressed: (){}),
 							_buildBottomAppBarItem(label: "Search", icon: Icons.search, onPressed: (){}),
						],
					)
				),
			),
		);
	}
}

Widget _buildBottomAppBarItem({required String label, required IconData icon, required void Function() onPressed}) {
	return InkWell(
		onTap: onPressed,
		child:Column(
			mainAxisSize: MainAxisSize.min,
			children: <Widget>[
				Icon(icon, size: 23),
				Flexible(child: Text(label, style: const TextStyle(fontSize: 12),))
			],
		)
	);
}
