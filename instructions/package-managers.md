Use this file before installing dependencies, updating lockfiles, running package-manager commands, or choosing a
default toolchain in a repository that does not declare one.

# Canonical Package Manager

- Always use the repository's canonical package manager if it is already declared.
- Treat manifests, lockfiles, wrappers, CI commands, and documented scripts as evidence.
- Never switch package managers in an existing repo unless explicitly asked.
- If commands fail because dependencies are missing, inspect the repo's installation workflow before choosing a tool.

# Defaults When Undeclared

Use these defaults only when the repository does not clearly declare a package manager:

- JavaScript/TypeScript: prefer Corepack plus pnpm
- Python: prefer `uv`
- Rust: use `cargo`
- Go: use Go modules
- Java/Kotlin: use the Gradle Wrapper or Maven Wrapper when present
- .NET: use the `dotnet` CLI and NuGet; prefer `Directory.Packages.props` for multi-project version management

# Dependency Changes

- Keep dependency changes scoped to the task.
- Update lockfiles with the same package manager that owns them.
- For security or CVE work, also read `instructions/security.md`.
- After dependency changes, run the smallest relevant validation first, then broaden based on risk.
