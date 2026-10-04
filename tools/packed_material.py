"""Explicit source-color preview for the streamed-animation inspection recipe.

Keep the default dense exporter material contract unchanged. Preserve HDR source
values as metadata; this LDR base-color derivative is not shader equivalence.
"""
import io
import math
import recover
from gltf_model import require
from recovery_model import named_values


def preview_material(reader, oid):
    tree = reader.tree(oid)
    saved = tree.get('m_SavedProperties', {})
    colors = named_values(saved.get('m_Colors', []), '/m_SavedProperties/m_Colors')
    textures = named_values(saved.get('m_TexEnvs', []), '/m_SavedProperties/m_TexEnvs')
    color_key = '_BaseColor' if '_BaseMap' in textures else '_Color'
    color = colors.get(color_key, ({'r': 1, 'g': 1, 'b': 1, 'a': 1}, ''))[0]
    result = {'id': oid, 'name': tree.get('m_Name', oid), 'color': [color[k] for k in 'rgba']}
    candidates = [key for key in ('_BaseMap', '_MainTex') if key in textures
                  and (textures[key][0].get('m_Texture') or {}).get('m_PathID', 0)]
    texture_key = candidates[0] if candidates else ('_BaseMap' if '_BaseMap' in textures else '_MainTex')
    require(all(type(v) in (int,float) and math.isfinite(v) and v >= 0 for v in result['color'])
            and result['color'][3] <= 1, 'invalid material preview color')
    result['source_color'] = list(result['color'])
    strength = max(1., *result['color'][:3])
    result['color'] = [v/strength for v in result['color'][:3]] + [result['color'][3]]
    result['preview_rgb_divisor'] = strength  # glTF base color is LDR; not shader/emission reconstruction.
    result['source_color_property'] = color_key
    result['source_texture_property'] = texture_key if texture_key in textures else None
    if texture_key in textures:
        env, trail = textures[texture_key]
        require(env.get('m_Scale', {'x':1,'y':1}) == {'x':1,'y':1} and
                env.get('m_Offset', {'x':0,'y':0}) == {'x':0,'y':0},
                'nonidentity texture transform needs KHR_texture_transform conversion')
        texture_id = reader.ref(oid, trail + '/m_Texture', {'Texture2D'}, nullable=True)
        if texture_id:
            tex = reader.parsed(texture_id)
            recover.texture_data(tex)
            image = tex.image
            require(image is not None, 'base texture decoder returned no image')
            stream = io.BytesIO(); image.save(stream, format='PNG')
            result['png'] = stream.getvalue()
    return result
