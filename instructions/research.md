Use for third-party and OpenAI documentation.

## Technical Documentation

For third-party libraries, frameworks, SDKs, APIs, CLIs, and cloud services, use Context7 when available:

1. Resolve the library ID unless the user supplied an exact `/org/project` ID.
2. Prefer the exact, official, version-matched source.
3. Query the selected ID with the user's full question.

When Context7 is unavailable or does not have the library, use the official documentation for the version that the
repository pins. Say which source and version you used.

Use official OpenAI documentation for OpenAI products. Context7 is unnecessary for general programming concepts,
business logic, refactoring, or code review.
