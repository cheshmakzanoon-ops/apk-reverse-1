# Recovered Lua modules

Patches applied on top of unluac's output. Each one repairs a module unluac
decompiled *without error* but whose result is not valid Lua, so nothing in
the pipeline noticed.

## Why these exist

`tools/check-lua-syntax.py` compiles every recovered `.lua`. It exists because
"unluac exited 0" is not the same claim as "the output loads". unluac emits
control flow its own Lua parser rejects, and that failure mode is silent: the
module looks recovered right up until something tries to run it.

Five modules were affected, all by the same root cause. When luac's control
flow optimiser flattens an `if` whose body ends in a forward jump, unluac
cannot always pick an `if`/`else` split that keeps the jump visible. It picks
one anyway and places the label inside the `else`, producing

```lua
if COND then
  ...
  goto lbl_42      -- jumps forward
  ::lbl_41::
else
  ::lbl_42::       -- ... into a block the goto cannot enter
  ...
end
```

which is a parse error (`no visible label 'lbl_42' for <goto>`), not a
runtime surprise. `DetectEventItemInfoView` is the same bug with a different
symptom: unluac lost a block boundary outright and the file ends up one `end`
short.

## How they were repaired

Not by pattern-matching the bad output. Each module was reconstructed from its
bytecode listing, which `tools/unluac-batch/disasm-one.sh` produces on demand,
and each reconstruction was checked against every line number the listing
records. Where the bytecode was ambiguous the patch keeps unluac's structure
and only removes the artefacts; where unluac had clearly mis-attributed a
block the body is put back where the jumps say it belongs.

## What each patch does

| Module | Repair |
| --- | --- |
| `DataCenter/SeasonManager/SeasonUpgradeLogManager` | `goto lbl_41` landed in the `else`. The real source is `if string.IsNullOrEmpty(update_time) then ... return end` followed by an unguarded tail, so the expiry check hoists out and the `sever` parsing follows it. |
| `UI/LWSeason/LWSeasonMain/Utils/SeasonRedPointUtils` | `goto lbl_47` landed in the `else`. Tail hoisted to after the `if heroConfigData` block. |
| `Util/LWResourceLackUtil` | `goto lbl_430` landed in the `else`, and the `else / if` pair is really an `elseif`. |
| `Scene/FlowerTrain/SingleFlowerTrain` | `goto lbl_82` was a jump to the end of its own branch, i.e. a no-op. Dropped. |
| `UI/UILWRadarCenter/UIDetectEvent/Component/DetectEventItemInfoView` | Lost block boundary. The VIP-worker section is emitted *after* the `if data ~= nil` block (the jumps to `l126` prove it), not inside it. |

## Applying

`tools/unluac-batch/apply-recovered.sh`, run automatically by
`tools/decompile.sh` after the Lua stage and by `tools/ci-checks.sh`. It is
idempotent, and it fails loudly rather than silently skipping a patch that no
longer applies — which would mean unluac's output changed and these
reconstructions need rechecking.
