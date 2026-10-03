package com.google.android.gms.internal.games_v2;

import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.AuthenticationResult;
import com.google.android.gms.games.GamesSignInClient;
import com.google.android.gms.games.gamessignin.AuthResponse;
import com.google.android.gms.games.gamessignin.AuthScope;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import j$.util.Objects;
import java.util.List;

public final class zzcv implements GamesSignInClient {
    private final zzaw zza;
    private final zzaq zzb;

    public zzcv(zzaw zzawVar, zzaq zzaqVar) {
        this.zza = zzawVar;
        this.zzb = zzaqVar;
    }

    @Override
    public final Task<AuthenticationResult> isAuthenticated() {
        return this.zza.zzc();
    }

    @Override
    public final Task<String> requestServerSideAccess(final String str, final boolean z) {
        return this.zzb.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final boolean z2 = z;
                return googleApi.doWrite(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzR((TaskCompletionSource) obj2, str2, z2);
                    }
                }).setMethodKey(6699).build());
            }
        });
    }

    @Override
    public final Task<AuthenticationResult> signIn() {
        return this.zza.zze();
    }

    @Override
    public final Task<AuthResponse> requestServerSideAccess(final String str, final boolean z, List<AuthScope> list) {
        Objects.requireNonNull(str, "serverClientId must not be null.");
        if (str.isEmpty()) {
            throw new IllegalArgumentException("serverClientId must not be empty.");
        }
        if (list == null || list.contains(null)) {
            throw new IllegalArgumentException("AuthScope array cannot contain null elements.");
        }
        return this.zza.zzb(new zzau() {
            @Override
            public final Task zza(GoogleApi googleApi, final List list2) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final boolean z2 = z;
                return googleApi.doWrite(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzS((TaskCompletionSource) obj2, str2, z2, AuthScope.zza(list2));
                    }
                }).setMethodKey(6748).build());
            }
        }, list);
    }
}
