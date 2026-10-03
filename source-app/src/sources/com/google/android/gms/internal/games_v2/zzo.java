package com.google.android.gms.internal.games_v2;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzo extends GoogleApi implements zzk {
    private static final Api.ClientKey zza;
    private static final Api.AbstractClientBuilder zzb;
    private static final Api zzc;

    static {
        Api.ClientKey clientKey = new Api.ClientKey();
        zza = clientKey;
        zzl zzlVar = new zzl();
        zzb = zzlVar;
        zzc = new Api("GamesConnect.API", zzlVar, clientKey);
    }

    zzo(Context context, zzi zziVar) {
        super(context, (Api<zzi>) zzc, zziVar, GoogleApi.Settings.DEFAULT_SETTINGS);
    }

    @Override
    public final Task zza(final zzq zzqVar, boolean z) {
        TaskApiCall taskApiCallBuild = TaskApiCall.builder().run(new RemoteCall() {
            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                ((zzw) ((zzp) obj).getService()).zzd(new zzm(this.zza, (TaskCompletionSource) obj2), zzqVar);
            }
        }).setMethodKey(6737).setAutoResolveMissingFeatures(z).build();
        return z ? doWrite(taskApiCallBuild) : doBestEffortWrite(taskApiCallBuild);
    }
}
