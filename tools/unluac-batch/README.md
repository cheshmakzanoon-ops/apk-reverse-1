# Lua bytecode decompiler driver

Decompiles all 18,300 Lua modules and all 1,275 config tables out of the game's
bytecode. Three layers, in the order the pipeline applies them:

1. **`unluac.jar`** - upstream unluac, with the game's modified header fixed up
   in memory by `UnluacBatch.java`.
2. **`patch/`** - two vendored unluac source files, compiled over the jar, that
   fix the one crash that stopped 3 modules from decompiling at all.
3. **`recovered/`** - five modules whose control flow unluac gets structurally
   wrong. It decompiles them without error; the result does not parse.

## `unluac.jar` (vendored)

Upstream [unluac](https://sourceforge.net/projects/unluac/) for Lua 5.0-5.4,
from its SourceForge release page
(`https://sourceforge.net/projects/unluac/files/latest/download`, reporting
`unluac v1.2.3.569`). It is vendored rather than downloaded at run time so the
pipeline works offline and stays reproducible.

## `UnluacBatch.java`

Spawning a JVM per chunk for 18,300 files would cost far more in startup than in
decompilation, so this driver loops inside one JVM. It is also where the
game-specific header problem is handled.

### The studio ships a modified `luac`

Every chunk the game ships has a non-standard binary header:

```
studio:  sig(4) ver(1) fmt=0x01(1) DATA(6) 04 04 08 08    LUAC_INT LUAC_NUM ...
upstream + unluac:
         sig(4) ver(1) fmt=0x00(1) DATA(6) 04 04 04 08 08 LUAC_INT LUAC_NUM ...
```

Two differences: the format byte is `0x01` instead of `0x00`, and there are four
size bytes (`int`, `Instruction`, `Integer`, `Number`) where unluac's
`LHeaderType53` expects five (`int`, `size_t`, `Instruction`, `Integer`,
`Number`). Rewriting the format byte and inserting one `0x04` realigns them
exactly. Only the header changes - every byte of prototype, code, constants and
debug info is passed through untouched.

`normalise()` does this in memory, so no second ~100 MB copy of the bytecode
tree is written to disk.

### Exit status

The driver exits non-zero only for systemic breakage - wrong inputs or a broken
tool - defined as more than half the attempted chunks failing. A handful of
individual chunks that unluac cannot handle is a *result*, not a crash: with
`set -e` in the calling pipeline, aborting the run would strand every later
stage. Both paths are covered by negative tests.

That threshold is now dead weight: after the patch below, **0 of 18,300 chunks
fail**. It is kept because it is the guard that would stop a broken jar from
"successfully" producing 18,300 empty files.

## `patch/` - the vendored unluac fix

`patch/unluac/decompile/ControlFlowHandler.java` is a full copy of the upstream
file with one change, and `patch/unluac/parse/LFloatNumber.java` with one
modifier widened. Both carry a provenance header. Build them with:

```bash
sh tools/unluac-batch/build-patch.sh      # -> classes/, JDK only, no network
```

The patched classes are compiled *against* `unluac.jar`, so they override only
the two classes they replace and everything else still resolves from the jar.

**The classpath order is `classes:unluac.jar`, not the reverse.** With the jar
first the JVM loads upstream's `ControlFlowHandler` and the patch is silently
inert - which is exactly the state the pipeline was in until it was caught.

### What the fix is

`ControlFlowHandler.is_break_jmp` dereferences `target.getEnd()` with no null
check:

```java
if (target.getEnd() == breakable.getEnd()) { ... }
```

Six sibling call sites in the same file guard the same dereference. When a
`goto` targets a prototype that is not a block, `target` is null and unluac dies
with a `NullPointerException`. The patch adds the null guard its siblings
already have.

The A/B proof, on the full tree:

| classpath | ok | empty | fail |
|---|---|---|---|
| `unluac.jar:classes` (patch inert) | 18,240 | 57 | 3 |
| `classes:unluac.jar` (patch live) | 18,243 | 57 | **0** |

The 3 failures are exactly the 3 `NullPointerException`s. Diffing a clean
patched run against the committed tree touches those 5 files and nothing else:
18,294 files byte-identical.

## `recovered/` - hand-reconstructed control flow

unluac can exit 0 and still emit Lua that its own parser rejects. Five modules
have a `goto` whose label lands inside a block, which is not valid Lua. These
were reconstructed by reading the bytecode listings, and live as patches in
`recovered/*.patch`; see `recovered/README.md` for the per-module reasoning.

```bash
sh tools/unluac-batch/apply-recovered.sh
```

Idempotent: an already-applied patch is skipped. A patch that applies in
*neither* direction is a hard error - it means unluac's output drifted and the
reconstruction needs rechecking, which must not pass unnoticed.

## `DisasmOne.java` / `disasm-one.sh`

`UnluacBatch` only emits a `*.disasm.txt` listing when decompilation *throws*.
A chunk that decompiles cleanly but emits unparseable control flow looks like a
success, so this helper produces a listing for a single chunk on demand - which
is how all five reconstructions were done.

```bash
sh tools/unluac-batch/disasm-one.sh <chunk.luac> [out.disasm.txt]
```

Requires `classes/` to be built.

## Syntax gate

`tools/check-lua-syntax.py` compiles every recovered `.lua` and separates real
parse errors from artifacts of the host interpreter. Current state:

```
source-app/lua/src          18,300 files -> 18,296 ok, 4 lua-5.5-only, 0 failed
source-app/data-tables-lua   1,275 files ->  1,275 ok, 0 lua-5.5-only, 0 failed
```

The 4 "5.5-only" warnings are assignments to a `for` loop's control variable,
which Lua 5.4 and 5.5 reject and 5.3 accepts. The game's compiler is 5.3-era,
so they are false positives - but they are reported as WARN rather than dropped,
because the host interpreter is a proxy, not the real thing. **A `lua5.3`
binary is the missing piece here**; see the limitations in the top-level
`README.md`.

## Usage

```bash
javac -cp unluac.jar -d classes UnluacBatch.java DisasmOne.java
java -Xmx1500m -Dunluac.failures=failures.tsv -cp classes:unluac.jar \
    UnluacBatch <chunkRoot> <luaOutRoot> [--force]
```

The run is resumable: a chunk whose output already exists is skipped. Chunks are
selected by magic rather than by extension, because the game's data tables are
the same bytecode but stored without one. `-Dunluac.failures` is rewritten on
each run rather than appended, so a chunk that failed on an early attempt and
succeeded later does not stay listed.

Larger chunks need a bigger heap: the biggest config table needs `-Xmx3000m`.
