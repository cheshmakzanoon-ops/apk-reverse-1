"""Preserve uncompressed floating-point textures as exact numeric payloads.

Half/float textures may contain signed data, not display colors. No clamping,
tonemapping, conversion to 8-bit PNG, or inference of shader semantics occurs.
"""
from __future__ import annotations
from recovery_core import RecoveryError,digest

# Unity TextureFormat: RHalf, RGHalf, RGBAHalf, RFloat, RGFloat, RGBAFloat.
FORMATS={15:(1,2),16:(2,2),17:(4,2),18:(1,4),19:(2,4),20:(4,4)}
MAX_BYTES=128*1024**2


def layout(width,height,mips,format_id):
    if (any(type(x) is not int or x<=0 for x in (width,height,mips))
            or max(width,height)>32768 or format_id not in FORMATS):
        raise RecoveryError('invalid floating texture dimensions/format')
    channels,component_bytes=FORMATS[format_id];levels=[];offset=0
    if mips>max(width,height).bit_length():raise RecoveryError('floating texture has too many mip levels')
    for i in range(mips):
        size=width*height*channels*component_bytes
        levels.append({'level':i,'width':width,'height':height,'offset':offset,'size':size})
        offset+=size;width=max(1,width//2);height=max(1,height//2)
    if offset>MAX_BYTES:raise RecoveryError('floating texture payload exceeds 128 MiB')
    return levels,offset


def validate_numeric_texture(data,detail):
    if detail.get('storage')!='unity_float_texture_v1' or detail.get('extension')!='bin':
        raise RecoveryError('unknown numeric texture format')
    format_id=detail['texture_format'];levels,size=layout(detail['width'],detail['height'],detail['mip_count'],format_id)
    channels,width=FORMATS[format_id]
    if (detail.get('levels')!=levels or detail.get('channels')!=channels
            or detail.get('component_bytes')!=width or detail.get('byte_order')!='little'
            or not isinstance(data,bytes) or len(data)!=size or digest(data)!=detail.get('payload_sha256')):
        raise RecoveryError('numeric texture layout/size/hash mismatch')
    if detail.get('display_color_conversion_performed') is not False:
        raise RecoveryError('numeric texture must not claim color conversion')
    return {'bytes':size,'levels':len(levels),'bit_exact_payload':True}


def convert_numeric_texture(texture):
    format_id=int(texture.m_TextureFormat)
    if getattr(texture,'m_ImageCount',1)!=1:raise RecoveryError('array floating textures need a separate adapter')
    mips=getattr(texture,'m_MipCount',None)
    if mips is None:raise RecoveryError('floating texture mip count unavailable')
    levels,size=layout(texture.m_Width,texture.m_Height,mips,format_id)
    data=texture.get_image_data()
    if not isinstance(data,bytes):data=bytes(data)
    if len(data)!=size:raise RecoveryError('floating texture payload differs from complete mip layout')
    channels,width=FORMATS[format_id]
    detail={'extension':'bin','storage':'unity_float_texture_v1','texture_format':format_id,
            'width':texture.m_Width,'height':texture.m_Height,'mip_count':mips,'levels':levels,
            'channels':channels,'component_bytes':width,'byte_order':'little',
            'payload_sha256':digest(data),'display_color_conversion_performed':False,
            'original_gpu_usage_reconstructed':False}
    validate_numeric_texture(data,detail)
    return 'bin',data,detail
