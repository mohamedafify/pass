package dev.afify.pass.passwordstore

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

	private val CHANNEL = "git_channel"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			when (call.method) {
				"clone" -> {
					val repoUrl = call.argument<String>("repoUrl")
					val clonePath = call.argument<String>("clonePath")
					val token = call.argument<String>("token")
					if (repoUrl != null && clonePath != null && token != null) {
						val gitService = GitService(clonePath)
						gitService.cloneRepository(repoUrl, result, token)
					} else {
						result.error("INVALID_ARGUMENTS", "Repository URL or clone path is null", null)
					}
				}
				"pull" -> {
					val branchName = call.argument<String>("branchName")
					val path = call.argument<String>("path")
					val token = call.argument<String>("token")
					if (branchName != null && path != null && token != null) {
						val gitService = GitService(path)
						gitService.open()
						gitService.pull(branchName, result, token)
					} else {
						result.error("INVALID_ARGUMENTS", "Invalid arguments for pull", null)
					}
				}
				"push" -> {
					val branchName = call.argument<String>("branchName")
					val path = call.argument<String>("path")
					if (branchName != null && path != null) {
						val gitService = GitService(path)
						gitService.open()
						gitService.push(branchName, result)
					} else {
						result.error("INVALID_ARGUMENTS", "Invalid arguments for push", null)
					}
				}
				"commit" -> {
					val message = call.argument<String>("message")
					val path = call.argument<String>("path")
					if (message != null && path != null) {
						val gitService = GitService(path)
						gitService.open()
						gitService.commit(message, result)
					} else {
						result.error("INVALID_ARGUMENTS", "Invalid commit message or repository path", null)
					}
				}
				else -> result.notImplemented() // Handle unknown methods
			}
		}
	}
}
