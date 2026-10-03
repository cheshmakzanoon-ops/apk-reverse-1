package com.google.android.gms.internal.play_billing;

import java.util.Arrays;

public final class zzbf {
    private final String zza;
    private final zzbe zzb;
    private zzbe zzc;

    public final String toString() {
        StringBuilder sb = new StringBuilder(32);
        sb.append(this.zza);
        sb.append('{');
        zzbe zzbeVar = this.zzb.zzb;
        String str = "";
        while (zzbeVar != null) {
            Object obj = zzbeVar.zza;
            sb.append(str);
            if (obj == null || !obj.getClass().isArray()) {
                sb.append(obj);
            } else {
                String strDeepToString = Arrays.deepToString(new Object[]{obj});
                sb.append((CharSequence) strDeepToString, 1, strDeepToString.length() - 1);
            }
            zzbeVar = zzbeVar.zzb;
            str = ", ";
        }
        sb.append('}');
        return sb.toString();
    }

    public final zzbf zza(Object obj) {
        zzbe zzbeVar = new zzbe();
        this.zzc.zzb = zzbeVar;
        this.zzc = zzbeVar;
        zzbeVar.zza = obj;
        return this;
    }

    zzbf(String str, zzbg zzbgVar) {
        zzbe zzbeVar = new zzbe();
        this.zzb = zzbeVar;
        this.zzc = zzbeVar;
        str.getClass();
        this.zza = str;
    }
}
