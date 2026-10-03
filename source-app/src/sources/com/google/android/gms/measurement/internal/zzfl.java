package com.google.android.gms.measurement.internal;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.text.TextUtils;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.common.wrappers.InstantApps;
import com.google.android.gms.internal.measurement.zznp;
import com.google.android.gms.internal.measurement.zzpg;
import com.google.android.gms.internal.measurement.zzps;
import com.google.android.gms.internal.measurement.zzqe;
import com.ishumei.smantifraud.l111l1111lI1l;
import java.math.BigInteger;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import org.checkerframework.checker.nullness.qual.EnsuresNonNull;
import org.checkerframework.dataflow.qual.Pure;

public final class zzfl extends zze {
    private String zza;
    private String zzb;
    private int zzc;
    private String zzd;
    private String zze;
    private long zzf;
    private long zzg;
    private List<String> zzh;
    private String zzi;
    private int zzj;
    private String zzk;
    private String zzl;
    private String zzm;
    private long zzn;
    private String zzo;

    final int zzaa() {
        zzu();
        return this.zzj;
    }

    @Override
    protected final boolean zzz() {
        return true;
    }

    final int zzab() {
        zzu();
        return this.zzc;
    }

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
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

    final zzo zza(String str) {
        String strZzf;
        int iZza;
        long jMin;
        long j;
        long j2;
        String str2;
        int iZzc;
        zzt();
        zzih zzihVarZzm = zzk().zzm();
        if (zznp.zza() && zze().zza(zzbi.zzcl)) {
            strZzf = zzk().zzh().zzf();
            iZza = zzihVarZzm.zza();
        } else {
            strZzf = "";
            iZza = 100;
        }
        String str3 = strZzf;
        int i = iZza;
        String strZzad = zzad();
        String strZzae = zzae();
        zzu();
        String str4 = this.zzb;
        long jZzab = zzab();
        zzu();
        Preconditions.checkNotNull(this.zzd);
        String str5 = this.zzd;
        zzu();
        zzt();
        if (this.zzf == 0) {
            this.zzf = this.zzu.zzt().zza(zza(), zza().getPackageName());
        }
        long j3 = this.zzf;
        boolean zZzac = this.zzu.zzac();
        boolean z = !zzk().zzm;
        zzt();
        String strZzah = !this.zzu.zzac() ? null : zzah();
        zzhf zzhfVar = this.zzu;
        long jZza = zzhfVar.zzn().zzc.zza();
        if (jZza == 0) {
            jMin = zzhfVar.zza;
        } else {
            jMin = Math.min(zzhfVar.zza, jZza);
        }
        long j4 = jMin;
        int iZzaa = zzaa();
        boolean zZzp = zze().zzp();
        zzgd zzgdVarZzk = zzk();
        zzgdVarZzk.zzt();
        boolean z2 = zzgdVarZzk.zzc().getBoolean("deferred_analytics_collection", false);
        String strZzac = zzac();
        Boolean boolZzg = zze().zzg("google_analytics_default_allow_ad_personalization_signals");
        Boolean boolValueOf = boolZzg == null ? null : Boolean.valueOf(!boolZzg.booleanValue());
        long j5 = this.zzg;
        List<String> list = this.zzh;
        String strZze = zzihVarZzm.zze();
        if (this.zzi == null) {
            this.zzi = zzq().zzp();
        }
        String str6 = this.zzi;
        if (zzps.zza() && zze().zza(zzbi.zzbs)) {
            zzt();
            j2 = 0;
            if (this.zzn != 0) {
                j = j5;
                long jCurrentTimeMillis = zzb().currentTimeMillis() - this.zzn;
                if (this.zzm != null && jCurrentTimeMillis > 86400000 && this.zzo == null) {
                    zzag();
                }
            } else {
                j = j5;
            }
            if (this.zzm == null) {
                zzag();
            }
            str2 = this.zzm;
        } else {
            j = j5;
            j2 = 0;
            str2 = null;
        }
        Boolean boolZzg2 = zze().zzg("google_analytics_sgtm_upload_enabled");
        boolean zBooleanValue = boolZzg2 == null ? false : boolZzg2.booleanValue();
        long jZzc = zzq().zzc(zzad());
        if (zzpg.zza() && zze().zza(zzbi.zzcg)) {
            zzq();
            iZzc = zznd.zzc();
        } else {
            iZzc = 0;
        }
        return new zzo(strZzad, strZzae, str4, jZzab, str5, 82001L, j3, str, zZzac, z, strZzah, 0L, j4, iZzaa, zZzp, z2, strZzac, boolValueOf, j, list, (String) null, strZze, str6, str2, zBooleanValue, jZzc, i, str3, iZzc, (zzpg.zza() && zze().zza(zzbi.zzcg)) ? zzq().zzh() : j2);
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

    final String zzac() {
        zzu();
        return this.zzl;
    }

    final String zzad() {
        zzu();
        Preconditions.checkNotNull(this.zza);
        return this.zza;
    }

    private final String zzah() {
        if (zzqe.zza() && zze().zza(zzbi.zzbk)) {
            zzj().zzp().zza("Disabled IID for tests.");
            return null;
        }
        try {
            Class<?> clsLoadClass = zza().getClassLoader().loadClass("com.google.firebase.analytics.FirebaseAnalytics");
            if (clsLoadClass == null) {
                return null;
            }
            try {
                Object objInvoke = clsLoadClass.getDeclaredMethod("getInstance", Context.class).invoke(null, zza());
                if (objInvoke == null) {
                    return null;
                }
                try {
                    return (String) clsLoadClass.getDeclaredMethod("getFirebaseInstanceId", null).invoke(objInvoke, null);
                } catch (Exception unused) {
                    zzj().zzv().zza("Failed to retrieve Firebase Instance Id");
                    return null;
                }
            } catch (Exception unused2) {
                zzj().zzw().zza("Failed to obtain Firebase Analytics instance");
                return null;
            }
        } catch (ClassNotFoundException unused3) {
        }
    }

    final String zzae() {
        zzt();
        zzu();
        Preconditions.checkNotNull(this.zzk);
        return this.zzk;
    }

    final List<String> zzaf() {
        return this.zzh;
    }

    zzfl(zzhf zzhfVar, long j) {
        super(zzhfVar);
        this.zzn = 0L;
        this.zzo = null;
        this.zzg = j;
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

    @Override
    @EnsuresNonNull({l111l1111lI1l.l111l1111l1Il, "appStore", "appName", "gmpAppId", "gaAppId"})
    protected final void zzx() {
        String str;
        String string;
        Object[] objArr;
        int iZzc;
        boolean z;
        List<String> listZzi;
        Iterator<String> it;
        String strZza;
        String str2;
        String packageName = zza().getPackageName();
        PackageManager packageManager = zza().getPackageManager();
        String str3 = "";
        String installerPackageName = "unknown";
        String str4 = "Unknown";
        int i = Integer.MIN_VALUE;
        try {
            if (packageManager == null) {
                zzj().zzg().zza("PackageManager is null, app identity information might be inaccurate. appId", zzfr.zza(packageName));
            } else {
                try {
                    installerPackageName = packageManager.getInstallerPackageName(packageName);
                } catch (IllegalArgumentException unused) {
                    zzj().zzg().zza("Error retrieving app installer package name. appId", zzfr.zza(packageName));
                }
                if (installerPackageName == null) {
                    installerPackageName = "manual_install";
                } else if ("com.android.vending".equals(installerPackageName)) {
                    installerPackageName = "";
                }
                try {
                    PackageInfo packageInfo = packageManager.getPackageInfo(zza().getPackageName(), 0);
                    if (packageInfo != null) {
                        CharSequence applicationLabel = packageManager.getApplicationLabel(packageInfo.applicationInfo);
                        string = !TextUtils.isEmpty(applicationLabel) ? applicationLabel.toString() : "Unknown";
                        try {
                            str4 = packageInfo.versionName;
                            i = packageInfo.versionCode;
                        } catch (PackageManager.NameNotFoundException unused2) {
                            str = str4;
                            str4 = string;
                            zzj().zzg().zza("Error retrieving package info. appId, appName", zzfr.zza(packageName), str4);
                            string = str4;
                            str4 = str;
                        }
                    }
                } catch (PackageManager.NameNotFoundException unused3) {
                    str = "Unknown";
                }
                this.zza = packageName;
                this.zzd = installerPackageName;
                this.zzb = str4;
                this.zzc = i;
                this.zze = string;
                this.zzf = 0L;
                if (TextUtils.isEmpty(this.zzu.zzu()) && "am".equals(this.zzu.zzv())) {
                    objArr = true;
                } else {
                    objArr = false;
                }
                iZzc = this.zzu.zzc();
                switch (iZzc) {
                    case 0:
                        zzj().zzp().zza("App measurement collection enabled");
                        break;
                    case 1:
                        zzj().zzn().zza("App measurement deactivated via the manifest");
                        break;
                    case 2:
                        zzj().zzp().zza("App measurement deactivated via the init parameters");
                        break;
                    case 3:
                        zzj().zzn().zza("App measurement disabled by setAnalyticsCollectionEnabled(false)");
                        break;
                    case 4:
                        zzj().zzn().zza("App measurement disabled via the manifest");
                        break;
                    case 5:
                        zzj().zzp().zza("App measurement disabled via the init parameters");
                        break;
                    case 6:
                        zzj().zzv().zza("App measurement deactivated via resources. This method is being deprecated. Please refer to https://firebase.google.com/support/guides/disable-analytics");
                        break;
                    case 7:
                        zzj().zzn().zza("App measurement disabled via the global data collection setting");
                        break;
                    case 8:
                        zzj().zzn().zza("App measurement disabled due to denied storage consent");
                        break;
                    default:
                        zzj().zzn().zza("App measurement disabled");
                        zzj().zzm().zza("Invalid scion state in identity");
                        break;
                }
                z = iZzc == 0;
                this.zzk = "";
                this.zzl = "";
                if (objArr != false) {
                    this.zzl = this.zzu.zzu();
                }
                strZza = new zzgz(zza(), this.zzu.zzx()).zza("google_app_id");
                if (TextUtils.isEmpty(strZza)) {
                    str3 = strZza;
                }
                this.zzk = str3;
                if (!TextUtils.isEmpty(strZza)) {
                    this.zzl = new zzgz(zza(), this.zzu.zzx()).zza("admob_app_id");
                }
                if (z) {
                    zzft zzftVarZzp = zzj().zzp();
                    String str5 = this.zza;
                    if (TextUtils.isEmpty(this.zzk)) {
                        str2 = this.zzl;
                    } else {
                        str2 = this.zzk;
                    }
                    zzftVarZzp.zza("App measurement enabled for app package, google app id", str5, str2);
                }
                this.zzh = null;
                listZzi = zze().zzi("analytics.safelisted_events");
                if (listZzi == null) {
                    if (listZzi.isEmpty()) {
                        zzj().zzv().zza("Safelisted event list is empty. Ignoring");
                    } else {
                        it = listZzi.iterator();
                        do {
                            if (it.hasNext()) {
                                this.zzh = listZzi;
                            }
                        } while (zzq().zzb("safelisted event", it.next()));
                    }
                } else {
                    this.zzh = listZzi;
                }
                if (packageManager != null) {
                    this.zzj = InstantApps.isInstantApp(zza()) ? 1 : 0;
                } else {
                    this.zzj = 0;
                }
            }
            strZza = new zzgz(zza(), this.zzu.zzx()).zza("google_app_id");
            if (TextUtils.isEmpty(strZza)) {
                str3 = strZza;
            }
            this.zzk = str3;
            if (!TextUtils.isEmpty(strZza)) {
                this.zzl = new zzgz(zza(), this.zzu.zzx()).zza("admob_app_id");
            }
            if (z) {
                zzft zzftVarZzp2 = zzj().zzp();
                String str6 = this.zza;
                if (TextUtils.isEmpty(this.zzk)) {
                    str2 = this.zzl;
                } else {
                    str2 = this.zzk;
                }
                zzftVarZzp2.zza("App measurement enabled for app package, google app id", str6, str2);
            }
        } catch (IllegalStateException e) {
            zzj().zzg().zza("Fetching Google App Id failed with exception. appId", zzfr.zza(packageName), e);
        }
        string = "Unknown";
        this.zza = packageName;
        this.zzd = installerPackageName;
        this.zzb = str4;
        this.zzc = i;
        this.zze = string;
        this.zzf = 0L;
        if (TextUtils.isEmpty(this.zzu.zzu())) {
            objArr = false;
        } else {
            objArr = false;
        }
        iZzc = this.zzu.zzc();
        switch (iZzc) {
            case 0:
                zzj().zzp().zza("App measurement collection enabled");
                break;
            case 1:
                zzj().zzn().zza("App measurement deactivated via the manifest");
                break;
            case 2:
                zzj().zzp().zza("App measurement deactivated via the init parameters");
                break;
            case 3:
                zzj().zzn().zza("App measurement disabled by setAnalyticsCollectionEnabled(false)");
                break;
            case 4:
                zzj().zzn().zza("App measurement disabled via the manifest");
                break;
            case 5:
                zzj().zzp().zza("App measurement disabled via the init parameters");
                break;
            case 6:
                zzj().zzv().zza("App measurement deactivated via resources. This method is being deprecated. Please refer to https://firebase.google.com/support/guides/disable-analytics");
                break;
            case 7:
                zzj().zzn().zza("App measurement disabled via the global data collection setting");
                break;
            case 8:
                zzj().zzn().zza("App measurement disabled due to denied storage consent");
                break;
            default:
                zzj().zzn().zza("App measurement disabled");
                zzj().zzm().zza("Invalid scion state in identity");
                break;
        }
        if (iZzc == 0) {
        }
        this.zzk = "";
        this.zzl = "";
        if (objArr != false) {
            this.zzl = this.zzu.zzu();
        }
        this.zzh = null;
        listZzi = zze().zzi("analytics.safelisted_events");
        if (listZzi == null) {
            if (listZzi.isEmpty()) {
                zzj().zzv().zza("Safelisted event list is empty. Ignoring");
            } else {
                it = listZzi.iterator();
                do {
                    if (it.hasNext()) {
                        this.zzh = listZzi;
                    }
                } while (zzq().zzb("safelisted event", it.next()));
            }
        } else {
            this.zzh = listZzi;
        }
        if (packageManager != null) {
            this.zzj = InstantApps.isInstantApp(zza()) ? 1 : 0;
        } else {
            this.zzj = 0;
        }
    }

    final void zzag() {
        String str;
        zzt();
        if (!zzk().zzm().zza(zzih.zza.ANALYTICS_STORAGE)) {
            zzj().zzc().zza("Analytics Storage consent is not granted");
            str = null;
        } else {
            byte[] bArr = new byte[16];
            zzq().zzv().nextBytes(bArr);
            str = String.format(Locale.US, "%032x", new BigInteger(1, bArr));
        }
        zzj().zzc().zza(String.format("Resetting session stitching token to %s", str == null ? "null" : "not null"));
        this.zzm = str;
        this.zzn = zzb().currentTimeMillis();
    }

    final boolean zzb(String str) {
        String str2 = this.zzo;
        boolean z = (str2 == null || str2.equals(str)) ? false : true;
        this.zzo = str;
        return z;
    }
}
