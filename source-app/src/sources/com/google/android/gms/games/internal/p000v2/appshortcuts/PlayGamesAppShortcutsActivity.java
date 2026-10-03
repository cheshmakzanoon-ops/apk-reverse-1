package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ResolveInfo;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.util.Log;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.zzd;
import com.google.android.gms.internal.games_v2.zzfr;
import com.google.android.gms.internal.games_v2.zzgz;
import com.google.android.gms.internal.games_v2.zzhd;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import java.util.List;

public final class PlayGamesAppShortcutsActivity extends Activity {
    private Intent zza;

    @Override
    protected final void onActivityResult(int i, int i2, Intent intent) {
        super.onActivityResult(i, i2, intent);
        if (i != 1005000000) {
            return;
        }
        if (i2 != -1) {
            finish();
        } else {
            new zzfr(Looper.getMainLooper()).postDelayed(new Runnable() {
                @Override
                public final void run() {
                    this.zza.zza();
                }
            }, 50L);
        }
    }

    @Override
    protected final void onCreate(Bundle bundle) {
        Intent intentAddFlags;
        super.onCreate(bundle);
        if (Build.VERSION.SDK_INT < 25) {
            finish();
            return;
        }
        final zzr zzrVarZza = zzt.zza(this, PlayGamesAppShortcutsActivity.class);
        if (zzrVarZza == null) {
            finish();
            return;
        }
        String strZzb = zzrVarZza.zzb();
        if (strZzb == null || strZzb.isEmpty()) {
            List<ResolveInfo> listQueryIntentActivities = getPackageManager().queryIntentActivities(new Intent("android.intent.action.MAIN").addCategory("android.intent.category.LAUNCHER").setPackage(getPackageName()), 795136);
            int i = zzhd.zzd;
            zzgz zzgzVar = new zzgz();
            for (ResolveInfo resolveInfo : listQueryIntentActivities) {
                ActivityInfo activityInfo = resolveInfo.activityInfo;
                if (activityInfo != null) {
                    int componentEnabledSetting = getPackageManager().getComponentEnabledSetting(new ComponentName(activityInfo.packageName, activityInfo.name));
                    if (componentEnabledSetting == 0) {
                        if (activityInfo.enabled) {
                            if (resolveInfo.activityInfo.exported) {
                                zzgzVar.zzd(resolveInfo);
                            }
                        }
                    } else if (componentEnabledSetting == 1) {
                        if (resolveInfo.activityInfo.exported) {
                            zzgzVar.zzd(resolveInfo);
                        }
                    }
                }
            }
            zzhd zzhdVarZze = zzgzVar.zze();
            int size = zzhdVarZze.size();
            int i2 = 0;
            while (true) {
                if (i2 >= size) {
                    strZzb = null;
                    break;
                }
                ActivityInfo activityInfo2 = ((ResolveInfo) zzhdVarZze.get(i2)).activityInfo;
                i2++;
                if (activityInfo2 != null) {
                    strZzb = activityInfo2.name;
                    break;
                }
            }
        }
        if (strZzb == null || strZzb.isEmpty()) {
            intentAddFlags = null;
        } else {
            String packageName = getPackageName();
            intentAddFlags = new Intent().setComponent(new ComponentName(packageName, strZzb)).setPackage(packageName).addFlags(335577088);
        }
        if (intentAddFlags == null) {
            finish();
            return;
        }
        this.zza = intentAddFlags;
        final zzq zzqVar = new zzq((Activity) this);
        Intent intent = getIntent();
        final zzi zziVar = new zzi(intent.getStringExtra("com.google.android.gms.games.EXTRA_APP_SHORTCUT_ID"), (PersistableBundle) intent.getParcelableExtra("com.google.android.gms.games.EXTRA_APP_SHORTCUT_EXTRAS"), null, true);
        zzqVar.doRead(TaskApiCall.builder().setMethodKey(6745).setFeatures(zzd.zzg).setAutoResolveMissingFeatures(false).run(new RemoteCall() {
            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                ((zzv) ((zzu) obj).getService()).zze(new zzm(zzqVar, (TaskCompletionSource) obj2), zzrVarZza, zziVar);
            }
        }).build()).addOnCompleteListener(this, new OnCompleteListener() {
            @Override
            public final void onComplete(Task task) {
                PlayGamesAppShortcutsActivity playGamesAppShortcutsActivity = this.zza;
                if (task.isSuccessful()) {
                    playGamesAppShortcutsActivity.startActivityForResult((Intent) task.getResult(), 1005000000);
                } else {
                    Log.e("PGShortcutsActivity", "Failed to access intent.", task.getException());
                    playGamesAppShortcutsActivity.finish();
                }
            }
        });
    }

    final void zza() {
        startActivityForResult(this.zza, 1005000001);
        finish();
        System.exit(0);
    }
}
