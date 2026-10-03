package com.google.android.gms.internal.measurement;

enum zzit {
    SCALAR(false),
    VECTOR(true),
    PACKED_VECTOR(true),
    MAP(false);

    private final boolean zzf;

    zzit(boolean z) {
        this.zzf = z;
    }
}
