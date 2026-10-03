# reverse-engineer-1 — `com.fun.lastwar.gp` source recovery

Reverse engineering of an Android APK to recover the game's source code, logic
and assets.

**Target:** `com.fun.lastwar.gp` (Last War: Survival Game — FunPlus, Unity Mono build)
**Input:** `input/app.apk` (813 MB, 1,947 entries, 9 DEX files, 53 native libs)
**Authorization:** target owned by the requester / CTF / authorized.

---

## Read this first

The game's **source code and assets are recovered and are in this repo**:
18,240 decompiled Lua modules of game logic (2,336,221 lines), 1,275 game
config tables, 3,624 C# files, 17,325 Java files, the 117 original managed
assemblies, and the extracted art/audio.

A **runnable game** is a different thing, and it is not what an APK decompile
yields. Building it back would require reimplementing the Unity engine
(`libunity.so`, 23 MB of compiled native code), the Lua VM (`libxlua.so`),
several proprietary SDK plugins, and the ~25,000 AssetBundles that live on the
studio's CDN rather than in the APK — plus a backend, since the client
authenticates against `lastwar-serverlist-*`. `unity-project/` is laid out as a
real Unity project with the recovered content in its original directories, but
it will not compile into a shippable game. That boundary is a property of the
input, not a gap in the extraction.

---

## What is in this repo

```
input/app.apk                     the original APK (untouched)

tools/re-env.sh                   pins the JDK / jadx / apktool locations
tools/decompile.sh                APK -> Java, resources, assets, Lua, tables
tools/decompile-csharp.sh         .mdl -> .dll -> C# source
tools/extract-lua.py              unpacks the LWLF script container
tools/unluac-batch/               batch Lua bytecode decompiler driver
                                  (also does the header fix, in memory)
tools/extract-unity-assets.py     bin/Data Unity files -> textures/scenes/shaders
tools/extract-game-assets.py      packed AssetBundle fragment -> art and audio
tools/peprobe/                    .NET helper that validates recovered PE images

source-app/src/                   17,325 decompiled Java files (jadx)
source-app/csharp/                3,624 decompiled C# files (ILSpy)
source-app/lua/luac/              18,300 Lua bytecode chunks, as shipped
source-app/lua/src/               18,240 decompiled Lua modules + 3 disassembly
                                  fallbacks  (2,336,221 lines)
source-app/data-tables/           1,275 config tables, bytecode, as shipped
source-app/data-tables-lua/       1,275 config tables decompiled to Lua
source-app/unity-assets/          7,564 files: boot scene, shaders, textures,
                                  MonoScript table, player settings
source-app/game-assets/           extracted game art/audio from the bundle
                                  fragment, plus inventory.jsonl

decompiled/apktool/               decoded AndroidManifest.xml + res/ (no smali)
decompiled/raw/classes*.dex       the 9 DEX files, unmodified
decompiled/raw/lib/<abi>/         53 native .so files
decompiled/unity/assemblies/      117 recovered .NET assemblies (.dll)
decompiled/unity/assets/          the full Unity asset payload as shipped

unity-project/                    the game reassembled as a Unity project,
                                  in its original Assets/ layout (symlinks)
.github/workflows/ci.yml          validates the pipeline on every push/PR
tools/ci-checks.sh                the checks CI runs (also runnable locally)
```

### What is and is not in version control

The pipeline and its documentation are committed. The **recovered payloads are
not** — `input/`, `decompiled/` and `source-app/` are gitignored, because:

- the working tree is **~4.2 GB**, and three files (the 775 MB APK and two
  498 MB copies of `BundleFragment0.bytes`) exceed GitHub's 100 MB per-file hard
  limit, so they cannot be pushed at all;
- every one of them is **regenerated deterministically** by the pipeline below,
  and the step guards fail loudly rather than silently producing nothing.

That is a real trade-off, stated plainly: the recovered game source is not in the
Git repository, it is in the working tree and reproducible with one command. If
you would rather have, say, `source-app/lua/src` in the repo despite the 130 MB,
drop the relevant line from `.gitignore` — but note that recovering everything
rather than nothing is worth more than a lean tree for most uses.

`unity-project/Assets/*` are symlinks into those ignored directories, so a fresh
clone has dangling links until the pipeline has run. `bash
unity-project/sync-links.sh` recreates them and reports any target still
missing.

---

## The app

| | |
|---|---|
| Package | `com.fun.lastwar.gp` |
| compileSdkVersion | 35 (Android 15) |
| Platform | Unity 2019.4.41f1, **Mono** scripting backend |
| Managed code | `assets/Assemblies/*.mdl`, 117 assemblies |
| Framework | XLua + Lua hot-update layer (`libxlua.so`, `assets/lwScripts/`) |
| Networking | SmartFox2X realtime server + `BestHTTP` |
| Notable SDKs | AppsFlyer, Thinking Analytics, Shumei, GME/Tencent voice, Zendesk, Google Ads, Vungle |

The declared package set also includes `com.fun.lastwar.debug`, `com.lastwar.ios`
and `com.lastwar.pc` (see `ConstURLConfig.cs`), so this is the Google Play
variant of a multi-platform client.

---

## Findings

### 1. Managed assemblies are obfuscated, not encrypted

The 117 game assemblies ship as `assets/Assemblies/*.mdl` instead of `.dll`. The
protection is a **single-byte XOR applied to a short prefix of each file's DOS
header**, and two details make it weaker than it looks:

- the key is **different per file** (36 distinct keys observed, `0x07`–`0x30`)
- the obfuscated prefix is **a different length per file** (`0x0c`–`0x20` bytes)

Everything past the prefix is verbatim, including the CLI header, the `BSJB`
metadata root and all IL. So `MZ` in byte 0 yields the key immediately, and the
prefix length is found by trying candidates and validating against a real PE/CLR
layout. `tools/decompile-csharp.sh` does this and recovers **117 of 117**
assemblies with no failures.

`libil2cpp.so` ships in the APK but is not the backend in use — the `libmono-*`
set and the shipped assemblies confirm Mono. That is also why there is no
`global-metadata.dat` or `ScriptingAssemblies.json`: those exist only for
IL2CPP, so their absence is expected, not a failure.

### 2. The Lua payload is the bulk of the game's logic

`assets/lwScripts/LWScripts.data` (99 MB) is a container the game calls `LWLF`.
Its format came from the game's own loader — the decompiled
`LWLuaFile._Load` in `source-app/csharp/Assembly-CSharp/LWLuaFile.cs`:

```
"LWLF"                 magic (LWLuaFileUtil.s_Magic)
int32 fileVersion     1 = original, 2 = SuperEncrypt-ed payloads
int32 version         LWLua version
int32 entryCount
entryCount x { string name; int32 length; byte data[length] }
```

Parsing it yields **18,300 Lua modules — 102,804,160 of 103,989,065 bytes
accounted for, and the entries consume the file exactly with zero trailing
bytes.** That exact fit is the validation: a wrong entry count cannot land on
EOF. Every payload begins `\x1bLua`, so all 18,300 are Lua bytecode. `759` in
the sidecar manifest is the Lua version, not the file count.

### 3. The studio ships a modified `luac`, and the fix is one byte plus one

Every chunk carries a non-standard header:

```
studio: sig(4) ver(1) fmt=0x01(1) DATA(6) 04 04 08 08   LUAC_INT LUAC_NUM ...
upstream Lua 5.3 + unluac:
        sig(4) ver(1) fmt=0x00(1) DATA(6) 04 04 04 08 08 LUAC_INT LUAC_NUM ...
```

Two differences: the format byte is `0x01`, and there are four size bytes
(`int`, `Instruction`, `Integer`, `Number`) where unluac's `LHeaderType53`
expects five (`int`, `size_t`, `Instruction`, `Integer`, `Number`). Rewriting
the format byte and inserting one `0x04` realigns them exactly. Only the header
changes — every byte of prototype, code, constants and debug info is passed
through untouched.

With that done, stock unluac recovers **18,240 of 18,300** modules. The
remaining 60 are not failures:

- **57** are genuinely empty — their disassembly is a lone `return` with no
  constants or code, so the original `.lua` held nothing but comments
- **3** hit a known unluac `NullPointerException`; their full bytecode listings
  are kept as `*.disasm.txt` so no logic is lost

The same applies to `assets/table/*.data`, which is a plain ZIP of 1,275
bytecode modules using the identical header. **All 1,275 decompile.** The two
largest (`lw_monster_opt`, 8 MB; `lw_world_monster`) need `-Xmx3000m`; the
driver takes `LUA_MEM` for exactly this.

### 4. The original `Assets/` tree is embedded in the bytecode

Every chunk stores the absolute source path it was compiled from:

```
/Users/mac/Git-Android-release/aps_client/Tools/../Assets/Main/LuaScripts/...
```

All 18,300 parse cleanly. So the project layout in `unity-project/` — the
`Assets/Main/LuaScripts/<category>/` split, `Assets/Main/HotUpdateDll/`,
`Assets/DataTable/`, the `Assets/Main/...` art paths — is the game's real
directory structure read back out of the binaries, not a reconstruction guess.

### 5. Assets ship as one packed fragment, keyed by hash

`assets/AssetBundles/BundleFragment0.bytes` is 522 MB of **concatenated
`UnityFS` bundles**. `BundleOffsetTable.bytes` gives `int32 offset` +
7-bit-prefixed name per bundle; bundles are contiguous, so each extent runs to
the next record's offset (7,867 of 7,868 offsets land exactly on the `UnityFS`
magic). `gameres` is a 16 MB text manifest: **11,155 directories, 95,602 asset
paths, 32,564 bundles, 46 groups**.

Two things bite here:

- The bundles carry the literal version strings `5.x.x` and `0.0.0` — the studio
  stripped the engine version, so UnityPy refuses them until
  `FALLBACK_UNITY_VERSION` is set to `2019.4.41f1` (read from the APK's own
  build settings).
- The offset table's name/offset pairing does **not** match the actual fragment
  layout, so bundling names taken from the table would mislabel every file.
  Each bundle's real name is therefore read from its own `AssetBundle` object,
  and asset names are resolved against the `gameres` path index — recovered
  files land under true in-game paths such as
  `Assets/Main/ActivityRes/2025EasterMod/Sprites/ActivityIcons/...png`.

Only the 7,868 bundles inside the APK are extractable; the other ~25,000 are
fetched from the studio's CDN on first run.

### 6. Hot-update path is fully visible

`ConstURLConfig.cs` hardcodes the infrastructure:

```csharp
public static readonly string[] cdns = {
  "https://lastwar-cdn.akamaized.net/hotupdate/",
  "https://lastwar-cdn.lastwarapp.net/hotupdate/",
  "https://cdn.lastwar.com/hotupdate/",
  "https://lastwar.asia-cdn.com/hotupdate/"
};
public const string debugDownloadURL_ = "http://lw-local-s188.gamespark.net/hotupdate/";
```

plus server-list hosts per region (`lastwar-serverlist-us-aws-ali`, `-gcp-ali`,
EA variants, a pressure-test host, and localhost GM hosts). The version check
endpoint is `/gameservice/getlsu3dversion.php`.

This is an older build: it still carries the `LuaUpdater` / `LWLuaFile` path,
and the C# tree has per-season systems (`WinterStorm`, `Werewolf`, `NineNation`,
`DarkSeason`, `LondonSeason`, `FlowerTrain`). Expect the live app to have moved on.

### 7. C# type tree is fully intact

`Assembly-CSharp.dll` decompiles to 5,749 types / 53,628 methods, covering the
whole game: city building and troop state machines (`WorldTroop*`, `CityTroop*`),
season/boss systems, the cross-server FSM (`CrossServer*`), asset/manifest
download, and the SDK bridge layer.

---

## Reproducing

Toolchain (JDK 17, jadx 1.5.6, apktool 2.9.3, .NET 8 + ilspycmd, UnityPy) lives
in `/opt/re-tools` where applicable; paths are pinned in `tools/re-env.sh`.

```bash
bash tools/decompile.sh              # Java + resources + native libs + assets
                                    # + Lua + config tables + built-in Unity assets
bash tools/decompile-csharp.sh       # recover .mdl -> decompile to C#
```

Steps are independent and re-runnable, and select work with environment
variables:

```bash
STEPS="apktool raw unity" bash tools/decompile.sh

# chunk the long jadx step on a small box
DEXES="classes4.dex" bash tools/decompile.sh

# heap for the Lua decompiler; the biggest data table needs ~3g
LUA_MEM=3000m STEPS=tables bash tools/decompile.sh

# AssetBundle extraction is resumable; budget is seconds per invocation
BUNDLE_BUDGET=150 STEPS=bundles bash tools/decompile.sh
BUNDLE_BUDGET=0    STEPS=bundles bash tools/decompile.sh   # all 7,868, ~90 min
```

`tools/peprobe` is the validation helper used to work out the `.mdl` format; it
reports PE headers, the CLI header and metadata counts per assembly:

```bash
dotnet run --project tools/peprobe -- decompiled/unity/assemblies/Assembly-CSharp.dll
# magic=PE32 machine=I386 sections=3 corHeader=present
# version=v4.0.30319 types=5749 methods=53628
```

Scripts must be invoked with `bash`, not `sh` — `decompile.sh` uses `pipefail`,
which dash does not support.

---

## Caveats

- The decompiled trees are not meant to compile as-is. They are decompilation
  output: identifiers the compiler already discarded are gone, and library code
  (AndroidX, Kotlin, OkHttp, ad SDKs) is included because it is what ships.
  `source-app/csharp/Assembly-CSharp/Assembly-CSharp.csproj` is the real signal
  for the game's own types.
- The Lua bytecode tables decompile into register-style output
  (`L0_1 = {...}`) — semantically complete and machine-generated, but not
  hand-written-looking source.
- Java output is jadx 1.5.6 with `--deobf`; obfuscated SDK classes keep
  generated names (`C0972R`, `p000j$`), which is expected for library layers.
- Native libraries are extracted, not analyzed. `libunity.so`, `libil2cpp.so`
  (unused), `libxlua.so`, `libgmesdk.so` and `libanogs.so` are the ones that
  would matter for deeper work.
- `source-app/game-assets/` is partial: bundle extraction runs at ~1.4
  bundles/second and was run in bounded slices. Rerun the `bundles` step to
  continue; it resumes from `.state.tsv`.
