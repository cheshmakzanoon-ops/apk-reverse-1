package com.android.billingclient.api;

import com.google.android.gms.internal.play_billing.zziw;
import com.google.android.gms.internal.play_billing.zzja;
import com.google.android.gms.internal.play_billing.zzji;
import com.google.android.gms.internal.play_billing.zzjk;
import com.google.android.gms.internal.play_billing.zzkn;
import com.google.android.gms.internal.play_billing.zzkr;

interface zzcz {
    public static final int zza = 0;

    static {
        com.google.android.gms.internal.play_billing.zzbz.zzc("com.android.vending.billing.PURCHASES_UPDATED", zzjk.zzb, "com.android.vending.billing.LOCAL_BROADCAST_PURCHASES_UPDATED", zzjk.zzc, "com.android.vending.billing.ALTERNATIVE_BILLING", zzjk.zzd);
    }

    void zza(zziw zziwVar);

    void zzb(zziw zziwVar, int i);

    void zzc(zziw zziwVar, int i, long j);

    void zzd(zziw zziwVar, long j, boolean z);

    void zze(zziw zziwVar, int i, long j, boolean z);

    void zzf(zzja zzjaVar);

    void zzg(zzja zzjaVar, int i);

    void zzh(zzja zzjaVar, long j, boolean z);

    void zzi(zzji zzjiVar);

    void zzj(zzkn zzknVar);

    void zzk(zzkr zzkrVar);
}
