import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passwordstore/src/config/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
	await dotenv.load(fileName: ".env");
	await GetStorage.init();
	WidgetsFlutterBinding.ensureInitialized();
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
 			theme: ThemeData.dark(),
			initialRoute: Pages.initial,
			getPages: Pages.routes,
			themeMode: ThemeMode.system,
		);
	}
}
