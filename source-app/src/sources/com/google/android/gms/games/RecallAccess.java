package com.google.android.gms.games;

import com.google.android.gms.internal.games_v2.zzam;
import j$.util.Objects;

public final class RecallAccess {
    private final String zza;

    private RecallAccess(String str) {
        this.zza = str;
    }

    public static RecallAccess zza(zzam zzamVar) {
        return new RecallAccess(zzamVar.zza());
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof RecallAccess) {
            return Objects.equals(this.zza, ((RecallAccess) obj).zza);
        }
        return false;
    }

    public String getSessionId() {
        return this.zza;
    }

    public final int hashCode() {
        return Objects.hash(new Object[]{this.zza});
    }
}
