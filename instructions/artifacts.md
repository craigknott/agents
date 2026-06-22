Use this file for documentation deliverables, PDFs, notebooks, LaTeX, slide decks, generated media, or other durable
artifacts. Prefer reproducible source artifacts over one-off manual edits.

# Durable Outputs

- Prefer checked-in, reproducible source artifacts when the user is working in a repository.
- Keep source files versioned when they define generated PDFs, slides, notebooks, or media.
- Match the requested output format and verify the rendered artifact when layout matters.

# Format-Specific Rules

- For PDFs, verify rendered output visually.
- For notebooks, prefer reproducible cells and clean execution order.
- For LaTeX, compile and inspect the resulting PDF before sign-off.
- For presentation assets, keep source artifacts versioned and export a final PDF when helpful.
- For polished PowerPoint work, use `elite-powerpoint-designer` when available.
- For generated bitmap images, use `imagegen` when the output should be raster rather than code-native vector or
  HTML/CSS.

# Reporting

- State what artifact was created or changed.
- State what render, export, or visual check was performed.
- If rendering could not be verified, say why and describe the remaining risk.
