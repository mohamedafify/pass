library home;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:passwordstore/src/constants/constants.dart';
import 'package:passwordstore/src/features/github/github.dart';
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
				appBar: AppBar(
					automaticallyImplyLeading: true,
				),
				floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
				floatingActionButton: FloatingActionButton(
					elevation: 2,
					shape: const CircleBorder(),
					child: const Icon(Icons.add),
					onPressed: () { controller.showRepos(); },
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
				body: Stack(
					children: [
						Obx(()=>showLoading(controller)),
					],
				),
			),
		);
	}

}

Widget showLoading(HomeController controller) {
	return controller.isLoading.value ? Loading() : Container();
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

Dialog _buildReposDialog(List<GithubRepo> list) {
	HomeController controller = Get.find<HomeController>();

	const String githubAddIcon = '''
		<svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-repo">
			<path d="M2 2.5A2.5 2.5 0 0 1 4.5 0h8.75a.75.75 0 0 1 .75.75v12.5a.75.75 0 0 1-.75.75h-2.5a.75.75 0 0 1 0-1.5h1.75v-2h-8a1 1 0 0 0-.714 1.7.75.75 0 1 1-1.072 1.05A2.495 2.495 0 0 1 2 11.5Zm10.5-1h-8a1 1 0 0 0-1 1v6.708A2.486 2.486 0 0 1 4.5 9h8ZM5 12.25a.25.25 0 0 1 .25-.25h3.5a.25.25 0 0 1 .25.25v3.25a.25.25 0 0 1-.4.2l-1.45-1.087a.249.249 0 0 0-.3 0L5.4 15.7a.25.25 0 0 1-.4-.2Z"></path>
		</svg>
	''';

	return Dialog(
		shape: const RoundedRectangleBorder(
			borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))
		),
		child: Stack(
			children: [
				Column(
					children: [
						Container(
							padding: const EdgeInsets.all(kSpacing),
							child: const Text("Choose your repository", style: TextStyle(fontSize: kFontBigSize, fontWeight: FontWeight.w500)),
						),
						const Divider(height: 0.1, color: black),
						Container(
							margin: const EdgeInsets.symmetric(horizontal: kSmallSpacing),
							width: double.infinity,
							child: TextButton.icon(
								style: const ButtonStyle(
									backgroundColor: MaterialStatePropertyAll(green),
								),
								label: const Text("Create new repository"),
								icon: SvgPicture.string(
									githubAddIcon,
									width: 20,
									height: 20,
									color: white,
								),
								onPressed: () { controller.createNewRepo(); },
							),
						),
						Expanded(child:SingleChildScrollView(
							child: Column(
								mainAxisSize: MainAxisSize.max,
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children: list.map((repo) => repoWidget(repo)).toList(),
							)
						))
					],
				),
				Obx(() => showLoading(controller)),
			],
		),
	);
}

Dialog _buildNewRepoName(BuildContext context) {
	TextEditingController newRepoController = TextEditingController();
	GlobalKey<FormState> newRepoFormKey = GlobalKey<FormState>();
	return Dialog(
		child: Form(
			key: newRepoFormKey,
			child:Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(
						padding: const EdgeInsets.all(kSpacing),
						child: const Text("New repository Name"),
					),
					Container(
						margin: const EdgeInsets.symmetric(horizontal: kSpacing),
						child: TextFormField(
							autovalidateMode: AutovalidateMode.onUserInteraction,
							validator: (value) {
								if (value != null) { 
									return value.isEmpty ? "Fill data" : null;
								} else {
									return "Fill data";
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

Widget repoWidget(GithubRepo repo) {
	HomeController controller = Get.find<HomeController>();
	return Container(
		margin: const EdgeInsets.symmetric(horizontal: kSmallSpacing),
		width: double.infinity,
		child: TextButton(
			onPressed: (){ controller.cloneRepo(repo); },
			child: Text(repo.name)
		)
	);
}
