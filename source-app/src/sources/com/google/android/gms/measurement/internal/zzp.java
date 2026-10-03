package com.google.android.gms.measurement.internal;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import com.google.android.gms.internal.measurement.zzpg;

public final class zzp extends BroadcastReceiver {
    private final zzhf zza;

    public zzp(zzhf zzhfVar) {
        this.zza = zzhfVar;
    }

    @Override
    public final void onReceive(Context context, Intent intent) {
        if (intent == null) {
            this.zza.zzj().zzu().zza("App receiver called with null intent");
            return;
        }
        String action = intent.getAction();
        if (action == null) {
            this.zza.zzj().zzu().zza("App receiver called with null action");
            return;
        }
        action.hashCode();
        if (action.equals("com.google.android.gms.measurement.TRIGGERS_AVAILABLE")) {
            final zzhf zzhfVar = this.zza;
            if (zzpg.zza() && zzhfVar.zzf().zzf(null, zzbi.zzcg)) {
                zzhfVar.zzj().zzp().zza("App receiver notified triggers are available");
                zzhfVar.zzl().zzb(new Runnable() {
                    @Override
                    public final void run() {
                        zzhf zzhfVar2 = zzhfVar;
                        if (!zzhfVar2.zzt().zzw()) {
                            zzhfVar2.zzj().zzu().zza("registerTrigger called but app not eligible");
                            return;
                        }
                        final zziq zziqVarZzp = zzhfVar2.zzp();
                        zziqVarZzp.getClass();
                        new Thread(new Runnable() {
                            @Override
                            public final void run() {
                                zziqVarZzp.zzal();
                            }
                        }).start();
                    }
                });
                return;
            }
            return;
        }
        this.zza.zzj().zzu().zza("App receiver called with unknown action");
    }
}
