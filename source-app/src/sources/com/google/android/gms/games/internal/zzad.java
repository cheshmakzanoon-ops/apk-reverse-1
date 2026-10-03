package com.google.android.gms.games.internal;

import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.GamesStatusUtils;
import com.google.android.gms.games.PlayerBuffer;
import com.google.android.gms.games.PlayerEntity;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzad extends zza {
    private final TaskCompletionSource zza;

    zzad(TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void zzh(DataHolder dataHolder) {
        int statusCode = dataHolder.getStatusCode();
        if (statusCode != 0 && statusCode != 3) {
            GamesStatusUtils.zzb(this.zza, statusCode);
            dataHolder.close();
            return;
        }
        PlayerBuffer playerBuffer = new PlayerBuffer(dataHolder);
        try {
            PlayerEntity playerEntity = playerBuffer.getCount() > 0 ? new PlayerEntity(playerBuffer.get(0)) : null;
            playerBuffer.release();
            this.zza.setResult(new AnnotatedData(playerEntity, statusCode == 3));
        } catch (Throwable th) {
            playerBuffer.release();
            throw th;
        }
    }
}
