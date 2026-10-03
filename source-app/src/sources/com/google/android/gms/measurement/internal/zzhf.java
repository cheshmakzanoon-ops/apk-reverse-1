package com.google.android.gms.measurement.internal;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Pair;
import androidx.core.content.ContextCompat;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.common.util.DefaultClock;
import com.google.android.gms.common.wrappers.Wrappers;
import com.google.android.gms.internal.measurement.zznp;
import com.google.android.gms.internal.measurement.zznv;
import com.google.android.gms.internal.measurement.zzoi;
import com.google.android.gms.internal.measurement.zzpg;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.messaging.Constants;
import java.net.URL;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import org.checkerframework.dataflow.qual.Pure;
import org.checkerframework.dataflow.qual.SideEffectFree;
import org.json.JSONException;
import org.json.JSONObject;

public class zzhf implements zzif {
    private static volatile zzhf zzb;
    final long zza;
    private Boolean zzaa;
    private long zzab;
    private volatile Boolean zzac;
    private Boolean zzad;
    private Boolean zzae;
    private volatile boolean zzaf;
    private int zzag;
    private int zzah;
    private final Context zzc;
    private final String zzd;
    private final String zze;
    private final String zzf;
    private final boolean zzg;
    private final zzae zzh;
    private final zzaf zzi;
    private final zzgd zzj;
    private final zzfr zzk;
    private final zzgy zzl;
    private final zzlx zzm;
    private final zznd zzn;
    private final zzfq zzo;
    private final Clock zzp;
    private final zzkh zzq;
    private final zziq zzr;
    private final zzb zzs;
    private final zzkc zzt;
    private final String zzu;
    private zzfo zzv;
    private zzkp zzw;
    private zzba zzx;
    private zzfl zzy;
    private boolean zzz = false;
    private AtomicInteger zzai = new AtomicInteger(0);

    public final int zzc() {
        zzl().zzt();
        if (this.zzi.zzv()) {
            return 1;
        }
        Boolean bool = this.zzae;
        if (bool != null && bool.booleanValue()) {
            return 2;
        }
        if (!zzad()) {
            return 8;
        }
        Boolean boolZzu = zzn().zzu();
        if (boolZzu != null) {
            return boolZzu.booleanValue() ? 0 : 3;
        }
        Boolean boolZzg = this.zzi.zzg("firebase_analytics_collection_enabled");
        if (boolZzg != null) {
            return boolZzg.booleanValue() ? 0 : 4;
        }
        Boolean bool2 = this.zzad;
        if (bool2 != null) {
            return bool2.booleanValue() ? 0 : 5;
        }
        return (this.zzac == null || this.zzac.booleanValue()) ? 0 : 7;
    }

    @Override
    @Pure
    public final Context zza() {
        return this.zzc;
    }

    @Override
    @Pure
    public final Clock zzb() {
        return this.zzp;
    }

    @Pure
    public final zzb zze() {
        zzb zzbVar = this.zzs;
        if (zzbVar != null) {
            return zzbVar;
        }
        throw new IllegalStateException("Component not created");
    }

    @Override
    @Pure
    public final zzae zzd() {
        return this.zzh;
    }

    @Pure
    public final zzaf zzf() {
        return this.zzi;
    }

    @Pure
    public final zzba zzg() {
        zza((zzic) this.zzx);
        return this.zzx;
    }

    @Pure
    public final zzfl zzh() {
        zza((zze) this.zzy);
        return this.zzy;
    }

    @Pure
    public final zzfo zzi() {
        zza((zze) this.zzv);
        return this.zzv;
    }

    @Pure
    public final zzfq zzk() {
        return this.zzo;
    }

    @Override
    @Pure
    public final zzfr zzj() {
        zza((zzic) this.zzk);
        return this.zzk;
    }

    public final zzfr zzm() {
        zzfr zzfrVar = this.zzk;
        if (zzfrVar == null || !zzfrVar.zzae()) {
            return null;
        }
        return this.zzk;
    }

    @Pure
    public final zzgd zzn() {
        zza((zzid) this.zzj);
        return this.zzj;
    }

    @Override
    @Pure
    public final zzgy zzl() {
        zza((zzic) this.zzl);
        return this.zzl;
    }

    @SideEffectFree
    final zzgy zzo() {
        return this.zzl;
    }

    public static zzhf zza(Context context, com.google.android.gms.internal.measurement.zzdd zzddVar, Long l) {
        if (zzddVar != null && (zzddVar.zze == null || zzddVar.zzf == null)) {
            zzddVar = new com.google.android.gms.internal.measurement.zzdd(zzddVar.zza, zzddVar.zzb, zzddVar.zzc, zzddVar.zzd, null, null, zzddVar.zzg, null);
        }
        Preconditions.checkNotNull(context);
        Preconditions.checkNotNull(context.getApplicationContext());
        if (zzb == null) {
            synchronized (zzhf.class) {
                if (zzb == null) {
                    zzb = new zzhf(new zzio(context, zzddVar, l));
                }
            }
        } else if (zzddVar != null && zzddVar.zzg != null && zzddVar.zzg.containsKey("dataCollectionDefaultEnabled")) {
            Preconditions.checkNotNull(zzb);
            zzb.zza(zzddVar.zzg.getBoolean("dataCollectionDefaultEnabled"));
        }
        Preconditions.checkNotNull(zzb);
        return zzb;
    }

    @Pure
    public final zziq zzp() {
        zza((zze) this.zzr);
        return this.zzr;
    }

    @Pure
    private final zzkc zzai() {
        zza((zzic) this.zzt);
        return this.zzt;
    }

    @Pure
    public final zzkh zzq() {
        zza((zze) this.zzq);
        return this.zzq;
    }

    @Pure
    public final zzkp zzr() {
        zza((zze) this.zzw);
        return this.zzw;
    }

    @Pure
    public final zzlx zzs() {
        zza((zze) this.zzm);
        return this.zzm;
    }

    @Pure
    public final zznd zzt() {
        zza((zzid) this.zzn);
        return this.zzn;
    }

    @Pure
    public final String zzu() {
        return this.zzd;
    }

    @Pure
    public final String zzv() {
        return this.zze;
    }

    @Pure
    public final String zzw() {
        return this.zzf;
    }

    @Pure
    public final String zzx() {
        return this.zzu;
    }

    static void zza(zzhf zzhfVar, zzio zzioVar) {
        zzhfVar.zzl().zzt();
        zzba zzbaVar = new zzba(zzhfVar);
        zzbaVar.zzac();
        zzhfVar.zzx = zzbaVar;
        zzfl zzflVar = new zzfl(zzhfVar, zzioVar.zzf);
        zzflVar.zzv();
        zzhfVar.zzy = zzflVar;
        zzfo zzfoVar = new zzfo(zzhfVar);
        zzfoVar.zzv();
        zzhfVar.zzv = zzfoVar;
        zzkp zzkpVar = new zzkp(zzhfVar);
        zzkpVar.zzv();
        zzhfVar.zzw = zzkpVar;
        zzhfVar.zzn.zzad();
        zzhfVar.zzj.zzad();
        zzhfVar.zzy.zzw();
        zzhfVar.zzj().zzn().zza("App measurement initialized, version", 82001L);
        zzhfVar.zzj().zzn().zza("To enable debug logging run: adb shell setprop log.tag.FA VERBOSE");
        String strZzad = zzflVar.zzad();
        if (TextUtils.isEmpty(zzhfVar.zzd)) {
            if (zzhfVar.zzt().zzf(strZzad)) {
                zzhfVar.zzj().zzn().zza("Faster debug mode event logging enabled. To disable, run:\n  adb shell setprop debug.firebase.analytics.app .none.");
            } else {
                zzhfVar.zzj().zzn().zza("To enable faster debug mode event logging run:\n  adb shell setprop debug.firebase.analytics.app " + strZzad);
            }
        }
        zzhfVar.zzj().zzc().zza("Debug-level message logging enabled");
        if (zzhfVar.zzag != zzhfVar.zzai.get()) {
            zzhfVar.zzj().zzg().zza("Not all components initialized", Integer.valueOf(zzhfVar.zzag), Integer.valueOf(zzhfVar.zzai.get()));
        }
        zzhfVar.zzz = true;
    }

    private zzhf(zzio zzioVar) {
        long jCurrentTimeMillis;
        boolean z = false;
        Preconditions.checkNotNull(zzioVar);
        zzae zzaeVar = new zzae(zzioVar.zza);
        this.zzh = zzaeVar;
        zzff.zza = zzaeVar;
        Context context = zzioVar.zza;
        this.zzc = context;
        this.zzd = zzioVar.zzb;
        this.zze = zzioVar.zzc;
        this.zzf = zzioVar.zzd;
        this.zzg = zzioVar.zzh;
        this.zzac = zzioVar.zze;
        this.zzu = zzioVar.zzj;
        this.zzaf = true;
        com.google.android.gms.internal.measurement.zzdd zzddVar = zzioVar.zzg;
        if (zzddVar != null && zzddVar.zzg != null) {
            Object obj = zzddVar.zzg.get("measurementEnabled");
            if (obj instanceof Boolean) {
                this.zzad = (Boolean) obj;
            }
            Object obj2 = zzddVar.zzg.get("measurementDeactivated");
            if (obj2 instanceof Boolean) {
                this.zzae = (Boolean) obj2;
            }
        }
        com.google.android.gms.internal.measurement.zzgn.zzb(context);
        Clock defaultClock = DefaultClock.getInstance();
        this.zzp = defaultClock;
        if (zzioVar.zzi != null) {
            jCurrentTimeMillis = zzioVar.zzi.longValue();
        } else {
            jCurrentTimeMillis = defaultClock.currentTimeMillis();
        }
        this.zza = jCurrentTimeMillis;
        this.zzi = new zzaf(this);
        zzgd zzgdVar = new zzgd(this);
        zzgdVar.zzac();
        this.zzj = zzgdVar;
        zzfr zzfrVar = new zzfr(this);
        zzfrVar.zzac();
        this.zzk = zzfrVar;
        zznd zzndVar = new zznd(this);
        zzndVar.zzac();
        this.zzn = zzndVar;
        this.zzo = new zzfq(new zzin(zzioVar, this));
        this.zzs = new zzb(this);
        zzkh zzkhVar = new zzkh(this);
        zzkhVar.zzv();
        this.zzq = zzkhVar;
        zziq zziqVar = new zziq(this);
        zziqVar.zzv();
        this.zzr = zziqVar;
        zzlx zzlxVar = new zzlx(this);
        zzlxVar.zzv();
        this.zzm = zzlxVar;
        zzkc zzkcVar = new zzkc(this);
        zzkcVar.zzac();
        this.zzt = zzkcVar;
        zzgy zzgyVar = new zzgy(this);
        zzgyVar.zzac();
        this.zzl = zzgyVar;
        if (zzioVar.zzg != null && zzioVar.zzg.zzb != 0) {
            z = true;
        }
        if (context.getApplicationContext() instanceof Application) {
            zziq zziqVarZzp = zzp();
            if (zziqVarZzp.zza().getApplicationContext() instanceof Application) {
                Application application = (Application) zziqVarZzp.zza().getApplicationContext();
                if (zziqVarZzp.zza == null) {
                    zziqVarZzp.zza = new zzjx(zziqVarZzp);
                }
                if (!z) {
                    application.unregisterActivityLifecycleCallbacks(zziqVarZzp.zza);
                    application.registerActivityLifecycleCallbacks(zziqVarZzp.zza);
                    zziqVarZzp.zzj().zzp().zza("Registered activity lifecycle callback");
                }
            }
        } else {
            zzj().zzu().zza("Application context is not an Application");
        }
        zzgyVar.zzb(new zzhg(this, zzioVar));
    }

    private static void zza(zzid zzidVar) {
        if (zzidVar == null) {
            throw new IllegalStateException("Component not created");
        }
    }

    private static void zza(zze zzeVar) {
        if (zzeVar == null) {
            throw new IllegalStateException("Component not created");
        }
        if (zzeVar.zzy()) {
            return;
        }
        throw new IllegalStateException("Component not initialized: " + String.valueOf(zzeVar.getClass()));
    }

    private static void zza(zzic zzicVar) {
        if (zzicVar == null) {
            throw new IllegalStateException("Component not created");
        }
        if (zzicVar.zzae()) {
            return;
        }
        throw new IllegalStateException("Component not initialized: " + String.valueOf(zzicVar.getClass()));
    }

    final void zzy() {
        throw new IllegalStateException("Unexpected call on client side");
    }

    final void zzz() {
        this.zzai.incrementAndGet();
    }

    final void zza(String str, int i, Throwable th, byte[] bArr, Map map) {
        if ((i != 200 && i != 204 && i != 304) || th != null) {
            zzj().zzu().zza("Network Request for Deferred Deep Link failed. response, exception", Integer.valueOf(i), th);
            return;
        }
        zzn().zzo.zza(true);
        if (bArr == null || bArr.length == 0) {
            zzj().zzc().zza("Deferred Deep Link response empty.");
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject(new String(bArr));
            String strOptString = jSONObject.optString("deeplink", "");
            String strOptString2 = jSONObject.optString("gclid", "");
            String strOptString3 = jSONObject.optString("gbraid", "");
            double dOptDouble = jSONObject.optDouble("timestamp", 0.0d);
            if (TextUtils.isEmpty(strOptString)) {
                zzj().zzc().zza("Deferred Deep Link is empty.");
                return;
            }
            Bundle bundle = new Bundle();
            if (zzoi.zza() && this.zzi.zza(zzbi.zzcs)) {
                if (!zzt().zzi(strOptString)) {
                    zzj().zzu().zza("Deferred Deep Link validation failed. gclid, gbraid, deep link", strOptString2, strOptString3, strOptString);
                    return;
                }
                bundle.putString("gbraid", strOptString3);
            } else if (!zzt().zzi(strOptString)) {
                zzj().zzu().zza("Deferred Deep Link validation failed. gclid, deep link", strOptString2, strOptString);
                return;
            }
            bundle.putString("gclid", strOptString2);
            bundle.putString("_cis", "ddp");
            this.zzr.zzc("auto", Constants.ScionAnalytics.EVENT_FIREBASE_CAMPAIGN, bundle);
            zznd zzndVarZzt = zzt();
            if (TextUtils.isEmpty(strOptString) || !zzndVarZzt.zza(strOptString, dOptDouble)) {
                return;
            }
            zzndVarZzt.zza().sendBroadcast(new Intent("android.google.analytics.action.DEEPLINK_ACTION"));
        } catch (JSONException e) {
            zzj().zzg().zza("Failed to parse the Deferred Deep Link response. exception", e);
        }
    }

    final void zzaa() {
        this.zzag++;
    }

    final void zza(boolean z) {
        this.zzac = Boolean.valueOf(z);
    }

    public final void zzb(boolean z) {
        zzl().zzt();
        this.zzaf = z;
    }

    protected final void zza(com.google.android.gms.internal.measurement.zzdd zzddVar) {
        zzih zzihVar;
        Boolean boolZza;
        zzl().zzt();
        if (zzpg.zza() && this.zzi.zza(zzbi.zzcg) && zzt().zzw()) {
            zznd zzndVarZzt = zzt();
            zzndVarZzt.zzt();
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction("com.google.android.gms.measurement.TRIGGERS_AVAILABLE");
            ContextCompat.registerReceiver(zzndVarZzt.zza(), new zzp(zzndVarZzt.zzu), intentFilter, 2);
            zzndVarZzt.zzj().zzc().zza("Registered app receiver");
        }
        zzih zzihVarZzm = zzn().zzm();
        int iZza = zzihVarZzm.zza();
        Boolean boolZzg = this.zzi.zzg("google_analytics_default_allow_ad_storage");
        Boolean boolZzg2 = this.zzi.zzg("google_analytics_default_allow_analytics_storage");
        if ((boolZzg != null || boolZzg2 != null) && zzn().zza(-10)) {
            zzihVar = new zzih(boolZzg, boolZzg2, -10);
        } else {
            if (!TextUtils.isEmpty(zzh().zzae()) && (iZza == 0 || iZza == 30 || iZza == 10 || iZza == 30 || iZza == 30 || iZza == 40)) {
                zzp().zza(new zzih(null, null, -10), this.zza);
            } else if (TextUtils.isEmpty(zzh().zzae()) && zzddVar != null && zzddVar.zzg != null && zzn().zza(30)) {
                zzihVar = zzih.zza(zzddVar.zzg, 30);
                if (!zzihVar.zzi()) {
                }
            }
            zzihVar = null;
        }
        if (zzihVar != null) {
            zzp().zza(zzihVar, this.zza);
            zzihVarZzm = zzihVar;
        }
        zzp().zza(zzihVarZzm);
        if (zznp.zza() && this.zzi.zza(zzbi.zzcl)) {
            int iZza2 = zzn().zzh().zza();
            Boolean boolZzg3 = this.zzi.zzg("google_analytics_default_allow_ad_user_data");
            if (boolZzg3 != null && zzih.zza(-10, iZza2)) {
                zzp().zza(new zzay(boolZzg3, -10));
            } else if (!TextUtils.isEmpty(zzh().zzae()) && (iZza2 == 0 || iZza2 == 30)) {
                zzp().zza(new zzay((Boolean) null, -10));
            } else {
                if (TextUtils.isEmpty(zzh().zzae()) && zzddVar != null && zzddVar.zzg != null && zzih.zza(30, iZza2)) {
                    zzay zzayVarZza = zzay.zza(zzddVar.zzg, 30);
                    if (zzayVarZza.zzg()) {
                        zzp().zza(zzayVarZza);
                    }
                }
                if (TextUtils.isEmpty(zzh().zzae()) && zzddVar != null && zzddVar.zzg != null && zzn().zzh.zza() == null && (boolZza = zzay.zza(zzddVar.zzg)) != null) {
                    zzp().zza(zzddVar.zze, FirebaseAnalytics.UserProperty.ALLOW_AD_PERSONALIZATION_SIGNALS, (Object) boolZza.toString(), false);
                }
            }
        }
        if (zzn().zzc.zza() == 0) {
            zzj().zzp().zza("Persisting first open", Long.valueOf(this.zza));
            zzn().zzc.zza(this.zza);
        }
        zzp().zzb.zzb();
        if (!zzaf()) {
            if (zzac()) {
                if (!zzt().zze("android.permission.INTERNET")) {
                    zzj().zzg().zza("App is missing INTERNET permission");
                }
                if (!zzt().zze("android.permission.ACCESS_NETWORK_STATE")) {
                    zzj().zzg().zza("App is missing ACCESS_NETWORK_STATE permission");
                }
                if (!Wrappers.packageManager(this.zzc).isCallerInstantApp() && !this.zzi.zzw()) {
                    if (!zznd.zza(this.zzc)) {
                        zzj().zzg().zza("AppMeasurementReceiver not registered/enabled");
                    }
                    if (!zznd.zza(this.zzc, false)) {
                        zzj().zzg().zza("AppMeasurementService not registered/enabled");
                    }
                }
                zzj().zzg().zza("Uploading is not possible. App measurement disabled");
            }
        } else {
            if (!TextUtils.isEmpty(zzh().zzae()) || !TextUtils.isEmpty(zzh().zzac())) {
                zzt();
                if (zznd.zza(zzh().zzae(), zzn().zzx(), zzh().zzac(), zzn().zzw())) {
                    zzj().zzn().zza("Rechecking which service to use due to a GMP App Id change");
                    zzn().zzy();
                    zzi().zzaa();
                    this.zzw.zzae();
                    this.zzw.zzad();
                    zzn().zzc.zza(this.zza);
                    zzn().zze.zza(null);
                }
                zzn().zzc(zzh().zzae());
                zzn().zzb(zzh().zzac());
            }
            if (!zzn().zzm().zza(zzih.zza.ANALYTICS_STORAGE)) {
                zzn().zze.zza(null);
            }
            zzp().zza(zzn().zze.zza());
            if (zznv.zza() && this.zzi.zza(zzbi.zzbm) && !zzt().zzx() && !TextUtils.isEmpty(zzn().zzq.zza())) {
                zzj().zzu().zza("Remote config removed with active feature rollouts");
                zzn().zzq.zza(null);
            }
            if (!TextUtils.isEmpty(zzh().zzae()) || !TextUtils.isEmpty(zzh().zzac())) {
                boolean zZzac = zzac();
                if (!zzn().zzaa() && !this.zzi.zzv()) {
                    zzn().zzb(!zZzac);
                }
                if (zZzac) {
                    zzp().zzaj();
                }
                zzs().zza.zza();
                zzr().zza(new AtomicReference<>());
                zzr().zza(zzn().zzt.zza());
            }
        }
        if (zzpg.zza() && this.zzi.zza(zzbi.zzcg) && zzt().zzw()) {
            final zziq zziqVarZzp = zzp();
            zziqVarZzp.getClass();
            new Thread(new Runnable() {
                @Override
                public final void run() {
                    zziqVarZzp.zzal();
                }
            }).start();
        }
        zzn().zzj.zza(true);
    }

    public final boolean zzab() {
        return this.zzac != null && this.zzac.booleanValue();
    }

    public final boolean zzac() {
        return zzc() == 0;
    }

    public final boolean zzad() {
        zzl().zzt();
        return this.zzaf;
    }

    @Pure
    public final boolean zzae() {
        return TextUtils.isEmpty(this.zzd);
    }

    protected final boolean zzaf() {
        if (!this.zzz) {
            throw new IllegalStateException("AppMeasurement is not initialized");
        }
        zzl().zzt();
        Boolean bool = this.zzaa;
        if (bool == null || this.zzab == 0 || (bool != null && !bool.booleanValue() && Math.abs(this.zzp.elapsedRealtime() - this.zzab) > 1000)) {
            this.zzab = this.zzp.elapsedRealtime();
            boolean z = true;
            Boolean boolValueOf = Boolean.valueOf(zzt().zze("android.permission.INTERNET") && zzt().zze("android.permission.ACCESS_NETWORK_STATE") && (Wrappers.packageManager(this.zzc).isCallerInstantApp() || this.zzi.zzw() || (zznd.zza(this.zzc) && zznd.zza(this.zzc, false))));
            this.zzaa = boolValueOf;
            if (boolValueOf.booleanValue()) {
                if (!zzt().zza(zzh().zzae(), zzh().zzac()) && TextUtils.isEmpty(zzh().zzac())) {
                    z = false;
                }
                this.zzaa = Boolean.valueOf(z);
            }
        }
        return this.zzaa.booleanValue();
    }

    @Pure
    public final boolean zzag() {
        return this.zzg;
    }

    public final boolean zzah() {
        zzl().zzt();
        zza((zzic) zzai());
        String strZzad = zzh().zzad();
        Pair<String, Boolean> pairZza = zzn().zza(strZzad);
        if (!this.zzi.zzp() || ((Boolean) pairZza.second).booleanValue() || TextUtils.isEmpty((CharSequence) pairZza.first)) {
            zzj().zzc().zza("ADID unavailable to retrieve Deferred Deep Link. Skipping");
            return false;
        }
        if (!zzai().zzc()) {
            zzj().zzu().zza("Network is not available for Deferred Deep Link request. Skipping");
            return false;
        }
        StringBuilder sb = new StringBuilder();
        if (zznp.zza() && this.zzi.zza(zzbi.zzcn)) {
            zziq zziqVarZzp = zzp();
            zziqVarZzp.zzt();
            zzam zzamVarZzaa = zziqVarZzp.zzo().zzaa();
            Bundle bundle = zzamVarZzaa != null ? zzamVarZzaa.zza : null;
            if (bundle == null) {
                int i = this.zzah;
                this.zzah = i + 1;
                boolean z = i < 10;
                zzj().zzc().zza("Failed to retrieve DMA consent from the service, " + (z ? "Retrying." : "Skipping.") + " retryCount", Integer.valueOf(this.zzah));
                return z;
            }
            zzih zzihVarZza = zzih.zza(bundle, 100);
            sb.append("&gcs=");
            sb.append(zzihVarZza.zzf());
            zzay zzayVarZza = zzay.zza(bundle, 100);
            sb.append("&dma=");
            sb.append(zzayVarZza.zzd() == Boolean.FALSE ? 0 : 1);
            if (!TextUtils.isEmpty(zzayVarZza.zze())) {
                sb.append("&dma_cps=");
                sb.append(zzayVarZza.zze());
            }
            int i2 = zzay.zza(bundle) == Boolean.TRUE ? 0 : 1;
            sb.append("&npa=");
            sb.append(i2);
            zzj().zzp().zza("Consent query parameters to Bow", sb);
        }
        zznd zzndVarZzt = zzt();
        zzh();
        URL urlZza = zzndVarZzt.zza(82001L, strZzad, (String) pairZza.first, zzn().zzp.zza() - 1, sb.toString());
        if (urlZza != null) {
            zzkc zzkcVarZzai = zzai();
            zzkb zzkbVar = new zzkb() {
                @Override
                public final void zza(String str, int i3, Throwable th, byte[] bArr, Map map) {
                    this.zza.zza(str, i3, th, bArr, map);
                }
            };
            zzkcVarZzai.zzt();
            zzkcVarZzai.zzab();
            Preconditions.checkNotNull(urlZza);
            Preconditions.checkNotNull(zzkbVar);
            zzkcVarZzai.zzl().zza(new zzke(zzkcVarZzai, strZzad, urlZza, null, null, zzkbVar));
        }
        return false;
    }
}
