"""Regression for Unity's empty-but-truthy variable-weight container."""
import sys
from pathlib import Path
from types import SimpleNamespace
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from recovery_model import variable_skin_present
from recovery_core import RecoveryError

class VariableWeightGuards(unittest.TestCase):
    def test_empty_container_is_not_variable_skin(self):
        for value in (None, [], (), b'', SimpleNamespace(m_Data=[])):
            self.assertFalse(variable_skin_present(value))

    def test_nonempty_data_still_blocks(self):
        for value in ([1], b'\x01', SimpleNamespace(m_Data=[1])):
            self.assertTrue(variable_skin_present(value))

    def test_unknown_layout_is_not_silently_accepted(self):
        with self.assertRaises(RecoveryError):
            variable_skin_present(SimpleNamespace(unrecognized=[]))

if __name__ == '__main__':
    unittest.main()
