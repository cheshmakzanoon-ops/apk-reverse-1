"""Regress the actual Android 34 view hierarchy from failed run 37247167064.

The XML is observed evidence. Mutated variants below are negative test fixtures,
not measurements of additional devices or recovered assets.
"""
from pathlib import Path
import sys
import unittest
import xml.etree.ElementTree as ET

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from android_runtime_check import PACKAGE, physical_point, surface_bounds

FIXTURE = Path(__file__).parent / 'fixtures/godot-android-generic-view.xml'
SIZE = [1080, 2209]
BOUNDS = [0, 128, 1080, 2337]


def fixture():
    return ET.fromstring(FIXTURE.read_bytes())


def container(tree):
    return next(n for n in tree.iter('node') if n.get('resource-id') ==
                'com.godot.game:id/godot_fragment_container')


def view(tree):
    return next(n for n in tree.iter('node') if n.get('class') == 'android.view.View'
                and n.get('focused') == 'true')


def locate(tree, size=SIZE):
    return surface_bounds(ET.tostring(tree), size)


class AndroidSurfaceTests(unittest.TestCase):
    def test_real_hierarchy_resolves_without_coordinate_guessing(self):
        self.assertEqual(surface_bounds(FIXTURE.read_bytes(), SIZE), BOUNDS)

    def test_real_probe_coordinates_map_to_observed_screen(self):
        bounds = surface_bounds(FIXTURE.read_bytes(), SIZE)
        state = {'surface_size': SIZE, 'coordinate_space': 'android_surface_pixels'}
        self.assertEqual(physical_point([154.5, 499.0], state, bounds), [154.5, 627.0])
        self.assertEqual(physical_point([415.5, 655.0], state, bounds), [415.5, 783.0])

    def test_missing_dimensions_rejected_for_generic_view(self):
        with self.assertRaises(RuntimeError): surface_bounds(FIXTURE.read_bytes())

    def test_invalid_dimensions_rejected(self):
        for size in ([], [1], [1, 2, 3], [0, 1], [-1, 1], [True, 1],
                     [float('nan'), 1], [float('inf'), 1], ['1080', 2209], [40000, 2209]):
            with self.subTest(size=size), self.assertRaises(RuntimeError): locate(fixture(), size)

    def test_size_mismatch_rejected(self):
        with self.assertRaises(RuntimeError): locate(fixture(), [1080, 2272])

    def test_wrong_package_rejected(self):
        tree = fixture(); view(tree).set('package', 'another.app')
        with self.assertRaises(RuntimeError): locate(tree)

    def test_missing_godot_anchor_rejected(self):
        tree = fixture(); container(tree).set('resource-id', 'android:id/content')
        with self.assertRaises(RuntimeError): locate(tree)

    def test_duplicate_godot_anchors_rejected(self):
        tree = fixture(); tree.append(ET.fromstring(ET.tostring(container(tree))))
        with self.assertRaises(RuntimeError): locate(tree)

    def test_wrong_anchor_owner_rejected(self):
        tree = fixture(); container(tree).set('package', 'another.app')
        with self.assertRaises(RuntimeError): locate(tree)

    def test_unfocused_generic_view_rejected(self):
        tree = fixture(); view(tree).set('focused', 'false')
        with self.assertRaises(RuntimeError): locate(tree)

    def test_disabled_generic_view_rejected(self):
        tree = fixture(); view(tree).set('enabled', 'false')
        with self.assertRaises(RuntimeError): locate(tree)

    def test_nonfocusable_generic_view_rejected(self):
        tree = fixture(); view(tree).set('focusable', 'false')
        with self.assertRaises(RuntimeError): locate(tree)

    def test_keyboard_is_not_a_render_view(self):
        tree = fixture(); view(tree).set('class', 'android.widget.EditText')
        with self.assertRaises(RuntimeError): locate(tree)

    def test_nested_view_bounds_must_equal_fragment(self):
        tree = fixture(); view(tree).set('bounds', '[0,129][1080,2338]')
        with self.assertRaises(RuntimeError): locate(tree)

    def test_duplicate_focused_views_rejected_even_with_equal_bounds(self):
        tree = fixture(); container(tree).append(ET.fromstring(ET.tostring(view(tree))))
        with self.assertRaises(RuntimeError): locate(tree)

    def test_view_outside_godot_fragment_rejected(self):
        tree = fixture(); target = view(tree)
        for parent in tree.iter():
            if target in list(parent): parent.remove(target); break
        tree.append(target)
        with self.assertRaises(RuntimeError): locate(tree)

    def test_malformed_or_empty_bounds_rejected(self):
        for text in ('[0,0][0,0]', '[1,1][0,0]', 'invalid', '[-1,0][1080,2209]'):
            tree = fixture(); view(tree).set('bounds', text)
            with self.subTest(bounds=text), self.assertRaises(RuntimeError): locate(tree)

    def test_named_surface_remains_supported(self):
        xml = f'<hierarchy><node package="{PACKAGE}" class="android.view.SurfaceView" bounds="[0,128][1080,2337]"/></hierarchy>'
        self.assertEqual(surface_bounds(xml), BOUNDS)
        self.assertEqual(surface_bounds(xml, SIZE), BOUNDS)
        with self.assertRaises(RuntimeError): surface_bounds(xml, [720, 1100])

    def test_named_surface_ambiguity_is_not_hidden_by_fallback(self):
        tree = fixture()
        for _ in range(2): ET.SubElement(tree, 'node', {'package': PACKAGE,
            'class': 'android.view.SurfaceView', 'bounds': '[0,128][1080,2337]'})
        with self.assertRaises(RuntimeError): locate(tree)

    def test_oversized_or_nontext_hierarchy_rejected(self):
        for xml in (None, 4, '<hierarchy>' + ' ' * (2 * 1024**2) + '</hierarchy>'):
            with self.assertRaises(RuntimeError): surface_bounds(xml, SIZE)


if __name__ == '__main__':
    unittest.main()
