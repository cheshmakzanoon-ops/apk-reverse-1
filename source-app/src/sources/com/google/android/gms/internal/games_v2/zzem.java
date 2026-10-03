package com.google.android.gms.internal.games_v2;

import android.content.Intent;
import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerBuffer;
import com.google.android.gms.games.PlayerEntity;
import com.google.android.gms.games.PlayersClient;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

public final class zzem implements PlayersClient {
    private final zzaq zza;

    public zzem(zzaq zzaqVar) {
        this.zza = zzaqVar;
    }

    private final Task zza(final String str, final int i, final boolean z) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final int i2 = i;
                final boolean z2 = z;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzt((TaskCompletionSource) obj2, str2, i2, false, z2);
                    }
                }).setMethodKey(6715).build());
            }
        });
    }

    private final Task zzb(final String str, final int i) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final int i2 = i;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzt((TaskCompletionSource) obj2, str2, i2, true, false);
                    }
                }).setMethodKey(6716).build());
            }
        });
    }

    @Override
    public final Task<Intent> getCompareProfileIntent(final Player player) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final Player player2 = player;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        PlayerEntity playerEntity = new PlayerEntity(player2);
                        Intent intentZzN = ((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzN(playerEntity);
                        intentZzN.setExtrasClassLoader(playerEntity.getClass().getClassLoader());
                        ((TaskCompletionSource) obj2).setResult(intentZzN);
                    }
                }).setMethodKey(6713).build());
            }
        });
    }

    @Override
    public final Task<Intent> getCompareProfileIntentWithAlternativeNameHints(String str, String str2, String str3) {
        return this.zza.zzb(new zzee(str, str2, str3));
    }

    @Override
    public final Task<Player> getCurrentPlayer() {
        return this.zza.zzb(zzdu.zza);
    }

    @Override
    public final Task<String> getCurrentPlayerId() {
        return this.zza.zzb(zzel.zza);
    }

    @Override
    public final Task<Intent> getPlayerSearchIntent() {
        return this.zza.zzb(zzeg.zza);
    }

    @Override
    public final Task<AnnotatedData<PlayerBuffer>> loadFriends(int i, boolean z) {
        return zza("friends_all", i, z);
    }

    @Override
    public final Task<AnnotatedData<PlayerBuffer>> loadMoreFriends(int i) {
        return zzb("friends_all", i);
    }

    @Override
    public final Task<AnnotatedData<PlayerBuffer>> loadMoreRecentlyPlayedWithPlayers(int i) {
        return zzb("played_with", i);
    }

    @Override
    public final Task<AnnotatedData<Player>> loadPlayer(String str) {
        return this.zza.zzb(new zzed(str, false));
    }

    @Override
    public final Task<AnnotatedData<PlayerBuffer>> loadRecentlyPlayedWithPlayers(int i, boolean z) {
        return zza("played_with", i, z);
    }

    @Override
    public final Task<Intent> getCompareProfileIntent(String str) {
        return this.zza.zzb(new zzee(str, null, null));
    }

    @Override
    public final Task<AnnotatedData<Player>> getCurrentPlayer(final boolean z) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final boolean z2 = z;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzr((TaskCompletionSource) obj2, z2);
                    }
                }).setMethodKey(6710).build());
            }
        });
    }

    @Override
    public final Task<AnnotatedData<Player>> loadPlayer(String str, boolean z) {
        return this.zza.zzb(new zzed(str, z));
    }
}
