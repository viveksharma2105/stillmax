# Design System Specification: The Nocturnal OS Experience

## 1. Overview & Creative North Star
**Creative North Star: "The Ethereal Observer"**

This design system is not a utility; it is a cinematic interface. It rejects the "flat and boxed" constraints of traditional Android launchers in favor of an immersive, atmospheric environment. By leveraging deep tonal shifts, high-contrast editorial typography, and the physics of light through glass, we create an experience that feels less like a software tool and more like a premium hardware extension.

The system breaks the "template" look by utilizing **intentional asymmetry** (placing heavy display type against light, airy icons) and **overlapping glass surfaces** that create a sense of infinite z-axis depth.

---

## 2. Colors & Surface Philosophy

The palette is rooted in the "Midnight" spectrum, using deep navies and electric accents to simulate a futuristic, neon-lit landscape.

### Tone & Role
- **Base (#131318):** The foundational void. Everything emerges from here.
- **Primary Accent (#D2BBFF / #7C3AED):** Used for "moments of intent"—active states, critical call-to-actions, and brand-defining pulses.
- **Secondary Accent (#5DE6FF / #00CBE6):** Used for informational accents and secondary interactive elements to provide a cool, high-tech contrast to the violet.

### The "No-Line" Rule
Traditional 1px solid dividers are strictly prohibited. Boundaries between sections must be defined exclusively through:
1. **Background Shifts:** Placing a `surface_container_low` card atop a `surface` background.
2. **Negative Space:** Using large, breathing gutters to define grouping.

### The "Glass & Gradient" Rule
Floating elements (Quick Settings, App Drawers, Folders) must utilize Glassmorphism.
- **Surface:** `rgba(19, 19, 24, 0.7)` (Surface color with 70% opacity).
- **Effect:** `backdrop-filter: blur(20px)`.
- **Signature Texture:** Use a subtle linear gradient on high-priority CTAs from `primary` to `primary_container` at a 135-degree angle to provide a "liquid neon" soul.

---

## 3. Typography: Editorial Sophistication

We pair a high-character display face with a highly legible geometric sans-serif to create a "Tech-Luxury" feel.

- **Display & Headlines (Space Grotesk):** Bold, wide, and unapologetic. Use `display-lg` for clock faces or "Hello" states. Use `headline-sm` for category headers (e.g., "Frequent Apps").
- **Body & Labels (Manrope):** Light and airy. Manrope’s modern proportions ensure readability even at 75% opacity.
- **Scale Usage:**
- **High Contrast:** Pair a `display-md` title with `body-sm` metadata to create an editorial, magazine-like hierarchy.
- **Tracking:** Increase letter-spacing on `label-sm` by 5% for an "expensive" feel.

---

## 4. Elevation & Depth: Tonal Layering

Depth is not simulated with shadows alone; it is earned through layering light and transparency.

### The Layering Principle
Think of the UI as "stacked sheets of frosted sapphire."
- **Level 0 (Deepest):** `surface_container_lowest` for the system background.
- **Level 1 (Sub-base):** `surface_container_low` for widgets or background sections.
- **Level 2 (Active):** `surface_container_high` for primary interactive cards.

### Ambient Shadows
When a "floating" effect is required (e.g., an expanded folder), use an extra-diffused shadow:
- **Shadow:** `0px 24px 48px rgba(0, 0, 0, 0.4)`.
- **The "Ghost Border":** Use `outline_variant` at **10% opacity** to catch the light on the edge of glass surfaces. This creates a "micro-rim" light effect.

---

## 5. Component Strategy

### Buttons
- **Primary:** `primary_container` fill with `on_primary_container` text. Corner radius: `16px` (md). No border.
- **Secondary (Glass):** `surface_container_highest` at 40% opacity with a `backdrop-blur(10px)`.
- **Tertiary:** Ghost style. No fill, `primary` text, and 0px border.

### Cards (The Core Launcher Unit)
- **Visuals:** Corner radius `24px` (lg).
- **Interaction:** On press, cards should scale to 98% and increase `backdrop-blur` intensity.
- **Rule:** Never use a divider line inside a card. Use `surface_container_highest` for a header strip or simply extra padding.

### Chips (Action & Filter)
- **Selection:** `secondary_container` background with `on_secondary_container` text.
- **Shape:** Fully rounded (`full`).
- **Placement:** Floating 4px above the surface for a "suspended" feel.

### Input Fields
- **State:** Unfocused inputs use `surface_container_lowest` with a 10% `outline_variant` Ghost Border.
- **Focus:** The border transitions to `primary` with a subtle `2px` outer glow (soft violet).

### Notifications & Tooltips
- **Execution:** Always Glassmorphic. Use `surface_bright` with 80% opacity and a `24px` blur. These must feel like they are floating "closer" to the user than any other element.

---

## 6. Do’s and Don’ts

### Do:
- **Do** use intentional white space. If a layout feels crowded, remove a border and add 16px of padding.
- **Do** use "Electric Violet" (`primary`) sparingly. It is a beacon of light, not a paint bucket.
- **Do** ensure all text on glass surfaces meets AA accessibility standards by darkening the backdrop-blur layer if necessary.

### Don't:
- **Don’t** use pure #000000. Use `surface_container_lowest` (#0E0E13) to allow for subtle depth.
- **Don’t** use hard, 100% opaque borders. They break the "Ethereal Observer" immersion.
- **Don’t** use standard Android "Material Ripple" in gray. Use a `primary` tinted ripple at 12% opacity.
- **Don’t** use sharp corners. Everything in this system follows the physics of "smoothed glass."