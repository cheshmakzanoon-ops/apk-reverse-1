package com.google.android.gms.internal.play_billing;

public enum zzir {
    DOUBLE(zzis.DOUBLE, 1),
    FLOAT(zzis.FLOAT, 5),
    INT64(zzis.LONG, 0),
    UINT64(zzis.LONG, 0),
    INT32(zzis.INT, 0),
    FIXED64(zzis.LONG, 1),
    FIXED32(zzis.INT, 5),
    BOOL(zzis.BOOLEAN, 0),
    STRING(zzis.STRING, 2),
    GROUP(zzis.MESSAGE, 3),
    MESSAGE(zzis.MESSAGE, 2),
    BYTES(zzis.BYTE_STRING, 2),
    UINT32(zzis.INT, 0),
    ENUM(zzis.ENUM, 0),
    SFIXED32(zzis.INT, 5),
    SFIXED64(zzis.LONG, 1),
    SINT32(zzis.INT, 0),
    SINT64(zzis.LONG, 0);

    private final zzis zzt;
    private final int zzu;

    zzir(zzis zzisVar, int i) {
        this.zzt = zzisVar;
        this.zzu = i;
    }

    public final int zza() {
        return this.zzu;
    }

    public final zzis zzb() {
        return this.zzt;
    }
}
