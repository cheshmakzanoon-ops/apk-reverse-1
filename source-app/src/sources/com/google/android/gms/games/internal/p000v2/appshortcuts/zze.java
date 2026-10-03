package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.content.Context;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.os.RemoteException;
import androidx.core.graphics.ColorKt$;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.zzd;
import com.google.android.gms.internal.games_v2.zzfq;
import com.google.android.gms.internal.games_v2.zzgz;
import com.google.android.gms.internal.games_v2.zzhd;
import com.google.android.gms.internal.games_v2.zzio;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.gms.tasks.Tasks;
import java.util.Iterator;
import java.util.List;

final class zze extends zzf {
    private final Context zza;

    public zze(Context context) {
        super(null);
        this.zza = context.getApplicationContext();
    }

    static zzg zzc(zzhd zzhdVar, zzhd zzhdVar2, Task task) {
        return task.isSuccessful() ? (zzg) task.getResult() : zze(zzhdVar, zzhdVar2);
    }

    private static zzg zze(zzhd zzhdVar, zzhd zzhdVar2) {
        return new zzg(zzf(zzhdVar), zzhd.zzi(), zzf(zzhdVar2), zzhd.zzi());
    }

    private static zzhd zzf(zzhd zzhdVar) {
        int i = zzhd.zzd;
        zzgz zzgzVar = new zzgz();
        int size = zzhdVar.size();
        for (int i2 = 0; i2 < size; i2++) {
            String strZza = ((zzi) zzhdVar.get(i2)).zza();
            if (strZza != null) {
                zzgzVar.zzd(strZza);
            }
        }
        return zzgzVar.zze();
    }

    private static zzhd zzg(List list) {
        int i = zzhd.zzd;
        zzgz zzgzVar = new zzgz();
        Iterator it = list.iterator();
        while (it.hasNext()) {
            ShortcutInfo shortcutInfoM = ColorKt$.ExternalSyntheticApiModelOutline0.m(it.next());
            if (!ColorKt$.ExternalSyntheticApiModelOutline0.m$4(shortcutInfoM) && ColorKt$.ExternalSyntheticApiModelOutline0.m(shortcutInfoM).startsWith("PLAY_GAMES_SERVICES_")) {
                zzgzVar.zzd(new zzi(ColorKt$.ExternalSyntheticApiModelOutline0.m(shortcutInfoM), ColorKt$.ExternalSyntheticApiModelOutline0.m(shortcutInfoM), Boolean.valueOf(ColorKt$.ExternalSyntheticApiModelOutline0.m$2(shortcutInfoM)), Boolean.valueOf(ColorKt$.ExternalSyntheticApiModelOutline0.m$5(shortcutInfoM))));
            }
        }
        return zzgzVar.zze();
    }

    @Override
    public final void zza() {
        zzfq.zza();
        new Thread(new Runnable() {
            @Override
            public final void run() {
                this.zza.zzb();
            }
        }, "initialize-shortcuts").start();
    }

    final void zzb() {
        Task taskForResult;
        Context context = this.zza;
        final ShortcutManager shortcutManagerM = ColorKt$.ExternalSyntheticApiModelOutline0.m(context.getSystemService(ColorKt$.ExternalSyntheticApiModelOutline0.m()));
        if (shortcutManagerM == null) {
            return;
        }
        final zzr zzrVarZza = zzt.zza(context, PlayGamesAppShortcutsActivity.class);
        final zzhd zzhdVarZzg = zzg(ColorKt$.ExternalSyntheticApiModelOutline0.m(shortcutManagerM));
        final zzhd zzhdVarZzg2 = zzg(ColorKt$.ExternalSyntheticApiModelOutline0.m$2(shortcutManagerM));
        if (zzrVarZza == null || zzrVarZza.zza() <= 0) {
            taskForResult = Tasks.forResult(zze(zzhdVarZzg, zzhdVarZzg2));
        } else {
            final zzq zzqVar = new zzq(context);
            taskForResult = zzqVar.doRead(TaskApiCall.builder().setMethodKey(6744).setFeatures(zzd.zzg).setAutoResolveMissingFeatures(false).run(new RemoteCall() {
                @Override
                public final void accept(Object obj, Object obj2) throws RemoteException {
                    ((zzv) ((zzu) obj).getService()).zzd(new zzl(zzqVar, (TaskCompletionSource) obj2), zzrVarZza, zzhdVarZzg, zzhdVarZzg2);
                }
            }).build()).continueWith(zzio.zza(), new Continuation() {
                @Override
                public final Object then(Task task) {
                    return zze.zzc(zzhdVarZzg, zzhdVarZzg2, task);
                }
            });
        }
        taskForResult.addOnSuccessListener(zzio.zza(), new OnSuccessListener() {
            @Override
            public final void onSuccess(Object obj) {
                zzg zzgVar = (zzg) obj;
                List listZza = zzgVar.zza();
                ShortcutManager shortcutManager = shortcutManagerM;
                if (listZza != null && !listZza.isEmpty()) {
                    ColorKt$.ExternalSyntheticApiModelOutline0.m$1(shortcutManager, listZza);
                }
                List listZzb = zzgVar.zzb();
                if (listZzb != null && !listZzb.isEmpty()) {
                    ColorKt$.ExternalSyntheticApiModelOutline0.m$1(shortcutManager, listZzb);
                }
                List listZzc = zzgVar.zzc();
                if (listZzc != null && !listZzc.isEmpty()) {
                    shortcutManager.disableShortcuts(listZzc);
                }
                List listZzd = zzgVar.zzd();
                if (listZzd == null || listZzd.isEmpty()) {
                    return;
                }
                ColorKt$.ExternalSyntheticApiModelOutline0.m(shortcutManager, listZzd);
            }
        });
    }
}
