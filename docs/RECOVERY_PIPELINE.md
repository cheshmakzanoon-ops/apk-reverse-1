# Recovery pipeline contract — phase R1

## Scope

R1 adds a new capture/verification/export pipeline alongside the legacy scripts.
It does not mutate their recovered source trees, apply new Lua patches, contact
game servers, or purport to finish a Godot port. The legacy README is preserved
verbatim separately because its format research remains useful, but its complete
source/assets claims are not acceptance criteria.

## Artifact layout and identities

`blobs/<first-two-hex>/<sha256>` contains exact byte sequences. `catalog.sqlite`
contains a versioned schema, the input APK digest, all ZIP entry identities and
metadata, parsed units, serialized members/resources, every parsed object, stream
and external-file dependency states, export results and capture issues.

ZIP entry identity uses the archive digest and central-directory ordinal, not a
possibly repeated name. Unit identity adds entry/extent identity. Member identity
adds its exact ancestry within the unit; object identity adds its signed path ID.
Object records preserve byte offsets, lengths and SHA-256 hashes within the
unmodified serialized member. The complete original archive is retained too.
This does not rely on decompilers reconstructing a bit-identical authoring file.

Readable typetrees are secondary. Binary values become blob references and retain
all bytes. Unknown value types cause an explicit decoding error rather than a
truncated `repr`. Nonfinite float64 values are retained as bit strings. Raw member
and object bytes remain authoritative even if a typetree cannot be decoded.

## Resolution

A first pass preserves members and the external references declared in each
serialized file. Texture, mesh and audio typetrees are decoded to collect stream
paths/ranges. `--trees` additionally decodes other object types. This is **not yet
an exhaustive PPtr/component binding graph**; those references remain preserved
in raw objects and optional typetrees.

A second pass resolves an exact normalized name, a same-unit basename, or a
uniquely identified basename across the capture. Identical bytes under multiple
aliases are acceptable for file reads. Different bytes under ambiguous names are
never picked by first-match order. Reference status is one of `resolved`,
`unresolved_in_capture`, `ambiguous`, or `invalid_range`.

Exports use a per-member UnityPy environment and lazy catalog-only dependency
lookup. A memory filesystem prevents scanning the host disk. No environment-wide
monkeypatch is installed. Nested dependencies with ambiguous reused names require
further binding work; they are not guessed. Known resource paths and actual byte
ranges must be inspected before calling an unresolved reference remote-only.

## Conversion boundaries

Mesh output uses UnityPy's mesh exporter and validates finite coordinates,
nonempty geometry, and vertex/UV/normal index bounds. The tests independently open
a synthetic exported mesh with trimesh. OBJ does not carry the recovered game's
full rig, controller, materials, prefab hierarchy or animation behavior; those
remain in the raw snapshot until a verified GLB/hierarchy conversion is added.

Texture checks call `get_image_data()` so external `m_StreamData` is considered.
Empty/short resolved pixel streams fail instead of producing plausible noise.
Sprite checks use `.texture`, not the legacy `.text` typo, and validate explicit
atlas bindings. Unbound atlas tags fail rather than selecting a guessed atlas.
PNG verification proves decodability, not visual or shader-level fidelity.

TextAssets use `surrogateescape` to preserve original binary bytes. Audio is
preserved and its stream dependencies indexed, but R1 does not add a neutral
audio exporter. The existing audio extractor is retained separately.

## Failure semantics

Capture creates an empty, new snapshot. Reusing a populated directory is refused,
so stale results cannot masquerade as a fresh run. Each unit becomes `indexed`,
`not_indexed`, or `error`. Budgeted scans are `partial` and exit nonzero. Capture
exceptions are recorded and the state becomes `failed`; already preserved data
is not deleted. A process killed before orderly shutdown remains non-complete.

The blob byte budget is a storage guard, not a guarantee against memory use in a
third-party decompressor. Run analysis in a resource-limited disposable environment.
Never run native/game code from an unknown APK just to obtain an inventory.

Verification rejects missing catalogs, incomplete scans, inconsistent counts,
corrupt/missing/unaccounted blobs, invalid serialized-object spans or hashes,
invalid resolved stream ranges, and malformed successful PNG/OBJ exports.
Unresolved dependencies or unreadable typetrees do not invalidate raw preservation;
they remain blockers for a claim of fully recovered usable assets. Failed exports
and unattempted exports are reported separately.

## Validation provenance

The regression fixtures are synthetic, including malformed data and repeated
names/path IDs. The actual-Unity integration fixture is a small generated Unity
serialized TextAsset, decoded by the pinned UnityPy version, not a mocked parser.
A separate manual Actions run is necessary for measurements against the supplied
813,035,279-byte APK. Do not cite synthetic counts as recovered game assets.

Local offline validation may skip the actual Unity integration test if UnityPy
cannot be installed. CI explicitly imports the pinned dependency before tests,
so a missing installation cannot silently turn into a passing skipped test run.
Every CI run records `pip freeze`; primary versions are in the requirements file.

## Follow-on gates

1. Preserve and verify the entire exact APK; independently inspect reported model
   and resource counts and several decoded outputs. Keep the full snapshot.
2. Build the exhaustive PPtr graph and original container/manifest path mapping;
   join GameObject/Transform/renderer/material/mesh/skeleton/clip relationships.
3. Implement validated skinned GLB exports, correct coordinate conventions and
   animation sampling, and inspect them in an independent viewer.
4. Reconcile remaining content against a version-matched authorized cache or
   content archive. Keep missing and deliberately unsupported content explicit.
5. Inventory all managed assemblies and native interfaces; preserve IL/bytecode
   alongside decompilation and test critical reconstructed control flow.
6. Build a Godot Android vertical slice using verified recovered inputs. Test
   rendering, controls, gameplay, lifecycle, performance and Android export on
   device. A blank project or generic replacement game is not this milestone.

## Primary implementation references

- https://github.com/K0lb3/UnityPy (pinned runtime version 1.25.4)
- https://github.com/K0lb3/UnityPy/blob/master/UnityPy/classes/legacy_patch/Texture2D.py
- https://github.com/K0lb3/UnityPy/blob/master/UnityPy/helpers/ResourceReader.py
- https://github.com/K0lb3/UnityPy/blob/master/UnityPy/export/SpriteHelper.py

These document library behavior, not measurements of this game's captured data.
