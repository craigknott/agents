Use this file before starting, stopping, or relying on local dev servers, background processes, containers, emulators,
ports, or service dependencies. Keep the user's local environment stable and observable.

# Process And Port Hygiene

- Check for an existing process or server before starting a new one.
- If the preferred port is busy, identify what is using it when practical and choose another port if that is safe.
- Do not kill user-owned or unrelated processes unless the user explicitly asks.
- Track the commands and sessions you start.
- Stop processes you started when they are no longer needed, unless keeping them running is useful to the user.
- If a server remains running for the user, report the URL, port, and any relevant command or session detail.

# Dependency Services

- Prefer repository scripts for local services, containers, emulators, tunnels, and seeded dependencies.
- Do not invent ad hoc service startup commands when the repo documents a canonical workflow.
- Treat commands that require auth, external accounts, paid resources, or long-running infrastructure as potentially
  blocking; report the requirement before assuming the environment is ready.
- If setup fails, use `instructions/validation.md` command-failure handling before treating the code as broken.

# Reporting

- Report local URLs, ports, and process state when they matter for verification or handoff.
- Distinguish a code failure from a missing local service, missing credentials, unavailable network, or sandbox limit.
- Do not leave unreported background processes, servers, or tunnels running.
