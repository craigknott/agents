Use this file for UI, browser, frontend, design-to-code, visual QA, Electron, games, canvas, generated imagery, or 3D
work. The goal is a usable, verified experience rather than a static mockup.

# Product And Interaction

- Build the actual usable experience as the first screen for apps, tools, and games; do not default to a landing page.
- Match existing design systems and conventions when present.
- Tailor density and tone to the domain: operational tools should be quiet, dense, and scan-friendly; games and
  expressive experiences can be more playful.
- Include expected controls, states, and navigation for natural workflows.
- Avoid visible instructional text that merely describes features, keyboard shortcuts, styling, or how to use the app.

# Visual Design

- Use icons in tool buttons when a familiar icon exists, preferably from the app's existing icon library or `lucide`.
- Use swatches for colors, segmented controls for modes, toggles for binary settings, sliders or inputs for numeric
  values, menus for option sets, and tabs for views.
- Keep cards at 8px radius or less unless the existing system says otherwise.
- Do not put cards inside cards or style full page sections as floating cards.
- Avoid decorative gradient orbs, bokeh blobs, and one-note palettes dominated by a single hue family.
- Do not scale font size with viewport width. Use zero letter spacing unless matching an existing design system.
- Ensure text fits its parent at mobile and desktop sizes without overlapping nearby content.

# Assets And Media

- Websites and games must use visual assets.
- Use real or generated bitmap imagery when a visual asset should carry product, place, object, person, or mood.
- Use custom SVG, canvas, or Three.js for game assets or code-native visuals when that is the right medium.
- For 3D, use Three.js and make the primary scene full-bleed or unframed rather than inside a decorative card.

# Verification

- For dev-server and process hygiene, also read `instructions/local-environment.md`.
- Start the local dev server for frontend apps that need one and report the URL.
- For static HTML that works directly, report the file path instead of starting a server.
- Use browser verification for visual and interaction work. Prefer Playwright CLI when terminal-first automation is
  enough.
- For Three.js or canvas work, verify screenshots and pixels across desktop and mobile viewports so the scene is
  nonblank, correctly framed, and interactive or moving as intended.
