library git;

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

part 'repo.dart';

class Git {
	static const MethodChannel _channel = MethodChannel('git_channel');

	static Future<bool> clone(String repoUrl, String clonePath, String token) async {
		try {
			await _channel.invokeMethod('clone', {
				'repoUrl': repoUrl,
				'clonePath': clonePath,
				'token': token,
			});
			return true;
		} on PlatformException catch (e) {
			print('Failed to clone repository: ${e.message}'); // Handle error
			return false;
		}
	}

	static Future<bool> pull(String branchName, String token, String path) async {
		try {
			await _channel.invokeMethod('pull', {
				'branchName': branchName,
				'token': token,
				'path': path,
			});
			return true;
		} on PlatformException catch (e) {
			print('Failed to pull: ${e.message}');
			return false;
		}
	}

	/*
	static Future<bool> push(String remoteName, String branchName) async {
		try {
			await _channel.invokeMethod('push', {
				'remoteName': remoteName,
				'branchName': branchName,
			});
			return true;
		} on PlatformException catch (e) {
			print('Failed to push: ${e.message}');
			return false;
		}
	}

	static Future<bool> commit(String message) async {
		try {
			await _channel.invokeMethod('commit', {'message': message});
			return true;
		} on PlatformException catch (e) {
			print('Failed to commit: ${e.message}');
			return false;
		}
	}
	*/

}
