library gpg;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:openpgp/openpgp.dart';

class GPG {
	String privatekey, publickey, passphrase;

	GPG({ required this.privatekey, required this.publickey, required this.passphrase });

	Future<String> decrypt({ required Uint8List bytes }) async {
		Uint8List decryptedBytes = await OpenPGP.decryptBytes(
			bytes,
			privatekey,
			passphrase,
		);
		String decrypted = utf8.decode(decryptedBytes);
		return decrypted;
	}

	Future<Uint8List> encrypt({ required Uint8List bytes }) async {
		return await OpenPGP.encryptBytes(
			bytes,
			publickey,
		);
	}

	Future<String> decryptFile({ required FileSystemEntity file }) async {
		Uint8List bytes = await File(file.path).readAsBytes();
		Uint8List decryptedBytes = await OpenPGP.decryptBytes(
			bytes,
			privatekey,
			passphrase,
		);
		String decrypted = utf8.decode(decryptedBytes);
		return decrypted;
	}

	Future<Uint8List> encryptFile({ required FileSystemEntity file }) async {
		Uint8List bytes = await File(file.path).readAsBytes();
		return await OpenPGP.encryptBytes(
			bytes,
			publickey,
		);
	}

	static bool validatePublicKey(String key) {
		var lines = key.split('\n');
		return lines[0] == "-----BEGIN PGP PUBLIC KEY BLOCK-----";
	}

	static bool validatePrivateKey(String key) {
		var lines = key.split('\n');
		return lines[0] == "-----BEGIN PGP PRIVATE KEY BLOCK-----";
	}
}
