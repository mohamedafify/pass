package dev.afify.pass.passwordstore;

import io.flutter.plugin.common.MethodChannel; // Make sure to import this
import java.io.File;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.eclipse.jgit.transport.UsernamePasswordCredentialsProvider;

public class GitService {
	private String repoPath;
	private Git git;
	private final ExecutorService executor = Executors.newSingleThreadExecutor();

	public GitService(String repoPath) {
		this.repoPath = repoPath;
	}

	public void open() {
		executor.execute(() -> {
			try {
				git = Git.open(new File(repoPath));
			} catch (IOException e) {
				e.printStackTrace();
			}
		});
	}

	public void cloneRepository(String repoUrl, MethodChannel.Result result, String token) {
		executor.execute(() -> {
			try {
				git = Git.cloneRepository()
					.setURI(repoUrl)
					.setDirectory(new File(repoPath))
					.setCredentialsProvider(new UsernamePasswordCredentialsProvider("oauth2", token))
					.call();
				result.success("Repository cloned successfully");
			} catch (GitAPIException e) {
				e.printStackTrace();
				result.error("CLONE_ERROR", "Failed to clone repository: " + e.getMessage(), null);
			}
		});
	}

	public void pull(String branchName, MethodChannel.Result result, String token) {
		executor.execute(() -> {
			try {
				git.pull()
				.setCredentialsProvider(new UsernamePasswordCredentialsProvider("oauth2", token))
				.setRemoteBranchName(branchName)
				.call();
				result.success("Pull operation successful");
			} catch (GitAPIException e) {
				e.printStackTrace();
				result.error("PULL_ERROR", "Failed to pull: " + e.getMessage(), null);
			}
		});
	}

	public void push(String branchName, MethodChannel.Result result) {
		executor.execute(() -> {
			try {
				git.push().call();
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

}
