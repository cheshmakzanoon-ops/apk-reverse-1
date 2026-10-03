package com.google.android.gms.tasks;

import java.util.concurrent.Executor;

final class zzp<TResult, TContinuationResult> implements OnSuccessListener<TContinuationResult>, OnFailureListener, OnCanceledListener, zzq {
    private final Executor zza;
    private final SuccessContinuation zzb;
    private final zzw zzc;

    public zzp(Executor executor, SuccessContinuation successContinuation, zzw zzwVar) {
        this.zza = executor;
        this.zzb = successContinuation;
        this.zzc = zzwVar;
    }

    @Override
    public final void onCanceled() {
        this.zzc.zzc();
    }

    @Override
    public final void onFailure(Exception exc) {
        this.zzc.zza(exc);
    }

    @Override
    public final void onSuccess(TContinuationResult tcontinuationresult) {
        this.zzc.zzb(tcontinuationresult);
    }

    @Override
    public final void zzc() {
        throw new UnsupportedOperationException();
    }

    @Override
    public final void zzd(Task task) {
        this.zza.execute(new zzo(this, task));
    }
}
