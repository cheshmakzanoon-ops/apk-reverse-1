# Lua bytecode decompiler driver

## `unluac.jar` (vendored)

`unluac.jar` is the upstream [unluac](https://sourceforge.net/projects/unluac/)
decompiler for Lua 5.0-5.4, downloaded from its SourceForge release page
(`https://sourceforge.net/projects/unluac/files/latest/download`, reporting
`unluac v1.2.3.569`). It is vendored rather than downloaded at run time so the
pipeline works offline and stays reproducible.

unluac is the tool that decompiled 18,240 of the game's 18,300 Lua modules, and
all 1,275 config tables.

## `UnluacBatch.java`

Spawning a JVM per chunk for 18,300 files would cost far more in startup than in
decompilation, so this driver loops inside one JVM. It is also where two
game-specific problems are handled.

### 1. The studio ships a modified `luac`

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

### 2. Exit status distinguishes per-chunk gaps from real breakage

unluac has known limitations - it throws `NullPointerException` on some loop
shapes. Those chunks are preserved as `*.disasm.txt` bytecode listings so the
logic stays hand-recoverable, so they are a *result*, not a crash, and the driver
exits 0. Returning non-zero for them would abort the calling pipeline under
`set -e` and strand every later stage.

What still fails loudly is systemic breakage (wrong inputs, a broken tool),
defined as more than half the attempted chunks failing. Both paths are covered
by negative tests.

## Usage

```bash
javac -cp unluac.jar -d classes UnluacBatch.java
java -Xmx1500m -Dunluac.failures=failures.tsv -cp unluac.jar:classes \
    UnluacBatch <chunkRoot> <luaOutRoot> [--force]
```

The run is resumable: a chunk whose output already exists is skipped. Chunks are
selected by magic rather than by extension, because the game's data tables are
the same bytecode but stored without one. `-Dunluac.failures` is rewritten on
each run rather than appended, so a chunk that failed on an early attempt and
succeeded later does not stay listed.

Larger chunks need a bigger heap: the biggest config table needs `-Xmx3000m`.
