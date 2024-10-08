package dev.afify.pass.passwordstore

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

	private val CHANNEL = "git_channel"
	private var repoPath: String? = null // Property to hold the repository path

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			when (call.method) {
				"init" -> {
					val path = call.argument<String>("repoPath")
					if (path != null) {
						repoPath = path
						val gitService = GitService(repoPath!!)
						gitService.init(result) // Pass the result to handle success or failure
					} else {
						result.error("INVALID_ARGUMENTS", "Repository path is null", null)
					}
				}
				"pull" -> {
					val remoteName = call.argument<String>("remoteName")
					val branchName = call.argument<String>("branchName")
					if (remoteName != null && branchName != null && repoPath != null) {
						val gitService = GitService(repoPath!!)
						gitService.pull(remoteName, branchName, result) // Pass the result to handle responses
					} else {
						result.error("INVALID_ARGUMENTS", "Invalid arguments for pull", null)
					}
				}
				"push" -> {
					val remoteName = call.argument<String>("remoteName")
					val branchName = call.argument<String>("branchName")
					if (remoteName != null && branchName != null && repoPath != null) {
						val gitService = GitService(repoPath!!)
						gitService.push(remoteName, branchName, result) // Pass the result to handle responses
					} else {
						result.error("INVALID_ARGUMENTS", "Invalid arguments for push", null)
					}
				}
				"commit" -> {
					val message = call.argument<String>("message")
					if (message != null && repoPath != null) {
						val gitService = GitService(repoPath!!)
						gitService.commit(message, result) // Pass the result to handle responses
					} else {
						result.error("INVALID_ARGUMENTS", "Invalid commit message or repository path", null)
					}
				}
				"clone" -> {
					val repoUrl = call.argument<String>("repoUrl")
					val clonePath = call.argument<String>("clonePath")
					val token = call.argument<String>("token")
					if (repoUrl != null && clonePath != null) {
						val gitService = GitService(clonePath)
						gitService.cloneRepository(repoUrl, clonePath, result, token)
					} else {
						result.error("INVALID_ARGUMENTS", "Repository URL or clone path is null", null)
					}
				}
				"addAll" -> {
					if (repoPath != null) {
						val gitService = GitService(repoPath!!)
						gitService.addAll(result) // Pass the result to handle responses
					} else {
						result.error("INVALID_ARGUMENTS", "Repository path is null", null)
					}
				}
				else -> result.notImplemented() // Handle unknown methods
			}
		}
	}
}
