Use for dependency installation, updates, lockfiles, or package-manager selection.

- Follow the manager declared by lockfiles, manifests, wrappers, CI, or repository documentation.
- Do not switch managers in an existing repository unless requested.
- When undeclared, prefer pnpm with Corepack for JavaScript/TypeScript, `uv` for Python, Cargo for Rust, Go modules for
  Go, repository wrappers for Gradle or Maven, and `dotnet` with NuGet for .NET.
- Keep dependency changes scoped, update the owning lockfile, and run relevant validation.
