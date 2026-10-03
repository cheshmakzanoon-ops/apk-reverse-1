package com.google.android.gms.measurement.internal;

import android.app.Application;
import android.content.Context;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.SparseArray;
import androidx.collection.ArrayMap;
import androidx.privacysandbox.ads.adservices.java.measurement.MeasurementManagerFutures;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.common.util.CollectionUtils;
import com.google.android.gms.common.util.Strings;
import com.google.android.gms.internal.measurement.zznp;
import com.google.android.gms.internal.measurement.zznv;
import com.google.android.gms.internal.measurement.zzoh;
import com.google.android.gms.internal.measurement.zzoi;
import com.google.android.gms.internal.measurement.zzpg;
import com.google.android.gms.internal.measurement.zzps;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.google.common.util.concurrent.Futures;
import com.google.common.util.concurrent.ListenableFuture;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.messaging.Constants;
import com.unity3d.player.l$a$$ExternalSyntheticApiModelOutline0;
import j$.util.Comparator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Function;
import org.checkerframework.dataflow.qual.Pure;

public final class zziq extends zze {
    protected zzjx zza;
    final zzu zzb;
    private zzim zzc;
    private final Set<zzil> zzd;
    private boolean zze;
    private final AtomicReference<String> zzf;
    private final Object zzg;
    private boolean zzh;
    private PriorityQueue<zzmh> zzi;
    private zzih zzj;
    private final AtomicLong zzk;
    private long zzl;
    private boolean zzm;
    private zzaw zzn;
    private final zznf zzo;

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

    public final Boolean zzaa() {
        AtomicReference atomicReference = new AtomicReference();
        return (Boolean) zzl().zza(atomicReference, 15000L, "boolean test flag value", new zzja(this, atomicReference));
    }

    public final Double zzab() {
        AtomicReference atomicReference = new AtomicReference();
        return (Double) zzl().zza(atomicReference, 15000L, "double test flag value", new zzju(this, atomicReference));
    }

    public final Integer zzac() {
        AtomicReference atomicReference = new AtomicReference();
        return (Integer) zzl().zza(atomicReference, 15000L, "int test flag value", new zzjr(this, atomicReference));
    }

    public final Long zzad() {
        AtomicReference atomicReference = new AtomicReference();
        return (Long) zzl().zza(atomicReference, 15000L, "long test flag value", new zzjs(this, atomicReference));
    }

    public final String zzae() {
        return this.zzf.get();
    }

    public final String zzaf() {
        zzki zzkiVarZzaa = this.zzu.zzq().zzaa();
        if (zzkiVarZzaa != null) {
            return zzkiVarZzaa.zzb;
        }
        return null;
    }

    public final String zzag() {
        zzki zzkiVarZzaa = this.zzu.zzq().zzaa();
        if (zzkiVarZzaa != null) {
            return zzkiVarZzaa.zza;
        }
        return null;
    }

    public final String zzah() {
        if (this.zzu.zzu() != null) {
            return this.zzu.zzu();
        }
        try {
            return new zzgz(zza(), this.zzu.zzx()).zza("google_app_id");
        } catch (IllegalStateException e) {
            this.zzu.zzj().zzg().zza("getGoogleAppId failed with exception", e);
            return null;
        }
    }

    public final String zzai() {
        AtomicReference atomicReference = new AtomicReference();
        return (String) zzl().zza(atomicReference, 15000L, "String test flag value", new zzjj(this, atomicReference));
    }

    public final ArrayList<Bundle> zza(String str, String str2) {
        if (zzl().zzg()) {
            zzj().zzg().zza("Cannot get conditional user properties from analytics worker thread");
            return new ArrayList<>(0);
        }
        if (zzae.zza()) {
            zzj().zzg().zza("Cannot get conditional user properties from main thread");
            return new ArrayList<>(0);
        }
        AtomicReference atomicReference = new AtomicReference();
        this.zzu.zzl().zza(atomicReference, 5000L, "get conditional user properties", new zzjo(this, atomicReference, null, str, str2));
        List list = (List) atomicReference.get();
        if (list == null) {
            zzj().zzg().zza("Timed out waiting for get conditional user properties", null);
            return new ArrayList<>();
        }
        return zznd.zzb((List<zzad>) list);
    }

    public final List<zznc> zza(boolean z) {
        zzu();
        zzj().zzp().zza("Getting user properties (FE)");
        if (zzl().zzg()) {
            zzj().zzg().zza("Cannot get all user properties from analytics worker thread");
            return Collections.emptyList();
        }
        if (zzae.zza()) {
            zzj().zzg().zza("Cannot get all user properties from main thread");
            return Collections.emptyList();
        }
        AtomicReference atomicReference = new AtomicReference();
        this.zzu.zzl().zza(atomicReference, 5000L, "get user properties", new zzji(this, atomicReference, z));
        List<zznc> list = (List) atomicReference.get();
        if (list != null) {
            return list;
        }
        zzj().zzg().zza("Timed out waiting for get user properties, includeInternal", Boolean.valueOf(z));
        return Collections.emptyList();
    }

    public final Map<String, Object> zza(String str, String str2, boolean z) {
        if (zzl().zzg()) {
            zzj().zzg().zza("Cannot get user properties from analytics worker thread");
            return Collections.emptyMap();
        }
        if (zzae.zza()) {
            zzj().zzg().zza("Cannot get user properties from main thread");
            return Collections.emptyMap();
        }
        AtomicReference atomicReference = new AtomicReference();
        this.zzu.zzl().zza(atomicReference, 5000L, "get user properties", new zzjn(this, atomicReference, null, str, str2, z));
        List<zznc> list = (List) atomicReference.get();
        if (list == null) {
            zzj().zzg().zza("Timed out waiting for handle get user properties, includeInternal", Boolean.valueOf(z));
            return Collections.emptyMap();
        }
        ArrayMap arrayMap = new ArrayMap(list.size());
        for (zznc zzncVar : list) {
            Object objZza = zzncVar.zza();
            if (objZza != null) {
                arrayMap.put(zzncVar.zza, objZza);
            }
        }
        return arrayMap;
    }

    private final PriorityQueue<zzmh> zzao() {
        if (this.zzi == null) {
            l$a$$ExternalSyntheticApiModelOutline0.m$1();
            this.zzi = l$a$$ExternalSyntheticApiModelOutline0.m625m(Comparator.-CC.comparing(new Function() {
                @Override
                public Function andThen(Function function) {
                    return j$.util.function.Function.-CC.$default$andThen(this, function);
                }

                @Override
                public final Object apply(Object obj) {
                    return Long.valueOf(((zzmh) obj).zzb);
                }

                @Override
                public Function compose(Function function) {
                    return j$.util.function.Function.-CC.$default$compose(this, function);
                }
            }, new java.util.Comparator() {
                @Override
                public final int compare(Object obj, Object obj2) {
                    return (((Long) obj).longValue() > ((Long) obj2).longValue() ? 1 : (((Long) obj).longValue() == ((Long) obj2).longValue() ? 0 : -1));
                }
            }));
        }
        return this.zzi;
    }

    static void zza(zziq zziqVar, zzih zzihVar, zzih zzihVar2) {
        boolean zZza = zzihVar.zza(zzihVar2, zzih.zza.ANALYTICS_STORAGE, zzih.zza.AD_STORAGE);
        boolean zZzb = zzihVar.zzb(zzihVar2, zzih.zza.ANALYTICS_STORAGE, zzih.zza.AD_STORAGE);
        if (zZza || zZzb) {
            zziqVar.zzg().zzag();
        }
    }

    static void zza(zziq zziqVar, zzih zzihVar, long j, boolean z, boolean z2) {
        zziqVar.zzt();
        zziqVar.zzu();
        zzih zzihVarZzm = zziqVar.zzk().zzm();
        if (j <= zziqVar.zzl && zzih.zza(zzihVarZzm.zza(), zzihVar.zza())) {
            zziqVar.zzj().zzn().zza("Dropped out-of-date consent setting, proposed settings", zzihVar);
            return;
        }
        if (zziqVar.zzk().zza(zzihVar)) {
            zziqVar.zzl = j;
            zziqVar.zzo().zza(z);
            if (z2) {
                zziqVar.zzo().zza(new AtomicReference<>());
                return;
            }
            return;
        }
        zziqVar.zzj().zzn().zza("Lower precedence consent source ignored, proposed source", Integer.valueOf(zzihVar.zza()));
    }

    protected zziq(zzhf zzhfVar) {
        super(zzhfVar);
        this.zzd = new CopyOnWriteArraySet();
        this.zzg = new Object();
        this.zzh = false;
        this.zzm = true;
        this.zzo = new zzjp(this);
        this.zzf = new AtomicReference<>();
        this.zzj = zzih.zza;
        this.zzl = -1L;
        this.zzk = new AtomicLong(0L);
        this.zzb = new zzu(zzhfVar);
    }

    public final void zzaj() {
        Boolean boolZzg;
        zzt();
        zzu();
        if (this.zzu.zzaf()) {
            if (zze().zza(zzbi.zzbh) && (boolZzg = zze().zzg("google_analytics_deferred_deep_link_enabled")) != null && boolZzg.booleanValue()) {
                zzj().zzc().zza("Deferred Deep Link feature enabled.");
                zzl().zzb(new Runnable() {
                    @Override
                    public final void run() {
                        this.zza.zzam();
                    }
                });
            }
            zzo().zzac();
            this.zzm = false;
            String strZzv = zzk().zzv();
            if (TextUtils.isEmpty(strZzv)) {
                return;
            }
            zzf().zzab();
            if (strZzv.equals(Build.VERSION.RELEASE)) {
                return;
            }
            Bundle bundle = new Bundle();
            bundle.putString("_po", strZzv);
            zzc("auto", "_ou", bundle);
        }
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

    public final void zza(String str, String str2, Bundle bundle) {
        long jCurrentTimeMillis = zzb().currentTimeMillis();
        Preconditions.checkNotEmpty(str);
        Bundle bundle2 = new Bundle();
        bundle2.putString(AppMeasurementSdk.ConditionalUserProperty.NAME, str);
        bundle2.putLong(AppMeasurementSdk.ConditionalUserProperty.CREATION_TIMESTAMP, jCurrentTimeMillis);
        if (str2 != null) {
            bundle2.putString(AppMeasurementSdk.ConditionalUserProperty.EXPIRED_EVENT_NAME, str2);
            bundle2.putBundle(AppMeasurementSdk.ConditionalUserProperty.EXPIRED_EVENT_PARAMS, bundle);
        }
        zzl().zzb(new zzjl(this, bundle2));
    }

    public final void zzak() {
        if (!(zza().getApplicationContext() instanceof Application) || this.zza == null) {
            return;
        }
        ((Application) zza().getApplicationContext()).unregisterActivityLifecycleCallbacks(this.zza);
    }

    final void zzal() {
        if (zzpg.zza() && zze().zza(zzbi.zzcg)) {
            if (zzl().zzg()) {
                zzj().zzg().zza("Cannot get trigger URIs from analytics worker thread");
                return;
            }
            if (zzae.zza()) {
                zzj().zzg().zza("Cannot get trigger URIs from main thread");
                return;
            }
            zzu();
            zzj().zzp().zza("Getting trigger URIs (FE)");
            final AtomicReference atomicReference = new AtomicReference();
            zzl().zza(atomicReference, 5000L, "get trigger URIs", new Runnable() {
                @Override
                public final void run() {
                    zziq zziqVar = this.zza;
                    AtomicReference<List<zzmh>> atomicReference2 = atomicReference;
                    Bundle bundleZza = zziqVar.zzk().zzi.zza();
                    zzkp zzkpVarZzo = zziqVar.zzo();
                    if (bundleZza == null) {
                        bundleZza = new Bundle();
                    }
                    zzkpVarZzo.zza(atomicReference2, bundleZza);
                }
            });
            final List list = (List) atomicReference.get();
            if (list == null) {
                zzj().zzg().zza("Timed out waiting for get trigger URIs");
            } else {
                zzl().zzb(new Runnable() {
                    @Override
                    public final void run() {
                        this.zza.zza(list);
                    }
                });
            }
        }
    }

    public final void zzam() {
        zzt();
        if (zzk().zzo.zza()) {
            zzj().zzc().zza("Deferred Deep Link already retrieved. Not fetching again.");
            return;
        }
        long jZza = zzk().zzp.zza();
        zzk().zzp.zza(1 + jZza);
        if (jZza >= 5) {
            zzj().zzu().zza("Permanently failed to retrieve Deferred Deep Link. Reached maximum retries.");
            zzk().zzo.zza(true);
        } else {
            if (zznp.zza() && zze().zza(zzbi.zzcn)) {
                if (this.zzn == null) {
                    this.zzn = new zzjh(this, this.zzu);
                }
                this.zzn.zza(0L);
                return;
            }
            this.zzu.zzah();
        }
    }

    final void zza(List list) {
        zzt();
        if (Build.VERSION.SDK_INT >= 30) {
            SparseArray<Long> sparseArrayZzg = zzk().zzg();
            Iterator it = list.iterator();
            while (it.hasNext()) {
                zzmh zzmhVar = (zzmh) it.next();
                if (!sparseArrayZzg.contains(zzmhVar.zzc) || sparseArrayZzg.get(zzmhVar.zzc).longValue() < zzmhVar.zzb) {
                    zzao().add(zzmhVar);
                }
            }
            zzan();
        }
    }

    final void zza(Bundle bundle) {
        if (bundle == null) {
            zzk().zzt.zza(new Bundle());
            return;
        }
        Bundle bundleZza = zzk().zzt.zza();
        for (String str : bundle.keySet()) {
            Object obj = bundle.get(str);
            if (obj != null && !(obj instanceof String) && !(obj instanceof Long) && !(obj instanceof Double)) {
                zzq();
                if (zznd.zza(obj)) {
                    zzq();
                    zznd.zza(this.zzo, 27, (String) null, (String) null, 0);
                }
                zzj().zzv().zza("Invalid default event parameter type. Name, value", str, obj);
            } else if (zznd.zzg(str)) {
                zzj().zzv().zza("Invalid default event parameter name. Name", str);
            } else if (obj == null) {
                bundleZza.remove(str);
            } else if (zzq().zza("param", str, zze().zzb(this.zzu.zzh().zzad()), obj)) {
                zzq().zza(bundleZza, str, obj);
            }
        }
        zzq();
        if (zznd.zza(bundleZza, zze().zzg())) {
            zzq();
            zznd.zza(this.zzo, 26, (String) null, (String) null, 0);
            zzj().zzv().zza("Too many default event parameters set. Discarding beyond event parameter limit");
        }
        zzk().zzt.zza(bundleZza);
        zzo().zza(bundleZza);
    }

    public final void zzb(String str, String str2, Bundle bundle) {
        zza(str, str2, bundle, true, true, zzb().currentTimeMillis());
    }

    public final void zza(String str, String str2, Bundle bundle, boolean z, boolean z2, long j) {
        String str3 = str == null ? "app" : str;
        Bundle bundle2 = bundle == null ? new Bundle() : bundle;
        if (str2 == FirebaseAnalytics.Event.SCREEN_VIEW || (str2 != null && str2.equals(FirebaseAnalytics.Event.SCREEN_VIEW))) {
            zzn().zza(bundle2, j);
        } else {
            zzb(str3, str2, j, bundle2, z2, !z2 || this.zzc == null || zznd.zzg(str2), z, null);
        }
    }

    public final void zza(String str, String str2, Bundle bundle, String str3) {
        zzs();
        zzb(str, str2, zzb().currentTimeMillis(), bundle, false, true, true, str3);
    }

    final void zzc(String str, String str2, Bundle bundle) {
        zzt();
        zza(str, str2, zzb().currentTimeMillis(), bundle);
    }

    final void zza(String str, String str2, long j, Bundle bundle) {
        zzt();
        zza(str, str2, j, bundle, true, this.zzc == null || zznd.zzg(str2), true, null);
    }

    protected final void zza(String str, String str2, long j, Bundle bundle, boolean z, boolean z2, boolean z3, String str3) {
        boolean zZza;
        long j2;
        zziq zziqVar;
        String strTrim;
        int length;
        Class<?> cls;
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotNull(bundle);
        zzt();
        zzu();
        if (!this.zzu.zzac()) {
            zzj().zzc().zza("Event not sent since app measurement is disabled");
            return;
        }
        List<String> listZzaf = zzg().zzaf();
        if (listZzaf != null && !listZzaf.contains(str2)) {
            zzj().zzc().zza("Dropping non-safelisted event. event name, origin", str2, str);
            return;
        }
        if (!this.zze) {
            this.zze = true;
            try {
                if (!this.zzu.zzag()) {
                    cls = Class.forName("com.google.android.gms.tagmanager.TagManagerService", true, zza().getClassLoader());
                } else {
                    cls = Class.forName("com.google.android.gms.tagmanager.TagManagerService");
                }
                try {
                    cls.getDeclaredMethod("initialize", Context.class).invoke(null, zza());
                } catch (Exception e) {
                    zzj().zzu().zza("Failed to invoke Tag Manager's initialize() method", e);
                }
            } catch (ClassNotFoundException unused) {
                zzj().zzn().zza("Tag Manager is not found and thus will not be used");
            }
        }
        if (Constants.ScionAnalytics.EVENT_FIREBASE_CAMPAIGN.equals(str2)) {
            if (bundle.containsKey("gclid")) {
                zza("auto", "_lgclid", bundle.getString("gclid"), zzb().currentTimeMillis());
            }
            if (zzoi.zza() && zze().zza(zzbi.zzcs) && bundle.containsKey("gbraid")) {
                zza("auto", "_gbraid", bundle.getString("gbraid"), zzb().currentTimeMillis());
            }
        }
        if (z && zznd.zzj(str2)) {
            zzq().zza(bundle, zzk().zzt.zza());
        }
        if (!z3 && !"_iap".equals(str2)) {
            zznd zzndVarZzt = this.zzu.zzt();
            int i = 2;
            if (zzndVarZzt.zzc("event", str2)) {
                if (!zzndVarZzt.zza("event", zzii.zza, zzii.zzb, str2)) {
                    i = 13;
                } else if (zzndVarZzt.zza("event", 40, str2)) {
                    i = 0;
                }
            }
            if (i != 0) {
                zzj().zzh().zza("Invalid public event name. Event will not be logged (FE)", zzi().zza(str2));
                this.zzu.zzt();
                String strZza = zznd.zza(str2, 40, true);
                length = str2 != null ? str2.length() : 0;
                this.zzu.zzt();
                zznd.zza(this.zzo, i, "_ev", strZza, length);
                return;
            }
        }
        zzki zzkiVarZza = zzn().zza(false);
        if (zzkiVarZza != null && !bundle.containsKey("_sc")) {
            zzkiVarZza.zzd = true;
        }
        zznd.zza(zzkiVarZza, bundle, z && !z3);
        boolean zEquals = "am".equals(str);
        boolean zZzg = zznd.zzg(str2);
        if (z && this.zzc != null && !zZzg && !zEquals) {
            zzj().zzc().zza("Passing event to registered event handler (FE)", zzi().zza(str2), zzi().zza(bundle));
            Preconditions.checkNotNull(this.zzc);
            this.zzc.interceptEvent(str, str2, bundle, j);
            return;
        }
        if (this.zzu.zzaf()) {
            int iZza = zzq().zza(str2);
            if (iZza != 0) {
                zzj().zzh().zza("Invalid event name. Event will not be logged (FE)", zzi().zza(str2));
                zzq();
                String strZza2 = zznd.zza(str2, 40, true);
                length = str2 != null ? str2.length() : 0;
                this.zzu.zzt();
                zznd.zza(this.zzo, str3, iZza, "_ev", strZza2, length);
                return;
            }
            Bundle bundleZza = zzq().zza(str3, str2, bundle, CollectionUtils.listOf((Object[]) new String[]{"_o", "_sn", "_sc", "_si"}), z3);
            Preconditions.checkNotNull(bundleZza);
            if (zzn().zza(false) != null && "_ae".equals(str2)) {
                zzmd zzmdVar = zzp().zzb;
                long jElapsedRealtime = zzmdVar.zzb.zzb().elapsedRealtime();
                long j3 = jElapsedRealtime - zzmdVar.zza;
                zzmdVar.zza = jElapsedRealtime;
                if (j3 > 0) {
                    zzq().zza(bundleZza, j3);
                }
            }
            if (zznv.zza() && zze().zza(zzbi.zzbm)) {
                if (!"auto".equals(str) && "_ssr".equals(str2)) {
                    zznd zzndVarZzq = zzq();
                    String string = bundleZza.getString("_ffr");
                    if (Strings.isEmptyOrWhitespace(string)) {
                        strTrim = null;
                    } else {
                        strTrim = string != null ? string.trim() : string;
                    }
                    if (zzng.zza(strTrim, zzndVarZzq.zzk().zzq.zza())) {
                        zzndVarZzq.zzj().zzc().zza("Not logging duplicate session_start_with_rollout event");
                        return;
                    }
                    zzndVarZzq.zzk().zzq.zza(strTrim);
                } else if ("_ae".equals(str2)) {
                    String strZza3 = zzq().zzk().zzq.zza();
                    if (!TextUtils.isEmpty(strZza3)) {
                        bundleZza.putString("_ffr", strZza3);
                    }
                }
            }
            ArrayList arrayList = new ArrayList();
            arrayList.add(bundleZza);
            if (zze().zza(zzbi.zzcj)) {
                zZza = zzp().zzaa();
            } else {
                zZza = zzk().zzn.zza();
            }
            if (zzk().zzk.zza() > 0 && zzk().zza(j) && zZza) {
                zzj().zzp().zza("Current session is expired, remove the session number, ID, and engagement time");
                j2 = 0;
                zza("auto", "_sid", (Object) null, zzb().currentTimeMillis());
                zza("auto", "_sno", (Object) null, zzb().currentTimeMillis());
                zza("auto", "_se", (Object) null, zzb().currentTimeMillis());
                zzk().zzl.zza(0L);
            } else {
                j2 = 0;
            }
            if (bundleZza.getLong(FirebaseAnalytics.Param.EXTEND_SESSION, j2) == 1) {
                zzj().zzp().zza("EXTEND_SESSION param attached: initiate a new session or extend the current active session");
                zziqVar = this;
                zziqVar.zzu.zzs().zza.zza(j, true);
            } else {
                zziqVar = this;
            }
            ArrayList arrayList2 = new ArrayList(bundleZza.keySet());
            Collections.sort(arrayList2);
            int size = arrayList2.size();
            int i2 = 0;
            while (i2 < size) {
                Object obj = arrayList2.get(i2);
                i2++;
                String str4 = (String) obj;
                if (str4 != null) {
                    zzq();
                    Bundle[] bundleArrZzb = zznd.zzb(bundleZza.get(str4));
                    if (bundleArrZzb != null) {
                        bundleZza.putParcelableArray(str4, bundleArrZzb);
                    }
                }
            }
            int i3 = 0;
            while (i3 < arrayList.size()) {
                Bundle bundleZzb = (Bundle) arrayList.get(i3);
                String str5 = i3 != 0 ? "_ep" : str2;
                bundleZzb.putString("_o", str);
                if (z2) {
                    bundleZzb = zzq().zzb(bundleZzb);
                }
                Bundle bundle2 = bundleZzb;
                zzo().zza(new zzbg(str5, new zzbb(bundle2), str, j), str3);
                if (!zEquals) {
                    Iterator<zzil> it = zziqVar.zzd.iterator();
                    while (it.hasNext()) {
                        it.next().onEvent(str, str2, new Bundle(bundle2), j);
                    }
                }
                i3++;
            }
            if (zzn().zza(false) == null || !"_ae".equals(str2)) {
                return;
            }
            zzp().zza(true, true, zzb().elapsedRealtime());
        }
    }

    final void zzan() {
        zzmh zzmhVarPoll;
        MeasurementManagerFutures measurementManagerFuturesZzn;
        zzt();
        if (zzao().isEmpty() || this.zzh || (zzmhVarPoll = zzao().poll()) == null || (measurementManagerFuturesZzn = zzq().zzn()) == null) {
            return;
        }
        this.zzh = true;
        zzj().zzp().zza("Registering trigger URI", zzmhVarPoll.zza);
        ListenableFuture listenableFutureRegisterTriggerAsync = measurementManagerFuturesZzn.registerTriggerAsync(Uri.parse(zzmhVarPoll.zza));
        if (listenableFutureRegisterTriggerAsync == null) {
            this.zzh = false;
            zzao().add(zzmhVarPoll);
            return;
        }
        SparseArray<Long> sparseArrayZzg = zzk().zzg();
        sparseArrayZzg.put(zzmhVarPoll.zzc, Long.valueOf(zzmhVarPoll.zzb));
        zzgd zzgdVarZzk = zzk();
        if (sparseArrayZzg == null) {
            zzgdVarZzk.zzi.zza(null);
        } else {
            int[] iArr = new int[sparseArrayZzg.size()];
            long[] jArr = new long[sparseArrayZzg.size()];
            for (int i = 0; i < sparseArrayZzg.size(); i++) {
                iArr[i] = sparseArrayZzg.keyAt(i);
                jArr[i] = sparseArrayZzg.valueAt(i).longValue();
            }
            Bundle bundle = new Bundle();
            bundle.putIntArray("uriSources", iArr);
            bundle.putLongArray("uriTimestamps", jArr);
            zzgdVarZzk.zzi.zza(bundle);
        }
        Futures.addCallback(listenableFutureRegisterTriggerAsync, new zzjc(this, zzmhVarPoll), new zziz(this));
    }

    public final void zza(zzil zzilVar) {
        zzu();
        Preconditions.checkNotNull(zzilVar);
        if (this.zzd.add(zzilVar)) {
            return;
        }
        zzj().zzu().zza("OnEventListener already registered");
    }

    final void zza(long j, boolean z) {
        zzt();
        zzu();
        zzj().zzc().zza("Resetting analytics data (FE)");
        zzlx zzlxVarZzp = zzp();
        zzlxVarZzp.zzt();
        zzlxVarZzp.zzb.zza();
        if (zzps.zza() && zze().zza(zzbi.zzbs)) {
            zzg().zzag();
        }
        boolean zZzac = this.zzu.zzac();
        zzgd zzgdVarZzk = zzk();
        zzgdVarZzk.zzc.zza(j);
        if (!TextUtils.isEmpty(zzgdVarZzk.zzk().zzq.zza())) {
            zzgdVarZzk.zzq.zza(null);
        }
        if (zzoh.zza() && zzgdVarZzk.zze().zza(zzbi.zzbn)) {
            zzgdVarZzk.zzk.zza(0L);
        }
        zzgdVarZzk.zzl.zza(0L);
        if (!zzgdVarZzk.zze().zzv()) {
            zzgdVarZzk.zzb(!zZzac);
        }
        zzgdVarZzk.zzr.zza(null);
        zzgdVarZzk.zzs.zza(0L);
        zzgdVarZzk.zzt.zza(null);
        if (z) {
            zzo().zzaf();
        }
        if (zzoh.zza() && zze().zza(zzbi.zzbn)) {
            zzp().zza.zza();
        }
        this.zzm = !zZzac;
    }

    private final void zzb(String str, String str2, long j, Bundle bundle, boolean z, boolean z2, boolean z3, String str3) {
        zzl().zzb(new zzjg(this, str, str2, j, zznd.zza(bundle), z, z2, z3, str3));
    }

    private final void zza(String str, String str2, long j, Object obj) {
        zzl().zzb(new zzjf(this, str, str2, obj, j));
    }

    final void zza(String str) {
        this.zzf.set(str);
    }

    public final void zzb(Bundle bundle) {
        zza(bundle, zzb().currentTimeMillis());
    }

    public final void zza(Bundle bundle, long j) {
        Preconditions.checkNotNull(bundle);
        Bundle bundle2 = new Bundle(bundle);
        if (!TextUtils.isEmpty(bundle2.getString("app_id"))) {
            zzj().zzu().zza("Package name should be null when calling setConditionalUserProperty");
        }
        bundle2.remove("app_id");
        Preconditions.checkNotNull(bundle2);
        zzie.zza(bundle2, "app_id", String.class, null);
        zzie.zza(bundle2, "origin", String.class, null);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.NAME, String.class, null);
        zzie.zza(bundle2, "value", Object.class, null);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.TRIGGER_EVENT_NAME, String.class, null);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.TRIGGER_TIMEOUT, Long.class, 0L);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.TIMED_OUT_EVENT_NAME, String.class, null);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.TIMED_OUT_EVENT_PARAMS, Bundle.class, null);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.TRIGGERED_EVENT_NAME, String.class, null);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.TRIGGERED_EVENT_PARAMS, Bundle.class, null);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.TIME_TO_LIVE, Long.class, 0L);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.EXPIRED_EVENT_NAME, String.class, null);
        zzie.zza(bundle2, AppMeasurementSdk.ConditionalUserProperty.EXPIRED_EVENT_PARAMS, Bundle.class, null);
        Preconditions.checkNotEmpty(bundle2.getString(AppMeasurementSdk.ConditionalUserProperty.NAME));
        Preconditions.checkNotEmpty(bundle2.getString("origin"));
        Preconditions.checkNotNull(bundle2.get("value"));
        bundle2.putLong(AppMeasurementSdk.ConditionalUserProperty.CREATION_TIMESTAMP, j);
        String string = bundle2.getString(AppMeasurementSdk.ConditionalUserProperty.NAME);
        Object obj = bundle2.get("value");
        if (zzq().zzb(string) != 0) {
            zzj().zzg().zza("Invalid conditional user property name", zzi().zzc(string));
            return;
        }
        if (zzq().zza(string, obj) != 0) {
            zzj().zzg().zza("Invalid conditional user property value", zzi().zzc(string), obj);
            return;
        }
        Object objZzc = zzq().zzc(string, obj);
        if (objZzc == null) {
            zzj().zzg().zza("Unable to normalize conditional user property value", zzi().zzc(string), obj);
            return;
        }
        zzie.zza(bundle2, objZzc);
        long j2 = bundle2.getLong(AppMeasurementSdk.ConditionalUserProperty.TRIGGER_TIMEOUT);
        if (!TextUtils.isEmpty(bundle2.getString(AppMeasurementSdk.ConditionalUserProperty.TRIGGER_EVENT_NAME)) && (j2 > 15552000000L || j2 < 1)) {
            zzj().zzg().zza("Invalid conditional user property timeout", zzi().zzc(string), Long.valueOf(j2));
            return;
        }
        long j3 = bundle2.getLong(AppMeasurementSdk.ConditionalUserProperty.TIME_TO_LIVE);
        if (j3 > 15552000000L || j3 < 1) {
            zzj().zzg().zza("Invalid conditional user property time to live", zzi().zzc(string), Long.valueOf(j3));
        } else {
            zzl().zzb(new zzjm(this, bundle2));
        }
    }

    public final void zza(zzih zzihVar, long j) {
        zzih zzihVar2;
        boolean z;
        zzih zzihVar3;
        boolean z2;
        boolean zZzc;
        zzu();
        int iZza = zzihVar.zza();
        if (iZza != -10 && zzihVar.zzc() == null && zzihVar.zzd() == null) {
            zzj().zzv().zza("Discarding empty consent settings");
            return;
        }
        synchronized (this.zzg) {
            zzihVar2 = this.zzj;
            z = false;
            if (zzih.zza(iZza, zzihVar2.zza())) {
                zZzc = zzihVar.zzc(this.zzj);
                if (zzihVar.zzh() && !this.zzj.zzh()) {
                    z = true;
                }
                zzih zzihVarZzb = zzihVar.zzb(this.zzj);
                this.zzj = zzihVarZzb;
                zzihVar3 = zzihVarZzb;
                z2 = z;
                z = true;
            } else {
                zzihVar3 = zzihVar;
                z2 = false;
                zZzc = false;
            }
        }
        if (!z) {
            zzj().zzn().zza("Ignoring lower-priority consent settings, proposed settings", zzihVar3);
            return;
        }
        long andIncrement = this.zzk.getAndIncrement();
        if (zZzc) {
            zza((String) null);
            zzl().zzc(new zzjv(this, zzihVar3, j, andIncrement, z2, zzihVar2));
            return;
        }
        zzjy zzjyVar = new zzjy(this, zzihVar3, andIncrement, z2, zzihVar2);
        if (iZza == 30 || iZza == -10) {
            zzl().zzc(zzjyVar);
        } else {
            zzl().zzb(zzjyVar);
        }
    }

    final void zza(Bundle bundle, int i, long j) {
        zzu();
        String strZza = zzih.zza(bundle);
        if (strZza != null) {
            zzj().zzv().zza("Ignoring invalid consent setting", strZza);
            zzj().zzv().zza("Valid consent values are 'granted', 'denied'");
        }
        zzih zzihVarZza = zzih.zza(bundle, i);
        if (zznp.zza() && zze().zza(zzbi.zzcl)) {
            if (zzihVarZza.zzi()) {
                zza(zzihVarZza, j);
            }
            zzay zzayVarZza = zzay.zza(bundle, i);
            if (zzayVarZza.zzg()) {
                zza(zzayVarZza);
            }
            Boolean boolZza = zzay.zza(bundle);
            if (boolZza != null) {
                zza("app", FirebaseAnalytics.UserProperty.ALLOW_AD_PERSONALIZATION_SIGNALS, (Object) boolZza.toString(), false);
                return;
            }
            return;
        }
        zza(zzihVarZza, j);
    }

    final void zza(zzay zzayVar) {
        zzl().zzb(new zzjw(this, zzayVar));
    }

    public final void zza(zzim zzimVar) {
        zzim zzimVar2;
        zzt();
        zzu();
        if (zzimVar != null && zzimVar != (zzimVar2 = this.zzc)) {
            Preconditions.checkState(zzimVar2 == null, "EventInterceptor already set.");
        }
        this.zzc = zzimVar;
    }

    public final void zza(Boolean bool) {
        zzu();
        zzl().zzb(new zzjt(this, bool));
    }

    final void zza(zzih zzihVar) {
        zzt();
        boolean z = (zzihVar.zzh() && zzihVar.zzg()) || zzo().zzaj();
        if (z != this.zzu.zzad()) {
            this.zzu.zzb(z);
            Boolean boolZzp = zzk().zzp();
            if (!z || boolZzp == null || boolZzp.booleanValue()) {
                zza(Boolean.valueOf(z), false);
            }
        }
    }

    public final void zza(Boolean bool, boolean z) {
        zzt();
        zzu();
        zzj().zzc().zza("Setting app measurement enabled (FE)", bool);
        zzk().zza(bool);
        if (z) {
            zzk().zzb(bool);
        }
        if (this.zzu.zzad() || !(bool == null || bool.booleanValue())) {
            zzap();
        }
    }

    public final void zza(String str, String str2, Object obj, boolean z) {
        zza(str, str2, obj, z, zzb().currentTimeMillis());
    }

    public final void zza(String str, String str2, Object obj, boolean z, long j) {
        int iZzb;
        int length;
        if (str == null) {
            str = "app";
        }
        String str3 = str;
        if (z) {
            iZzb = zzq().zzb(str2);
        } else {
            zznd zzndVarZzq = zzq();
            if (!zzndVarZzq.zzc("user property", str2)) {
                iZzb = 6;
            } else if (!zzndVarZzq.zza("user property", zzij.zza, str2)) {
                iZzb = 15;
            } else if (zzndVarZzq.zza("user property", 24, str2)) {
                iZzb = 0;
            } else {
                iZzb = 6;
            }
        }
        if (iZzb != 0) {
            zzq();
            String strZza = zznd.zza(str2, 24, true);
            length = str2 != null ? str2.length() : 0;
            this.zzu.zzt();
            zznd.zza(this.zzo, iZzb, "_ev", strZza, length);
            return;
        }
        if (obj != null) {
            int iZza = zzq().zza(str2, obj);
            if (iZza != 0) {
                zzq();
                String strZza2 = zznd.zza(str2, 24, true);
                length = ((obj instanceof String) || (obj instanceof CharSequence)) ? String.valueOf(obj).length() : 0;
                this.zzu.zzt();
                zznd.zza(this.zzo, iZza, "_ev", strZza2, length);
                return;
            }
            Object objZzc = zzq().zzc(str2, obj);
            if (objZzc != null) {
                zza(str3, str2, j, objZzc);
                return;
            }
            return;
        }
        zza(str3, str2, j, (Object) null);
    }

    final void zza(String str, String str2, Object obj, long j) {
        String str3;
        Object obj2;
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        zzt();
        zzu();
        if (FirebaseAnalytics.UserProperty.ALLOW_AD_PERSONALIZATION_SIGNALS.equals(str2)) {
            if (obj instanceof String) {
                String str4 = (String) obj;
                if (!TextUtils.isEmpty(str4)) {
                    Long lValueOf = Long.valueOf("false".equals(str4.toLowerCase(Locale.ENGLISH)) ? 1L : 0L);
                    zzk().zzh.zza(lValueOf.longValue() == 1 ? "true" : "false");
                    obj2 = lValueOf;
                } else if (obj == null) {
                    zzk().zzh.zza("unset");
                    obj2 = obj;
                } else {
                    str3 = str2;
                    obj2 = obj;
                }
            } else if (obj == null) {
                zzk().zzh.zza("unset");
                obj2 = obj;
            } else {
                str3 = str2;
                obj2 = obj;
            }
            str3 = "_npa";
        } else {
            str3 = str2;
            obj2 = obj;
        }
        if (!this.zzu.zzac()) {
            zzj().zzp().zza("User property not set since app measurement is disabled");
        } else if (this.zzu.zzaf()) {
            zzo().zza(new zznc(str3, j, obj2, str));
        }
    }

    public final void zzb(zzil zzilVar) {
        zzu();
        Preconditions.checkNotNull(zzilVar);
        if (this.zzd.remove(zzilVar)) {
            return;
        }
        zzj().zzu().zza("OnEventListener had not been registered");
    }

    public final void zzap() {
        zzt();
        String strZza = zzk().zzh.zza();
        if (strZza != null) {
            if ("unset".equals(strZza)) {
                zza("app", "_npa", (Object) null, zzb().currentTimeMillis());
            } else {
                zza("app", "_npa", Long.valueOf("true".equals(strZza) ? 1L : 0L), zzb().currentTimeMillis());
            }
        }
        if (this.zzu.zzac() && this.zzm) {
            zzj().zzc().zza("Recording app launch after enabling measurement for the first time (FE)");
            zzaj();
            if (zzoh.zza() && zze().zza(zzbi.zzbn)) {
                zzp().zza.zza();
            }
            zzl().zzb(new zzje(this));
            return;
        }
        zzj().zzc().zza("Updating Scion state (FE)");
        zzo().zzag();
    }
}
