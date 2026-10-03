package com.google.android.gms.internal.measurement;

import android.util.Log;
import javax.annotation.Nullable;

final class zzgq extends zzgn<Boolean> {
    @Override
    @Nullable
    final Boolean zza(Object obj) {
        if (obj instanceof Boolean) {
            return (Boolean) obj;
        }
        if (obj instanceof String) {
            String str = (String) obj;
            if (zzfr.zzb.matcher(str).matches()) {
                return true;
            }
            if (zzfr.zzc.matcher(str).matches()) {
                return false;
            }
        }
        Log.e("PhenotypeFlag", "Invalid boolean value for " + super.zzb() + ": " + String.valueOf(obj));
        return null;
    }

    zzgq(zzgv zzgvVar, String str, Boolean bool, boolean z) {
        super(zzgvVar, str, bool);
    }
}
