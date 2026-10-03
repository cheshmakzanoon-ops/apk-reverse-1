# Reconstructed Unity project

This is the game's Unity project reassembled from `input/app.apk`. The layout is
not invented — the original `Assets/` tree was recovered from paths embedded in
the shipped Lua bytecode, which still contain the studio's own build paths:

    /Users/mac/Git-Android-release/aps_client/Tools/../Assets/Main/LuaScripts/...

So `Assets/Main/LuaScripts/`, `Assets/Main/HotUpdateDll/`, `Assets/DataTable/`
and the `Assets/Main/...` art paths are the game's real directories, not a
reconstruction guess.

| Project path | Recovered from | Contents |
| --- | --- | --- |
| `Assets/Main/LuaScripts/` | `assets/lwScripts/LWScripts.data` | 18,297 decompiled Lua modules of game logic |
| `Assets/Main/HotUpdateDll/` | `assets/Assemblies/*.mdl` | the 117 recovered managed assemblies |
| `Assets/DataTable/` | `assets/table/*.data` | 1,275 decompiled game config tables |
| `Assets/Main/Art/` | `assets/AssetBundles/` | extracted sprites, textures, audio and text |
| `Assets/CSharp/` | decompiled IL of the 117 assemblies | 3,624 `.cs` files (decompiled, not original sources) |

The five entries are symlinks into the trees produced by the pipeline, so the
~750 MB of recovered content is stored once. Nothing is duplicated. Three of
the five targets (`LuaScripts`, `DataTable`, `CSharp`) are tracked in Git and
resolve in a fresh clone; `HotUpdateDll` and `Art` are not tracked, so
`bash unity-project/sync-links.sh` reports them missing until the pipeline has
run.

`ProjectSettings/ProjectVersion.txt` records **2019.4.41f1**, the engine version
read out of the APK's own build settings. `Packages/manifest.json` lists the
Unity packages the recovered code depends on.

## What this will and will not do

**It will not build or run, and it cannot.** Being direct about why:

1. The engine is a closed native binary. `libunity.so` is 23 MB of compiled
   engine shipped inside the APK; the `UnityEngine.*` assemblies here are
   reference assemblies that only bind against a running engine.
2. The native plugins the C# calls into by P/Invoke are not reimplementable
   from a decompile: `libxlua.so` (12 MB Lua VM), `libgmesdk.so` (voice chat),
   `libanogs.so` (analytics), `libtxffmpeg.so`, `libzstd.so`, `libmtPro.so`.
3. The asset bundles are keyed by hash and the game's `gameres` manifest
   references 32,564 of them; only the 7,868 present in the APK's
   `BundleFragment0.bytes` can be extracted offline. The remainder are fetched
   from the studio's CDN at first run.
4. The game is not offline-capable. It authenticates against
   `lastwar-serverlist-*` hosts and `gameservice/getlsu3dversion.php`, so even a
   perfect client build would have nothing to talk to.

What *is* recovered is the source: the Lua logic, the C# systems, the config
tables and the asset pipeline. That is the part a decompile can actually give
you, and the Lua, C#, Java and config-table trees are committed to this
repository.

## Continuing the asset extraction

`Assets/Main/Art` is partial by construction — extraction is resumable and runs
at roughly 1.4 bundles/second:

    bash tools/decompile.sh input/app.apk decompiled STEPS=bundles

Each invocation records finished bundles in `source-app/game-assets/.state.tsv`
and picks up where the last one stopped. Set `BUNDLE_BUDGET=0` to run all
7,868 in one go (about 90 minutes).

## Scene data

`BuildSettings.json` under `source-app/unity-assets/globalgamemanagers/` records
a single build scene, `Assets/Launch.unity` (the 4.2 MB file size is its
`preloadedPlugins` list, not scene data — worth knowing before opening it). The
boot scene that ships in the APK, `level0`, is extracted to
`source-app/unity-assets/level0/` as a typed JSON dump of its GameObject
hierarchy, transforms and cameras. Everything else is a bundle, and bundles are
addressed by hash rather than by name in the scene list.
