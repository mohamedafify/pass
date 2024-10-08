library routes;

import 'package:get/get.dart';
import 'package:passwordstore/src/features/file_viewer/file_viewer_screen.dart';
import 'package:passwordstore/src/features/home/home_screen.dart';
import 'package:passwordstore/src/features/login/login_screen.dart';

part 'pages.dart';

class Routes {
	static const String home = '/home';
	static const String login = '/login';
	static const String fileViewer = '/file_viewer';
}
