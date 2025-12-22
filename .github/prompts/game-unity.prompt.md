# Unity Game Development Prompt

You are an expert Unity game developer and visual designer. Using the latest stable Unity version (preferably LTS or Unity 6) and Visual Studio (or an equivalent IDE), create a **complete, playable 2D game** that is visually polished, performant, and easy to build and run locally on major platforms.

---

## Requirements

### Theme
- AI will propose a **unique, cohesive theme** with a clear mood and tone that fits the gameplay.

### Gameplay
- Must be **simple to pick up but engaging and addictive**.
- Examples: score-based survival, endless runner, puzzle with escalating challenge, or a hybrid of these.

### Art Style
- Consistent aesthetic across all assets.
- Unified color palette.
- Smooth animations using Unity's Animator/Animation Clips/Tweening.
- Subtle particle effects for polish (e.g., dust, sparks, UI transitions).

### Audio
- Include **royalty-free** background music and sound effects.
- Proper audio layering (music track, UI sounds, game action SFX).
- Ensure volume levels are balanced and platform-appropriate.

### Code Quality
- Clean, modular, and maintainable code:
  - Single-responsibility scripts and components.
  - Use **ScriptableObjects** for configuration and game data.
  - Event-driven or observer patterns for decoupled systems.
  - Avoid heavy logic in `Update()`.
- Well-commented and inline documentation included.

### Performance & Build
- Optimize for runtime performance:
  - Minimize allocations and garbage collection.
  - Cache frequently used references.
  - Use object pooling where needed.
- Optimize asset import settings for target platforms.
- Validate performance with **Unity Profiler** and **Memory Profiler**.
- Game should be **fully buildable locally** for Windows, Mac, Linux, or WebGL.

### File / Project Structure
- Organize the project with clear folder structure:
  - `Scenes/` for scene files.
  - `Scripts/` organized by feature.
  - `Prefabs/` for reusable assets.
  - `Assets/`, `Audio/`, `UI/`, etc.
- Use **Assembly Definitions (.asmdef)** to separate runtime, editor, and test code.
- Include all assets in the repo so the project runs without missing references.

### Testing
- Include Unity Test Framework tests:
  - **Edit Mode** tests for logic.
  - **Play Mode** tests for gameplay and interactions.

---

## Deliverables

1. **Design Document**  
   Includes:
   - Game concept
   - Visual aesthetic
   - Gameplay loop (player goals, mechanics, progression)

2. **Unity Project Files**  
   All scenes, assets, and scripts required for the game.

3. **Asset List**  
   Detailed list of sprites, images, and audio files used, including source and licensing information.

4. **Instructions**  
   A `README.md` with:
   - How to open and run the game
   - Control scheme
   - Build steps for target platforms

---

## Notes and Verifications

- Use **Unity LTS** or Unity 6 with official best practices for asset import, project organization, and optimization.  
  [Unity How-To Guides](https://unity.com/how-to)  

- Assembly Definitions improve compile times and modularity.  
  [Structuring Unity Code for Production](https://medium.com/@modyari/structuring-your-unity-code-for-production-important-best-practices-dbc66b5a87d4)  

- Avoiding logic-heavy `Update()` calls and minimizing allocations are standard Unity performance recommendations.  
  [Unity Performance Tips](https://unity.com/how-to)

---

## Unverified or Conditional

- **UI Toolkit Runtime:** Feature set depends on the chosen Unity version and platform targets. Confirm before using.  
- **Royalty-Free Assets:** Definition and licensing requirements may vary by project or jurisdiction. Verify all asset sources.
