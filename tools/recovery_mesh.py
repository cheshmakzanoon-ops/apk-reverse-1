"""Native Mesh channel-to-OBJ adapter: geometry only, no fabricated UVs/normals."""
from __future__ import annotations
import math
from recovery_core import RecoveryError,validate_obj


def geometry_obj(positions, triangles, normals=None, uv=None):
    if not positions or len(positions)<3:raise RecoveryError('mesh has no usable positions')
    count=len(positions);normals=normals or [];uv=uv or []
    for rows,width in ((positions,3),(normals,3),(uv,2)):
        if rows and (len(rows)!=count or any(len(r)<width or not all(math.isfinite(x) for x in r[:width]) for r in rows)):
            raise RecoveryError('mesh channel dimensions or numeric values invalid')
    lines=['# Captured mesh geometry; skeletal/material data remain in source bytes\n']
    for x,y,z,*_ in positions:lines.append(f'v {-x:.9g} {y:.9g} {z:.9g}\n')
    for u,v,*_ in uv:lines.append(f'vt {u:.9g} {v:.9g}\n')
    for x,y,z,*_ in normals:lines.append(f'vn {-x:.9g} {y:.9g} {z:.9g}\n')
    def index(i):
        if type(i) is not int or not 0<=i<count:raise RecoveryError('mesh triangle index outside source positions')
        v=i+1
        return f'{v}/{v}/{v}' if uv and normals else f'{v}/{v}' if uv else f'{v}//{v}' if normals else str(v)
    for sub,faces in enumerate(triangles):
        lines.append(f'g captured_submesh_{sub}\n')
        for face in faces:
            if len(face)!=3:raise RecoveryError('non-triangle face unsupported')
            lines.append('f '+' '.join(index(i) for i in reversed(face))+'\n')
    text=''.join(lines);geometry=validate_obj(text)
    return 'obj',text.encode(),{'geometry':geometry,'source_submeshes':len(triangles),
        'uv_present':bool(uv),'normals_present':bool(normals),'rig_preserved_in_raw_only':True,
        'coordinate_conversion':'negate X and reverse winding','adapter':'native_triangle_channels_v1'}


def convert_mesh(mesh):
    from UnityPy.helpers.MeshHelper import MeshHandler
    handler=MeshHandler(mesh);handler.process();width=2 if handler.m_Use16BitIndices else 4
    indices=handler.m_IndexBuffer
    if indices is None:raise RecoveryError('mesh index stream unavailable')
    triangles=[]
    for sub in mesh.m_SubMeshes:
        begin=sub.firstByte;count=sub.indexCount;base=getattr(sub,'baseVertex',0) or 0
        if (int(sub.topology)!=0 or type(begin) is not int or begin<0 or begin%width
                or type(count) is not int or count<=0 or count%3 or type(base) is not int or base<0
                or begin//width+count>len(indices)):
            raise RecoveryError('unsupported topology or invalid source index range')
        begin//=width
        triangles.append([[int(i)+base for i in indices[n:n+3]] for n in range(begin,begin+count,3)])
    return geometry_obj(handler.m_Vertices,triangles,handler.m_Normals,handler.m_UV0)
