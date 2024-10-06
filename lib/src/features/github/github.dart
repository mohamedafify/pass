library github;

import 'dart:developer';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:passwordstore/src/constants/constants.dart';

part 'services.dart';
part 'user.dart';

class Github {
	static Github? _instance;

	static const FlutterAppAuth _appAuth = FlutterAppAuth();
	static final String _clientId = dotenv.env['CLIENT_ID']!;
	static final String _clientSecret = dotenv.env['CLIENT_SECRET']!;
	static const String _redirectUrl = 'passwordstore://auth-github';

	late GithubService _service;
	late String accessToken;

	// prevent instantiation
	Github._internal();

	static Future<Github?> getInstance() async {
		_instance ??= await Github._initializeToken();
		return _instance;
	}

	// make sure there is a valid token to start using api
	static Future<Github?> _initializeToken() async {
		Github instance = Github._internal();
		print('Authentication started');
		print('getting token from storage...');
		String? token = GetStorage().read(githubTokenKey);
		if (token != null) {
			print('token: $token');
			instance._service = GithubService(accessToken: token);
			print('validation token...');
			bool isValidToken = await instance._service._hasValidToken();
			if (isValidToken) {
				print('token is valid');
				instance.accessToken = token;
				return instance;
			} else {
				print('token is Not valid, reauthenticating');
				String? token = await _authenticate();
				if (token != null) {
					print('token: $token');
					await GetStorage().write(githubTokenKey, token);
					instance.accessToken = token;
					instance._service.accessToken = token;
					return instance;
				}
				return null;
			}
		} else {
			print('token is not found, reauthenticating...');
			String? token = await _authenticate();
			if (token != null) {
				print('token: $token');
				await GetStorage().write(githubTokenKey, token);
				instance._service = GithubService(accessToken: token);
				instance.accessToken = token;
				return instance;
			}
			return null;
		}
	}

	static Future<String?> _authenticate() async {
		try {
			final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
				AuthorizationTokenRequest(
					_clientId,
					_redirectUrl,
					serviceConfiguration: const AuthorizationServiceConfiguration(
						authorizationEndpoint: 'https://github.com/login/oauth/authorize',
						tokenEndpoint: 'https://github.com/login/oauth/access_token',
					),
					scopes: ['repo', 'user'], // Add other scopes as needed
					clientSecret: _clientSecret
				),
			);
			final String? accessToken = result.accessToken;
			return accessToken;
		} catch (e) {
			print('Error during authentication: $e');
			return null;
		}
	}

	Future<GithubUser?> getUser() async {
		return await _service._getUser();
	}

}
