package com.google.android.gms.measurement.internal;

import android.database.sqlite.SQLiteException;
import android.os.Bundle;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.internal.measurement.zzpg;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

final class zzib implements Callable<List<zzmh>> {
    private final zzo zza;
    private final Bundle zzb;
    private final zzhj zzc;

    @Override
    public final List<zzmh> call() throws Exception {
        this.zzc.zza.zzr();
        zzmp zzmpVar = this.zzc.zza;
        zzo zzoVar = this.zza;
        Bundle bundle = this.zzb;
        zzmpVar.zzl().zzt();
        if (!zzpg.zza() || !zzmpVar.zze().zze(zzoVar.zza, zzbi.zzcf) || zzoVar.zza == null) {
            return new ArrayList();
        }
        if (bundle != null) {
            int[] intArray = bundle.getIntArray("uriSources");
            long[] longArray = bundle.getLongArray("uriTimestamps");
            if (intArray != null) {
                if (longArray == null || longArray.length != intArray.length) {
                    zzmpVar.zzj().zzg().zza("Uri sources and timestamps do not match");
                } else {
                    for (int i = 0; i < intArray.length; i++) {
                        zzao zzaoVarZzf = zzmpVar.zzf();
                        String str = zzoVar.zza;
                        int i2 = intArray[i];
                        long j = longArray[i];
                        Preconditions.checkNotEmpty(str);
                        zzaoVarZzf.zzt();
                        zzaoVarZzf.zzak();
                        try {
                            int iDelete = zzaoVarZzf.m30e_().delete("trigger_uris", "app_id=? and source=? and timestamp_millis<=?", new String[]{str, String.valueOf(i2), String.valueOf(j)});
                            zzaoVarZzf.zzj().zzp().zza("Pruned " + iDelete + " trigger URIs. appId, source, timestamp", str, Integer.valueOf(i2), Long.valueOf(j));
                        } catch (SQLiteException e) {
                            zzaoVarZzf.zzj().zzg().zza("Error pruning trigger URIs. appId", zzfr.zza(str), e);
                        }
                    }
                }
            }
        }
        return zzmpVar.zzf().zzh(zzoVar.zza);
    }

    zzib(zzhj zzhjVar, zzo zzoVar, Bundle bundle) {
        this.zzc = zzhjVar;
        this.zza = zzoVar;
        this.zzb = bundle;
    }
}
