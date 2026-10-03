package com.google.android.gms.internal.measurement;

import android.content.Context;
import android.database.ContentObserver;
import android.util.Log;
import androidx.core.content.PermissionChecker;
import javax.annotation.Nullable;

final class zzgg implements zzgb {
    private static zzgg zza;

    @Nullable
    private final Context zzb;

    @Nullable
    private final ContentObserver zzc;

    static zzgg zza(Context context) {
        zzgg zzggVar;
        synchronized (zzgg.class) {
            if (zza == null) {
                zza = PermissionChecker.checkSelfPermission(context, "com.google.android.providers.gsf.permission.READ_GSERVICES") == 0 ? new zzgg(context) : new zzgg();
            }
            zzggVar = zza;
        }
        return zzggVar;
    }

    @Override
    @Nullable
    public final String zza(final String str) {
        Context context = this.zzb;
        if (context != null && !zzfw.zza(context)) {
            try {
                return (String) zzge.zza(new zzgd() {
                    @Override
                    public final Object zza() {
                        return this.zza.zzb(str);
                    }
                });
            } catch (IllegalStateException | NullPointerException | SecurityException e) {
                Log.e("GservicesLoader", "Unable to read GServices for: " + str, e);
            }
        }
        return null;
    }

    final String zzb(String str) {
        return zzfr.zza(this.zzb.getContentResolver(), str, (String) null);
    }

    private zzgg() {
        this.zzb = null;
        this.zzc = null;
    }

    private zzgg(Context context) {
        this.zzb = context;
        zzgi zzgiVar = new zzgi(this, null);
        this.zzc = zzgiVar;
        context.getContentResolver().registerContentObserver(zzfr.zza, true, zzgiVar);
    }

    static synchronized void zza() {
        Context context;
        zzgg zzggVar = zza;
        if (zzggVar != null && (context = zzggVar.zzb) != null && zzggVar.zzc != null) {
            context.getContentResolver().unregisterContentObserver(zza.zzc);
        }
        zza = null;
    }
}
