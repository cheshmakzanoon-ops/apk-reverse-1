package com.google.android.gms.internal.games_v2;

import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.EventsClient;
import com.google.android.gms.games.event.EventBuffer;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

public final class zzcq implements EventsClient {
    private final zzaq zza;

    public zzcq(zzaq zzaqVar) {
        this.zza = zzaqVar;
    }

    @Override
    public final void increment(final String str, final int i) {
        this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final int i2 = i;
                return googleApi.doWrite(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) {
                        ((com.google.android.gms.games.internal.zzah) obj).zzI(str2, i2);
                    }
                }).setMethodKey(6729).build());
            }
        });
    }

    @Override
    public final Task<AnnotatedData<EventBuffer>> load(final boolean z) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final boolean z2 = z;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzG((TaskCompletionSource) obj2, z2);
                    }
                }).setMethodKey(6727).build());
            }
        });
    }

    @Override
    public final Task<AnnotatedData<EventBuffer>> loadByIds(final boolean z, final String... strArr) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final boolean z2 = z;
                final String[] strArr2 = strArr;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzH((TaskCompletionSource) obj2, z2, strArr2);
                    }
                }).setMethodKey(6728).build());
            }
        });
    }
}
