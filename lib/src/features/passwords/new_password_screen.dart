part of passwords;

class NewPasswordScreen extends GetView<PasswordsController> {
	const NewPasswordScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: true,
				),
				body: CustomScrollView(
					slivers: [
						SliverFillRemaining(
							hasScrollBody: false,
							child: Form(
								key: controller.newPasswordFormKey,
								child: Column(
									children: [
										Expanded(child:Container(
											padding: const EdgeInsets.symmetric(horizontal: kSpacing),
											child: Column(
												children: [
													const SizedBox(height: kSmallSpacing),
													_buildPath(),
													const SizedBox(height: kSmallSpacing),
													_buildUsername(),
													const SizedBox(height: kSmallSpacing),
													_buildPassword(),
													const Spacer(),
													_buildSubmitButton(),
													const SizedBox(height: kSpacing),
												]
											)
										)),
									]
								)
							),
						)])
			),
		);
	}

	Widget _buildPath() {
		return TextFormField(
			controller: controller.newPathController,
			decoration: const InputDecoration(
				labelText: "Path"
			),
		);
	}

	Widget _buildUsername() {
		return TextFormField(
			controller: controller.newUsernameController,
			decoration: const InputDecoration(
				labelText: "Username"
			),
		);
	}

	Widget _buildPassword() {
		return TextFormField(
			controller: controller.newPasswordController,
			decoration: const InputDecoration(
				labelText: "Password"
			),
			onTap: () {
				showBottomSheet(context: Get.context!, builder: (context) {
					return Container();
				});
			},
		);
	}

	Widget _buildSubmitButton() {
		return TextButton(
			onPressed: () {},
			child: const Text("Submit"),
		);
	}
}
