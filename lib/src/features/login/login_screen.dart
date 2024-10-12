library login;

import 'package:passwordstore/src/constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passwordstore/src/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
						Obx(() => showLoading(controller)),
					],
				),
			),
		);
	}
}

Widget showLoading(LoginController controller) {
	return controller.isLoading.value ? Loading() : Container();
}

Dialog _buildReposDialog(List<GithubRepo> list) {
	LoginController controller = Get.find<LoginController>();

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
	LoginController controller = Get.find<LoginController>();
	return Container(
		margin: const EdgeInsets.symmetric(horizontal: kSmallSpacing),
		width: double.infinity,
		child: TextButton(
			onPressed: (){ controller.cloneRepo(repo); },
			child: Text(repo.name)
		)
	);
}

