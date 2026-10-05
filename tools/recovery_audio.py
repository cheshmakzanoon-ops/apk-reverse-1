"""Validated single-sample PCM audio derivatives; original encoded bytes stay intact.

UnityPy's pinned decoder resolves AudioClip resource streams through the capture.
No original game code is executed. A decoded WAV is not original authoring audio.
Multiple subsounds or unsupported containers are explicit failures, not mixed down.
"""
from __future__ import annotations
import io
import math
import struct
import wave

from recovery_core import RecoveryError

MAX_WAV_BYTES = 128 * 1024**2


def validate_wav(data):
    if not isinstance(data, bytes) or not 44 <= len(data) <= MAX_WAV_BYTES:
        raise RecoveryError('WAV missing, too small or above 128-MiB limit')
    if data[:4] != b'RIFF' or data[8:12] != b'WAVE' or struct.unpack_from('<I', data, 4)[0]+8 != len(data):
        raise RecoveryError('WAV RIFF identity/length mismatch')
    # Walk the full container so truncated chunks and duplicate sample streams
    # cannot pass merely because the first header is readable.
    position = 12; found = {}
    while position < len(data):
        if position+8 > len(data): raise RecoveryError('truncated WAV chunk header')
        tag, size = struct.unpack_from('<4sI', data, position)
        end = position+8+size
        if end+(size % 2) > len(data): raise RecoveryError('truncated WAV chunk')
        if tag in (b'fmt ', b'data'):
            if tag in found: raise RecoveryError('duplicate WAV format/data chunk')
            found[tag] = size
        position = end+(size % 2)
    if set(found) != {b'fmt ', b'data'}: raise RecoveryError('WAV format/data chunk missing')
    try:
        with wave.open(io.BytesIO(data), 'rb') as stream:
            channels, width, rate, frames, codec, _ = stream.getparams()
            if not (1 <= channels <= 8 and width in (1,2,3,4) and 1000 <= rate <= 384000
                    and frames > 0 and codec == 'NONE'):
                raise RecoveryError('unsupported or empty PCM WAV')
            expected = channels * width * frames
            if found[b'data'] != expected or len(stream.readframes(frames)) != expected:
                raise RecoveryError('PCM WAV sample/frame length mismatch')
    except (wave.Error, EOFError, struct.error) as exc:
        raise RecoveryError('invalid PCM WAV: '+str(exc)) from exc
    return {'channels': channels, 'sample_width_bytes': width, 'sample_rate': rate,
            'frames': frames, 'duration_seconds': frames/rate}


def convert_audio(audio):
    channels = getattr(audio, 'm_Channels', None)
    rate = getattr(audio, 'm_Frequency', None)
    duration = getattr(audio, 'm_Length', None)
    if (type(channels) is not int or not 1 <= channels <= 8 or type(rate) is not int
            or not 1000 <= rate <= 384000 or type(duration) not in (int,float)
            or not math.isfinite(duration) or duration <= 0):
        raise RecoveryError('audio source metadata unsupported')
    if channels*rate*(duration+1)*4 > MAX_WAV_BYTES:
        raise RecoveryError('audio PCM estimate exceeds export budget')
    samples = audio.samples
    if not isinstance(samples, dict) or len(samples) != 1:
        raise RecoveryError('AudioClip must decode to exactly one sample; subsound selection needs review')
    name, data = next(iter(samples.items()))
    if not isinstance(name, str): raise RecoveryError('invalid decoded sample identity')
    detail = validate_wav(data)
    if detail['channels'] != channels or detail['sample_rate'] != rate:
        raise RecoveryError('decoded WAV channel/rate differs from source metadata')
    detail.update(source_sample_name=name, source_duration_seconds=duration,
                  source_compression_format=getattr(audio,'m_CompressionFormat',None),
                  source_subsound_index=getattr(audio,'m_SubsoundIndex',None),
                  source_encoded_bytes_preserved=True, derivative='decoded PCM, not original authoring audio')
    return 'wav', data, detail
