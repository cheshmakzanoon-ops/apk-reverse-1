package com.google.android.gms.internal.common;

import com.google.android.gms.common.api.Api;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public final class zzw {
    private final zzp zza;
    private final boolean zzb;
    private final zzu zzc;

    private zzw(zzu zzuVar, boolean z, zzp zzpVar, int i) {
        this.zzc = zzuVar;
        this.zzb = z;
        this.zza = zzpVar;
    }

    public static zzw zza(zzp zzpVar) {
        return new zzw(new zzu(zzpVar), false, zzo.zza, Api.BaseClientBuilder.API_PRIORITY_OTHER);
    }

    public final zzw zzb() {
        return new zzw(this.zzc, true, this.zza, Api.BaseClientBuilder.API_PRIORITY_OTHER);
    }

    public final Iterable zzc(CharSequence charSequence) {
        return new zzt(this, charSequence);
    }

    final Iterator zze(CharSequence charSequence) {
        return this.zzc.zza(this, charSequence);
    }

    final zzp zzf() {
        return this.zza;
    }

    final boolean zzg() {
        return this.zzb;
    }

    public final List zzd(CharSequence charSequence) {
        charSequence.getClass();
        Iterator itZza = this.zzc.zza(this, charSequence);
        ArrayList arrayList = new ArrayList();
        while (itZza.hasNext()) {
            arrayList.add((String) itZza.next());
        }
        return Collections.unmodifiableList(arrayList);
    }
}
