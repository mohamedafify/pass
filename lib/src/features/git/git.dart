library git;

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'repo.dart';

class Git {
	static const MethodChannel _channel = MethodChannel('git_channel');

	Future<bool> init(String repoPath) async {
		try {
			await _channel.invokeMethod('init', {'repoPath': repoPath});
			return true;
		} on PlatformException catch (e) {
			print('Failed to initialize Git: ${e.message}');
			return false;
		}
	}

	Future<bool> pull(String remoteName, String branchName) async {
		try {
			await _channel.invokeMethod('pull', {
				'remoteName': remoteName,
				'branchName': branchName,
			});
			return true;
		} on PlatformException catch (e) {
			print('Failed to pull: ${e.message}');
			return false;
		}
	}

	Future<bool> push(String remoteName, String branchName) async {
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

	Future<bool> commit(String message) async {
		try {
			await _channel.invokeMethod('commit', {'message': message});
			return true;
		} on PlatformException catch (e) {
			print('Failed to commit: ${e.message}');
			return false;
		}
	}

	Future<bool> clone(String repoUrl, String clonePath) async {
		try {
			await _channel.invokeMethod('clone', {
				'repoUrl': repoUrl,
				'clonePath': clonePath,
			});
			return true;
		} on PlatformException catch (e) {
			print('Failed to clone repository: ${e.message}'); // Handle error
			return false;
		}
	}

	Future<bool> addAll() async {
		try {
			await _channel.invokeMethod('addAll');
			return true;
		} on PlatformException catch (e) {
			print('Failed to add all changes: ${e.message}');
			return false;
		}
	}
}
