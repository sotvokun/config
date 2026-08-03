## Code Review Policy

For every code-review task, delegate the review to the custom `reviewer` subagent.

When a code-review task is delegated to the `reviewer` subagent, the main agent MUST NOT perform the same or overlapping review work while the reviewer is running. The main agent must wait for the reviewer result and base the final answer on that result.

For implementation tasks, after making code changes, run the `reviewer` subagent before declaring the task complete. The main agent must wait for the reviewer to finish before giving the final completion response.

If the `reviewer` subagent is unavailable, fails to start, crashes, is explicitly shut down, or returns a terminal failure, continue with Codex's default review behavior.

Do not treat a slow reviewer as unavailable. If the reviewer is running, keep waiting unless the user explicitly asks to stop, continue without it, or change direction.
