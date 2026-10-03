package com.google.android.gms.internal.common;

import com.google.firebase.analytics.FirebaseAnalytics;

final class zzs extends zzv {
    final zzp zza;

    zzs(zzw zzwVar, CharSequence charSequence, zzp zzpVar) {
        super(zzwVar, charSequence);
        this.zza = zzpVar;
    }

    @Override
    final int zzc(int i) {
        CharSequence charSequence = this.zzb;
        int length = charSequence.length();
        zzr.zzc(i, length, FirebaseAnalytics.Param.INDEX);
        while (i < length) {
            if (this.zza.zza(charSequence.charAt(i))) {
                return i;
            }
            i++;
        }
        return -1;
    }

    @Override
    final int zzd(int i) {
        return i + 1;
    }
}
