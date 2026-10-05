"""Generated reference-cache tests, not additional game recovery measurements."""
import json
from pathlib import Path
import sys
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
import recovery_graph as graph
from recovery_core import Catalog, RecoveryError
from test_recovery_r2 import GraphFixture, ptr


class ReferenceCacheTests(GraphFixture):
    def tearDown(self):
        for cat in getattr(self, "catalogs", []):
            cat.close()
        super().tearDown()

    def open_graph(self):
        root = self.snapshot(externals=('missing.assets',))
        self.build()
        cat = Catalog(root)
        if not hasattr(self, "catalogs"): self.catalogs = []
        self.catalogs.append(cat)
        mid = cat.db.execute('SELECT member_id FROM objects LIMIT 1').fetchone()[0]
        return cat, mid

    def test_cached_results_equal_uncached_for_all_statuses(self):
        cat, mid = self.open_graph()
        values = [ptr(1), ptr(6), ptr(999), ptr(-2**63), ptr(0), ptr(1, 1), ptr(1, 99),
                  ptr(0, 99), ptr(True), ptr(1, -1), ptr(2**63), ptr([], 0), ptr(1, {})]
        expected = [graph.resolve(cat, mid, p) for p in values]
        with graph.cached_references(cat):
            for _ in range(2):
                self.assertEqual([graph.resolve(cat, mid, p) for p in values], expected)

    def test_duplicate_refs_avoid_repeated_database_queries(self):
        cat, mid = self.open_graph()
        queries = []
        cat.db.set_trace_callback(queries.append)
        for _ in range(100): graph.resolve(cat, mid, ptr(1))
        uncached = len(queries); queries.clear()
        with graph.cached_references(cat) as cache:
            for _ in range(100): graph.resolve(cat, mid, ptr(1))
            self.assertEqual(cache.cache_info().misses, 1)
            self.assertEqual(cache.cache_info().hits, 99)
        self.assertEqual((uncached, len(queries)), (100, 1))
        cat.db.set_trace_callback(None)

    def test_capacity_is_bounded_and_eviction_preserves_values(self):
        cat, mid = self.open_graph()
        with graph.cached_references(cat, max_entries=2) as cache:
            for p in (1, 2, 3, 1):
                self.assertEqual(graph.resolve(cat, mid, ptr(p)), graph._resolve_uncached(cat, mid, ptr(p)))
            self.assertEqual(cache.cache_info().currsize, 2)
            self.assertEqual(cache.cache_info().misses, 4)

    def test_member_id_is_part_of_key(self):
        cat, mid = self.open_graph()
        with graph.cached_references(cat):
            self.assertEqual(graph.resolve(cat, mid, ptr(1))[2], 'resolved')
            self.assertEqual(graph.resolve(cat, 'another-member', ptr(1))[2], 'missing_object')

    def test_external_slot_is_part_of_key(self):
        cat, mid = self.open_graph()
        with graph.cached_references(cat):
            self.assertEqual(graph.resolve(cat, mid, ptr(1))[2], 'resolved')
            self.assertEqual(graph.resolve(cat, mid, ptr(1, 1))[2], 'unresolved_in_capture')

    def test_ambiguity_remains_a_blocker(self):
        cat, mid = self.open_graph()
        with patch.object(cat, 'resolve', return_value=('ambiguous', None)):
            with graph.cached_references(cat):
                self.assertEqual(graph.resolve(cat, mid, ptr(1, 1))[2], 'ambiguous')

    def test_resource_cannot_be_used_as_serialized_target(self):
        cat, mid = self.open_graph()
        with patch.object(cat, 'resolve', return_value=('resolved', {'kind': 'resource'})):
            with graph.cached_references(cat):
                self.assertEqual(graph.resolve(cat, mid, ptr(1, 1))[2], 'not_serialized')

    def test_nested_scope_restores_parent_and_clears_own_cache(self):
        cat, mid = self.open_graph()
        with graph.cached_references(cat) as outer:
            graph.resolve(cat, mid, ptr(1))
            with graph.cached_references(cat) as inner:
                graph.resolve(cat, mid, ptr(1))
                self.assertIs(cat._reference_cache, inner)
            self.assertEqual(inner.cache_info().currsize, 0)
            self.assertIs(cat._reference_cache, outer)
        self.assertFalse(hasattr(cat, '_reference_cache'))
        self.assertEqual(outer.cache_info().currsize, 0)

    def test_exception_removes_cache(self):
        cat, _ = self.open_graph()
        with self.assertRaisesRegex(RuntimeError, 'injected'):
            with graph.cached_references(cat): raise RuntimeError('injected')
        self.assertFalse(hasattr(cat, '_reference_cache'))

    def test_verifier_does_not_inherit_success_after_identity_edit(self):
        cat, _ = self.open_graph()
        self.assertEqual(graph.verify_graph(cat), [])
        cat.db.execute('UPDATE objects SET path_id=60 WHERE path_id=6')
        errors = graph.verify_graph(cat)
        self.assertTrue(any('invalid pointer binding' in e for e in errors))
        self.assertFalse(hasattr(cat, '_reference_cache'))

    def test_verifier_still_detects_changed_edge(self):
        cat, _ = self.open_graph()
        self.assertEqual(graph.verify_graph(cat), [])
        cat.db.execute("UPDATE object_refs SET status='null' WHERE status='resolved'")
        self.assertTrue(graph.verify_graph(cat))

    def test_new_scope_reads_changed_slots(self):
        cat, mid = self.open_graph()
        with graph.cached_references(cat):
            self.assertEqual(graph.resolve(cat, mid, ptr(1, 1))[4], 'missing.assets')
        cat.db.execute("UPDATE external_slots SET name='different.assets' WHERE file_id=1")
        with graph.cached_references(cat):
            self.assertEqual(graph.resolve(cat, mid, ptr(1, 1))[4], 'different.assets')

    def test_verifier_pins_snapshot_while_another_connection_commits(self):
        import sqlite3
        cat, _ = self.open_graph()
        cat.db.commit()
        cat.db.execute('PRAGMA journal_mode=WAL')
        original = graph.tree_for
        changed = []
        def during_read(catalog, obj):
            if not changed:
                with sqlite3.connect(cat.root / 'catalog.sqlite') as writer:
                    writer.execute('UPDATE objects SET path_id=60 WHERE path_id=6')
                changed.append(True)
            return original(catalog, obj)
        with patch.object(graph, 'tree_for', side_effect=during_read):
            self.assertEqual(graph.verify_graph(cat), [])
        self.assertEqual(changed, [True])
        self.assertTrue(graph.verify_graph(cat))
        self.assertFalse(cat.db.in_transaction)

    def test_invalid_capacity_refused(self):
        cat, _ = self.open_graph()
        for value in (0, -1, True, 2.5, 262145):
            with self.subTest(value=value), self.assertRaises(RecoveryError):
                with graph.cached_references(cat, value): pass

    def test_exception_is_not_cached(self):
        cat, mid = self.open_graph()
        original = graph._resolve_uncached
        with graph.cached_references(cat) as cache:
            with patch.object(graph, '_resolve_uncached', side_effect=RuntimeError('read failed')):
                with self.assertRaises(RuntimeError): graph.resolve(cat, mid, ptr(1))
            self.assertEqual(graph.resolve(cat, mid, ptr(1)), original(cat, mid, ptr(1)))
            self.assertEqual(cache.cache_info().misses, 2)


if __name__ == '__main__': unittest.main()
