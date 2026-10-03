package com.google.android.gms.measurement.internal;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.List;
import java.util.Map;
import org.checkerframework.dataflow.qual.Pure;

public final class zzkh extends zze {
    protected zzki zza;
    private volatile zzki zzb;
    private volatile zzki zzc;
    private final Map<Activity, zzki> zzd;
    private Activity zze;
    private volatile boolean zzf;
    private volatile zzki zzg;
    private zzki zzh;
    private boolean zzi;
    private final Object zzj;

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    @Override
    protected final boolean zzz() {
        return false;
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
    }

    @Override
    public final zzb zzc() {
        return super.zzc();
    }

    @Override
    @Pure
    public final zzae zzd() {
        return super.zzd();
    }

    @Override
    @Pure
    public final zzaf zze() {
        return super.zze();
    }

    @Override
    @Pure
    public final zzba zzf() {
        return super.zzf();
    }

    @Override
    public final zzfl zzg() {
        return super.zzg();
    }

    @Override
    public final zzfo zzh() {
        return super.zzh();
    }

    @Override
    @Pure
    public final zzfq zzi() {
        return super.zzi();
    }

    @Override
    @Pure
    public final zzfr zzj() {
        return super.zzj();
    }

    @Override
    @Pure
    public final zzgd zzk() {
        return super.zzk();
    }

    @Override
    @Pure
    public final zzgy zzl() {
        return super.zzl();
    }

    @Override
    public final zziq zzm() {
        return super.zzm();
    }

    private final zzki zzd(Activity activity) {
        Preconditions.checkNotNull(activity);
        zzki zzkiVar = this.zzd.get(activity);
        if (zzkiVar == null) {
            zzki zzkiVar2 = new zzki(null, zza(activity.getClass(), "Activity"), zzq().zzm());
            this.zzd.put(activity, zzkiVar2);
            zzkiVar = zzkiVar2;
        }
        return this.zzg != null ? this.zzg : zzkiVar;
    }

    public final zzki zzaa() {
        return this.zzb;
    }

    public final zzki zza(boolean z) {
        zzu();
        zzt();
        if (!z) {
            return this.zza;
        }
        zzki zzkiVar = this.zza;
        return zzkiVar != null ? zzkiVar : this.zzh;
    }

    @Override
    public final zzkh zzn() {
        return super.zzn();
    }

    @Override
    public final zzkp zzo() {
        return super.zzo();
    }

    @Override
    public final zzlx zzp() {
        return super.zzp();
    }

    @Override
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    private final String zza(Class<?> cls, String str) {
        String str2;
        String canonicalName = cls.getCanonicalName();
        if (canonicalName == null) {
            return str;
        }
        String[] strArrSplit = canonicalName.split("\\.");
        if (strArrSplit.length > 0) {
            str2 = strArrSplit[strArrSplit.length - 1];
        } else {
            str2 = "";
        }
        return str2.length() > zze().zzb(null) ? str2.substring(0, zze().zzb(null)) : str2;
    }

    static void zza(zzkh zzkhVar, Bundle bundle, zzki zzkiVar, zzki zzkiVar2, long j) {
        if (bundle != null) {
            bundle.remove(FirebaseAnalytics.Param.SCREEN_NAME);
            bundle.remove(FirebaseAnalytics.Param.SCREEN_CLASS);
        }
        zzkhVar.zza(zzkiVar, zzkiVar2, j, true, zzkhVar.zzq().zza((String) null, FirebaseAnalytics.Event.SCREEN_VIEW, bundle, (List<String>) null, false));
    }

    public zzkh(zzhf zzhfVar) {
        super(zzhfVar);
        this.zzj = new Object();
        this.zzd = new ConcurrentHashMap();
    }

    private final void zza(Activity activity, zzki zzkiVar, boolean z) {
        zzki zzkiVar2;
        zzki zzkiVar3 = this.zzb == null ? this.zzc : this.zzb;
        if (zzkiVar.zzb == null) {
            zzkiVar2 = new zzki(zzkiVar.zza, activity != null ? zza(activity.getClass(), "Activity") : null, zzkiVar.zzc, zzkiVar.zze, zzkiVar.zzf);
        } else {
            zzkiVar2 = zzkiVar;
        }
        this.zzc = this.zzb;
        this.zzb = zzkiVar2;
        zzl().zzb(new zzkm(this, zzkiVar2, zzkiVar3, zzb().elapsedRealtime(), z));
    }

    public final void zza(zzki zzkiVar, zzki zzkiVar2, long j, boolean z, Bundle bundle) {
        String str;
        zzt();
        boolean z2 = false;
        boolean z3 = (zzkiVar2 != null && zzkiVar2.zzc == zzkiVar.zzc && zzkk.zza(zzkiVar2.zzb, zzkiVar.zzb) && zzkk.zza(zzkiVar2.zza, zzkiVar.zza)) ? false : true;
        if (z && this.zza != null) {
            z2 = true;
        }
        if (z3) {
            Bundle bundle2 = bundle != null ? new Bundle(bundle) : new Bundle();
            zznd.zza(zzkiVar, bundle2, true);
            if (zzkiVar2 != null) {
                if (zzkiVar2.zza != null) {
                    bundle2.putString("_pn", zzkiVar2.zza);
                }
                if (zzkiVar2.zzb != null) {
                    bundle2.putString("_pc", zzkiVar2.zzb);
                }
                bundle2.putLong("_pi", zzkiVar2.zzc);
            }
            if (z2) {
                long jZza = zzp().zzb.zza(j);
                if (jZza > 0) {
                    zzq().zza(bundle2, jZza);
                }
            }
            if (!zze().zzu()) {
                bundle2.putLong("_mst", 1L);
            }
            if (zzkiVar.zze) {
                str = "app";
            } else {
                str = "auto";
            }
            zzm().zza(str, "_vs", (!zzkiVar.zze || zzkiVar.zzf == 0) ? zzb().currentTimeMillis() : zzkiVar.zzf, bundle2);
        }
        if (z2) {
            zza(this.zza, true, j);
        }
        this.zza = zzkiVar;
        if (zzkiVar.zze) {
            this.zzh = zzkiVar;
        }
        zzo().zza(zzkiVar);
    }

    @Override
    public final void zzr() {
        super.zzr();
    }

    @Override
    public final void zzs() {
        super.zzs();
    }

    @Override
    public final void zzt() {
        super.zzt();
    }

    public final void zza(Activity activity, Bundle bundle) {
        Bundle bundle2;
        if (!zze().zzu() || bundle == null || (bundle2 = bundle.getBundle("com.google.app_measurement.screen_service")) == null) {
            return;
        }
        this.zzd.put(activity, new zzki(bundle2.getString(AppMeasurementSdk.ConditionalUserProperty.NAME), bundle2.getString("referrer_name"), bundle2.getLong("id")));
    }

    public final void zza(Activity activity) {
        synchronized (this.zzj) {
            if (activity == this.zze) {
                this.zze = null;
            }
        }
        if (zze().zzu()) {
            this.zzd.remove(activity);
        }
    }

    public final void zzb(Activity activity) {
        synchronized (this.zzj) {
            this.zzi = false;
            this.zzf = true;
        }
        long jElapsedRealtime = zzb().elapsedRealtime();
        if (!zze().zzu()) {
            this.zzb = null;
            zzl().zzb(new zzko(this, jElapsedRealtime));
        } else {
            zzki zzkiVarZzd = zzd(activity);
            this.zzc = this.zzb;
            this.zzb = null;
            zzl().zzb(new zzkn(this, zzkiVarZzd, jElapsedRealtime));
        }
    }

    public final void zzc(Activity activity) {
        synchronized (this.zzj) {
            this.zzi = true;
            if (activity != this.zze) {
                synchronized (this.zzj) {
                    this.zze = activity;
                    this.zzf = false;
                }
                if (zze().zzu()) {
                    this.zzg = null;
                    zzl().zzb(new zzkq(this));
                }
            }
        }
        if (!zze().zzu()) {
            this.zzb = this.zzg;
            zzl().zzb(new zzkl(this));
        } else {
            zza(activity, zzd(activity), false);
            zzb zzbVarZzc = zzc();
            zzbVarZzc.zzl().zzb(new zzc(zzbVarZzc, zzbVarZzc.zzb().elapsedRealtime()));
        }
    }

    public final void zzb(Activity activity, Bundle bundle) {
        zzki zzkiVar;
        if (!zze().zzu() || bundle == null || (zzkiVar = this.zzd.get(activity)) == null) {
            return;
        }
        Bundle bundle2 = new Bundle();
        bundle2.putLong("id", zzkiVar.zzc);
        bundle2.putString(AppMeasurementSdk.ConditionalUserProperty.NAME, zzkiVar.zza);
        bundle2.putString("referrer_name", zzkiVar.zzb);
        bundle.putBundle("com.google.app_measurement.screen_service", bundle2);
    }

    public final void zza(zzki zzkiVar, boolean z, long j) {
        zzc().zza(zzb().elapsedRealtime());
        if (!zzp().zza(zzkiVar != null && zzkiVar.zzd, z, j) || zzkiVar == null) {
            return;
        }
        zzkiVar.zzd = false;
    }

    @Deprecated
    public final void zza(Activity activity, String str, String str2) {
        if (!zze().zzu()) {
            zzj().zzv().zza("setCurrentScreen cannot be called while screen reporting is disabled.");
            return;
        }
        zzki zzkiVar = this.zzb;
        if (zzkiVar == null) {
            zzj().zzv().zza("setCurrentScreen cannot be called while no activity active");
            return;
        }
        if (this.zzd.get(activity) == null) {
            zzj().zzv().zza("setCurrentScreen must be called with an activity in the activity lifecycle");
            return;
        }
        if (str2 == null) {
            str2 = zza(activity.getClass(), "Activity");
        }
        boolean zZza = zzkk.zza(zzkiVar.zzb, str2);
        boolean zZza2 = zzkk.zza(zzkiVar.zza, str);
        if (zZza && zZza2) {
            zzj().zzv().zza("setCurrentScreen cannot be called with the same class and name");
            return;
        }
        if (str != null && (str.length() <= 0 || str.length() > zze().zzb(null))) {
            zzj().zzv().zza("Invalid screen name length in setCurrentScreen. Length", Integer.valueOf(str.length()));
            return;
        }
        if (str2 != null && (str2.length() <= 0 || str2.length() > zze().zzb(null))) {
            zzj().zzv().zza("Invalid class name length in setCurrentScreen. Length", Integer.valueOf(str2.length()));
            return;
        }
        zzj().zzp().zza("Setting current screen to name, class", str == null ? "null" : str, str2);
        zzki zzkiVar2 = new zzki(str, str2, zzq().zzm());
        this.zzd.put(activity, zzkiVar2);
        zza(activity, zzkiVar2, true);
    }

    public final void zza(Bundle bundle, long j) {
        String str;
        synchronized (this.zzj) {
            if (!this.zzi) {
                zzj().zzv().zza("Cannot log screen view event when the app is in the background.");
                return;
            }
            String strZza = null;
            if (bundle != null) {
                String string = bundle.getString(FirebaseAnalytics.Param.SCREEN_NAME);
                if (string != null && (string.length() <= 0 || string.length() > zze().zzb(null))) {
                    zzj().zzv().zza("Invalid screen name length for screen view. Length", Integer.valueOf(string.length()));
                    return;
                }
                String string2 = bundle.getString(FirebaseAnalytics.Param.SCREEN_CLASS);
                if (string2 != null && (string2.length() <= 0 || string2.length() > zze().zzb(null))) {
                    zzj().zzv().zza("Invalid screen class length for screen view. Length", Integer.valueOf(string2.length()));
                    return;
                } else {
                    strZza = string2;
                    str = string;
                }
            } else {
                str = null;
            }
            if (strZza == null) {
                Activity activity = this.zze;
                if (activity != null) {
                    strZza = zza(activity.getClass(), "Activity");
                } else {
                    strZza = "Activity";
                }
            }
            String str2 = strZza;
            zzki zzkiVar = this.zzb;
            if (this.zzf && zzkiVar != null) {
                this.zzf = false;
                boolean zZza = zzkk.zza(zzkiVar.zzb, str2);
                boolean zZza2 = zzkk.zza(zzkiVar.zza, str);
                if (zZza && zZza2) {
                    zzj().zzv().zza("Ignoring call to log screen view event with duplicate parameters.");
                    return;
                }
            }
            zzj().zzp().zza("Logging screen view with name, class", str == null ? "null" : str, str2 == null ? "null" : str2);
            zzki zzkiVar2 = this.zzb == null ? this.zzc : this.zzb;
            zzki zzkiVar3 = new zzki(str, str2, zzq().zzm(), true, j);
            this.zzb = zzkiVar3;
            this.zzc = zzkiVar2;
            this.zzg = zzkiVar3;
            zzl().zzb(new zzkj(this, bundle, zzkiVar3, zzkiVar2, zzb().elapsedRealtime()));
        }
    }
}
