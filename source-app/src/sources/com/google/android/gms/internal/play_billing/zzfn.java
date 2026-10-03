package com.google.android.gms.internal.play_billing;

public enum zzfn {
    DOUBLE(0, 1, zzgd.DOUBLE),
    FLOAT(1, 1, zzgd.FLOAT),
    INT64(2, 1, zzgd.LONG),
    UINT64(3, 1, zzgd.LONG),
    INT32(4, 1, zzgd.INT),
    FIXED64(5, 1, zzgd.LONG),
    FIXED32(6, 1, zzgd.INT),
    BOOL(7, 1, zzgd.BOOLEAN),
    STRING(8, 1, zzgd.STRING),
    MESSAGE(9, 1, zzgd.MESSAGE),
    BYTES(10, 1, zzgd.BYTE_STRING),
    UINT32(11, 1, zzgd.INT),
    ENUM(12, 1, zzgd.ENUM),
    SFIXED32(13, 1, zzgd.INT),
    SFIXED64(14, 1, zzgd.LONG),
    SINT32(15, 1, zzgd.INT),
    SINT64(16, 1, zzgd.LONG),
    GROUP(17, 1, zzgd.MESSAGE),
    DOUBLE_LIST(18, 2, zzgd.DOUBLE),
    FLOAT_LIST(19, 2, zzgd.FLOAT),
    INT64_LIST(20, 2, zzgd.LONG),
    UINT64_LIST(21, 2, zzgd.LONG),
    INT32_LIST(22, 2, zzgd.INT),
    FIXED64_LIST(23, 2, zzgd.LONG),
    FIXED32_LIST(24, 2, zzgd.INT),
    BOOL_LIST(25, 2, zzgd.BOOLEAN),
    STRING_LIST(26, 2, zzgd.STRING),
    MESSAGE_LIST(27, 2, zzgd.MESSAGE),
    BYTES_LIST(28, 2, zzgd.BYTE_STRING),
    UINT32_LIST(29, 2, zzgd.INT),
    ENUM_LIST(30, 2, zzgd.ENUM),
    SFIXED32_LIST(31, 2, zzgd.INT),
    SFIXED64_LIST(32, 2, zzgd.LONG),
    SINT32_LIST(33, 2, zzgd.INT),
    SINT64_LIST(34, 2, zzgd.LONG),
    DOUBLE_LIST_PACKED(35, 3, zzgd.DOUBLE),
    FLOAT_LIST_PACKED(36, 3, zzgd.FLOAT),
    INT64_LIST_PACKED(37, 3, zzgd.LONG),
    UINT64_LIST_PACKED(38, 3, zzgd.LONG),
    INT32_LIST_PACKED(39, 3, zzgd.INT),
    FIXED64_LIST_PACKED(40, 3, zzgd.LONG),
    FIXED32_LIST_PACKED(41, 3, zzgd.INT),
    BOOL_LIST_PACKED(42, 3, zzgd.BOOLEAN),
    UINT32_LIST_PACKED(43, 3, zzgd.INT),
    ENUM_LIST_PACKED(44, 3, zzgd.ENUM),
    SFIXED32_LIST_PACKED(45, 3, zzgd.INT),
    SFIXED64_LIST_PACKED(46, 3, zzgd.LONG),
    SINT32_LIST_PACKED(47, 3, zzgd.INT),
    SINT64_LIST_PACKED(48, 3, zzgd.LONG),
    GROUP_LIST(49, 2, zzgd.MESSAGE),
    MAP(50, 4, zzgd.VOID);

    private static final zzfn[] zzZ;
    private final int zzab;

    static {
        zzfn[] zzfnVarArrValues = values();
        zzZ = new zzfn[zzfnVarArrValues.length];
        for (zzfn zzfnVar : zzfnVarArrValues) {
            zzZ[zzfnVar.zzab] = zzfnVar;
        }
    }

    zzfn(int i, int i2, zzgd zzgdVar) {
        this.zzab = i;
        int i3 = i2 - 1;
        if (i3 == 1 || i3 == 3) {
            zzgdVar.zza();
        }
        if (i2 == 1) {
            zzgd zzgdVar2 = zzgd.VOID;
            zzgdVar.ordinal();
        }
    }

    public final int zza() {
        return this.zzab;
    }
}
