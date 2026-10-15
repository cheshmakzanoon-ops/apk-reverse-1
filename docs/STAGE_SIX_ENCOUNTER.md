# Stage-six encounter port

The opening-stage dependency package (`OPENING_STAGE_SCOPE.md`) recovers the stage-six
actors' raw objects. This milestone ports their **behaviour**: a stationary SoloHero turret
shoots a stream of ZakuB/ZakuC zombies, and each killed zombie is replaced at the spot it
started from. It is logic only. It does not assemble a scene, load any recovered asset, or
make a playable stage.

## What the recovered code does

`LWOpeningStageDirtyWorks:ShowInTroubledFellow` places SoloHero (scale 1.2) at the first node
of stage 6 (`98, 0.4, 104`, read from `lw_opening_stage.lua`) and queues five zombies, each
after `random() * 2` seconds, at fixed positions and yaws around z = 109-111.

| Actor | State | Behaviour |
|---|---|---|
| ZakuZombie | Born | waits until its timer exceeds 2.8 s |
| | Walk | `walking=true`; moves forward at 0.35 units/s until its timer exceeds the config's `walkTime` (6, 6, 5, 4, 4 s); the step is also applied on the frame it leaves Walk |
| | Attack | fires the `attack` trigger, then waits `random() * 3.2 + 0.5` s, repeatedly |
| SoloHero | Idle | plays `idle`; as soon as any zombie has been initialised, aims at the first one |
| | Aim | the turret component rotates 30 deg/s toward the target until the flat direction is within `dot > 0.999` |
| | Fire | after 0.5 s: muzzle flash (scale 2), hit effect (scale 1) and the kill; plays `attack`; 0.3 s later enters Reload |
| | Reload | plays `idle`; returns to Idle once its timer exceeds 1.5 s |

Killing a zombie broadcasts a destroyed event. The event dealer immediately creates a new
zombie from the same config, so the encounter never ends. A zombie killed mid-walk clears its
`walking` flag as its state machine is torn down.

## Files

| File | Role |
|---|---|
| `godot/gameplay/opening_stage_encounter.gd` | the port, in plain 64-bit floats (Godot's `Vector3` is 32-bit) |
| `godot/gameplay/opening_stage_fsm.gd` | the recovered `Common.FSMachine` switching contract |
| `godot/gameplay/opening_stage_math.gd` | yaw helpers in Unity's left-handed frame |
| `tools/opening_stage_oracle.py` | runs the recovered Lua and writes reference traces |
| `godot/gameplay/verify_opening_stage.gd` | replays the scenarios through the port and diffs the traces |
| `tests/test_opening_stage.py` | oracle integrity and recovered-timing assertions |

## Verification

The oracle runs, unmodified and pinned by git blob ID, the real `ShowInTroubledFellow`, the
real utils update loop, the event dealer, `SoloHero`, `ZakuZombie`, `FSMachine`, `BaseClass`,
`string.split` and all seven state scripts, in a Lua 5.3 sandbox with no OS, file, debug or
network access and an instruction budget. Only Unity services are stubbed: resource loading,
transforms, animators, the timer service, the event bus and the `SoloHeroTurret` component
(re-implemented from the recovered C#). Randomness is a scripted integer sequence.

Anything the recovered code reaches that the harness does not model resolves to an inert
"ghost" and is reported. The accepted runs have **zero ghost touches and zero engine errors**,
and a unit test enforces that.

Five scenarios (32/64/128 fps, three asset-latency profiles, turrets starting at 0, 170 and
-120 degrees, one 150 s soak) produce **2,507 events**: spawns, every state change, animator
calls, effect positions, kills, respawns and final positions. The GDScript port reproduces all of
them in order, with numbers within 1e-9, and its final state matches. Run it with:

```bash
python tools/opening_stage_oracle.py --repo . --out reports/opening-stage/oracle.json
godot --headless --path godot --script gameplay/verify_opening_stage.gd -- \
  reports/opening-stage/oracle.json reports/opening-stage/native-encounter.json
python -m unittest tests/test_opening_stage.py -v
```

## Assumptions the recovered code does not settle

- **Frame order.** Timers, then the hero's and zombies' Lua update (zombies in id order), then
  the turret component. Unity's real order between these is not recovered.
- **Load latency.** Assets are assumed to finish loading after a configurable delay (default 0,
  and tested at 0.03-0.3 s). A kill and its hit effect are assumed to happen on the same frame.
- **Event listener order** is registration order.
- **`pairs()` order.** The real utils update zombies in Lua table order. The port uses ascending
  id. This only matters on a frame where two zombies draw randomness at once; the oracle counts
  those frames. Two of five scenarios contain one, and the port still matched, but ordering there
  is not proven.
- **Turret and muzzle placement are fixtures.** The real values live in the SoloHero prefab
  hierarchy and must come from the recovered package, not from this milestone.

## Not covered

LingerZombie, the squad, camera and guide flow, the parkour battle that follows (level 1008),
road variants, sound, UI, particle effects themselves (only their requested positions and
scales), and the effect warm-up instantiated in the Fire state's constructor. None of this runs
on a device. This does not establish equivalence with the shipped binary.
