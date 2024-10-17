import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passwordstore/src/config/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:passwordstore/src/constants/constants.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
	Workmanager().executeTask((task, inputData) {
		print("Native called background task: $task");
		return Future.value(true);
	});
}

void main() async {
// 	Workmanager().initialize(
// 		callbackDispatcher,
// 		isInDebugMode: true
// 	);
// 	Workmanager().registerOneOffTask("task-identifier", "simpleTask");
	WidgetsFlutterBinding.ensureInitialized();
	await dotenv.load(fileName: ".env");
	await GetStorage.init();
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return GetMaterialApp(
			debugShowCheckedModeBanner: false,
			fallbackLocale: const Locale('en', 'US'),
			navigatorKey: Get.key,
			title: 'Pass',
			theme: githubTheme,
			initialRoute: Pages.initial,
			getPages: Pages.routes,
			themeMode: ThemeMode.system,
		);
	}
}
