package com.google.android.gms.internal.games_v2;

import android.content.Intent;
import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.drive.Contents;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.SnapshotsClient;
import com.google.android.gms.games.snapshot.Snapshot;
import com.google.android.gms.games.snapshot.SnapshotContents;
import com.google.android.gms.games.snapshot.SnapshotMetadata;
import com.google.android.gms.games.snapshot.SnapshotMetadataBuffer;
import com.google.android.gms.games.snapshot.SnapshotMetadataChange;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

public final class zzfk implements SnapshotsClient {
    private final zzaq zza;

    public zzfk(zzaq zzaqVar) {
        this.zza = zzaqVar;
    }

    @Override
    public final Task<SnapshotMetadata> commitAndClose(final Snapshot snapshot, final SnapshotMetadataChange snapshotMetadataChange) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final Snapshot snapshot2 = snapshot;
                final SnapshotMetadataChange snapshotMetadataChange2 = snapshotMetadataChange;
                return googleApi.doWrite(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzM((TaskCompletionSource) obj2, snapshot2, snapshotMetadataChange2);
                    }
                }).setMethodKey(6722).build());
            }
        });
    }

    @Override
    public final Task<String> delete(final SnapshotMetadata snapshotMetadata) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final SnapshotMetadata snapshotMetadata2 = snapshotMetadata;
                return googleApi.doWrite(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzN((TaskCompletionSource) obj2, snapshotMetadata2.getSnapshotId());
                    }
                }).setMethodKey(6724).build());
            }
        });
    }

    @Override
    public final Task<Void> discardAndClose(final Snapshot snapshot) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final Snapshot snapshot2 = snapshot;
                return googleApi.doWrite(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        SnapshotContents snapshotContents = snapshot2.getSnapshotContents();
                        Preconditions.checkState(!snapshotContents.isClosed(), "Snapshot already closed");
                        Contents contentsZza = snapshotContents.zza();
                        snapshotContents.zzb();
                        ((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzC(contentsZza);
                        ((TaskCompletionSource) obj2).setResult(null);
                    }
                }).setMethodKey(6723).build());
            }
        });
    }

    @Override
    public final Task<Integer> getMaxCoverImageSize() {
        return this.zza.zzb(zzes.zza);
    }

    @Override
    public final Task<Integer> getMaxDataSize() {
        return this.zza.zzb(zzfj.zza);
    }

    @Override
    public final Task<Intent> getSelectSnapshotIntent(final String str, final boolean z, final boolean z2, final int i) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final boolean z3 = z;
                final boolean z4 = z2;
                final int i2 = i;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) {
                        ((TaskCompletionSource) obj2).setResult(((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzz(str2, z3, z4, i2));
                    }
                }).setMethodKey(6719).build());
            }
        });
    }

    @Override
    public final Task<AnnotatedData<SnapshotMetadataBuffer>> load(final boolean z) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final boolean z2 = z;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzK((TaskCompletionSource) obj2, z2);
                    }
                }).setMethodKey(6720).build());
            }
        });
    }

    @Override
    public final Task<SnapshotsClient.DataOrConflict<Snapshot>> open(SnapshotMetadata snapshotMetadata) {
        return open(snapshotMetadata.getUniqueName(), false, -1);
    }

    @Override
    public final Task<SnapshotsClient.DataOrConflict<Snapshot>> resolveConflict(String str, Snapshot snapshot) {
        SnapshotMetadata metadata = snapshot.getMetadata();
        SnapshotMetadataChange.Builder builder = new SnapshotMetadataChange.Builder();
        builder.fromMetadata(metadata);
        return this.zza.zzb(new zzfg(str, metadata.getSnapshotId(), builder.build(), snapshot.getSnapshotContents()));
    }

    @Override
    public final Task<SnapshotsClient.DataOrConflict<Snapshot>> open(SnapshotMetadata snapshotMetadata, int i) {
        return open(snapshotMetadata.getUniqueName(), false, i);
    }

    @Override
    public final Task<SnapshotsClient.DataOrConflict<Snapshot>> open(String str, boolean z) {
        return open(str, z, -1);
    }

    @Override
    public final Task<SnapshotsClient.DataOrConflict<Snapshot>> open(final String str, final boolean z, final int i) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final boolean z2 = z;
                final int i2 = i;
                return googleApi.doWrite(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzL((TaskCompletionSource) obj2, str2, z2, i2);
                    }
                }).setMethodKey(6721).build());
            }
        });
    }

    @Override
    public final Task<SnapshotsClient.DataOrConflict<Snapshot>> resolveConflict(String str, String str2, SnapshotMetadataChange snapshotMetadataChange, SnapshotContents snapshotContents) {
        return this.zza.zzb(new zzfg(str, str2, snapshotMetadataChange, snapshotContents));
    }
}
