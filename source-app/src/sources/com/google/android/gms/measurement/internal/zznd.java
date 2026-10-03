package com.google.android.gms.measurement.internal;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.pm.ServiceInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.RemoteException;
import android.text.TextUtils;
import androidx.activity.ComponentDialog$;
import androidx.privacysandbox.ads.adservices.java.measurement.MeasurementManagerFutures;
import com.google.android.gms.common.GoogleApiAvailabilityLight;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.common.util.CollectionUtils;
import com.google.android.gms.common.wrappers.Wrappers;
import com.google.android.gms.internal.measurement.zzot;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.ishumei.smantifraud.l1l11lI1l;
import java.io.ByteArrayInputStream;
import java.math.BigInteger;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.TreeSet;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.concurrent.atomic.AtomicLong;
import javax.security.auth.x500.X500Principal;
import org.checkerframework.checker.nullness.qual.EnsuresNonNull;
import org.checkerframework.dataflow.qual.Pure;

public final class zznd extends zzic {
    private static final String[] zza = {"firebase_", "google_", "ga_"};
    private static final String[] zzb = {"_err"};
    private SecureRandom zzc;
    private final AtomicLong zzd;
    private int zze;
    private MeasurementManagerFutures zzf;
    private Boolean zzg;
    private Integer zzh;

    private final int zza(String str, String str2, String str3, Object obj, Bundle bundle, List<String> list, boolean z, boolean z2) {
        int i;
        int size;
        zzt();
        int i2 = 0;
        if (!zza(obj)) {
            i = 0;
        } else {
            if (!z2) {
                return 21;
            }
            if (!zza(str3, zzik.zzc)) {
                return 20;
            }
            if (!this.zzu.zzr().zzai()) {
                return 25;
            }
            boolean z3 = obj instanceof Parcelable[];
            if (z3) {
                size = ((Parcelable[]) obj).length;
            } else if (obj instanceof ArrayList) {
                size = ((ArrayList) obj).size();
            } else {
                i = 0;
            }
            if (size > 200) {
                zzj().zzv().zza("Parameter array is too long; discarded. Value kind, name, array length", "param", str3, Integer.valueOf(size));
                if (z3) {
                    Parcelable[] parcelableArr = (Parcelable[]) obj;
                    if (parcelableArr.length > 200) {
                        bundle.putParcelableArray(str3, (Parcelable[]) Arrays.copyOf(parcelableArr, 200));
                    }
                } else if (obj instanceof ArrayList) {
                    ArrayList arrayList = (ArrayList) obj;
                    if (arrayList.size() > 200) {
                        bundle.putParcelableArrayList(str3, new ArrayList<>(arrayList.subList(0, 200)));
                    }
                }
                i = 17;
            } else {
                i = 0;
            }
        }
        if (zza("param", str3, (zzg(str2) || zzg(str3)) ? zze().zzc(this.zzu.zzh().zzad()) : zze().zzb(this.zzu.zzh().zzad()), obj)) {
            return i;
        }
        if (!z2) {
            return 4;
        }
        if (obj instanceof Bundle) {
            zza(str, str2, str3, (Bundle) obj, list, z);
        } else if (obj instanceof Parcelable[]) {
            for (Parcelable parcelable : (Parcelable[]) obj) {
                if (!(parcelable instanceof Bundle)) {
                    zzj().zzv().zza("All Parcelable[] elements must be of type Bundle. Value type, name", parcelable.getClass(), str3);
                    return 4;
                }
                zza(str, str2, str3, (Bundle) parcelable, list, z);
            }
        } else {
            if (!(obj instanceof ArrayList)) {
                return 4;
            }
            ArrayList arrayList2 = (ArrayList) obj;
            int size2 = arrayList2.size();
            while (i2 < size2) {
                Object obj2 = arrayList2.get(i2);
                int i3 = i2 + 1;
                if (!(obj2 instanceof Bundle)) {
                    zzj().zzv().zza("All ArrayList elements must be of type Bundle. Value type, name", obj2 != null ? obj2.getClass() : "null", str3);
                    return 4;
                }
                zza(str, str2, str3, (Bundle) obj2, list, z);
                i2 = i3;
            }
        }
        return i;
    }

    @Override
    protected final boolean zzo() {
        return true;
    }

    final int zza(String str, Object obj) {
        boolean zZza;
        if ("_ldl".equals(str)) {
            zZza = zza("user property referrer", str, zzm(str), obj);
        } else {
            zZza = zza("user property", str, zzm(str), obj);
        }
        return zZza ? 0 : 7;
    }

    final int zza(String str) {
        if (!zzb("event", str)) {
            return 2;
        }
        if (zza("event", zzii.zza, zzii.zzb, str)) {
            return !zza("event", 40, str) ? 2 : 0;
        }
        return 13;
    }

    private final int zzk(String str) {
        if (!zzb("event param", str)) {
            return 3;
        }
        if (zza("event param", (String[]) null, str)) {
            return !zza("event param", 40, str) ? 3 : 0;
        }
        return 14;
    }

    private final int zzl(String str) {
        if (!zzc("event param", str)) {
            return 3;
        }
        if (zza("event param", (String[]) null, str)) {
            return !zza("event param", 40, str) ? 3 : 0;
        }
        return 14;
    }

    final int zzb(String str) {
        if (!zzb("user property", str)) {
            return 6;
        }
        if (zza("user property", zzij.zza, str)) {
            return !zza("user property", 24, str) ? 6 : 0;
        }
        return 15;
    }

    static int zzc() {
        if (Build.VERSION.SDK_INT < 30 || ComponentDialog$.ExternalSyntheticApiModelOutline0.m(30) <= 3) {
            return 0;
        }
        return ComponentDialog$.ExternalSyntheticApiModelOutline0.m(1000000);
    }

    @EnsuresNonNull({"this.apkVersion"})
    public final int zzg() {
        if (this.zzh == null) {
            this.zzh = Integer.valueOf(GoogleApiAvailabilityLight.getInstance().getApkVersion(zza()) / 1000);
        }
        return this.zzh.intValue();
    }

    private static int zzm(String str) {
        if ("_ldl".equals(str)) {
            return 2048;
        }
        if ("_id".equals(str)) {
            return l1l11lI1l.l111l11111lIl;
        }
        return ("_lgclid".equals(str) || "_gbraid".equals(str)) ? 100 : 36;
    }

    public final int zza(int i) {
        return GoogleApiAvailabilityLight.getInstance().isGooglePlayServicesAvailable(zza(), 12451000);
    }

    final long zzc(String str) {
        if (zza().getPackageManager() == null) {
            return 0L;
        }
        int i = 0;
        try {
            ApplicationInfo applicationInfo = Wrappers.packageManager(zza()).getApplicationInfo(str, 0);
            if (applicationInfo != null) {
                i = applicationInfo.targetSdkVersion;
            }
        } catch (PackageManager.NameNotFoundException unused) {
            zzj().zzn().zza("PackageManager failed to find running app: app_id", str);
        }
        return i;
    }

    final long zzh() {
        long j;
        zzt();
        if (!zzd(this.zzu.zzh().zzad())) {
            return 0L;
        }
        if (Build.VERSION.SDK_INT < 30) {
            j = 4;
        } else if (ComponentDialog$.ExternalSyntheticApiModelOutline0.m(30) < 4) {
            j = 8;
        } else {
            j = zzc() < zzbi.zzau.zza(null).intValue() ? 16L : 0L;
        }
        if (!zze("android.permission.ACCESS_ADSERVICES_ATTRIBUTION")) {
            j |= 2;
        }
        if (j == 0 && !zzy()) {
            j |= 64;
        }
        if (j == 0) {
            return 1L;
        }
        return j;
    }

    final long zza(Context context, String str) {
        zzt();
        Preconditions.checkNotNull(context);
        Preconditions.checkNotEmpty(str);
        PackageManager packageManager = context.getPackageManager();
        MessageDigest messageDigestZzu = zzu();
        long jZza = -1;
        if (messageDigestZzu == null) {
            zzj().zzg().zza("Could not get MD5 instance");
            return -1L;
        }
        if (packageManager != null) {
            try {
                if (!zzb(context, str)) {
                    PackageInfo packageInfo = Wrappers.packageManager(context).getPackageInfo(zza().getPackageName(), 64);
                    if (packageInfo.signatures != null && packageInfo.signatures.length > 0) {
                        jZza = zza(messageDigestZzu.digest(packageInfo.signatures[0].toByteArray()));
                    } else {
                        zzj().zzu().zza("Could not get signatures");
                    }
                    return jZza;
                }
            } catch (PackageManager.NameNotFoundException e) {
                zzj().zzg().zza("Package name not found", e);
            }
        }
        return 0L;
    }

    static long zza(byte[] bArr) {
        Preconditions.checkNotNull(bArr);
        int i = 0;
        Preconditions.checkState(bArr.length > 0);
        long j = 0;
        for (int length = bArr.length - 1; length >= 0 && length >= bArr.length - 8; length--) {
            j += (((long) bArr[length]) & 255) << i;
            i += 8;
        }
        return j;
    }

    public static long zza(zzbb zzbbVar) {
        long length = 0;
        if (zzbbVar == null) {
            return 0L;
        }
        Iterator<String> it = zzbbVar.iterator();
        while (it.hasNext()) {
            Object objZzc = zzbbVar.zzc(it.next());
            if (objZzc instanceof Parcelable[]) {
                length += (long) ((Parcelable[]) objZzc).length;
            }
        }
        return length;
    }

    public final long zzm() {
        long andIncrement;
        long j;
        if (this.zzd.get() == 0) {
            synchronized (this.zzd) {
                long jNextLong = new Random(System.nanoTime() ^ zzb().currentTimeMillis()).nextLong();
                int i = this.zze + 1;
                this.zze = i;
                j = jNextLong + ((long) i);
            }
            return j;
        }
        synchronized (this.zzd) {
            this.zzd.compareAndSet(-1L, 1L);
            andIncrement = this.zzd.getAndIncrement();
        }
        return andIncrement;
    }

    public static long zza(long j, long j2) {
        return (j + (j2 * 60000)) / 86400000;
    }

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    public static Bundle zza(List<zznc> list) {
        Bundle bundle = new Bundle();
        if (list == null) {
            return bundle;
        }
        for (zznc zzncVar : list) {
            if (zzncVar.zzd != null) {
                bundle.putString(zzncVar.zza, zzncVar.zzd);
            } else if (zzncVar.zzc != null) {
                bundle.putLong(zzncVar.zza, zzncVar.zzc.longValue());
            } else if (zzncVar.zzf != null) {
                bundle.putDouble(zzncVar.zza, zzncVar.zzf.doubleValue());
            }
        }
        return bundle;
    }

    final Bundle zza(Uri uri, boolean z, boolean z2) {
        String queryParameter;
        String queryParameter2;
        String queryParameter3;
        String queryParameter4;
        String queryParameter5;
        String queryParameter6;
        String queryParameter7;
        String queryParameter8;
        String queryParameter9;
        if (uri == null) {
            return null;
        }
        try {
            if (uri.isHierarchical()) {
                queryParameter = uri.getQueryParameter("utm_campaign");
                queryParameter2 = uri.getQueryParameter("utm_source");
                queryParameter3 = uri.getQueryParameter("utm_medium");
                queryParameter4 = uri.getQueryParameter("gclid");
                queryParameter5 = z2 ? uri.getQueryParameter("gbraid") : null;
                queryParameter6 = uri.getQueryParameter("utm_id");
                queryParameter7 = uri.getQueryParameter("dclid");
                queryParameter8 = uri.getQueryParameter("srsltid");
                queryParameter9 = z ? uri.getQueryParameter("sfmc_id") : null;
            } else {
                queryParameter = null;
                queryParameter2 = null;
                queryParameter3 = null;
                queryParameter4 = null;
                queryParameter5 = null;
                queryParameter6 = null;
                queryParameter7 = null;
                queryParameter8 = null;
                queryParameter9 = null;
            }
            if (TextUtils.isEmpty(queryParameter) && TextUtils.isEmpty(queryParameter2) && TextUtils.isEmpty(queryParameter3) && TextUtils.isEmpty(queryParameter4) && ((!z2 || TextUtils.isEmpty(queryParameter5)) && TextUtils.isEmpty(queryParameter6) && TextUtils.isEmpty(queryParameter7) && TextUtils.isEmpty(queryParameter8) && (!z || TextUtils.isEmpty(queryParameter9)))) {
                return null;
            }
            Bundle bundle = new Bundle();
            if (!TextUtils.isEmpty(queryParameter)) {
                bundle.putString("campaign", queryParameter);
            }
            if (!TextUtils.isEmpty(queryParameter2)) {
                bundle.putString("source", queryParameter2);
            }
            if (!TextUtils.isEmpty(queryParameter3)) {
                bundle.putString("medium", queryParameter3);
            }
            if (!TextUtils.isEmpty(queryParameter4)) {
                bundle.putString("gclid", queryParameter4);
            }
            if (z2 && !TextUtils.isEmpty(queryParameter5)) {
                bundle.putString("gbraid", queryParameter5);
            }
            String queryParameter10 = uri.getQueryParameter("utm_term");
            if (!TextUtils.isEmpty(queryParameter10)) {
                bundle.putString(FirebaseAnalytics.Param.TERM, queryParameter10);
            }
            String queryParameter11 = uri.getQueryParameter("utm_content");
            if (!TextUtils.isEmpty(queryParameter11)) {
                bundle.putString(FirebaseAnalytics.Param.CONTENT, queryParameter11);
            }
            String queryParameter12 = uri.getQueryParameter(FirebaseAnalytics.Param.ACLID);
            if (!TextUtils.isEmpty(queryParameter12)) {
                bundle.putString(FirebaseAnalytics.Param.ACLID, queryParameter12);
            }
            String queryParameter13 = uri.getQueryParameter(FirebaseAnalytics.Param.CP1);
            if (!TextUtils.isEmpty(queryParameter13)) {
                bundle.putString(FirebaseAnalytics.Param.CP1, queryParameter13);
            }
            String queryParameter14 = uri.getQueryParameter("anid");
            if (!TextUtils.isEmpty(queryParameter14)) {
                bundle.putString("anid", queryParameter14);
            }
            if (!TextUtils.isEmpty(queryParameter6)) {
                bundle.putString(FirebaseAnalytics.Param.CAMPAIGN_ID, queryParameter6);
            }
            if (!TextUtils.isEmpty(queryParameter7)) {
                bundle.putString("dclid", queryParameter7);
            }
            String queryParameter15 = uri.getQueryParameter("utm_source_platform");
            if (!TextUtils.isEmpty(queryParameter15)) {
                bundle.putString(FirebaseAnalytics.Param.SOURCE_PLATFORM, queryParameter15);
            }
            String queryParameter16 = uri.getQueryParameter("utm_creative_format");
            if (!TextUtils.isEmpty(queryParameter16)) {
                bundle.putString(FirebaseAnalytics.Param.CREATIVE_FORMAT, queryParameter16);
            }
            String queryParameter17 = uri.getQueryParameter("utm_marketing_tactic");
            if (!TextUtils.isEmpty(queryParameter17)) {
                bundle.putString(FirebaseAnalytics.Param.MARKETING_TACTIC, queryParameter17);
            }
            if (!TextUtils.isEmpty(queryParameter8)) {
                bundle.putString("srsltid", queryParameter8);
            }
            if (z && !TextUtils.isEmpty(queryParameter9)) {
                bundle.putString("sfmc_id", queryParameter9);
            }
            return bundle;
        } catch (UnsupportedOperationException e) {
            zzj().zzu().zza("Install referrer url isn't a hierarchical URI", e);
            return null;
        }
    }

    public static Bundle zza(Bundle bundle) {
        if (bundle == null) {
            return new Bundle();
        }
        Bundle bundle2 = new Bundle(bundle);
        for (String str : bundle2.keySet()) {
            Object obj = bundle2.get(str);
            if (obj instanceof Bundle) {
                bundle2.putBundle(str, new Bundle((Bundle) obj));
            } else {
                int i = 0;
                if (obj instanceof Parcelable[]) {
                    Parcelable[] parcelableArr = (Parcelable[]) obj;
                    while (i < parcelableArr.length) {
                        if (parcelableArr[i] instanceof Bundle) {
                            parcelableArr[i] = new Bundle((Bundle) parcelableArr[i]);
                        }
                        i++;
                    }
                } else if (obj instanceof List) {
                    List list = (List) obj;
                    while (i < list.size()) {
                        Object obj2 = list.get(i);
                        if (obj2 instanceof Bundle) {
                            list.set(i, new Bundle((Bundle) obj2));
                        }
                        i++;
                    }
                }
            }
        }
        return bundle2;
    }

    final Bundle zzb(Bundle bundle) {
        Bundle bundle2 = new Bundle();
        if (bundle != null) {
            for (String str : bundle.keySet()) {
                Object objZzb = zzb(str, bundle.get(str));
                if (objZzb == null) {
                    zzj().zzv().zza("Param value can't be null", zzi().zzb(str));
                } else {
                    zza(bundle2, str, objZzb);
                }
            }
        }
        return bundle2;
    }

    final Bundle zza(String str, String str2, Bundle bundle, List<String> list, boolean z) {
        int iZzl;
        int i;
        boolean zZza = zza(str2, zzii.zzd);
        if (bundle == null) {
            return null;
        }
        Bundle bundle2 = new Bundle(bundle);
        int iZzg = zze().zzg();
        int i2 = 0;
        for (String str3 : new TreeSet(bundle.keySet())) {
            if (list == null || !list.contains(str3)) {
                iZzl = !z ? zzl(str3) : 0;
                if (iZzl == 0) {
                    iZzl = zzk(str3);
                }
            } else {
                iZzl = 0;
            }
            if (iZzl != 0) {
                zza(bundle2, iZzl, str3, str3, iZzl == 3 ? str3 : null);
                bundle2.remove(str3);
                i = iZzg;
            } else {
                i = iZzg;
                int iZza = zza(str, str2, str3, bundle.get(str3), bundle2, list, z, zZza);
                if (iZza == 17) {
                    zza(bundle2, iZza, str3, str3, (Object) false);
                } else if (iZza != 0 && !"_ev".equals(str3)) {
                    zza(bundle2, iZza, iZza == 21 ? str2 : str3, str3, bundle.get(str3));
                    bundle2.remove(str3);
                }
                if (zzh(str3)) {
                    int i3 = i2 + 1;
                    if (i3 > i) {
                        zzj().zzh().zza("Event can't contain more than " + i + " params", zzi().zza(str2), zzi().zza(bundle));
                        zzb(bundle2, 5);
                        bundle2.remove(str3);
                    }
                    i2 = i3;
                }
            }
            iZzg = i;
        }
        return bundle2;
    }

    final MeasurementManagerFutures zzn() {
        if (this.zzf == null) {
            this.zzf = MeasurementManagerFutures.from(zza());
        }
        return this.zzf;
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

    final zzbg zza(String str, String str2, Bundle bundle, String str3, long j, boolean z, boolean z2) {
        if (TextUtils.isEmpty(str2)) {
            return null;
        }
        if (zza(str2) != 0) {
            zzj().zzg().zza("Invalid conditional property event name", zzi().zzc(str2));
            throw new IllegalArgumentException();
        }
        Bundle bundle2 = bundle != null ? new Bundle(bundle) : new Bundle();
        bundle2.putString("_o", str3);
        Bundle bundleZza = zza(str, str2, bundle2, CollectionUtils.listOf("_o"), true);
        if (z) {
            bundleZza = zzb(bundleZza);
        }
        Preconditions.checkNotNull(bundleZza);
        return new zzbg(str2, new zzbb(bundleZza), str3, j);
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

    final Object zzb(String str, Object obj) {
        int iZzb;
        if ("_ev".equals(str)) {
            return zza(zze().zzc(this.zzu.zzh().zzad()), obj, true, true);
        }
        if (zzg(str)) {
            iZzb = zze().zzc(this.zzu.zzh().zzad());
        } else {
            iZzb = zze().zzb(this.zzu.zzh().zzad());
        }
        return zza(iZzb, obj, false, true);
    }

    final Object zzc(String str, Object obj) {
        if ("_ldl".equals(str)) {
            return zza(zzm(str), obj, true, false);
        }
        return zza(zzm(str), obj, false, false);
    }

    private final Object zza(int i, Object obj, boolean z, boolean z2) {
        Bundle bundleZzb;
        if (obj == null) {
            return null;
        }
        if ((obj instanceof Long) || (obj instanceof Double)) {
            return obj;
        }
        if (obj instanceof Integer) {
            return Long.valueOf(((Integer) obj).intValue());
        }
        if (obj instanceof Byte) {
            return Long.valueOf(((Byte) obj).byteValue());
        }
        if (obj instanceof Short) {
            return Long.valueOf(((Short) obj).shortValue());
        }
        if (obj instanceof Boolean) {
            return Long.valueOf(((Boolean) obj).booleanValue() ? 1L : 0L);
        }
        if (obj instanceof Float) {
            return Double.valueOf(((Float) obj).doubleValue());
        }
        if ((obj instanceof String) || (obj instanceof Character) || (obj instanceof CharSequence)) {
            return zza(String.valueOf(obj), i, z);
        }
        if (!z2 || (!(obj instanceof Bundle[]) && !(obj instanceof Parcelable[]))) {
            return null;
        }
        ArrayList arrayList = new ArrayList();
        for (Parcelable parcelable : (Parcelable[]) obj) {
            if ((parcelable instanceof Bundle) && (bundleZzb = zzb((Bundle) parcelable)) != null && !bundleZzb.isEmpty()) {
                arrayList.add(bundleZzb);
            }
        }
        return arrayList.toArray(new Bundle[arrayList.size()]);
    }

    final String zzp() {
        byte[] bArr = new byte[16];
        zzv().nextBytes(bArr);
        return String.format(Locale.US, "%032x", new BigInteger(1, bArr));
    }

    public static String zza(String str, int i, boolean z) {
        if (str == null) {
            return null;
        }
        if (str.codePointCount(0, str.length()) <= i) {
            return str;
        }
        if (!z) {
            return null;
        }
        return str.substring(0, str.offsetByCodePoints(0, i)) + "...";
    }

    public final URL zza(long j, String str, String str2, long j2, String str3) {
        try {
            Preconditions.checkNotEmpty(str2);
            Preconditions.checkNotEmpty(str);
            String strConcat = String.format("https://www.googleadservices.com/pagead/conversion/app/deeplink?id_type=adid&sdk_version=%s&rdid=%s&bundleid=%s&retry=%s", String.format("v%s.%s", Long.valueOf(j), Integer.valueOf(zzg())), str2, str, Long.valueOf(j2));
            if (str.equals(zze().zzo())) {
                strConcat = strConcat.concat("&ddl_test=1");
            }
            if (!str3.isEmpty()) {
                if (str3.charAt(0) != '&') {
                    strConcat = strConcat.concat("&");
                }
                strConcat = strConcat.concat(str3);
            }
            return new URL(strConcat);
        } catch (IllegalArgumentException | MalformedURLException e) {
            zzj().zzg().zza("Failed to create BOW URL for Deferred Deep Link. exception", e.getMessage());
            return null;
        }
    }

    static MessageDigest zzu() {
        for (int i = 0; i < 2; i++) {
            try {
                MessageDigest messageDigest = MessageDigest.getInstance("MD5");
                if (messageDigest != null) {
                    return messageDigest;
                }
            } catch (NoSuchAlgorithmException unused) {
            }
        }
        return null;
    }

    @EnsuresNonNull({"this.secureRandom"})
    final SecureRandom zzv() {
        zzt();
        if (this.zzc == null) {
            this.zzc = new SecureRandom();
        }
        return this.zzc;
    }

    public static ArrayList<Bundle> zzb(List<zzad> list) {
        if (list == null) {
            return new ArrayList<>(0);
        }
        ArrayList<Bundle> arrayList = new ArrayList<>(list.size());
        for (zzad zzadVar : list) {
            Bundle bundle = new Bundle();
            bundle.putString("app_id", zzadVar.zza);
            bundle.putString("origin", zzadVar.zzb);
            bundle.putLong(AppMeasurementSdk.ConditionalUserProperty.CREATION_TIMESTAMP, zzadVar.zzd);
            bundle.putString(AppMeasurementSdk.ConditionalUserProperty.NAME, zzadVar.zzc.zza);
            zzie.zza(bundle, Preconditions.checkNotNull(zzadVar.zzc.zza()));
            bundle.putBoolean(AppMeasurementSdk.ConditionalUserProperty.ACTIVE, zzadVar.zze);
            if (zzadVar.zzf != null) {
                bundle.putString(AppMeasurementSdk.ConditionalUserProperty.TRIGGER_EVENT_NAME, zzadVar.zzf);
            }
            if (zzadVar.zzg != null) {
                zzbg zzbgVar = zzadVar.zzg;
                bundle.putString(AppMeasurementSdk.ConditionalUserProperty.TIMED_OUT_EVENT_NAME, zzbgVar.zza);
                if (zzbgVar.zzb != null) {
                    bundle.putBundle(AppMeasurementSdk.ConditionalUserProperty.TIMED_OUT_EVENT_PARAMS, zzbgVar.zzb.zzb());
                }
            }
            bundle.putLong(AppMeasurementSdk.ConditionalUserProperty.TRIGGER_TIMEOUT, zzadVar.zzh);
            if (zzadVar.zzi != null) {
                zzbg zzbgVar2 = zzadVar.zzi;
                bundle.putString(AppMeasurementSdk.ConditionalUserProperty.TRIGGERED_EVENT_NAME, zzbgVar2.zza);
                if (zzbgVar2.zzb != null) {
                    bundle.putBundle(AppMeasurementSdk.ConditionalUserProperty.TRIGGERED_EVENT_PARAMS, zzbgVar2.zzb.zzb());
                }
            }
            bundle.putLong(AppMeasurementSdk.ConditionalUserProperty.TRIGGERED_TIMESTAMP, zzadVar.zzc.zzb);
            bundle.putLong(AppMeasurementSdk.ConditionalUserProperty.TIME_TO_LIVE, zzadVar.zzj);
            if (zzadVar.zzk != null) {
                zzbg zzbgVar3 = zzadVar.zzk;
                bundle.putString(AppMeasurementSdk.ConditionalUserProperty.EXPIRED_EVENT_NAME, zzbgVar3.zza);
                if (zzbgVar3.zzb != null) {
                    bundle.putBundle(AppMeasurementSdk.ConditionalUserProperty.EXPIRED_EVENT_PARAMS, zzbgVar3.zzb.zzb());
                }
            }
            arrayList.add(bundle);
        }
        return arrayList;
    }

    zznd(zzhf zzhfVar) {
        super(zzhfVar);
        this.zzh = null;
        this.zzd = new AtomicLong(0L);
    }

    final void zza(Bundle bundle, long j) {
        long j2 = bundle.getLong("_et");
        if (j2 != 0) {
            zzj().zzu().zza("Params already contained engagement", Long.valueOf(j2));
        }
        bundle.putLong("_et", j + j2);
    }

    private static void zza(Bundle bundle, int i, String str, String str2, Object obj) {
        if (zzb(bundle, i)) {
            bundle.putString("_ev", zza(str, 40, true));
            if (obj != null) {
                Preconditions.checkNotNull(bundle);
                if (obj != null) {
                    if ((obj instanceof String) || (obj instanceof CharSequence)) {
                        bundle.putLong("_el", String.valueOf(obj).length());
                    }
                }
            }
        }
    }

    public static void zza(zzki zzkiVar, Bundle bundle, boolean z) {
        if (bundle == null || zzkiVar == null || (bundle.containsKey("_sc") && !z)) {
            if (bundle != null && zzkiVar == null && z) {
                bundle.remove("_sn");
                bundle.remove("_sc");
                bundle.remove("_si");
                return;
            }
            return;
        }
        if (zzkiVar.zza != null) {
            bundle.putString("_sn", zzkiVar.zza);
        } else {
            bundle.remove("_sn");
        }
        if (zzkiVar.zzb != null) {
            bundle.putString("_sc", zzkiVar.zzb);
        } else {
            bundle.remove("_sc");
        }
        bundle.putLong("_si", zzkiVar.zzc);
    }

    final void zza(Bundle bundle, Bundle bundle2) {
        if (bundle2 == null) {
            return;
        }
        for (String str : bundle2.keySet()) {
            if (!bundle.containsKey(str)) {
                zzq().zza(bundle, str, bundle2.get(str));
            }
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

    final void zza(Parcelable[] parcelableArr, int i, boolean z) {
        Preconditions.checkNotNull(parcelableArr);
        for (Parcelable parcelable : parcelableArr) {
            Bundle bundle = (Bundle) parcelable;
            int i2 = 0;
            for (String str : new TreeSet(bundle.keySet())) {
                if (zzh(str) && !zza(str, zzik.zzd) && (i2 = i2 + 1) > i) {
                    if (z) {
                        zzj().zzh().zza("Param can't contain more than " + i + " item-scoped custom parameters", zzi().zzb(str), zzi().zza(bundle));
                        zzb(bundle, 28);
                    } else {
                        zzj().zzh().zza("Param cannot contain item-scoped custom parameters", zzi().zzb(str), zzi().zza(bundle));
                        zzb(bundle, 23);
                    }
                    bundle.remove(str);
                }
            }
        }
    }

    final void zza(zzfv zzfvVar, int i) {
        int i2 = 0;
        for (String str : new TreeSet(zzfvVar.zzb.keySet())) {
            if (zzh(str) && (i2 = i2 + 1) > i) {
                zzj().zzh().zza("Event can't contain more than " + i + " params", zzi().zza(zzfvVar.zza), zzi().zza(zzfvVar.zzb));
                zzb(zzfvVar.zzb, 5);
                zzfvVar.zzb.remove(str);
            }
        }
    }

    public static void zza(zznf zznfVar, int i, String str, String str2, int i2) {
        zza(zznfVar, (String) null, i, str, str2, i2);
    }

    static void zza(zznf zznfVar, String str, int i, String str2, String str3, int i2) {
        Bundle bundle = new Bundle();
        zzb(bundle, i);
        if (!TextUtils.isEmpty(str2) && !TextUtils.isEmpty(str3)) {
            bundle.putString(str2, str3);
        }
        if (i == 6 || i == 7 || i == 2) {
            bundle.putLong("_el", i2);
        }
        zznfVar.zza(str, "_err", bundle);
    }

    @Override
    protected final void zzz() {
        zzt();
        SecureRandom secureRandom = new SecureRandom();
        long jNextLong = secureRandom.nextLong();
        if (jNextLong == 0) {
            jNextLong = secureRandom.nextLong();
            if (jNextLong == 0) {
                zzj().zzu().zza("Utils falling back to Random for random id");
            }
        }
        this.zzd.set(jNextLong);
    }

    final void zza(Bundle bundle, String str, Object obj) {
        if (bundle == null) {
            return;
        }
        if (obj instanceof Long) {
            bundle.putLong(str, ((Long) obj).longValue());
            return;
        }
        if (obj instanceof String) {
            bundle.putString(str, String.valueOf(obj));
            return;
        }
        if (obj instanceof Double) {
            bundle.putDouble(str, ((Double) obj).doubleValue());
        } else if (obj instanceof Bundle[]) {
            bundle.putParcelableArray(str, (Bundle[]) obj);
        } else if (str != null) {
            zzj().zzv().zza("Not putting event parameter. Invalid value type. name, type", zzi().zzb(str), obj != null ? obj.getClass().getSimpleName() : null);
        }
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, boolean z) {
        Bundle bundle = new Bundle();
        bundle.putBoolean("r", z);
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            this.zzu.zzj().zzu().zza("Error returning boolean value to wrapper", e);
        }
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, ArrayList<Bundle> arrayList) {
        Bundle bundle = new Bundle();
        bundle.putParcelableArrayList("r", arrayList);
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            this.zzu.zzj().zzu().zza("Error returning bundle list to wrapper", e);
        }
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, Bundle bundle) {
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            this.zzu.zzj().zzu().zza("Error returning bundle value to wrapper", e);
        }
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, byte[] bArr) {
        Bundle bundle = new Bundle();
        bundle.putByteArray("r", bArr);
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            this.zzu.zzj().zzu().zza("Error returning byte array to wrapper", e);
        }
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, int i) {
        Bundle bundle = new Bundle();
        bundle.putInt("r", i);
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            this.zzu.zzj().zzu().zza("Error returning int value to wrapper", e);
        }
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, long j) {
        Bundle bundle = new Bundle();
        bundle.putLong("r", j);
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            this.zzu.zzj().zzu().zza("Error returning long value to wrapper", e);
        }
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, String str) {
        Bundle bundle = new Bundle();
        bundle.putString("r", str);
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            this.zzu.zzj().zzu().zza("Error returning string value to wrapper", e);
        }
    }

    private final void zza(String str, String str2, String str3, Bundle bundle, List<String> list, boolean z) {
        int iZzl;
        int iZza;
        if (bundle == null) {
            return;
        }
        int iZzc = zze().zzc();
        int i = 0;
        for (String str4 : new TreeSet(bundle.keySet())) {
            if (list == null || !list.contains(str4)) {
                iZzl = !z ? zzl(str4) : 0;
                if (iZzl == 0) {
                    iZzl = zzk(str4);
                }
            } else {
                iZzl = 0;
            }
            if (iZzl != 0) {
                zza(bundle, iZzl, str4, str4, iZzl == 3 ? str4 : null);
                bundle.remove(str4);
            } else {
                if (zza(bundle.get(str4))) {
                    zzj().zzv().zza("Nested Bundle parameters are not allowed; discarded. event name, param name, child param name", str2, str3, str4);
                    iZza = 22;
                } else {
                    iZza = zza(str, str2, str4, bundle.get(str4), bundle, list, z, false);
                }
                if (iZza != 0 && !"_ev".equals(str4)) {
                    zza(bundle, iZza, str4, str4, bundle.get(str4));
                    bundle.remove(str4);
                } else if (zzh(str4) && !zza(str4, zzik.zzd)) {
                    int i2 = i + 1;
                    if (!zza(231100000, true)) {
                        zzj().zzh().zza("Item array not supported on client's version of Google Play Services (Android Only)", zzi().zza(str2), zzi().zza(bundle));
                        zzb(bundle, 23);
                        bundle.remove(str4);
                    } else if (i2 > iZzc) {
                        if (zzot.zza() && zze().zza(zzbi.zzcc)) {
                            zzj().zzh().zza("Item can't contain more than " + iZzc + " item-scoped custom params", zzi().zza(str2), zzi().zza(bundle));
                            zzb(bundle, 28);
                            bundle.remove(str4);
                        } else {
                            zzj().zzh().zza("Item cannot contain custom parameters", zzi().zza(str2), zzi().zza(bundle));
                            zzb(bundle, 23);
                            bundle.remove(str4);
                        }
                    }
                    i = i2;
                }
            }
        }
    }

    private static boolean zzb(Bundle bundle, int i) {
        if (bundle == null || bundle.getLong("_err") != 0) {
            return false;
        }
        bundle.putLong("_err", i);
        return true;
    }

    static boolean zzd(String str) {
        String strZza = zzbi.zzay.zza(null);
        return strZza.equals("*") || Arrays.asList(strZza.split(",")).contains(str);
    }

    private static boolean zza(String str, String[] strArr) {
        Preconditions.checkNotNull(strArr);
        for (String str2 : strArr) {
            if (zzng.zza(str, str2)) {
                return true;
            }
        }
        return false;
    }

    final boolean zza(String str, String str2) {
        if (!TextUtils.isEmpty(str)) {
            if (zzn(str)) {
                return true;
            }
            if (this.zzu.zzae()) {
                zzj().zzh().zza("Invalid google_app_id. Firebase Analytics disabled. See https://goo.gl/NAOOOI. provided id", zzfr.zza(str));
            }
            return false;
        }
        if (!TextUtils.isEmpty(str2)) {
            if (zzn(str2)) {
                return true;
            }
            zzj().zzh().zza("Invalid admob_app_id. Analytics disabled.", zzfr.zza(str2));
            return false;
        }
        if (this.zzu.zzae()) {
            zzj().zzh().zza("Missing google_app_id. Firebase Analytics disabled. See https://goo.gl/NAOOOI");
        }
        return false;
    }

    final boolean zza(String str, int i, String str2) {
        if (str2 == null) {
            zzj().zzh().zza("Name is required and can't be null. Type", str);
            return false;
        }
        if (str2.codePointCount(0, str2.length()) <= i) {
            return true;
        }
        zzj().zzh().zza("Name is too long. Type, maximum supported length, name", str, Integer.valueOf(i), str2);
        return false;
    }

    final boolean zza(String str, String[] strArr, String str2) {
        return zza(str, strArr, (String[]) null, str2);
    }

    final boolean zza(String str, String[] strArr, String[] strArr2, String str2) {
        if (str2 == null) {
            zzj().zzh().zza("Name is required and can't be null. Type", str);
            return false;
        }
        Preconditions.checkNotNull(str2);
        for (String str3 : zza) {
            if (str2.startsWith(str3)) {
                zzj().zzh().zza("Name starts with reserved prefix. Type, name", str, str2);
                return false;
            }
        }
        if (strArr == null || !zza(str2, strArr)) {
            return true;
        }
        if (strArr2 != null && zza(str2, strArr2)) {
            return true;
        }
        zzj().zzh().zza("Name is reserved. Type, name", str, str2);
        return false;
    }

    final boolean zza(String str, String str2, int i, Object obj) {
        if (obj != null && !(obj instanceof Long) && !(obj instanceof Float) && !(obj instanceof Integer) && !(obj instanceof Byte) && !(obj instanceof Short) && !(obj instanceof Boolean) && !(obj instanceof Double)) {
            if (!(obj instanceof String) && !(obj instanceof Character) && !(obj instanceof CharSequence)) {
                return false;
            }
            String strValueOf = String.valueOf(obj);
            if (strValueOf.codePointCount(0, strValueOf.length()) > i) {
                zzj().zzv().zza("Value is too long; discarded. Value kind, name, value length", str, str2, Integer.valueOf(strValueOf.length()));
                return false;
            }
        }
        return true;
    }

    final boolean zzb(String str, String str2) {
        if (str2 == null) {
            zzj().zzh().zza("Name is required and can't be null. Type", str);
            return false;
        }
        if (str2.length() == 0) {
            zzj().zzh().zza("Name is required and can't be empty. Type", str);
            return false;
        }
        int iCodePointAt = str2.codePointAt(0);
        if (!Character.isLetter(iCodePointAt) && iCodePointAt != 95) {
            zzj().zzh().zza("Name must start with a letter or _ (underscore). Type, name", str, str2);
            return false;
        }
        int length = str2.length();
        int iCharCount = Character.charCount(iCodePointAt);
        while (iCharCount < length) {
            int iCodePointAt2 = str2.codePointAt(iCharCount);
            if (iCodePointAt2 != 95 && !Character.isLetterOrDigit(iCodePointAt2)) {
                zzj().zzh().zza("Name must consist of letters, digits or _ (underscores). Type, name", str, str2);
                return false;
            }
            iCharCount += Character.charCount(iCodePointAt2);
        }
        return true;
    }

    final boolean zzc(String str, String str2) {
        if (str2 == null) {
            zzj().zzh().zza("Name is required and can't be null. Type", str);
            return false;
        }
        if (str2.length() == 0) {
            zzj().zzh().zza("Name is required and can't be empty. Type", str);
            return false;
        }
        int iCodePointAt = str2.codePointAt(0);
        if (!Character.isLetter(iCodePointAt)) {
            zzj().zzh().zza("Name must start with a letter. Type, name", str, str2);
            return false;
        }
        int length = str2.length();
        int iCharCount = Character.charCount(iCodePointAt);
        while (iCharCount < length) {
            int iCodePointAt2 = str2.codePointAt(iCharCount);
            if (iCodePointAt2 != 95 && !Character.isLetterOrDigit(iCodePointAt2)) {
                zzj().zzh().zza("Name must consist of letters, digits or _ (underscores). Type, name", str, str2);
                return false;
            }
            iCharCount += Character.charCount(iCodePointAt2);
        }
        return true;
    }

    static boolean zza(Bundle bundle, int i) {
        int i2 = 0;
        if (bundle.size() <= i) {
            return false;
        }
        for (String str : new TreeSet(bundle.keySet())) {
            i2++;
            if (i2 > i) {
                bundle.remove(str);
            }
        }
        return true;
    }

    private final boolean zzy() {
        Object e;
        Integer num;
        boolean z;
        if (this.zzg == null) {
            MeasurementManagerFutures measurementManagerFuturesZzn = zzn();
            if (measurementManagerFuturesZzn == null) {
                return false;
            }
            try {
                num = (Integer) measurementManagerFuturesZzn.getMeasurementApiStatusAsync().get(10000L, TimeUnit.MILLISECONDS);
                if (num != null) {
                    try {
                        z = true;
                        if (num.intValue() != 1) {
                            z = false;
                        }
                        this.zzg = Boolean.valueOf(z);
                    } catch (InterruptedException e2) {
                        e = e2;
                        zzj().zzu().zza("Measurement manager api exception", e);
                        this.zzg = false;
                    } catch (CancellationException e3) {
                        e = e3;
                        zzj().zzu().zza("Measurement manager api exception", e);
                        this.zzg = false;
                    } catch (ExecutionException e4) {
                        e = e4;
                        zzj().zzu().zza("Measurement manager api exception", e);
                        this.zzg = false;
                    } catch (TimeoutException e5) {
                        e = e5;
                        zzj().zzu().zza("Measurement manager api exception", e);
                        this.zzg = false;
                    }
                    zzj().zzp().zza("Measurement manager api status result", num);
                } else {
                    z = false;
                    this.zzg = Boolean.valueOf(z);
                    zzj().zzp().zza("Measurement manager api status result", num);
                }
            } catch (InterruptedException | CancellationException | ExecutionException | TimeoutException e6) {
                e = e6;
                num = null;
            }
        }
        return this.zzg.booleanValue();
    }

    final boolean zze(String str) {
        zzt();
        if (Wrappers.packageManager(zza()).checkCallingOrSelfPermission(str) == 0) {
            return true;
        }
        zzj().zzc().zza("Permission not granted", str);
        return false;
    }

    final boolean zzf(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        return zze().zzn().equals(str);
    }

    static boolean zza(Object obj) {
        return (obj instanceof Parcelable[]) || (obj instanceof ArrayList) || (obj instanceof Bundle);
    }

    private final boolean zzb(Context context, String str) {
        X500Principal x500Principal = new X500Principal("CN=Android Debug,O=Android,C=US");
        try {
            PackageInfo packageInfo = Wrappers.packageManager(context).getPackageInfo(str, 64);
            if (packageInfo == null || packageInfo.signatures == null || packageInfo.signatures.length <= 0) {
                return true;
            }
            return ((X509Certificate) CertificateFactory.getInstance("X.509").generateCertificate(new ByteArrayInputStream(packageInfo.signatures[0].toByteArray()))).getSubjectX500Principal().equals(x500Principal);
        } catch (PackageManager.NameNotFoundException e) {
            zzj().zzg().zza("Package name not found", e);
            return true;
        } catch (CertificateException e2) {
            zzj().zzg().zza("Error obtaining certificate", e2);
            return true;
        }
    }

    final boolean zzw() {
        zzt();
        return zzh() == 1;
    }

    public final boolean zzx() {
        try {
            zza().getClassLoader().loadClass("com.google.firebase.remoteconfig.FirebaseRemoteConfig");
            return true;
        } catch (ClassNotFoundException unused) {
            return false;
        }
    }

    public final boolean zza(int i, boolean z) {
        Boolean boolZzab = this.zzu.zzr().zzab();
        if (zzg() < i / 1000) {
            return (boolZzab == null || boolZzab.booleanValue()) ? false : true;
        }
        return true;
    }

    static boolean zzg(String str) {
        return !TextUtils.isEmpty(str) && str.startsWith("_");
    }

    static boolean zzh(String str) {
        Preconditions.checkNotEmpty(str);
        return str.charAt(0) != '_' || str.equals("_ep");
    }

    static boolean zza(Context context) {
        ActivityInfo receiverInfo;
        Preconditions.checkNotNull(context);
        try {
            PackageManager packageManager = context.getPackageManager();
            return (packageManager == null || (receiverInfo = packageManager.getReceiverInfo(new ComponentName(context, "com.google.android.gms.measurement.AppMeasurementReceiver"), 0)) == null || !receiverInfo.enabled) ? false : true;
        } catch (PackageManager.NameNotFoundException unused) {
        }
    }

    private static boolean zzc(Context context, String str) {
        ServiceInfo serviceInfo;
        try {
            PackageManager packageManager = context.getPackageManager();
            return (packageManager == null || (serviceInfo = packageManager.getServiceInfo(new ComponentName(context, str), 0)) == null || !serviceInfo.enabled) ? false : true;
        } catch (PackageManager.NameNotFoundException unused) {
        }
    }

    static boolean zza(Context context, boolean z) {
        Preconditions.checkNotNull(context);
        if (Build.VERSION.SDK_INT >= 24) {
            return zzc(context, "com.google.android.gms.measurement.AppMeasurementJobService");
        }
        return zzc(context, "com.google.android.gms.measurement.AppMeasurementService");
    }

    public final boolean zzi(String str) {
        List<ResolveInfo> listQueryIntentActivities;
        return (TextUtils.isEmpty(str) || (listQueryIntentActivities = zza().getPackageManager().queryIntentActivities(new Intent("android.intent.action.VIEW", Uri.parse(str)), 0)) == null || listQueryIntentActivities.isEmpty()) ? false : true;
    }

    final boolean zza(String str, double d) {
        try {
            SharedPreferences.Editor editorEdit = zza().getSharedPreferences("google.analytics.deferred.deeplink.prefs", 0).edit();
            editorEdit.putString("deeplink", str);
            editorEdit.putLong("timestamp", Double.doubleToRawLongBits(d));
            return editorEdit.commit();
        } catch (RuntimeException e) {
            zzj().zzg().zza("Failed to persist Deferred Deep Link. exception", e);
            return false;
        }
    }

    static boolean zza(Intent intent) {
        String stringExtra = intent.getStringExtra("android.intent.extra.REFERRER_NAME");
        return "android-app://com.google.android.googlequicksearchbox/https/www.google.com".equals(stringExtra) || "https://www.google.com".equals(stringExtra) || "android-app://com.google.appcrawler".equals(stringExtra);
    }

    public static boolean zzj(String str) {
        for (String str2 : zzb) {
            if (str2.equals(str)) {
                return false;
            }
        }
        return true;
    }

    static boolean zza(String str, String str2, String str3, String str4) {
        boolean zIsEmpty = TextUtils.isEmpty(str);
        boolean zIsEmpty2 = TextUtils.isEmpty(str2);
        if (!zIsEmpty && !zIsEmpty2) {
            Preconditions.checkNotNull(str);
            return !str.equals(str2);
        }
        if (zIsEmpty && zIsEmpty2) {
            if (TextUtils.isEmpty(str3) || TextUtils.isEmpty(str4)) {
                return !TextUtils.isEmpty(str4);
            }
            return !str3.equals(str4);
        }
        if (zIsEmpty || !zIsEmpty2) {
            return TextUtils.isEmpty(str3) || !str3.equals(str4);
        }
        if (TextUtils.isEmpty(str4)) {
            return false;
        }
        return TextUtils.isEmpty(str3) || !str3.equals(str4);
    }

    private static boolean zzn(String str) {
        Preconditions.checkNotNull(str);
        return str.matches("^(1:\\d+:android:[a-f0-9]+|ca-app-pub-.*)$");
    }

    static byte[] zza(Parcelable parcelable) {
        if (parcelable == null) {
            return null;
        }
        Parcel parcelObtain = Parcel.obtain();
        try {
            parcelable.writeToParcel(parcelObtain, 0);
            return parcelObtain.marshall();
        } finally {
            parcelObtain.recycle();
        }
    }

    static Bundle[] zzb(Object obj) {
        if (obj instanceof Bundle) {
            return new Bundle[]{(Bundle) obj};
        }
        if (obj instanceof Parcelable[]) {
            Parcelable[] parcelableArr = (Parcelable[]) obj;
            return (Bundle[]) Arrays.copyOf(parcelableArr, parcelableArr.length, Bundle[].class);
        }
        if (!(obj instanceof ArrayList)) {
            return null;
        }
        ArrayList arrayList = (ArrayList) obj;
        return (Bundle[]) arrayList.toArray(new Bundle[arrayList.size()]);
    }
}
