package com.google.android.gms.internal.games_v2;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.RecallAccess;
import com.google.android.gms.games.RecallClient;
import com.google.android.gms.tasks.SuccessContinuation;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

public final class zzer extends GoogleApi implements RecallClient {
    private static final Api.ClientKey zza;
    private static final Api.AbstractClientBuilder zzb;
    private static final Api zzc;
    private final zzaw zzd;

    static {
        Api.ClientKey clientKey = new Api.ClientKey();
        zza = clientKey;
        zzen zzenVar = new zzen();
        zzb = zzenVar;
        zzc = new Api("Recall.API", zzenVar, clientKey);
    }

    public zzer(Context context, zzaw zzawVar) {
        super(context, (Api<Api.ApiOptions.NoOptions>) zzc, Api.ApiOptions.NO_OPTIONS, GoogleApi.Settings.DEFAULT_SETTINGS);
        this.zzd = zzawVar;
    }

    @Override
    public final Task<RecallAccess> requestRecallAccess() {
        final TaskApiCall taskApiCallBuild = TaskApiCall.builder().setMethodKey(6742).setAutoResolveMissingFeatures(false).setFeatures(com.google.android.gms.games.zzd.zze).run(new RemoteCall() {
            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                ((zzal) ((zzfm) obj).getService()).zzd(new zzeo(this.zza, (TaskCompletionSource) obj2), "unusedServerClientId");
            }
        }).build();
        return this.zzd.zzd().onSuccessTask(new SuccessContinuation() {
            @Override
            public final Task then(Object obj) {
                return this.zza.doRead(taskApiCallBuild);
            }
        });
    }
}
