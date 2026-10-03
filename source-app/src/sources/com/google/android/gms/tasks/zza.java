package com.google.android.gms.tasks;

final class zza implements OnSuccessListener {
    final OnTokenCanceledListener zza;

    zza(zzb zzbVar, OnTokenCanceledListener onTokenCanceledListener) {
        this.zza = onTokenCanceledListener;
    }

    @Override
    public final void onSuccess(Object obj) {
        this.zza.onCanceled();
    }
}
