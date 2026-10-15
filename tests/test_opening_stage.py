from __future__ import annotations
from pathlib import Path
import re
import sys
import unittest
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
import opening_stage_oracle as oracle  # noqa: E402

PORT = ROOT / 'godot/gameplay/opening_stage_encounter.gd'
SPEC = dict(name='unit', fps=64, seconds=40, hero_load_delay=0.0, zaku_load_delay=0.0,
            vfx_load_delay=0.0, seed=11, turret_yaw=0.0)


class OracleBase(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.sources = oracle.load_sources(ROOT)
        cls.stage = oracle.stage_row(ROOT)
        cls.result = oracle.run_scenario(cls.sources, cls.stage, SPEC)
        cls.dt = 1.0 / SPEC['fps']

    def frames_over(self, seconds):
        """Updates needed for a timer accumulating dt each frame to exceed `seconds`."""
        total, frames = 0.0, 0
        while not total > seconds:
            total += self.dt
            frames += 1
        return frames

    def gap_frames(self, t0, t1):
        return round((t1 - t0) / self.dt)

    def events(self, name, **match):
        return [e for e in self.result['trace'] if e['ev'] == name and all(e.get(k) == v for k, v in match.items())]


class SandboxTests(OracleBase):
    def test_recovered_lua_runs_without_engine_errors_or_unmodelled_calls(self):
        self.assertEqual(self.result['errors'], [])
        # A nonempty touch map would mean the recovered code reached an engine API the harness
        # does not model and silently received an inert stand-in.
        self.assertEqual(self.result['touches'], {})

    def test_stage_six_row_is_read_from_the_committed_table(self):
        self.assertEqual(self.stage, {'id': 6, 'nodes': ['98,0.4,104']})

    def test_run_is_reproducible(self):
        again = oracle.run_scenario(self.sources, self.stage, SPEC)
        self.assertEqual(again['trace'], self.result['trace'])
        self.assertEqual(again['final'], self.result['final'])

    def test_changed_source_is_rejected(self):
        name = next(iter(oracle.PINNED))
        with mock.patch.dict(oracle.PINNED, {name: '0' * 40}):
            with self.assertRaises(SystemExit):
                oracle.load_sources(ROOT)

    def test_unscripted_randomness_cannot_leak_in(self):
        # The harness demands a scripted sequence, and in the first second only the five
        # spawn-delay draws can occur (no zombie has reached its attack state yet).
        self.assertIn('scripted random sequence exhausted', oracle.HARNESS)
        run = oracle.run_scenario(self.sources, self.stage, dict(SPEC, seconds=1))
        self.assertEqual(run['final']['rng_draws'], 5)

    def test_refuses_to_overwrite_existing_output(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / 'oracle.json'
            target.write_text('keep')
            with self.assertRaises(SystemExit):
                oracle.main(['--repo', str(ROOT), '--out', str(target)])
            self.assertEqual(target.read_text(), 'keep')


class RecoveredBehaviourTests(OracleBase):
    """Timing facts established by running the recovered state scripts."""

    def hero_states(self):
        return [(e['t'], e['state']) for e in self.events('fsm', who='hero')]

    def test_hero_starts_idle_and_cycles_aim_fire_reload(self):
        states = [s for _, s in self.hero_states()]
        self.assertEqual(states[0], 'Idle')
        cycle = ['Idle', 'Aim', 'Fire', 'Reload']
        for previous, current in zip(states, states[1:]):
            self.assertEqual(current, cycle[(cycle.index(previous) + 1) % 4])
        self.assertGreaterEqual(states.count('Reload'), 3)

    def test_kill_lands_half_a_second_after_fire_begins(self):
        fires = [t for t, s in self.hero_states() if s == 'Fire']
        kills = [e['t'] for e in self.events('destroyed')]
        self.assertGreaterEqual(len(kills), len(fires) - 1)
        for fire_time in fires[:len(kills)]:
            gap = min(k - fire_time for k in kills if k >= fire_time)
            self.assertAlmostEqual(gap, 0.5, delta=self.dt * 1.01)

    def test_reload_holds_for_just_over_one_and_a_half_seconds(self):
        states = self.hero_states()
        reloads = 0
        for (t0, s0), (t1, s1) in zip(states, states[1:]):
            if s0 == 'Reload':
                self.assertEqual(s1, 'Idle')
                # Reload is entered from a timer before the hero's own update, so its first
                # update (and first dt of accumulation) is on the entry frame.
                self.assertEqual(self.gap_frames(t0, t1), self.frames_over(1.5) - 1)
                reloads += 1
        self.assertGreater(reloads, 3)

    def test_turret_aims_before_firing(self):
        # Aim -> Fire only happens through the turret component, never instantly with a far turn.
        spec = dict(SPEC, name='away', turret_yaw=170.0, seconds=20)
        run = oracle.run_scenario(self.sources, self.stage, spec)
        states = [(e['t'], e['state']) for e in run['trace'] if e['ev'] == 'fsm' and e['who'] == 'hero']
        aim = next(t for t, s in states if s == 'Aim')
        fire = next(t for t, s in states if s == 'Fire')
        # About 170 degrees at 30 degrees per second.
        self.assertGreater(fire - aim, 4.5)

    def test_zombie_born_then_walk_for_configured_time_then_attack(self):
        walk_times = {int(i): float(w) for i, w in re.findall(r'"id": (\d+),[^}]*"walk_time": ([0-9.]+)', PORT.read_text())}
        self.assertEqual(set(walk_times), {1, 2, 3, 4, 5})
        by_zombie = {}
        for e in self.events('fsm'):
            if e['who'] != 'hero': by_zombie.setdefault(e['who'], []).append((e['t'], e['state']))
        spawn_id = {f"z{e['z']}": e['id'] for e in self.events('spawn')}
        checked = 0
        for who, states in by_zombie.items():
            names = [s for _, s in states]
            self.assertEqual(names[0], 'Born')
            if len(states) >= 2:
                self.assertEqual(names[1], 'Walk')
                # Born is entered by a timer and updates on that same frame.
                self.assertEqual(self.gap_frames(states[0][0], states[1][0]), self.frames_over(2.8) - 1)
                checked += 1
            if len(states) >= 3:
                self.assertEqual(names[2], 'Attack')
                # Walk is entered during Born's update, so its accumulation starts next frame.
                self.assertEqual(self.gap_frames(states[1][0], states[2][0]),
                                 self.frames_over(walk_times[spawn_id[who]]))
        self.assertGreater(checked, 5)

    def test_killed_zombies_are_replaced_in_the_same_instant_at_the_same_slot(self):
        kills = self.events('destroyed')
        self.assertGreater(len(kills), 5)
        for kill in kills:
            spawns = [s for s in self.events('spawn', id=kill['id']) if s['t'] == kill['t'] and s['z'] != kill['z']]
            self.assertEqual(len(spawns), 1, kill)

    def test_walking_zombie_killed_mid_walk_clears_its_walking_flag(self):
        flags = [e for e in self.events('anim', call='SetBool') if e['arg'] == 'walking']
        for who in {e['who'] for e in flags}:
            seq = [e['val'] for e in flags if e['who'] == who]
            self.assertEqual(seq[0], True)
            self.assertEqual(seq, [True, False][:len(seq)])

    def test_muzzle_flash_and_hit_use_recovered_scales(self):
        vfx = self.events('vfx')
        self.assertTrue(vfx)
        for e in vfx:
            self.assertEqual(e['scale'], {'muzzle': 2, 'blood': 1}[e['kind']])

    def test_update_order_hazard_is_reported_not_hidden(self):
        # Frames where two zombies draw randomness in one update depend on Lua's pairs() order.
        self.assertIsInstance(self.result['ambiguous_frames'], list)


class PortConstantTests(unittest.TestCase):
    def test_port_constants_match_what_the_recovered_code_does(self):
        text = PORT.read_text()
        for name, value in {'HERO_SCALE': '1.2', 'ZAKU_BORN_TIME': '2.8', 'ZAKU_WALK_SPEED': '0.35',
                            'HERO_FIRE_DELAY': '0.5', 'HERO_RECOVER_DELAY': '0.3', 'HERO_RELOAD_TIME': '1.5',
                            'TURRET_ROTATE_SPEED': '30.0', 'TURRET_ALIGN_DOT': '0.999'}.items():
            self.assertRegex(text, rf'const {name} := {re.escape(value)}\b')
        self.assertEqual(oracle.FIXTURE_HERO['rotate_speed'], 30.0)


if __name__ == '__main__':
    unittest.main()
