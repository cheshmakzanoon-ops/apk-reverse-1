package com.google.android.gms.internal.games_v2;

import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.snapshot.SnapshotContents;
import com.google.android.gms.games.snapshot.SnapshotMetadataChange;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzfg implements zzap {
    private final String zza;
    private final String zzb;
    private final SnapshotMetadataChange zzc;
    private final SnapshotContents zzd;

    zzfg(String str, String str2, SnapshotMetadataChange snapshotMetadataChange, SnapshotContents snapshotContents) {
        this.zza = str;
        this.zzb = str2;
        this.zzc = snapshotMetadataChange;
        this.zzd = snapshotContents;
    }

    @Override
    public final Task zza(GoogleApi googleApi) {
        TaskApiCall.Builder builder = TaskApiCall.builder();
        final String str = this.zza;
        final String str2 = this.zzb;
        final SnapshotMetadataChange snapshotMetadataChange = this.zzc;
        final SnapshotContents snapshotContents = this.zzd;
        return googleApi.doWrite(builder.run(new RemoteCall() {
            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                ((com.google.android.gms.games.internal.zzah) obj).zzO((TaskCompletionSource) obj2, str, str2, snapshotMetadataChange, snapshotContents);
            }
        }).setMethodKey(6725).build());
    }
}
