"""Generated source files are provenance tests, not newly recovered game code."""
from pathlib import Path
import hashlib
import os
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from recovery_core import RecoveryError
from recovery_source_links import build


class SourceLinksTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.git('init', '-q')
        self.git('config', 'user.name', 'Generated test')
        self.git('config', 'user.email', 'test@example.invalid')
        self.profile = {'input_sha256': 'a' * 64, 'roots': [{'path': 'assets/stage.prefab'}]}
    def tearDown(self):
        self.tmp.cleanup()
    def git(self, *args):
        return subprocess.check_output(['git', *args], cwd=self.root, stderr=subprocess.PIPE)
    def source(self, text, name='module.lua'):
        p = self.root/'source-app'/name
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_bytes(text if isinstance(text, bytes) else text.encode())
        self.git('add', '--', str(p.relative_to(self.root)))
        self.git('commit', '-qm', 'Generated source fixture')
        return p
    def test_exact_line_source_hash_and_commit_recorded(self):
        p=self.source('first\nload("Stage")\n')
        r=build(self.root,self.profile); m=r['matched_files'][0]
        self.assertEqual(m['matches'],[{'line':2,'text':'load("Stage")','terms':['stage']}])
        self.assertEqual(m['sha256'],hashlib.sha256(p.read_bytes()).hexdigest())
        self.assertEqual(r['commit'],self.git('rev-parse','HEAD').decode().strip())
        self.assertTrue(r['all_inspected_files_match_head'])
    def test_source_is_not_executed(self):
        self.source('os.execute("touch forbidden") -- stage')
        build(self.root,self.profile)
        self.assertFalse((self.root/'forbidden').exists())
    def test_dirty_matching_file_refused(self):
        p=self.source('-- stage');p.write_text('-- stage edited')
        with self.assertRaises(RecoveryError):build(self.root,self.profile)
    def test_removed_hit_cannot_conceal_dirty_source(self):
        p=self.source('-- stage');p.write_text('-- unrelated')
        with self.assertRaises(RecoveryError):build(self.root,self.profile)
    def test_dirty_nonmatching_source_also_refused(self):
        p=self.source('-- unrelated');p.write_text('-- different')
        with self.assertRaises(RecoveryError):build(self.root,self.profile)
    def test_staged_but_uncommitted_edit_refused(self):
        p=self.source('-- stage');p.write_text('-- stage changed');self.git('add','source-app/module.lua')
        with self.assertRaises(RecoveryError):build(self.root,self.profile)
    def test_untracked_sources_do_not_become_recovered_hits(self):
        self.source('-- unrelated');(self.root/'source-app/untracked.lua').write_text('-- stage')
        r=build(self.root,self.profile)
        self.assertEqual(r['source_files_scanned'],1);self.assertEqual(r['matched_files'],[])
    def test_missing_source_remains_explicit(self):
        p=self.source('-- stage');p.unlink();r=build(self.root,self.profile)
        self.assertEqual(len(r['skipped_files']),1);self.assertEqual(r['source_files_scanned'],0)
    def test_symlink_target_not_read(self):
        p=self.source('-- stage');p.unlink();p.symlink_to(self.root/'absent')
        r=build(self.root,self.profile);self.assertEqual(len(r['skipped_files']),1)
    def test_big_file_reported_not_silently_covered(self):
        self.source(b'-- stage'+b' '*(4*1024**2))
        r=build(self.root,self.profile);self.assertEqual(len(r['skipped_files']),1)
    def test_binary_bytes_preserved_in_hit_not_executed(self):
        self.source(b'-- stage \xff\n');r=build(self.root,self.profile)
        self.assertEqual(r['matched_files'][0]['matches'][0]['text'].encode('utf-8','surrogateescape'),b'-- stage \xff')
    def test_only_declared_source_types_inspected(self):
        self.source('-- stage','data.txt');self.source('// stage','code.cs')
        r=build(self.root,self.profile);self.assertEqual(r['source_files_scanned'],1)
    def test_empty_roots_refused(self):
        self.source('-- stage')
        with self.assertRaises(RecoveryError):build(self.root,{'roots':[]})
    def test_scope_does_not_claim_dynamic_or_behavioral_recovery(self):
        self.source('-- stage');r=build(self.root,self.profile)
        for k in ('dynamic_dependencies_complete','behavior_ported','source_binary_equivalence_proven','game_code_executed'):
            self.assertFalse(r[k])


if __name__ == '__main__':unittest.main()
