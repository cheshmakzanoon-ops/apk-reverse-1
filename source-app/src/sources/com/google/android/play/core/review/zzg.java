package com.google.android.play.core.review;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.play.core.review.internal.zzt;

class zzg extends com.google.android.play.core.review.internal.zzg {
    final com.google.android.play.core.review.internal.zzi zza;
    final TaskCompletionSource zzb;
    final zzi zzc;

    zzg(zzi zziVar, com.google.android.play.core.review.internal.zzi zziVar2, TaskCompletionSource taskCompletionSource) {
        this.zzc = zziVar;
        this.zza = zziVar2;
        this.zzb = taskCompletionSource;
    }

    @Override
    public void zzb(Bundle bundle) throws RemoteException {
        zzt zztVar = this.zzc.zza;
        if (zztVar != null) {
            zztVar.zzr(this.zzb);
        }
        this.zza.zzd("onGetLaunchReviewFlowInfo", new Object[0]);
    }
}
