package dev.afify.pass.passwordstore;

import io.flutter.plugin.common.MethodChannel; // Make sure to import this
import java.io.File;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.eclipse.jgit.transport.RefSpec;
import org.eclipse.jgit.transport.UsernamePasswordCredentialsProvider;

public class GitService {
	private String repoPath;
	private Git git;
	private final ExecutorService executor = Executors.newSingleThreadExecutor(); // Executor for background tasks

	public GitService(String repoPath) {
		this.repoPath = repoPath;
	}

	public void init(MethodChannel.Result result) {
		executor.execute(() -> {
			try {
				git = Git.init().setDirectory(new File(repoPath)).call();
				result.success("Git repository initialized successfully");
			} catch (Exception e) {
				e.printStackTrace();
				result.error("INIT_ERROR", "Failed to initialize repository: " + e.getMessage(), null);
			}
		});
	}

	public void pull(String remoteName, String branchName, MethodChannel.Result result) {
		executor.execute(() -> {
			try {
				git.pull().setRemote(remoteName).setRemoteBranchName(branchName).call();
				result.success("Pull operation successful");
			} catch (GitAPIException e) {
				e.printStackTrace();
				result.error("PULL_ERROR", "Failed to pull: " + e.getMessage(), null);
			}
		});
	}

	public void push(String remoteName, String branchName, MethodChannel.Result result) {
		executor.execute(() -> {
			try {
				RefSpec refSpec = new RefSpec("refs/heads/" + branchName + ":refs/heads/" + branchName);
				git.push().setRemote(remoteName).setRefSpecs(refSpec).call();
				result.success("Push operation successful");
			} catch (GitAPIException e) {
				e.printStackTrace();
				result.error("PUSH_ERROR", "Failed to push: " + e.getMessage(), null);
			}
		});
	}

	public void commit(String message, MethodChannel.Result result) {
		executor.execute(() -> {
			try {
				git.add().addFilepattern(".").call(); // Add all changes
				git.commit().setMessage(message).call();
				result.success("Commit successful");
			} catch (GitAPIException e) {
				e.printStackTrace();
				result.error("COMMIT_ERROR", "Failed to commit: " + e.getMessage(), null);
			}
		});
	}

	public void cloneRepository(String repoUrl, String clonePath, MethodChannel.Result result, String token) {
		executor.execute(() -> {
			try {
				Git.cloneRepository()
					.setURI(repoUrl)
					.setDirectory(new File(clonePath))
					.setCredentialsProvider(new UsernamePasswordCredentialsProvider("oauth2", token))
					.call();
				result.success("Repository cloned successfully");
			} catch (GitAPIException e) {
				e.printStackTrace();
				result.error("CLONE_ERROR", "Failed to clone repository: " + e.getMessage(), null);
			}
		});
	}

	public void addAll(MethodChannel.Result result) {
		executor.execute(() -> {
			try {
				git.add().addFilepattern(".").call(); // Add all changes
				result.success("Add all changes successful");
			} catch (GitAPIException e) {
				e.printStackTrace();
				result.error("ADD_ERROR", "Failed to add changes: " + e.getMessage(), null);
			}
		});
	}
}
