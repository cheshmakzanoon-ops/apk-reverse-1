package com.google.android.gms.internal.measurement;

import java.lang.reflect.Type;

public enum zzir {
    DOUBLE(0, zzit.SCALAR, zzjk.DOUBLE),
    FLOAT(1, zzit.SCALAR, zzjk.FLOAT),
    INT64(2, zzit.SCALAR, zzjk.LONG),
    UINT64(3, zzit.SCALAR, zzjk.LONG),
    INT32(4, zzit.SCALAR, zzjk.INT),
    FIXED64(5, zzit.SCALAR, zzjk.LONG),
    FIXED32(6, zzit.SCALAR, zzjk.INT),
    BOOL(7, zzit.SCALAR, zzjk.BOOLEAN),
    STRING(8, zzit.SCALAR, zzjk.STRING),
    MESSAGE(9, zzit.SCALAR, zzjk.MESSAGE),
    BYTES(10, zzit.SCALAR, zzjk.BYTE_STRING),
    UINT32(11, zzit.SCALAR, zzjk.INT),
    ENUM(12, zzit.SCALAR, zzjk.ENUM),
    SFIXED32(13, zzit.SCALAR, zzjk.INT),
    SFIXED64(14, zzit.SCALAR, zzjk.LONG),
    SINT32(15, zzit.SCALAR, zzjk.INT),
    SINT64(16, zzit.SCALAR, zzjk.LONG),
    GROUP(17, zzit.SCALAR, zzjk.MESSAGE),
    DOUBLE_LIST(18, zzit.VECTOR, zzjk.DOUBLE),
    FLOAT_LIST(19, zzit.VECTOR, zzjk.FLOAT),
    INT64_LIST(20, zzit.VECTOR, zzjk.LONG),
    UINT64_LIST(21, zzit.VECTOR, zzjk.LONG),
    INT32_LIST(22, zzit.VECTOR, zzjk.INT),
    FIXED64_LIST(23, zzit.VECTOR, zzjk.LONG),
    FIXED32_LIST(24, zzit.VECTOR, zzjk.INT),
    BOOL_LIST(25, zzit.VECTOR, zzjk.BOOLEAN),
    STRING_LIST(26, zzit.VECTOR, zzjk.STRING),
    MESSAGE_LIST(27, zzit.VECTOR, zzjk.MESSAGE),
    BYTES_LIST(28, zzit.VECTOR, zzjk.BYTE_STRING),
    UINT32_LIST(29, zzit.VECTOR, zzjk.INT),
    ENUM_LIST(30, zzit.VECTOR, zzjk.ENUM),
    SFIXED32_LIST(31, zzit.VECTOR, zzjk.INT),
    SFIXED64_LIST(32, zzit.VECTOR, zzjk.LONG),
    SINT32_LIST(33, zzit.VECTOR, zzjk.INT),
    SINT64_LIST(34, zzit.VECTOR, zzjk.LONG),
    DOUBLE_LIST_PACKED(35, zzit.PACKED_VECTOR, zzjk.DOUBLE),
    FLOAT_LIST_PACKED(36, zzit.PACKED_VECTOR, zzjk.FLOAT),
    INT64_LIST_PACKED(37, zzit.PACKED_VECTOR, zzjk.LONG),
    UINT64_LIST_PACKED(38, zzit.PACKED_VECTOR, zzjk.LONG),
    INT32_LIST_PACKED(39, zzit.PACKED_VECTOR, zzjk.INT),
    FIXED64_LIST_PACKED(40, zzit.PACKED_VECTOR, zzjk.LONG),
    FIXED32_LIST_PACKED(41, zzit.PACKED_VECTOR, zzjk.INT),
    BOOL_LIST_PACKED(42, zzit.PACKED_VECTOR, zzjk.BOOLEAN),
    UINT32_LIST_PACKED(43, zzit.PACKED_VECTOR, zzjk.INT),
    ENUM_LIST_PACKED(44, zzit.PACKED_VECTOR, zzjk.ENUM),
    SFIXED32_LIST_PACKED(45, zzit.PACKED_VECTOR, zzjk.INT),
    SFIXED64_LIST_PACKED(46, zzit.PACKED_VECTOR, zzjk.LONG),
    SINT32_LIST_PACKED(47, zzit.PACKED_VECTOR, zzjk.INT),
    SINT64_LIST_PACKED(48, zzit.PACKED_VECTOR, zzjk.LONG),
    GROUP_LIST(49, zzit.VECTOR, zzjk.MESSAGE),
    MAP(50, zzit.MAP, zzjk.VOID);

    private static final zzir[] zzaz;
    private static final Type[] zzba = new Type[0];
    private final zzjk zzbc;
    private final int zzbd;
    private final zzit zzbe;
    private final Class<?> zzbf;
    private final boolean zzbg;

    public final int zza() {
        return this.zzbd;
    }

    static {
        zzir[] zzirVarArrValues = values();
        zzaz = new zzir[zzirVarArrValues.length];
        for (zzir zzirVar : zzirVarArrValues) {
            zzaz[zzirVar.zzbd] = zzirVar;
        }
    }

    zzir(int i, zzit zzitVar, zzjk zzjkVar) {
        int i2;
        this.zzbd = i;
        this.zzbe = zzitVar;
        this.zzbc = zzjkVar;
        int iOrdinal = zzitVar.ordinal();
        if (iOrdinal == 1 || iOrdinal == 3) {
            this.zzbf = zzjkVar.zza();
        } else {
            this.zzbf = null;
        }
        this.zzbg = (zzitVar != zzit.SCALAR || (i2 = zziu.zza[zzjkVar.ordinal()]) == 1 || i2 == 2 || i2 == 3) ? false : true;
    }
}
