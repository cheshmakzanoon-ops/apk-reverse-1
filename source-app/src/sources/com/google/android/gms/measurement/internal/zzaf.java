package com.google.android.gms.measurement.internal;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.Bundle;
import android.text.TextUtils;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.common.util.ProcessUtils;
import com.google.android.gms.common.wrappers.Wrappers;
import com.google.android.gms.internal.measurement.zzoo;
import com.google.android.gms.internal.measurement.zzot;
import com.ishumei.smantifraud.l1l11lI1l;
import java.lang.reflect.InvocationTargetException;
import java.util.Arrays;
import java.util.List;
import org.checkerframework.checker.nullness.qual.EnsuresNonNull;
import org.checkerframework.dataflow.qual.Pure;

public final class zzaf extends zzid {
    private Boolean zza;
    private zzah zzb;
    private Boolean zzc;

    public final double zza(String str, zzfi<Double> zzfiVar) {
        if (str == null) {
            return zzfiVar.zza(null).doubleValue();
        }
        String strZza = this.zzb.zza(str, zzfiVar.zza());
        if (TextUtils.isEmpty(strZza)) {
            return zzfiVar.zza(null).doubleValue();
        }
        try {
            return zzfiVar.zza(Double.valueOf(Double.parseDouble(strZza))).doubleValue();
        } catch (NumberFormatException unused) {
            return zzfiVar.zza(null).doubleValue();
        }
    }

    final int zzc() {
        return (zzot.zza() && zze().zzf(null, zzbi.zzcc) && zzq().zza(231100000, true)) ? 35 : 0;
    }

    final int zza(String str) {
        return zza(str, zzbi.zzah, 500, 2000);
    }

    final int zzb(String str) {
        return (zzoo.zza() && zze().zzf(null, zzbi.zzcu)) ? 500 : 100;
    }

    final int zzc(String str) {
        return Math.max(zzb(str), l1l11lI1l.l111l11111lIl);
    }

    public final int zzg() {
        return zzq().zza(201500000, true) ? 100 : 25;
    }

    public final int zzd(String str) {
        return zza(str, zzbi.zzai, 25, 100);
    }

    public final int zze(String str) {
        return zzb(str, zzbi.zzo);
    }

    public final int zzb(String str, zzfi<Integer> zzfiVar) {
        if (str == null) {
            return zzfiVar.zza(null).intValue();
        }
        String strZza = this.zzb.zza(str, zzfiVar.zza());
        if (TextUtils.isEmpty(strZza)) {
            return zzfiVar.zza(null).intValue();
        }
        try {
            return zzfiVar.zza(Integer.valueOf(Integer.parseInt(strZza))).intValue();
        } catch (NumberFormatException unused) {
            return zzfiVar.zza(null).intValue();
        }
    }

    public final int zza(String str, zzfi<Integer> zzfiVar, int i, int i2) {
        return Math.max(Math.min(zzb(str, zzfiVar), i2), i);
    }

    final long zzf(String str) {
        return zzc(str, zzbi.zza);
    }

    public static long zzh() {
        return zzbi.zzd.zza(null).longValue();
    }

    public static long zzm() {
        return zzbi.zzad.zza(null).longValue();
    }

    public final long zzc(String str, zzfi<Long> zzfiVar) {
        if (str == null) {
            return zzfiVar.zza(null).longValue();
        }
        String strZza = this.zzb.zza(str, zzfiVar.zza());
        if (TextUtils.isEmpty(strZza)) {
            return zzfiVar.zza(null).longValue();
        }
        try {
            return zzfiVar.zza(Long.valueOf(Long.parseLong(strZza))).longValue();
        } catch (NumberFormatException unused) {
            return zzfiVar.zza(null).longValue();
        }
    }

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    private final Bundle zzy() {
        try {
            if (zza().getPackageManager() == null) {
                zzj().zzg().zza("Failed to load metadata: PackageManager is null");
                return null;
            }
            ApplicationInfo applicationInfo = Wrappers.packageManager(zza()).getApplicationInfo(zza().getPackageName(), 128);
            if (applicationInfo == null) {
                zzj().zzg().zza("Failed to load metadata: ApplicationInfo is null");
                return null;
            }
            return applicationInfo.metaData;
        } catch (PackageManager.NameNotFoundException e) {
            zzj().zzg().zza("Failed to load metadata: Package name not found", e);
            return null;
        }
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
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
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    final Boolean zzg(String str) {
        Preconditions.checkNotEmpty(str);
        Bundle bundleZzy = zzy();
        if (bundleZzy == null) {
            zzj().zzg().zza("Failed to load metadata: Metadata bundle is null");
            return null;
        }
        if (bundleZzy.containsKey(str)) {
            return Boolean.valueOf(bundleZzy.getBoolean(str));
        }
        return null;
    }

    public final String zzn() {
        return zza("debug.firebase.analytics.app", "");
    }

    public final String zzo() {
        return zza("debug.deferred.deeplink", "");
    }

    public final String zzd(String str, zzfi<String> zzfiVar) {
        if (str == null) {
            return zzfiVar.zza(null);
        }
        return zzfiVar.zza(this.zzb.zza(str, zzfiVar.zza()));
    }

    final String zzh(String str) {
        return zzd(str, zzbi.zzal);
    }

    private final String zza(String str, String str2) {
        try {
            String str3 = (String) Class.forName("android.os.SystemProperties").getMethod("get", String.class, String.class).invoke(null, str, str2);
            Preconditions.checkNotNull(str3);
            return str3;
        } catch (ClassNotFoundException e) {
            zzj().zzg().zza("Could not find SystemProperties class", e);
            return str2;
        } catch (IllegalAccessException e2) {
            zzj().zzg().zza("Could not access SystemProperties.get()", e2);
            return str2;
        } catch (NoSuchMethodException e3) {
            zzj().zzg().zza("Could not find SystemProperties.get() method", e3);
            return str2;
        } catch (InvocationTargetException e4) {
            zzj().zzg().zza("SystemProperties.get() threw an exception", e4);
            return str2;
        }
    }

    final List<String> zzi(String str) {
        Integer numValueOf;
        String[] stringArray;
        Preconditions.checkNotEmpty(str);
        Bundle bundleZzy = zzy();
        if (bundleZzy == null) {
            zzj().zzg().zza("Failed to load metadata: Metadata bundle is null");
        } else {
            if (bundleZzy.containsKey(str)) {
                numValueOf = Integer.valueOf(bundleZzy.getInt(str));
            }
            if (numValueOf == null) {
                return null;
            }
            try {
                stringArray = zza().getResources().getStringArray(numValueOf.intValue());
                if (stringArray == null) {
                    return null;
                }
                return Arrays.asList(stringArray);
            } catch (Resources.NotFoundException e) {
                zzj().zzg().zza("Failed to load string array from metadata: resource not found", e);
                return null;
            }
        }
        numValueOf = null;
        if (numValueOf == null) {
            return null;
        }
        stringArray = zza().getResources().getStringArray(numValueOf.intValue());
        if (stringArray == null) {
            return null;
        }
        return Arrays.asList(stringArray);
    }

    zzaf(zzhf zzhfVar) {
        super(zzhfVar);
        this.zzb = new zzah() {
            @Override
            public final String zza(String str, String str2) {
                return null;
            }
        };
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

    final void zza(zzah zzahVar) {
        this.zzb = zzahVar;
    }

    public final boolean zzp() {
        Boolean boolZzg = zzg("google_analytics_adid_collection_enabled");
        return boolZzg == null || boolZzg.booleanValue();
    }

    final boolean zzj(String str) {
        return zzf(str, zzbi.zzak);
    }

    public final boolean zza(zzfi<Boolean> zzfiVar) {
        return zzf(null, zzfiVar);
    }

    public final boolean zze(String str, zzfi<Boolean> zzfiVar) {
        return zzf(str, zzfiVar);
    }

    public final boolean zzf(String str, zzfi<Boolean> zzfiVar) {
        if (str == null) {
            return zzfiVar.zza(null).booleanValue();
        }
        String strZza = this.zzb.zza(str, zzfiVar.zza());
        if (TextUtils.isEmpty(strZza)) {
            return zzfiVar.zza(null).booleanValue();
        }
        return zzfiVar.zza(Boolean.valueOf("1".equals(strZza))).booleanValue();
    }

    public final boolean zzk(String str) {
        return "1".equals(this.zzb.zza(str, "gaia_collection_enabled"));
    }

    public final boolean zzu() {
        Boolean boolZzg = zzg("google_analytics_automatic_screen_reporting_enabled");
        return boolZzg == null || boolZzg.booleanValue();
    }

    public final boolean zzv() {
        Boolean boolZzg = zzg("firebase_analytics_collection_deactivated");
        return boolZzg != null && boolZzg.booleanValue();
    }

    public final boolean zzl(String str) {
        return "1".equals(this.zzb.zza(str, "measurement.event_sampling_enabled"));
    }

    final boolean zzw() {
        if (this.zza == null) {
            Boolean boolZzg = zzg("app_measurement_lite");
            this.zza = boolZzg;
            if (boolZzg == null) {
                this.zza = false;
            }
        }
        return this.zza.booleanValue() || !this.zzu.zzag();
    }

    @EnsuresNonNull({"this.isMainProcess"})
    public final boolean zzx() {
        if (this.zzc == null) {
            synchronized (this) {
                if (this.zzc == null) {
                    ApplicationInfo applicationInfo = zza().getApplicationInfo();
                    String myProcessName = ProcessUtils.getMyProcessName();
                    if (applicationInfo != null) {
                        String str = applicationInfo.processName;
                        this.zzc = Boolean.valueOf(str != null && str.equals(myProcessName));
                    }
                    if (this.zzc == null) {
                        this.zzc = Boolean.TRUE;
                        zzj().zzg().zza("My process not in the list of running processes");
                    }
                }
            }
        }
        return this.zzc.booleanValue();
    }
}
