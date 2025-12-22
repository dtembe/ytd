# Project Overview

This project is a Unity game developed with Unity Editor (latest LTS or Unity 6), using Visual Studio for coding/debugging. Architecture follows feature-driven modules, with separation between runtime systems, editor tools, and testable logic. Strong emphasis on performance, maintainability, and up-to-date best practices.

## Folder Structure

- `/Assets`
  - `/Scripts`: organized by feature (e.g. `Player/`, `Enemies/`, `Systems/`, `UI/`). Editor‐only scripts go under an `Editor/` folder.  
  - `/Scenes`: scene files (`MainMenu.unity`, `Level1.unity`, etc.), with smaller additive/loadable scenes when needed.  
  - `/Prefabs`: prefabs and nested prefabs for reusable game objects.  
  - `/ScriptableObjects`: data‐only defined assets for configuration, balance, etc.  
  - `/Art`: textures, models, animations, materials, shaders.  
  - `/Audio`: music, sound effects.  
  - `/UI`: UI layouts, canvas prefabs, TextMeshPro assets, UI animations.  
  - `/Plugins` or `/ThirdParty`: third‐party / asset store or external packages (kept isolated).  
- `/ProjectSettings`: Unity project configuration files (rendering, input, quality, physics, etc.).  
- `/Packages`: manifest (`Packages/manifest.json`) and lock files for Unity packages.  
- `/Tests`: Unity Test Framework files  
  - `/Tests/EditMode`  
  - `/Tests/PlayMode`  
- `/Docs`: design docs, architecture notes, tooling and editor setup, onboarding.  
- `/Builds`: exported builds (ignored in version control).  
- `/UserSettings`: local preferences (ignored in version control).  

## Libraries, Packages, and Tools

- Use Unity’s built‐in **Package Manager** for dependencies. Prefer official Unity packages or verified third‐party ones.  
- Core recommended packages include:
  - **Input System** (Unity’s newer input system)  
  - **TextMeshPro** for high-quality text rendering  
  - **Cinemachine** for advanced camera behaviors (optional, if needed)  
  - **Addressables** for efficient asset loading / memory footprint (optional, where applicable)  
  - **URP** or **HDRP** depending on visual fidelity needed, with correct quality settings for target platform  
- Use Visual Studio (or VS Code / Rider) with proper Unity support (editor integration, debugging, assembly definitions).  
- Version control: Git (or Plastic SCM) with `.gitignore` for Unity (including ignoring `Library/`, `Temp/`, `Obj/`, `Builds/`, etc.).  
- Use Unity Test Framework for automated testing (Edit Mode & Play Mode).  

## Coding Standards & Conventions

- **C# Style** (consistent with Unity 6 C# Style Guide) :contentReference[oaicite:0]{index=0}  
  - Use **PascalCase** for `Namespaces`, `Classes`, `Methods`, `Properties`, `Events`; **camelCase** for parameters, local variables.  
  - Constants should be all uppercase with underscores or follow Unity’s preferred constant naming conventions. :contentReference[oaicite:1]{index=1}  
  - Avoid special characters in identifiers. Do not use spaces in file or folder names; prefer PascalCase or camelCase. :contentReference[oaicite:2]{index=2}  
- **MonoBehaviour / Unity API Best Practices**  
  - Keep `MonoBehaviour` classes focused; business logic or algorithmic code should reside in plain C# classes to aid testability.  
  - Avoid expensive operations inside `Update()`. Use events, coroutines, or schedules for less frequent/triggered work.  
  - Cache component references rather than calling `GetComponent<T>()` repeatedly. Avoid frequent use of `Find*()` methods at runtime.  
  - Use `SerializeField private` fields rather than public fields for Inspector exposure.  
- **Performance & Memory**  
  - Profile early (using Unity Profiler, Memory Profiler). Watch for GC allocations in hot paths.  
  - Use object pooling for frequently spawned/destroyed GameObjects.  
  - Use Addressables (or equivalent) for efficient asset loading, especially in large projects or target platforms with constrained memory.  
  - Optimize build settings (graphics, quality, shadows, texture compression, etc.) per platform.  
- **UI & UX**  
  - Use TextMeshPro instead of legacy text components for quality and performance.  
  - UI layouts should be responsive: correct anchoring, scaling via `Canvas Scaler` (Scale With Screen Size).  
  - Separate UI flows/scenes (menus/settings/gameplay HUD). Use additive loading or keep persistent UI objects (e.g. via singleton or bootstrapped manager) carefully.  
- **Naming Conventions**  
  - For scripts, match filename to the class name. One public class per file.  
  - Prefab names should reflect what the object represents (e.g., `Enemy_Goblin`, `Player_Controller`). Avoid generic names.  
  - Boolean variables should start with verbs or “is/has/should” etc.  
- **Error Handling & Logging**  
  - Use Unity's logging (Debug.Log, Debug.LogWarning, Debug.LogError) appropriately; avoid log spam in production.  
  - Use assertions or guard clauses for invalid states.  
  - Sensitive or expensive operations should have fallback / safe guards.  
- **Testing**  
  - Cover pure logic in Edit Mode tests. Runtime behavior / gameplay interaction via Play Mode tests.  
  - Automate tests (CI integration) where possible to catch regressions early.  

## UI / Interaction Guidelines

- Use modern Unity UI (uGUI + TextMeshPro) or UI Toolkit where appropriate (for editor tooling or runtime UI if target platform supports it).  
- Ensure accessible design: readable text sizes, color contrast, support for color‐blindness and scaling.  
- Support input variations (keyboard, gamepad, touch) via Unity Input System.  
- Provide feedback (hover, pressed states, disabled states) in UI elements, animations/transitions to make interaction feel responsive.

## Repository, Agent & Build Rules

- Don’t commit auto-generated or local-only files (`Library/`, `Temp/`, `obj/`, etc.).  
- Include `.meta` files for all assets so that Unity asset import settings remain consistent. :contentReference[oaicite:3]{index=3}  
- Use assembly definitions (`.asmdef`) to split code into assemblies (Editor vs Runtime vs Tests) to speed compile times and manage dependencies.  
- Use platform‐appropriate commands/scripts for build automation, CI and packaging.  
- Maintain versioned changelogs (e.g., `CHANGELOG.md`) and inline documentation for public APIs.  

