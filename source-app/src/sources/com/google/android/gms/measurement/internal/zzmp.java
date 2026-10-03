package com.google.android.gms.measurement.internal;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Pair;
import androidx.collection.ArrayMap;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.stats.ConnectionTracker;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.common.wrappers.Wrappers;
import com.google.android.gms.internal.measurement.zznk;
import com.google.android.gms.internal.measurement.zznp;
import com.google.android.gms.internal.measurement.zznq;
import com.google.android.gms.internal.measurement.zzoi;
import com.google.android.gms.internal.measurement.zzon;
import com.google.android.gms.internal.measurement.zzot;
import com.google.android.gms.internal.measurement.zzpg;
import com.google.android.gms.internal.measurement.zzps;
import com.google.android.gms.internal.measurement.zzqd;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.google.common.net.HttpHeaders;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.messaging.Constants;
import com.ishumei.smantifraud.l11l11lI1lll;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.math.BigInteger;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.channels.OverlappingFileLockException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class zzmp implements zzif {
    private static volatile zzmp zza;
    private List<Long> zzaa;
    private long zzab;
    private final Map<String, zzih> zzac;
    private final Map<String, zzay> zzad;
    private final Map<String, zzb> zzae;
    private zzki zzaf;
    private String zzag;
    private final zznf zzah;
    private zzgp zzb;
    private zzfy zzc;
    private zzao zzd;
    private zzgb zze;
    private zzmj zzf;
    private zzt zzg;
    private final zzmz zzh;
    private zzkg zzi;
    private zzls zzj;
    private final zzmn zzk;
    private zzgm zzl;
    private final zzhf zzm;
    private boolean zzn;
    private boolean zzo;
    private long zzp;
    private List<Runnable> zzq;
    private final Set<String> zzr;
    private int zzs;
    private int zzt;
    private boolean zzu;
    private boolean zzv;
    private boolean zzw;
    private FileLock zzx;
    private FileChannel zzy;
    private List<Long> zzz;

    private class zza implements zzas {
        com.google.android.gms.internal.measurement.zzfi.zzj zza;
        List<Long> zzb;
        List<com.google.android.gms.internal.measurement.zzfi.zze> zzc;
        private long zzd;

        private static long zza(com.google.android.gms.internal.measurement.zzfi.zze zzeVar) {
            return ((zzeVar.zzd() / 1000) / 60) / 60;
        }

        private zza() {
        }

        @Override
        public final void zza(com.google.android.gms.internal.measurement.zzfi.zzj zzjVar) {
            Preconditions.checkNotNull(zzjVar);
            this.zza = zzjVar;
        }

        @Override
        public final boolean zza(long j, com.google.android.gms.internal.measurement.zzfi.zze zzeVar) {
            Preconditions.checkNotNull(zzeVar);
            if (this.zzc == null) {
                this.zzc = new ArrayList();
            }
            if (this.zzb == null) {
                this.zzb = new ArrayList();
            }
            if (!this.zzc.isEmpty() && zza(this.zzc.get(0)) != zza(zzeVar)) {
                return false;
            }
            long jZzbw = this.zzd + ((long) zzeVar.zzbw());
            zzmp.this.zze();
            if (jZzbw >= Math.max(0, zzbi.zzi.zza(null).intValue())) {
                return false;
            }
            this.zzd = jZzbw;
            this.zzc.add(zzeVar);
            this.zzb.add(Long.valueOf(j));
            int size = this.zzc.size();
            zzmp.this.zze();
            return size < Math.max(1, zzbi.zzj.zza(null).intValue());
        }
    }

    private class zzb {
        final String zza;
        long zzb;

        private zzb(zzmp zzmpVar) {
            this(zzmpVar, zzmpVar.zzq().zzp());
        }

        private zzb(zzmp zzmpVar, String str) {
            this.zza = str;
            this.zzb = zzmpVar.zzb().elapsedRealtime();
        }
    }

    private final int zza(FileChannel fileChannel) {
        zzl().zzt();
        if (fileChannel == null || !fileChannel.isOpen()) {
            zzj().zzg().zza("Bad channel to read from");
            return 0;
        }
        ByteBuffer byteBufferAllocate = ByteBuffer.allocate(4);
        try {
            fileChannel.position(0L);
            int i = fileChannel.read(byteBufferAllocate);
            if (i == 4) {
                byteBufferAllocate.flip();
                return byteBufferAllocate.getInt();
            }
            if (i != -1) {
                zzj().zzu().zza("Unexpected data length. Bytes read", Integer.valueOf(i));
            }
            return 0;
        } catch (IOException e) {
            zzj().zzg().zza("Failed to read from channel", e);
            return 0;
        }
    }

    private final long zzx() {
        long jCurrentTimeMillis = zzb().currentTimeMillis();
        zzls zzlsVar = this.zzj;
        zzlsVar.zzak();
        zzlsVar.zzt();
        long jZza = zzlsVar.zze.zza();
        if (jZza == 0) {
            jZza = ((long) zzlsVar.zzq().zzv().nextInt(86400000)) + 1;
            zzlsVar.zze.zza(jZza);
        }
        return ((((jCurrentTimeMillis + jZza) / 1000) / 60) / 60) / 24;
    }

    @Override
    public final Context zza() {
        return this.zzm.zza();
    }

    final Bundle zza(String str) {
        boolean zEquals;
        zzl().zzt();
        zzs();
        if (!zznp.zza() || zzi().zzb(str) == null) {
            return null;
        }
        Bundle bundle = new Bundle();
        zzih zzihVarZzb = zzb(str);
        bundle.putAll(zzihVarZzb.zzb());
        bundle.putAll(zza(str, zzd(str), zzihVarZzb, new zzak()).zzb());
        if (zzp().zzc(str)) {
            zEquals = true;
        } else {
            zzne zzneVarZze = zzf().zze(str, "_npa");
            if (zzneVarZze != null) {
                zEquals = zzneVarZze.zze.equals(1L);
            } else if (this.zzb.zzb(str, zzih.zza.AD_PERSONALIZATION)) {
                zEquals = false;
            } else {
                zEquals = true;
            }
        }
        bundle.putString("ad_personalization", zEquals ? "denied" : "granted");
        return bundle;
    }

    @Override
    public final Clock zzb() {
        return ((zzhf) Preconditions.checkNotNull(this.zzm)).zzb();
    }

    final zzh zza(zzo zzoVar) {
        String strZza;
        zzl().zzt();
        zzs();
        Preconditions.checkNotNull(zzoVar);
        Preconditions.checkNotEmpty(zzoVar.zza);
        if (!zzoVar.zzu.isEmpty()) {
            this.zzae.put(zzoVar.zza, new zzb(zzoVar.zzu));
        }
        zzh zzhVarZzd = zzf().zzd(zzoVar.zza);
        zzih zzihVarZza = zzb(zzoVar.zza).zza(zzih.zza(zzoVar.zzt));
        if (zzihVarZza.zzg()) {
            strZza = this.zzj.zza(zzoVar.zza, zzoVar.zzn);
        } else {
            strZza = "";
        }
        if (zzhVarZzd == null) {
            zzhVarZzd = new zzh(this.zzm, zzoVar.zza);
            if (zzihVarZza.zzh()) {
                zzhVarZzd.zzb(zza(zzihVarZza));
            }
            if (zzihVarZza.zzg()) {
                zzhVarZzd.zzh(strZza);
            }
        } else if (zzihVarZza.zzg() && strZza != null && !strZza.equals(zzhVarZzd.zzae())) {
            zzhVarZzd.zzh(strZza);
            if (zzoVar.zzn && !"00000000-0000-0000-0000-000000000000".equals(this.zzj.zza(zzoVar.zza, zzihVarZza).first)) {
                zzhVarZzd.zzb(zza(zzihVarZza));
                if (zzf().zze(zzoVar.zza, "_id") != null && zzf().zze(zzoVar.zza, "_lair") == null) {
                    zzf().zza(new zzne(zzoVar.zza, "auto", "_lair", zzb().currentTimeMillis(), 1L));
                }
            }
        } else if (TextUtils.isEmpty(zzhVarZzd.zzy()) && zzihVarZza.zzh()) {
            zzhVarZzd.zzb(zza(zzihVarZza));
        }
        zzhVarZzd.zzf(zzoVar.zzb);
        zzhVarZzd.zza(zzoVar.zzp);
        if (!TextUtils.isEmpty(zzoVar.zzk)) {
            zzhVarZzd.zze(zzoVar.zzk);
        }
        if (zzoVar.zze != 0) {
            zzhVarZzd.zzm(zzoVar.zze);
        }
        if (!TextUtils.isEmpty(zzoVar.zzc)) {
            zzhVarZzd.zzd(zzoVar.zzc);
        }
        zzhVarZzd.zza(zzoVar.zzj);
        if (zzoVar.zzd != null) {
            zzhVarZzd.zzc(zzoVar.zzd);
        }
        zzhVarZzd.zzj(zzoVar.zzf);
        zzhVarZzd.zzb(zzoVar.zzh);
        if (!TextUtils.isEmpty(zzoVar.zzg)) {
            zzhVarZzd.zzg(zzoVar.zzg);
        }
        zzhVarZzd.zza(zzoVar.zzn);
        zzhVarZzd.zza(zzoVar.zzq);
        zzhVarZzd.zzk(zzoVar.zzr);
        if (zzps.zza() && (zze().zza(zzbi.zzbr) || zze().zze(zzoVar.zza, zzbi.zzbt))) {
            zzhVarZzd.zzi(zzoVar.zzv);
        }
        if (zznq.zza() && zze().zza(zzbi.zzbq)) {
            zzhVarZzd.zza(zzoVar.zzs);
        } else if (zznq.zza() && zze().zza(zzbi.zzbp)) {
            zzhVarZzd.zza((List<String>) null);
        }
        if (zzqd.zza() && zze().zza(zzbi.zzbu)) {
            zzhVarZzd.zzc(zzoVar.zzw);
        }
        if (zzpg.zza() && zze().zza(zzbi.zzcf)) {
            zzhVarZzd.zza(zzoVar.zzaa);
        }
        zzhVarZzd.zzr(zzoVar.zzx);
        if (zzhVarZzd.zzal()) {
            zzf().zza(zzhVarZzd);
        }
        return zzhVarZzd;
    }

    private final zzo zzc(String str) {
        String strZzf;
        int iZza;
        zzh zzhVarZzd = zzf().zzd(str);
        if (zzhVarZzd == null || TextUtils.isEmpty(zzhVarZzd.zzaa())) {
            zzj().zzc().zza("No app data available; dropping", str);
            return null;
        }
        Boolean boolZza = zza(zzhVarZzd);
        if (boolZza != null && !boolZza.booleanValue()) {
            zzj().zzg().zza("App version does not match; dropping. appId", zzfr.zza(str));
            return null;
        }
        zzih zzihVarZzb = zzb(str);
        if (zznp.zza() && zze().zza(zzbi.zzcm)) {
            strZzf = zzd(str).zzf();
            iZza = zzihVarZzb.zza();
        } else {
            strZzf = "";
            iZza = 100;
        }
        int i = iZza;
        return new zzo(str, zzhVarZzd.zzac(), zzhVarZzd.zzaa(), zzhVarZzd.zzc(), zzhVarZzd.zzz(), zzhVarZzd.zzo(), zzhVarZzd.zzl(), (String) null, zzhVarZzd.zzak(), false, zzhVarZzd.zzab(), zzhVarZzd.zzb(), 0L, 0, zzhVarZzd.zzaj(), false, zzhVarZzd.zzv(), zzhVarZzd.zzu(), zzhVarZzd.zzm(), zzhVarZzd.zzag(), (String) null, zzihVarZzb.zze(), "", (String) null, zzhVarZzd.zzam(), zzhVarZzd.zzt(), i, strZzf, zzhVarZzd.zza(), zzhVarZzd.zzd());
    }

    public final zzt zzc() {
        return (zzt) zza(this.zzg);
    }

    @Override
    public final zzae zzd() {
        return this.zzm.zzd();
    }

    public final zzaf zze() {
        return ((zzhf) Preconditions.checkNotNull(this.zzm)).zzf();
    }

    public final zzao zzf() {
        return (zzao) zza(this.zzd);
    }

    private final zzay zza(String str, zzay zzayVar, zzih zzihVar, zzak zzakVar) {
        if (zznp.zza()) {
            int iZza = 90;
            if (zzi().zzb(str) == null) {
                if (zzayVar.zzc() == Boolean.FALSE) {
                    iZza = zzayVar.zza();
                    zzakVar.zza(zzih.zza.AD_USER_DATA, iZza);
                } else {
                    zzakVar.zza(zzih.zza.AD_USER_DATA, zzaj.FAILSAFE);
                }
                return new zzay((Boolean) false, iZza, (Boolean) true, "-");
            }
            Boolean boolZzc = zzayVar.zzc();
            if (boolZzc != null) {
                iZza = zzayVar.zza();
                zzakVar.zza(zzih.zza.AD_USER_DATA, iZza);
            } else {
                if (this.zzb.zza(str, zzih.zza.AD_USER_DATA) == zzih.zza.AD_STORAGE && zzihVar.zzc() != null) {
                    Boolean boolZzc2 = zzihVar.zzc();
                    zzakVar.zza(zzih.zza.AD_USER_DATA, zzaj.REMOTE_DELEGATION);
                    boolZzc = boolZzc2;
                }
                if (boolZzc == null) {
                    boolZzc = Boolean.valueOf(this.zzb.zzb(str, zzih.zza.AD_USER_DATA));
                    zzakVar.zza(zzih.zza.AD_USER_DATA, zzaj.REMOTE_DEFAULT);
                }
            }
            Preconditions.checkNotNull(boolZzc);
            boolean zZzn = this.zzb.zzn(str);
            SortedSet<String> sortedSetZzh = zzi().zzh(str);
            if (!boolZzc.booleanValue() || sortedSetZzh.isEmpty()) {
                return new zzay((Boolean) false, iZza, Boolean.valueOf(zZzn), "-");
            }
            return new zzay((Boolean) true, iZza, Boolean.valueOf(zZzn), zZzn ? TextUtils.join("", sortedSetZzh) : "");
        }
        return zzay.zza;
    }

    private final zzay zzd(String str) {
        zzl().zzt();
        zzs();
        if (zznp.zza()) {
            zzay zzayVar = this.zzad.get(str);
            if (zzayVar != null) {
                return zzayVar;
            }
            zzay zzayVarZzf = zzf().zzf(str);
            this.zzad.put(str, zzayVarZzf);
            return zzayVarZzf;
        }
        return zzay.zza;
    }

    public final zzfq zzg() {
        return this.zzm.zzk();
    }

    @Override
    public final zzfr zzj() {
        return ((zzhf) Preconditions.checkNotNull(this.zzm)).zzj();
    }

    public final zzfy zzh() {
        return (zzfy) zza(this.zzc);
    }

    private final zzgb zzy() {
        zzgb zzgbVar = this.zze;
        if (zzgbVar != null) {
            return zzgbVar;
        }
        throw new IllegalStateException("Network broadcast receiver not created");
    }

    public final zzgp zzi() {
        return (zzgp) zza(this.zzb);
    }

    @Override
    public final zzgy zzl() {
        return ((zzhf) Preconditions.checkNotNull(this.zzm)).zzl();
    }

    final zzhf zzk() {
        return this.zzm;
    }

    final zzih zzb(String str) {
        zzl().zzt();
        zzs();
        zzih zzihVarZzg = this.zzac.get(str);
        if (zzihVarZzg == null) {
            zzihVarZzg = zzf().zzg(str);
            if (zzihVarZzg == null) {
                zzihVarZzg = zzih.zza;
            }
            zza(str, zzihVarZzg);
        }
        return zzihVarZzg;
    }

    public final zzkg zzm() {
        return (zzkg) zza(this.zzi);
    }

    public final zzls zzn() {
        return this.zzj;
    }

    private final zzmj zzz() {
        return (zzmj) zza(this.zzf);
    }

    private static zzmo zza(zzmo zzmoVar) {
        if (zzmoVar == null) {
            throw new IllegalStateException("Upload Component not created");
        }
        if (zzmoVar.zzam()) {
            return zzmoVar;
        }
        throw new IllegalStateException("Component not initialized: " + String.valueOf(zzmoVar.getClass()));
    }

    public final zzmn zzo() {
        return this.zzk;
    }

    public static zzmp zza(Context context) {
        Preconditions.checkNotNull(context);
        Preconditions.checkNotNull(context.getApplicationContext());
        if (zza == null) {
            synchronized (zzmp.class) {
                if (zza == null) {
                    zza = new zzmp((zzna) Preconditions.checkNotNull(new zzna(context)));
                }
            }
        }
        return zza;
    }

    public final zzmz zzp() {
        return (zzmz) zza(this.zzh);
    }

    public final zznd zzq() {
        return ((zzhf) Preconditions.checkNotNull(this.zzm)).zzt();
    }

    private final Boolean zza(zzh zzhVar) {
        try {
            if (zzhVar.zzc() != -2147483648L) {
                if (zzhVar.zzc() == Wrappers.packageManager(this.zzm.zza()).getPackageInfo(zzhVar.zzx(), 0).versionCode) {
                    return true;
                }
            } else {
                String str = Wrappers.packageManager(this.zzm.zza()).getPackageInfo(zzhVar.zzx(), 0).versionName;
                String strZzaa = zzhVar.zzaa();
                if (strZzaa != null && strZzaa.equals(str)) {
                    return true;
                }
            }
            return false;
        } catch (PackageManager.NameNotFoundException unused) {
            return null;
        }
    }

    private final String zza(zzih zzihVar) {
        if (!zzihVar.zzh()) {
            return null;
        }
        byte[] bArr = new byte[16];
        zzq().zzv().nextBytes(bArr);
        return String.format(Locale.US, "%032x", new BigInteger(1, bArr));
    }

    final String zzb(zzo zzoVar) {
        try {
            return (String) zzl().zza(new zzmt(this, zzoVar)).get(30000L, TimeUnit.MILLISECONDS);
        } catch (InterruptedException | ExecutionException | TimeoutException e) {
            zzj().zzg().zza("Failed to get app instance id. appId", zzfr.zza(zzoVar.zza), e);
            return null;
        }
    }

    static void zza(zzmp zzmpVar, zzna zznaVar) {
        zzmpVar.zzl().zzt();
        zzmpVar.zzl = new zzgm(zzmpVar);
        zzao zzaoVar = new zzao(zzmpVar);
        zzaoVar.zzal();
        zzmpVar.zzd = zzaoVar;
        zzmpVar.zze().zza((zzah) Preconditions.checkNotNull(zzmpVar.zzb));
        zzls zzlsVar = new zzls(zzmpVar);
        zzlsVar.zzal();
        zzmpVar.zzj = zzlsVar;
        zzt zztVar = new zzt(zzmpVar);
        zztVar.zzal();
        zzmpVar.zzg = zztVar;
        zzkg zzkgVar = new zzkg(zzmpVar);
        zzkgVar.zzal();
        zzmpVar.zzi = zzkgVar;
        zzmj zzmjVar = new zzmj(zzmpVar);
        zzmjVar.zzal();
        zzmpVar.zzf = zzmjVar;
        zzmpVar.zze = new zzgb(zzmpVar);
        if (zzmpVar.zzs != zzmpVar.zzt) {
            zzmpVar.zzj().zzg().zza("Not all upload components initialized", Integer.valueOf(zzmpVar.zzs), Integer.valueOf(zzmpVar.zzt));
        }
        zzmpVar.zzn = true;
    }

    private zzmp(zzna zznaVar) {
        this(zznaVar, null);
    }

    private zzmp(zzna zznaVar, zzhf zzhfVar) {
        this.zzn = false;
        this.zzr = new HashSet();
        this.zzah = new zzmw(this);
        Preconditions.checkNotNull(zznaVar);
        this.zzm = zzhf.zza(zznaVar.zza, null, null);
        this.zzab = -1L;
        this.zzk = new zzmn(this);
        zzmz zzmzVar = new zzmz(this);
        zzmzVar.zzal();
        this.zzh = zzmzVar;
        zzfy zzfyVar = new zzfy(this);
        zzfyVar.zzal();
        this.zzc = zzfyVar;
        zzgp zzgpVar = new zzgp(this);
        zzgpVar.zzal();
        this.zzb = zzgpVar;
        this.zzac = new HashMap();
        this.zzad = new HashMap();
        this.zzae = new HashMap();
        zzl().zzb(new zzms(this, zznaVar));
    }

    final void zza(Runnable runnable) {
        zzl().zzt();
        if (this.zzq == null) {
            this.zzq = new ArrayList();
        }
        this.zzq.add(runnable);
    }

    final void zzr() {
        zzl().zzt();
        zzs();
        if (this.zzo) {
            return;
        }
        this.zzo = true;
        if (zzad()) {
            int iZza = zza(this.zzy);
            int iZzab = this.zzm.zzh().zzab();
            zzl().zzt();
            if (iZza > iZzab) {
                zzj().zzg().zza("Panic: can't downgrade version. Previous, current version", Integer.valueOf(iZza), Integer.valueOf(iZzab));
            } else if (iZza < iZzab) {
                if (zza(iZzab, this.zzy)) {
                    zzj().zzp().zza("Storage version upgraded. Previous, current version", Integer.valueOf(iZza), Integer.valueOf(iZzab));
                } else {
                    zzj().zzg().zza("Storage version upgrade failed. Previous, current version", Integer.valueOf(iZza), Integer.valueOf(iZzab));
                }
            }
        }
    }

    final void zzs() {
        if (!this.zzn) {
            throw new IllegalStateException("UploadController is not initialized");
        }
    }

    private final void zzaa() {
        zzl().zzt();
        if (this.zzu || this.zzv || this.zzw) {
            zzj().zzp().zza("Not stopping services. fetch, network, upload", Boolean.valueOf(this.zzu), Boolean.valueOf(this.zzv), Boolean.valueOf(this.zzw));
            return;
        }
        zzj().zzp().zza("Stopping uploading service(s)");
        List<Runnable> list = this.zzq;
        if (list == null) {
            return;
        }
        Iterator<Runnable> it = list.iterator();
        while (it.hasNext()) {
            it.next().run();
        }
        ((List) Preconditions.checkNotNull(this.zzq)).clear();
    }

    final void zza(String str, com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar) {
        int iZza;
        int iIndexOf;
        Set<String> setZzg = zzi().zzg(str);
        if (setZzg != null) {
            zzaVar.zzd(setZzg);
        }
        if (zzi().zzq(str)) {
            zzaVar.zzg();
        }
        if (zzi().zzt(str)) {
            if (zze().zze(str, zzbi.zzbv)) {
                String strZzu = zzaVar.zzu();
                if (!TextUtils.isEmpty(strZzu) && (iIndexOf = strZzu.indexOf(".")) != -1) {
                    zzaVar.zzo(strZzu.substring(0, iIndexOf));
                }
            } else {
                zzaVar.zzl();
            }
        }
        if (zzi().zzu(str) && (iZza = zzmz.zza(zzaVar, "_id")) != -1) {
            zzaVar.zzc(iZza);
        }
        if (zzi().zzs(str)) {
            zzaVar.zzh();
        }
        if (zzi().zzp(str)) {
            zzaVar.zze();
            zzb zzbVar = this.zzae.get(str);
            if (zzbVar == null || zzbVar.zzb + zze().zzc(str, zzbi.zzat) < zzb().elapsedRealtime()) {
                zzbVar = new zzb();
                this.zzae.put(str, zzbVar);
            }
            zzaVar.zzk(zzbVar.zza);
        }
        if (zzi().zzr(str)) {
            zzaVar.zzp();
        }
    }

    private final void zzb(zzh zzhVar) {
        zzl().zzt();
        if (TextUtils.isEmpty(zzhVar.zzac()) && TextUtils.isEmpty(zzhVar.zzv())) {
            zza((String) Preconditions.checkNotNull(zzhVar.zzx()), 204, (Throwable) null, (byte[]) null, (Map<String, List<String>>) null);
            return;
        }
        Uri.Builder builder = new Uri.Builder();
        String strZzac = zzhVar.zzac();
        if (TextUtils.isEmpty(strZzac)) {
            strZzac = zzhVar.zzv();
        }
        ArrayMap arrayMap = null;
        builder.scheme(zzbi.zze.zza(null)).encodedAuthority(zzbi.zzf.zza(null)).path("config/app/" + strZzac).appendQueryParameter("platform", l11l11lI1lll.l111l1111l1Il).appendQueryParameter("gmp_version", "82001").appendQueryParameter("runtime_version", "0");
        String string = builder.build().toString();
        try {
            String str = (String) Preconditions.checkNotNull(zzhVar.zzx());
            URL url = new URL(string);
            zzj().zzp().zza("Fetching remote configuration", str);
            com.google.android.gms.internal.measurement.zzfc.zzd zzdVarZzc = zzi().zzc(str);
            String strZze = zzi().zze(str);
            if (zzdVarZzc != null) {
                if (!TextUtils.isEmpty(strZze)) {
                    arrayMap = new ArrayMap();
                    arrayMap.put(HttpHeaders.IF_MODIFIED_SINCE, strZze);
                }
                String strZzd = zzi().zzd(str);
                if (!TextUtils.isEmpty(strZzd)) {
                    if (arrayMap == null) {
                        arrayMap = new ArrayMap();
                    }
                    arrayMap.put(HttpHeaders.IF_NONE_MATCH, strZzd);
                }
            }
            this.zzu = true;
            zzfy zzfyVarZzh = zzh();
            zzmu zzmuVar = new zzmu(this);
            zzfyVarZzh.zzt();
            zzfyVarZzh.zzak();
            Preconditions.checkNotNull(url);
            Preconditions.checkNotNull(zzmuVar);
            zzfyVarZzh.zzl().zza(new zzgc(zzfyVarZzh, str, url, null, arrayMap, zzmuVar));
        } catch (MalformedURLException unused) {
            zzj().zzg().zza("Failed to parse config URL. Not fetching. appId", zzfr.zza(zzhVar.zzx()), string);
        }
    }

    final void zza(zzh zzhVar, com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar) {
        com.google.android.gms.internal.measurement.zzfi.zzn next;
        zzl().zzt();
        zzs();
        if (zznp.zza()) {
            zzak zzakVarZza = zzak.zza(zzaVar.zzs());
            String strZzx = zzhVar.zzx();
            zzl().zzt();
            zzs();
            if (zznp.zza()) {
                zzih zzihVarZzb = zzb(strZzx);
                if (zznp.zza() && zze().zza(zzbi.zzco)) {
                    zzaVar.zzg(zzihVarZzb.zzf());
                }
                if (zzihVarZzb.zzc() != null) {
                    zzakVarZza.zza(zzih.zza.AD_STORAGE, zzihVarZzb.zza());
                } else {
                    zzakVarZza.zza(zzih.zza.AD_STORAGE, zzaj.FAILSAFE);
                }
                if (zzihVarZzb.zzd() != null) {
                    zzakVarZza.zza(zzih.zza.ANALYTICS_STORAGE, zzihVarZzb.zza());
                } else {
                    zzakVarZza.zza(zzih.zza.ANALYTICS_STORAGE, zzaj.FAILSAFE);
                }
            }
            String strZzx2 = zzhVar.zzx();
            zzl().zzt();
            zzs();
            if (zznp.zza()) {
                zzay zzayVarZza = zza(strZzx2, zzd(strZzx2), zzb(strZzx2), zzakVarZza);
                zzaVar.zzb(((Boolean) Preconditions.checkNotNull(zzayVarZza.zzd())).booleanValue());
                if (!TextUtils.isEmpty(zzayVarZza.zze())) {
                    zzaVar.zzh(zzayVarZza.zze());
                }
            }
            zzl().zzt();
            zzs();
            if (zznp.zza()) {
                Iterator<com.google.android.gms.internal.measurement.zzfi.zzn> it = zzaVar.zzx().iterator();
                do {
                    if (!it.hasNext()) {
                        next = null;
                        break;
                    }
                    next = it.next();
                } while (!"_npa".equals(next.zzg()));
                if (next != null) {
                    if (zzakVarZza.zza(zzih.zza.AD_PERSONALIZATION) == zzaj.UNSET) {
                        Boolean boolZzu = zzhVar.zzu();
                        if (boolZzu == null || ((boolZzu == Boolean.TRUE && next.zzc() != 1) || (boolZzu == Boolean.FALSE && next.zzc() != 0))) {
                            zzakVarZza.zza(zzih.zza.AD_PERSONALIZATION, zzaj.API);
                        } else {
                            zzakVarZza.zza(zzih.zza.AD_PERSONALIZATION, zzaj.MANIFEST);
                        }
                    }
                } else if (zznp.zza() && zze().zza(zzbi.zzcp)) {
                    int i = 1;
                    if (this.zzb.zzb(zzhVar.zzx()) == null) {
                        zzakVarZza.zza(zzih.zza.AD_PERSONALIZATION, zzaj.FAILSAFE);
                    } else {
                        i = 1 ^ (this.zzb.zzb(zzhVar.zzx(), zzih.zza.AD_PERSONALIZATION) ? 1 : 0);
                        zzakVarZza.zza(zzih.zza.AD_PERSONALIZATION, zzaj.REMOTE_DEFAULT);
                    }
                    zzaVar.zza((com.google.android.gms.internal.measurement.zzfi.zzn) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzn.zze().zza("_npa").zzb(zzb().currentTimeMillis()).zza(i).zzab()));
                }
            }
            zzaVar.zzf(zzakVarZza.toString());
        }
    }

    private static void zza(com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar, int i, String str) {
        List<com.google.android.gms.internal.measurement.zzfi.zzg> listZzf = zzaVar.zzf();
        for (int i2 = 0; i2 < listZzf.size(); i2++) {
            if ("_err".equals(listZzf.get(i2).zzg())) {
                return;
            }
        }
        com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZza = com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_err");
        long j = i;
        Long.valueOf(j).getClass();
        zzaVar.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZza.zza(j).zzab())).zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_ev").zzb(str).zzab()));
    }

    final void zza(zzbg zzbgVar, zzo zzoVar) {
        zzbg zzbgVar2;
        List<zzad> listZza;
        List<zzad> listZza2;
        List<zzad> listZza3;
        String str;
        Preconditions.checkNotNull(zzoVar);
        Preconditions.checkNotEmpty(zzoVar.zza);
        zzl().zzt();
        zzs();
        String str2 = zzoVar.zza;
        long j = zzbgVar.zzd;
        zzfv zzfvVarZza = zzfv.zza(zzbgVar);
        zzl().zzt();
        zznd.zza((this.zzaf == null || (str = this.zzag) == null || !str.equals(str2)) ? null : this.zzaf, zzfvVarZza.zzb, false);
        zzbg zzbgVarZza = zzfvVarZza.zza();
        zzp();
        if (zzmz.zza(zzbgVarZza, zzoVar)) {
            if (!zzoVar.zzh) {
                zza(zzoVar);
                return;
            }
            if (zzoVar.zzs == null) {
                zzbgVar2 = zzbgVarZza;
            } else if (zzoVar.zzs.contains(zzbgVarZza.zza)) {
                Bundle bundleZzb = zzbgVarZza.zzb.zzb();
                bundleZzb.putLong("ga_safelisted", 1L);
                zzbgVar2 = new zzbg(zzbgVarZza.zza, new zzbb(bundleZzb), zzbgVarZza.zzc, zzbgVarZza.zzd);
            } else {
                zzj().zzc().zza("Dropping non-safelisted event. appId, event name, origin", str2, zzbgVarZza.zza, zzbgVarZza.zzc);
                return;
            }
            zzf().zzp();
            try {
                zzao zzaoVarZzf = zzf();
                Preconditions.checkNotEmpty(str2);
                zzaoVarZzf.zzt();
                zzaoVarZzf.zzak();
                if (j < 0) {
                    zzaoVarZzf.zzj().zzu().zza("Invalid time querying timed out conditional properties", zzfr.zza(str2), Long.valueOf(j));
                    listZza = Collections.emptyList();
                } else {
                    listZza = zzaoVarZzf.zza("active=0 and app_id=? and abs(? - creation_timestamp) > trigger_timeout", new String[]{str2, String.valueOf(j)});
                }
                for (zzad zzadVar : listZza) {
                    if (zzadVar != null) {
                        zzj().zzp().zza("User property timed out", zzadVar.zza, this.zzm.zzk().zzc(zzadVar.zzc.zza), zzadVar.zzc.zza());
                        if (zzadVar.zzg != null) {
                            zzc(new zzbg(zzadVar.zzg, j), zzoVar);
                        }
                        zzf().zza(str2, zzadVar.zzc.zza);
                    }
                }
                zzao zzaoVarZzf2 = zzf();
                Preconditions.checkNotEmpty(str2);
                zzaoVarZzf2.zzt();
                zzaoVarZzf2.zzak();
                if (j < 0) {
                    zzaoVarZzf2.zzj().zzu().zza("Invalid time querying expired conditional properties", zzfr.zza(str2), Long.valueOf(j));
                    listZza2 = Collections.emptyList();
                } else {
                    listZza2 = zzaoVarZzf2.zza("active<>0 and app_id=? and abs(? - triggered_timestamp) > time_to_live", new String[]{str2, String.valueOf(j)});
                }
                ArrayList arrayList = new ArrayList(listZza2.size());
                for (zzad zzadVar2 : listZza2) {
                    if (zzadVar2 != null) {
                        zzj().zzp().zza("User property expired", zzadVar2.zza, this.zzm.zzk().zzc(zzadVar2.zzc.zza), zzadVar2.zzc.zza());
                        zzf().zzh(str2, zzadVar2.zzc.zza);
                        if (zzadVar2.zzk != null) {
                            arrayList.add(zzadVar2.zzk);
                        }
                        zzf().zza(str2, zzadVar2.zzc.zza);
                    }
                }
                int size = arrayList.size();
                int i = 0;
                while (i < size) {
                    Object obj = arrayList.get(i);
                    i++;
                    zzc(new zzbg((zzbg) obj, j), zzoVar);
                }
                zzao zzaoVarZzf3 = zzf();
                String str3 = zzbgVar2.zza;
                Preconditions.checkNotEmpty(str2);
                Preconditions.checkNotEmpty(str3);
                zzaoVarZzf3.zzt();
                zzaoVarZzf3.zzak();
                if (j < 0) {
                    zzaoVarZzf3.zzj().zzu().zza("Invalid time querying triggered conditional properties", zzfr.zza(str2), zzaoVarZzf3.zzi().zza(str3), Long.valueOf(j));
                    listZza3 = Collections.emptyList();
                } else {
                    listZza3 = zzaoVarZzf3.zza("active=0 and app_id=? and trigger_event_name=? and abs(? - creation_timestamp) <= trigger_timeout", new String[]{str2, str3, String.valueOf(j)});
                }
                ArrayList arrayList2 = new ArrayList(listZza3.size());
                for (zzad zzadVar3 : listZza3) {
                    if (zzadVar3 != null) {
                        zznc zzncVar = zzadVar3.zzc;
                        zzne zzneVar = new zzne((String) Preconditions.checkNotNull(zzadVar3.zza), zzadVar3.zzb, zzncVar.zza, j, Preconditions.checkNotNull(zzncVar.zza()));
                        if (zzf().zza(zzneVar)) {
                            zzj().zzp().zza("User property triggered", zzadVar3.zza, this.zzm.zzk().zzc(zzneVar.zzc), zzneVar.zze);
                        } else {
                            zzj().zzg().zza("Too many active user properties, ignoring", zzfr.zza(zzadVar3.zza), this.zzm.zzk().zzc(zzneVar.zzc), zzneVar.zze);
                        }
                        if (zzadVar3.zzi != null) {
                            arrayList2.add(zzadVar3.zzi);
                        }
                        zzadVar3.zzc = new zznc(zzneVar);
                        zzadVar3.zze = true;
                        zzf().zza(zzadVar3);
                    }
                }
                zzc(zzbgVar2, zzoVar);
                int size2 = arrayList2.size();
                int i2 = 0;
                while (i2 < size2) {
                    Object obj2 = arrayList2.get(i2);
                    i2++;
                    zzc(new zzbg((zzbg) obj2, j), zzoVar);
                }
                zzf().zzw();
            } finally {
                zzf().zzu();
            }
        }
    }

    final void zza(zzbg zzbgVar, String str) {
        String strZzf;
        int iZza;
        zzh zzhVarZzd = zzf().zzd(str);
        if (zzhVarZzd == null || TextUtils.isEmpty(zzhVarZzd.zzaa())) {
            zzj().zzc().zza("No app data available; dropping event", str);
            return;
        }
        Boolean boolZza = zza(zzhVarZzd);
        if (boolZza == null) {
            if (!"_ui".equals(zzbgVar.zza)) {
                zzj().zzu().zza("Could not find package. appId", zzfr.zza(str));
            }
        } else if (!boolZza.booleanValue()) {
            zzj().zzg().zza("App version does not match; dropping event. appId", zzfr.zza(str));
            return;
        }
        zzih zzihVarZzb = zzb(str);
        if (zznp.zza() && zze().zza(zzbi.zzcm)) {
            strZzf = zzd(str).zzf();
            iZza = zzihVarZzb.zza();
        } else {
            strZzf = "";
            iZza = 100;
        }
        int i = iZza;
        zzb(zzbgVar, new zzo(str, zzhVarZzd.zzac(), zzhVarZzd.zzaa(), zzhVarZzd.zzc(), zzhVarZzd.zzz(), zzhVarZzd.zzo(), zzhVarZzd.zzl(), (String) null, zzhVarZzd.zzak(), false, zzhVarZzd.zzab(), zzhVarZzd.zzb(), 0L, 0, zzhVarZzd.zzaj(), false, zzhVarZzd.zzv(), zzhVarZzd.zzu(), zzhVarZzd.zzm(), zzhVarZzd.zzag(), (String) null, zzihVarZzb.zze(), "", (String) null, zzhVarZzd.zzam(), zzhVarZzd.zzt(), i, strZzf, zzhVarZzd.zza(), zzhVarZzd.zzd()));
    }

    private final void zzb(zzbg zzbgVar, zzo zzoVar) {
        Preconditions.checkNotEmpty(zzoVar.zza);
        zzfv zzfvVarZza = zzfv.zza(zzbgVar);
        zzq().zza(zzfvVarZza.zzb, zzf().zzc(zzoVar.zza));
        zzq().zza(zzfvVarZza, zze().zzd(zzoVar.zza));
        zzbg zzbgVarZza = zzfvVarZza.zza();
        if (Constants.ScionAnalytics.EVENT_FIREBASE_CAMPAIGN.equals(zzbgVarZza.zza) && "referrer API v2".equals(zzbgVarZza.zzb.zzd("_cis"))) {
            String strZzd = zzbgVarZza.zzb.zzd("gclid");
            if (!TextUtils.isEmpty(strZzd)) {
                zza(new zznc("_lgclid", zzbgVarZza.zzd, strZzd, "auto"), zzoVar);
            }
        }
        if (zzoi.zza() && zzoi.zzc() && Constants.ScionAnalytics.EVENT_FIREBASE_CAMPAIGN.equals(zzbgVarZza.zza) && "referrer API v2".equals(zzbgVarZza.zzb.zzd("_cis"))) {
            String strZzd2 = zzbgVarZza.zzb.zzd("gbraid");
            if (!TextUtils.isEmpty(strZzd2)) {
                zza(new zznc("_gbraid", zzbgVarZza.zzd, strZzd2, "auto"), zzoVar);
            }
        }
        zza(zzbgVarZza, zzoVar);
    }

    private final void zza(com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar, long j, boolean z) {
        String str;
        zzne zzneVar;
        String str2;
        if (!z) {
            str = "_lte";
        } else {
            str = "_se";
        }
        zzne zzneVarZze = zzf().zze(zzaVar.zzr(), str);
        if (zzneVarZze == null || zzneVarZze.zze == null) {
            zzneVar = new zzne(zzaVar.zzr(), "auto", str, zzb().currentTimeMillis(), Long.valueOf(j));
        } else {
            zzneVar = new zzne(zzaVar.zzr(), "auto", str, zzb().currentTimeMillis(), Long.valueOf(((Long) zzneVarZze.zze).longValue() + j));
        }
        com.google.android.gms.internal.measurement.zzfi.zzn zznVar = (com.google.android.gms.internal.measurement.zzfi.zzn) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzn.zze().zza(str).zzb(zzb().currentTimeMillis()).zza(((Long) zzneVar.zze).longValue()).zzab());
        int iZza = zzmz.zza(zzaVar, str);
        if (iZza >= 0) {
            zzaVar.zza(iZza, zznVar);
        } else {
            zzaVar.zza(zznVar);
        }
        if (j > 0) {
            zzf().zza(zzneVar);
            if (!z) {
                str2 = "lifetime";
            } else {
                str2 = "session-scoped";
            }
            zzj().zzp().zza("Updated engagement user property. scope, value", str2, zzneVar.zze);
        }
    }

    final void zzt() {
        this.zzt++;
    }

    final void zza(String str, int i, Throwable th, byte[] bArr, Map<String, List<String>> map) {
        zzl().zzt();
        zzs();
        Preconditions.checkNotEmpty(str);
        if (bArr == null) {
            try {
                bArr = new byte[0];
            } catch (Throwable th2) {
                this.zzu = false;
                zzaa();
                throw th2;
            }
        }
        zzj().zzp().zza("onConfigFetched. Response size", Integer.valueOf(bArr.length));
        zzf().zzp();
        try {
            zzh zzhVarZzd = zzf().zzd(str);
            boolean z = (i == 200 || i == 204 || i == 304) && th == null;
            if (zzhVarZzd == null) {
                zzj().zzu().zza("App does not exist in onConfigFetched. appId", zzfr.zza(str));
            } else if (z || i == 404) {
                List<String> list = map != null ? map.get(HttpHeaders.LAST_MODIFIED) : null;
                String str2 = (list == null || list.isEmpty()) ? null : list.get(0);
                List<String> list2 = map != null ? map.get(HttpHeaders.ETAG) : null;
                String str3 = (list2 == null || list2.isEmpty()) ? null : list2.get(0);
                if (i == 404 || i == 304) {
                    if (zzi().zzc(str) == null && !zzi().zza(str, null, null, null)) {
                        zzf().zzu();
                        this.zzu = false;
                        zzaa();
                        return;
                    }
                } else if (!zzi().zza(str, bArr, str2, str3)) {
                    zzf().zzu();
                    this.zzu = false;
                    zzaa();
                    return;
                }
                zzhVarZzd.zzc(zzb().currentTimeMillis());
                zzf().zza(zzhVarZzd);
                if (i == 404) {
                    zzj().zzv().zza("Config not found. Using empty config. appId", str);
                } else {
                    zzj().zzp().zza("Successfully fetched config. Got network response. code, size", Integer.valueOf(i), Integer.valueOf(bArr.length));
                }
                if (zzh().zzu() && zzac()) {
                    zzw();
                } else {
                    zzab();
                }
            } else {
                zzhVarZzd.zzl(zzb().currentTimeMillis());
                zzf().zza(zzhVarZzd);
                zzj().zzp().zza("Fetching config failed. code, error", Integer.valueOf(i), th);
                zzi().zzi(str);
                this.zzj.zzd.zza(zzb().currentTimeMillis());
                if (i == 503 || i == 429) {
                    this.zzj.zzb.zza(zzb().currentTimeMillis());
                }
                zzab();
            }
            zzf().zzw();
            zzf().zzu();
            this.zzu = false;
            zzaa();
        } catch (Throwable th3) {
            zzf().zzu();
            throw th3;
        }
    }

    final void zza(boolean z) {
        zzab();
    }

    final void zza(boolean z, int i, Throwable th, byte[] bArr, String str) {
        zzl().zzt();
        zzs();
        if (bArr == null) {
            try {
                bArr = new byte[0];
            } catch (Throwable th2) {
                this.zzv = false;
                zzaa();
                throw th2;
            }
        }
        List<Long> list = (List) Preconditions.checkNotNull(this.zzz);
        this.zzz = null;
        if ((zznk.zza() && zze().zza(zzbi.zzcr) && !z) || ((i == 200 || i == 204) && th == null)) {
            try {
                if (!zznk.zza() || !zze().zza(zzbi.zzcr) || z) {
                    this.zzj.zzc.zza(zzb().currentTimeMillis());
                }
                this.zzj.zzd.zza(0L);
                zzab();
                if (!zznk.zza() || !zze().zza(zzbi.zzcr) || z) {
                    zzj().zzp().zza("Successful upload. Got network response. code, size", Integer.valueOf(i), Integer.valueOf(bArr.length));
                } else if (zznk.zza() && zze().zza(zzbi.zzcr)) {
                    zzj().zzp().zza("Purged empty bundles");
                }
                zzf().zzp();
                try {
                    for (Long l : list) {
                        try {
                            zzao zzaoVarZzf = zzf();
                            long jLongValue = l.longValue();
                            zzaoVarZzf.zzt();
                            zzaoVarZzf.zzak();
                            try {
                                if (zzaoVarZzf.m30e_().delete("queue", "rowid=?", new String[]{String.valueOf(jLongValue)}) != 1) {
                                    throw new SQLiteException("Deleted fewer rows from queue than expected");
                                }
                            } catch (SQLiteException e) {
                                zzaoVarZzf.zzj().zzg().zza("Failed to delete a bundle in a queue table", e);
                                throw e;
                            }
                        } catch (SQLiteException e2) {
                            List<Long> list2 = this.zzaa;
                            if (list2 == null || !list2.contains(l)) {
                                throw e2;
                            }
                        }
                    }
                    zzf().zzw();
                    zzf().zzu();
                    this.zzaa = null;
                    if (zzh().zzu() && zzac()) {
                        zzw();
                    } else {
                        this.zzab = -1L;
                        zzab();
                    }
                    this.zzp = 0L;
                } catch (Throwable th3) {
                    zzf().zzu();
                    throw th3;
                }
            } catch (SQLiteException e3) {
                zzj().zzg().zza("Database error while trying to delete uploaded bundles", e3);
                this.zzp = zzb().elapsedRealtime();
                zzj().zzp().zza("Disable upload, time", Long.valueOf(this.zzp));
            }
        } else {
            zzj().zzp().zza("Network upload failed. Will retry later. code, error", Integer.valueOf(i), th);
            this.zzj.zzd.zza(zzb().currentTimeMillis());
            if (i == 503 || i == 429) {
                this.zzj.zzb.zza(zzb().currentTimeMillis());
            }
            zzf().zza(list);
            zzab();
        }
        this.zzv = false;
        zzaa();
    }

    final void zzc(zzo zzoVar) {
        String str;
        String str2;
        zzbc zzbcVarZzd;
        PackageInfo packageInfo;
        ApplicationInfo applicationInfo;
        long j;
        boolean z;
        String str3 = "_pfo";
        zzl().zzt();
        zzs();
        Preconditions.checkNotNull(zzoVar);
        Preconditions.checkNotEmpty(zzoVar.zza);
        if (zze(zzoVar)) {
            zzh zzhVarZzd = zzf().zzd(zzoVar.zza);
            if (zzhVarZzd != null && TextUtils.isEmpty(zzhVarZzd.zzac()) && !TextUtils.isEmpty(zzoVar.zzb)) {
                zzhVarZzd.zzc(0L);
                zzf().zza(zzhVarZzd);
                zzi().zzj(zzoVar.zza);
            }
            if (!zzoVar.zzh) {
                zza(zzoVar);
                return;
            }
            long jCurrentTimeMillis = zzoVar.zzl;
            if (jCurrentTimeMillis == 0) {
                jCurrentTimeMillis = zzb().currentTimeMillis();
            }
            this.zzm.zzg().zzm();
            int i = zzoVar.zzm;
            if (i != 0 && i != 1) {
                zzj().zzu().zza("Incorrect app type, assuming installed app. appId, appType", zzfr.zza(zzoVar.zza), Integer.valueOf(i));
                i = 0;
            }
            zzf().zzp();
            try {
                zzne zzneVarZze = zzf().zze(zzoVar.zza, "_npa");
                if (zzneVarZze != null && !"auto".equals(zzneVarZze.zzb)) {
                    str = "_sysu";
                    str2 = "_sys";
                } else if (zzoVar.zzq != null) {
                    str = "_sysu";
                    str2 = "_sys";
                    zznc zzncVar = new zznc("_npa", jCurrentTimeMillis, Long.valueOf(zzoVar.zzq.booleanValue() ? 1L : 0L), "auto");
                    if (zzneVarZze == null || !zzneVarZze.zze.equals(zzncVar.zzc)) {
                        zza(zzncVar, zzoVar);
                    }
                } else {
                    str = "_sysu";
                    str2 = "_sys";
                    if (zzneVarZze != null) {
                        zza("_npa", zzoVar);
                    }
                }
                zzh zzhVarZzd2 = zzf().zzd((String) Preconditions.checkNotNull(zzoVar.zza));
                if (zzhVarZzd2 != null) {
                    zzq();
                    if (zznd.zza(zzoVar.zzb, zzhVarZzd2.zzac(), zzoVar.zzp, zzhVarZzd2.zzv())) {
                        zzj().zzu().zza("New GMP App Id passed in. Removing cached database data. appId", zzfr.zza(zzhVarZzd2.zzx()));
                        zzao zzaoVarZzf = zzf();
                        String strZzx = zzhVarZzd2.zzx();
                        zzaoVarZzf.zzak();
                        zzaoVarZzf.zzt();
                        Preconditions.checkNotEmpty(strZzx);
                        try {
                            SQLiteDatabase sQLiteDatabaseM30e_ = zzaoVarZzf.m30e_();
                            String[] strArr = {strZzx};
                            int iDelete = sQLiteDatabaseM30e_.delete("events", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("user_attributes", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("conditional_properties", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("apps", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("raw_events", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("raw_events_metadata", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("event_filters", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("property_filters", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("audience_filter_values", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("consent_settings", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("default_event_params", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("trigger_uris", "app_id=?", strArr);
                            if (iDelete > 0) {
                                zzaoVarZzf.zzj().zzp().zza("Deleted application data. app, records", strZzx, Integer.valueOf(iDelete));
                            }
                        } catch (SQLiteException e) {
                            zzaoVarZzf.zzj().zzg().zza("Error deleting application data. appId, error", zzfr.zza(strZzx), e);
                        }
                        zzhVarZzd2 = null;
                    }
                }
                if (zzhVarZzd2 != null) {
                    boolean z2 = (zzhVarZzd2.zzc() == -2147483648L || zzhVarZzd2.zzc() == zzoVar.zzj) ? false : true;
                    String strZzaa = zzhVarZzd2.zzaa();
                    if (z2 | ((zzhVarZzd2.zzc() != -2147483648L || strZzaa == null || strZzaa.equals(zzoVar.zzc)) ? false : true)) {
                        Bundle bundle = new Bundle();
                        bundle.putString("_pv", strZzaa);
                        zza(new zzbg("_au", new zzbb(bundle), "auto", jCurrentTimeMillis), zzoVar);
                    }
                }
                zza(zzoVar);
                if (i == 0) {
                    zzbcVarZzd = zzf().zzd(zzoVar.zza, "_f");
                } else {
                    zzbcVarZzd = i == 1 ? zzf().zzd(zzoVar.zza, "_v") : null;
                }
                if (zzbcVarZzd == null) {
                    long j2 = ((jCurrentTimeMillis / 3600000) + 1) * 3600000;
                    if (i == 0) {
                        zza(new zznc("_fot", jCurrentTimeMillis, Long.valueOf(j2), "auto"), zzoVar);
                        zzl().zzt();
                        zzgm zzgmVar = (zzgm) Preconditions.checkNotNull(this.zzl);
                        String str4 = zzoVar.zza;
                        if (str4 == null || str4.isEmpty()) {
                            zzgmVar.zza.zzj().zzw().zza("Install Referrer Reporter was called with invalid app package name");
                        } else {
                            zzgmVar.zza.zzl().zzt();
                            if (!zzgmVar.zza()) {
                                zzgmVar.zza.zzj().zzn().zza("Install Referrer Reporter is not available");
                            } else {
                                zzgl zzglVar = new zzgl(zzgmVar, str4);
                                zzgmVar.zza.zzl().zzt();
                                Intent intent = new Intent("com.google.android.finsky.BIND_GET_INSTALL_REFERRER_SERVICE");
                                intent.setComponent(new ComponentName("com.android.vending", "com.google.android.finsky.externalreferrer.GetInstallReferrerService"));
                                PackageManager packageManager = zzgmVar.zza.zza().getPackageManager();
                                if (packageManager == null) {
                                    zzgmVar.zza.zzj().zzw().zza("Failed to obtain Package Manager to verify binding conditions for Install Referrer");
                                } else {
                                    List<ResolveInfo> listQueryIntentServices = packageManager.queryIntentServices(intent, 0);
                                    if (listQueryIntentServices != null && !listQueryIntentServices.isEmpty()) {
                                        ResolveInfo resolveInfo = listQueryIntentServices.get(0);
                                        if (resolveInfo.serviceInfo != null) {
                                            String str5 = resolveInfo.serviceInfo.packageName;
                                            if (resolveInfo.serviceInfo.name != null && "com.android.vending".equals(str5) && zzgmVar.zza()) {
                                                try {
                                                    zzgmVar.zza.zzj().zzp().zza("Install Referrer Service is", ConnectionTracker.getInstance().bindService(zzgmVar.zza.zza(), new Intent(intent), zzglVar, 1) ? "available" : "not available");
                                                } catch (RuntimeException e2) {
                                                    zzgmVar.zza.zzj().zzg().zza("Exception occurred while binding to Install Referrer Service", e2.getMessage());
                                                }
                                            } else {
                                                zzgmVar.zza.zzj().zzu().zza("Play Store version 8.3.73 or higher required for Install Referrer");
                                            }
                                        }
                                    } else {
                                        zzgmVar.zza.zzj().zzn().zza("Play Service for fetching Install Referrer is unavailable on device");
                                    }
                                }
                            }
                        }
                        zzl().zzt();
                        zzs();
                        Bundle bundle2 = new Bundle();
                        bundle2.putLong("_c", 1L);
                        bundle2.putLong("_r", 1L);
                        bundle2.putLong("_uwa", 0L);
                        bundle2.putLong("_pfo", 0L);
                        String str6 = str2;
                        bundle2.putLong(str6, 0L);
                        String str7 = str;
                        bundle2.putLong(str7, 0L);
                        bundle2.putLong("_et", 1L);
                        if (zzoVar.zzo) {
                            bundle2.putLong("_dac", 1L);
                        }
                        String str8 = (String) Preconditions.checkNotNull(zzoVar.zza);
                        zzao zzaoVarZzf2 = zzf();
                        Preconditions.checkNotEmpty(str8);
                        zzaoVarZzf2.zzt();
                        zzaoVarZzf2.zzak();
                        long jZzb = zzaoVarZzf2.zzb(str8, "first_open_count");
                        if (this.zzm.zza().getPackageManager() == null) {
                            zzj().zzg().zza("PackageManager is null, first open report might be inaccurate. appId", zzfr.zza(str8));
                            str3 = "_pfo";
                        } else {
                            try {
                                packageInfo = Wrappers.packageManager(this.zzm.zza()).getPackageInfo(str8, 0);
                            } catch (PackageManager.NameNotFoundException e3) {
                                zzj().zzg().zza("Package info is null, first open report might be inaccurate. appId", zzfr.zza(str8), e3);
                                packageInfo = null;
                            }
                            if (packageInfo != null && packageInfo.firstInstallTime != 0) {
                                if (packageInfo.firstInstallTime != packageInfo.lastUpdateTime) {
                                    if (!zze().zza(zzbi.zzbl) || jZzb == 0) {
                                        bundle2.putLong("_uwa", 1L);
                                    }
                                    z = false;
                                } else {
                                    z = true;
                                }
                                zza(new zznc("_fi", jCurrentTimeMillis, Long.valueOf(z ? 1L : 0L), "auto"), zzoVar);
                            }
                            try {
                                applicationInfo = Wrappers.packageManager(this.zzm.zza()).getApplicationInfo(str8, 0);
                            } catch (PackageManager.NameNotFoundException e4) {
                                zzj().zzg().zza("Application info is null, first open report might be inaccurate. appId", zzfr.zza(str8), e4);
                                applicationInfo = null;
                            }
                            if (applicationInfo != null) {
                                if ((applicationInfo.flags & 1) != 0) {
                                    j = 1;
                                    bundle2.putLong(str6, 1L);
                                } else {
                                    j = 1;
                                }
                                if ((applicationInfo.flags & 128) != 0) {
                                    bundle2.putLong(str7, j);
                                }
                            }
                        }
                        if (jZzb >= 0) {
                            bundle2.putLong(str3, jZzb);
                        }
                        zzb(new zzbg("_f", new zzbb(bundle2), "auto", jCurrentTimeMillis), zzoVar);
                    } else if (i == 1) {
                        zza(new zznc("_fvt", jCurrentTimeMillis, Long.valueOf(j2), "auto"), zzoVar);
                        zzl().zzt();
                        zzs();
                        Bundle bundle3 = new Bundle();
                        bundle3.putLong("_c", 1L);
                        bundle3.putLong("_r", 1L);
                        bundle3.putLong("_et", 1L);
                        if (zzoVar.zzo) {
                            bundle3.putLong("_dac", 1L);
                        }
                        zzb(new zzbg("_v", new zzbb(bundle3), "auto", jCurrentTimeMillis), zzoVar);
                    }
                } else if (zzoVar.zzi) {
                    zzb(new zzbg("_cd", new zzbb(new Bundle()), "auto", jCurrentTimeMillis), zzoVar);
                }
                zzf().zzw();
                zzf().zzu();
            } catch (Throwable th) {
                zzf().zzu();
                throw th;
            }
        }
    }

    final void zzu() {
        this.zzs++;
    }

    final void zza(zzad zzadVar) {
        zzo zzoVarZzc = zzc((String) Preconditions.checkNotNull(zzadVar.zza));
        if (zzoVarZzc != null) {
            zza(zzadVar, zzoVarZzc);
        }
    }

    final void zza(zzad zzadVar, zzo zzoVar) {
        Preconditions.checkNotNull(zzadVar);
        Preconditions.checkNotEmpty(zzadVar.zza);
        Preconditions.checkNotNull(zzadVar.zzc);
        Preconditions.checkNotEmpty(zzadVar.zzc.zza);
        zzl().zzt();
        zzs();
        if (zze(zzoVar)) {
            if (!zzoVar.zzh) {
                zza(zzoVar);
                return;
            }
            zzf().zzp();
            try {
                zza(zzoVar);
                String str = (String) Preconditions.checkNotNull(zzadVar.zza);
                zzad zzadVarZzc = zzf().zzc(str, zzadVar.zzc.zza);
                if (zzadVarZzc != null) {
                    zzj().zzc().zza("Removing conditional user property", zzadVar.zza, this.zzm.zzk().zzc(zzadVar.zzc.zza));
                    zzf().zza(str, zzadVar.zzc.zza);
                    if (zzadVarZzc.zze) {
                        zzf().zzh(str, zzadVar.zzc.zza);
                    }
                    if (zzadVar.zzk != null) {
                        zzc((zzbg) Preconditions.checkNotNull(zzq().zza(str, ((zzbg) Preconditions.checkNotNull(zzadVar.zzk)).zza, zzadVar.zzk.zzb != null ? zzadVar.zzk.zzb.zzb() : null, zzadVarZzc.zzb, zzadVar.zzk.zzd, true, true)), zzoVar);
                    }
                } else {
                    zzj().zzu().zza("Conditional user property doesn't exist", zzfr.zza(zzadVar.zza), this.zzm.zzk().zzc(zzadVar.zzc.zza));
                }
                zzf().zzw();
            } finally {
                zzf().zzu();
            }
        }
    }

    private static void zza(com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar, String str) {
        List<com.google.android.gms.internal.measurement.zzfi.zzg> listZzf = zzaVar.zzf();
        for (int i = 0; i < listZzf.size(); i++) {
            if (str.equals(listZzf.get(i).zzg())) {
                zzaVar.zza(i);
                return;
            }
        }
    }

    final void zza(String str, zzo zzoVar) {
        zzl().zzt();
        zzs();
        if (zze(zzoVar)) {
            if (!zzoVar.zzh) {
                zza(zzoVar);
                return;
            }
            if ("_npa".equals(str) && zzoVar.zzq != null) {
                zzj().zzc().zza("Falling back to manifest metadata value for ad personalization");
                zza(new zznc("_npa", zzb().currentTimeMillis(), Long.valueOf(zzoVar.zzq.booleanValue() ? 1L : 0L), "auto"), zzoVar);
                return;
            }
            zzj().zzc().zza("Removing user property", this.zzm.zzk().zzc(str));
            zzf().zzp();
            try {
                zza(zzoVar);
                if ("_id".equals(str)) {
                    zzf().zzh((String) Preconditions.checkNotNull(zzoVar.zza), "_lair");
                }
                zzf().zzh((String) Preconditions.checkNotNull(zzoVar.zza), str);
                zzf().zzw();
                zzj().zzc().zza("User property removed", this.zzm.zzk().zzc(str));
            } finally {
                zzf().zzu();
            }
        }
    }

    final void zzd(zzo zzoVar) {
        if (this.zzz != null) {
            ArrayList arrayList = new ArrayList();
            this.zzaa = arrayList;
            arrayList.addAll(this.zzz);
        }
        zzao zzaoVarZzf = zzf();
        String str = (String) Preconditions.checkNotNull(zzoVar.zza);
        Preconditions.checkNotEmpty(str);
        zzaoVarZzf.zzt();
        zzaoVarZzf.zzak();
        try {
            SQLiteDatabase sQLiteDatabaseM30e_ = zzaoVarZzf.m30e_();
            String[] strArr = {str};
            int iDelete = sQLiteDatabaseM30e_.delete("apps", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("events", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("user_attributes", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("conditional_properties", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("raw_events", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("raw_events_metadata", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("queue", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("audience_filter_values", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("main_event_params", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("default_event_params", "app_id=?", strArr) + sQLiteDatabaseM30e_.delete("trigger_uris", "app_id=?", strArr);
            if (iDelete > 0) {
                zzaoVarZzf.zzj().zzp().zza("Reset analytics data. app, records", str, Integer.valueOf(iDelete));
            }
        } catch (SQLiteException e) {
            zzaoVarZzf.zzj().zzg().zza("Error resetting analytics data. appId, error", zzfr.zza(str), e);
        }
        if (zzoVar.zzh) {
            zzc(zzoVar);
        }
    }

    public final void zza(String str, zzki zzkiVar) {
        zzl().zzt();
        String str2 = this.zzag;
        if (str2 == null || str2.equals(str) || zzkiVar != null) {
            this.zzag = str;
            this.zzaf = zzkiVar;
        }
    }

    private final void zza(List<Long> list) {
        Preconditions.checkArgument(!list.isEmpty());
        if (this.zzz != null) {
            zzj().zzg().zza("Set uploading progress before finishing the previous upload");
        } else {
            this.zzz = new ArrayList(list);
        }
    }

    protected final void zzv() {
        zzl().zzt();
        zzf().zzv();
        if (this.zzj.zzc.zza() == 0) {
            this.zzj.zzc.zza(zzb().currentTimeMillis());
        }
        zzab();
    }

    final void zzb(zzad zzadVar) {
        zzo zzoVarZzc = zzc((String) Preconditions.checkNotNull(zzadVar.zza));
        if (zzoVarZzc != null) {
            zzb(zzadVar, zzoVarZzc);
        }
    }

    final void zzb(zzad zzadVar, zzo zzoVar) {
        Preconditions.checkNotNull(zzadVar);
        Preconditions.checkNotEmpty(zzadVar.zza);
        Preconditions.checkNotNull(zzadVar.zzb);
        Preconditions.checkNotNull(zzadVar.zzc);
        Preconditions.checkNotEmpty(zzadVar.zzc.zza);
        zzl().zzt();
        zzs();
        if (zze(zzoVar)) {
            if (!zzoVar.zzh) {
                zza(zzoVar);
                return;
            }
            zzad zzadVar2 = new zzad(zzadVar);
            boolean z = false;
            zzadVar2.zze = false;
            zzf().zzp();
            try {
                zzad zzadVarZzc = zzf().zzc((String) Preconditions.checkNotNull(zzadVar2.zza), zzadVar2.zzc.zza);
                if (zzadVarZzc != null && !zzadVarZzc.zzb.equals(zzadVar2.zzb)) {
                    zzj().zzu().zza("Updating a conditional user property with different origin. name, origin, origin (from DB)", this.zzm.zzk().zzc(zzadVar2.zzc.zza), zzadVar2.zzb, zzadVarZzc.zzb);
                }
                if (zzadVarZzc != null && zzadVarZzc.zze) {
                    zzadVar2.zzb = zzadVarZzc.zzb;
                    zzadVar2.zzd = zzadVarZzc.zzd;
                    zzadVar2.zzh = zzadVarZzc.zzh;
                    zzadVar2.zzf = zzadVarZzc.zzf;
                    zzadVar2.zzi = zzadVarZzc.zzi;
                    zzadVar2.zze = zzadVarZzc.zze;
                    zzadVar2.zzc = new zznc(zzadVar2.zzc.zza, zzadVarZzc.zzc.zzb, zzadVar2.zzc.zza(), zzadVarZzc.zzc.zze);
                } else if (TextUtils.isEmpty(zzadVar2.zzf)) {
                    zzadVar2.zzc = new zznc(zzadVar2.zzc.zza, zzadVar2.zzd, zzadVar2.zzc.zza(), zzadVar2.zzc.zze);
                    z = true;
                    zzadVar2.zze = true;
                }
                if (zzadVar2.zze) {
                    zznc zzncVar = zzadVar2.zzc;
                    zzne zzneVar = new zzne((String) Preconditions.checkNotNull(zzadVar2.zza), zzadVar2.zzb, zzncVar.zza, zzncVar.zzb, Preconditions.checkNotNull(zzncVar.zza()));
                    if (zzf().zza(zzneVar)) {
                        zzj().zzc().zza("User property updated immediately", zzadVar2.zza, this.zzm.zzk().zzc(zzneVar.zzc), zzneVar.zze);
                    } else {
                        zzj().zzg().zza("(2)Too many active user properties, ignoring", zzfr.zza(zzadVar2.zza), this.zzm.zzk().zzc(zzneVar.zzc), zzneVar.zze);
                    }
                    if (z && zzadVar2.zzi != null) {
                        zzc(new zzbg(zzadVar2.zzi, zzadVar2.zzd), zzoVar);
                    }
                }
                if (zzf().zza(zzadVar2)) {
                    zzj().zzc().zza("Conditional property added", zzadVar2.zza, this.zzm.zzk().zzc(zzadVar2.zzc.zza), zzadVar2.zzc.zza());
                } else {
                    zzj().zzg().zza("Too many conditional properties, ignoring", zzfr.zza(zzadVar2.zza), this.zzm.zzk().zzc(zzadVar2.zzc.zza), zzadVar2.zzc.zza());
                }
                zzf().zzw();
            } finally {
                zzf().zzu();
            }
        }
    }

    final void zza(String str, zzih zzihVar) {
        zzl().zzt();
        zzs();
        this.zzac.put(str, zzihVar);
        zzf().zza(str, zzihVar);
    }

    final void zza(String str, zzay zzayVar) {
        zzl().zzt();
        zzs();
        if (zznp.zza()) {
            this.zzad.put(str, zzayVar);
            zzf().zza(str, zzayVar);
        }
    }

    private final void zzab() {
        long jMax;
        long jMax2;
        zzl().zzt();
        zzs();
        if (this.zzp > 0) {
            long jAbs = 3600000 - Math.abs(zzb().elapsedRealtime() - this.zzp);
            if (jAbs > 0) {
                zzj().zzp().zza("Upload has been suspended. Will update scheduling later in approximately ms", Long.valueOf(jAbs));
                zzy().zzb();
                zzz().zzu();
                return;
            }
            this.zzp = 0L;
        }
        if (!this.zzm.zzaf() || !zzac()) {
            zzj().zzp().zza("Nothing to upload or uploading impossible");
            zzy().zzb();
            zzz().zzu();
            return;
        }
        long jCurrentTimeMillis = zzb().currentTimeMillis();
        zze();
        long jMax3 = Math.max(0L, zzbi.zzaa.zza(null).longValue());
        boolean z = zzf().zzz() || zzf().zzy();
        if (z) {
            String strZzn = zze().zzn();
            if (!TextUtils.isEmpty(strZzn) && !".none.".equals(strZzn)) {
                zze();
                jMax = Math.max(0L, zzbi.zzv.zza(null).longValue());
            } else {
                zze();
                jMax = Math.max(0L, zzbi.zzu.zza(null).longValue());
            }
        } else {
            zze();
            jMax = Math.max(0L, zzbi.zzt.zza(null).longValue());
        }
        long jZza = this.zzj.zzc.zza();
        long jZza2 = this.zzj.zzd.zza();
        long j = jMax;
        long jMax4 = Math.max(zzf().m28c_(), zzf().m29d_());
        if (jMax4 != 0) {
            long jAbs2 = jCurrentTimeMillis - Math.abs(jMax4 - jCurrentTimeMillis);
            long jAbs3 = jCurrentTimeMillis - Math.abs(jZza - jCurrentTimeMillis);
            long jAbs4 = jCurrentTimeMillis - Math.abs(jZza2 - jCurrentTimeMillis);
            long jMax5 = Math.max(jAbs3, jAbs4);
            jMax2 = jAbs2 + jMax3;
            if (z && jMax5 > 0) {
                jMax2 = Math.min(jAbs2, jMax5) + j;
            }
            if (!zzp().zza(jMax5, j)) {
                jMax2 = jMax5 + j;
            }
            if (jAbs4 != 0 && jAbs4 >= jAbs2) {
                int i = 0;
                while (true) {
                    zze();
                    if (i >= Math.min(20, Math.max(0, zzbi.zzac.zza(null).intValue()))) {
                        jMax2 = 0;
                        break;
                    }
                    zze();
                    jMax2 += Math.max(0L, zzbi.zzab.zza(null).longValue()) * (1 << i);
                    if (jMax2 > jAbs4) {
                        break;
                    } else {
                        i++;
                    }
                }
            }
        } else {
            jMax2 = 0;
            break;
        }
        if (jMax2 == 0) {
            zzj().zzp().zza("Next upload time is 0");
            zzy().zzb();
            zzz().zzu();
            return;
        }
        if (!zzh().zzu()) {
            zzj().zzp().zza("No network");
            zzy().zza();
            zzz().zzu();
            return;
        }
        long jZza3 = this.zzj.zzb.zza();
        zze();
        long jMax6 = Math.max(0L, zzbi.zzr.zza(null).longValue());
        if (!zzp().zza(jZza3, jMax6)) {
            jMax2 = Math.max(jMax2, jZza3 + jMax6);
        }
        zzy().zzb();
        long jCurrentTimeMillis2 = jMax2 - zzb().currentTimeMillis();
        if (jCurrentTimeMillis2 <= 0) {
            zze();
            jCurrentTimeMillis2 = Math.max(0L, zzbi.zzw.zza(null).longValue());
            this.zzj.zzc.zza(zzb().currentTimeMillis());
        }
        zzj().zzp().zza("Upload scheduled in approximately ms", Long.valueOf(jCurrentTimeMillis2));
        zzz().zza(jCurrentTimeMillis2);
    }

    private final void zza(String str, boolean z) {
        zzh zzhVarZzd = zzf().zzd(str);
        if (zzhVarZzd != null) {
            zzhVarZzd.zzd(z);
            if (zzhVarZzd.zzal()) {
                zzf().zza(zzhVarZzd);
            }
        }
    }

    final void zza(zznc zzncVar, zzo zzoVar) {
        zzne zzneVarZze;
        long jLongValue;
        zzl().zzt();
        zzs();
        if (zze(zzoVar)) {
            if (!zzoVar.zzh) {
                zza(zzoVar);
                return;
            }
            int iZzb = zzq().zzb(zzncVar.zza);
            int length = 0;
            if (iZzb != 0) {
                zzq();
                String str = zzncVar.zza;
                zze();
                String strZza = zznd.zza(str, 24, true);
                int length2 = zzncVar.zza != null ? zzncVar.zza.length() : 0;
                zzq();
                zznd.zza(this.zzah, zzoVar.zza, iZzb, "_ev", strZza, length2);
                return;
            }
            int iZza = zzq().zza(zzncVar.zza, zzncVar.zza());
            if (iZza != 0) {
                zzq();
                String str2 = zzncVar.zza;
                zze();
                String strZza2 = zznd.zza(str2, 24, true);
                Object objZza = zzncVar.zza();
                if (objZza != null && ((objZza instanceof String) || (objZza instanceof CharSequence))) {
                    length = String.valueOf(objZza).length();
                }
                zzq();
                zznd.zza(this.zzah, zzoVar.zza, iZza, "_ev", strZza2, length);
                return;
            }
            Object objZzc = zzq().zzc(zzncVar.zza, zzncVar.zza());
            if (objZzc == null) {
                return;
            }
            if ("_sid".equals(zzncVar.zza)) {
                long j = zzncVar.zzb;
                String str3 = zzncVar.zze;
                String str4 = (String) Preconditions.checkNotNull(zzoVar.zza);
                zzne zzneVarZze2 = zzf().zze(str4, "_sno");
                if (zzneVarZze2 != null && (zzneVarZze2.zze instanceof Long)) {
                    jLongValue = ((Long) zzneVarZze2.zze).longValue();
                } else {
                    if (zzneVarZze2 != null) {
                        zzj().zzu().zza("Retrieved last session number from database does not contain a valid (long) value", zzneVarZze2.zze);
                    }
                    zzbc zzbcVarZzd = zzf().zzd(str4, "_s");
                    if (zzbcVarZzd != null) {
                        jLongValue = zzbcVarZzd.zzc;
                        zzj().zzp().zza("Backfill the session number. Last used session number", Long.valueOf(jLongValue));
                    } else {
                        jLongValue = 0;
                    }
                }
                zza(new zznc("_sno", j, Long.valueOf(jLongValue + 1), str3), zzoVar);
            }
            zzne zzneVar = new zzne((String) Preconditions.checkNotNull(zzoVar.zza), (String) Preconditions.checkNotNull(zzncVar.zze), zzncVar.zza, zzncVar.zzb, objZzc);
            zzj().zzp().zza("Setting user property", this.zzm.zzk().zzc(zzneVar.zzc), objZzc);
            zzf().zzp();
            try {
                if ("_id".equals(zzneVar.zzc) && (zzneVarZze = zzf().zze(zzoVar.zza, "_id")) != null && !zzneVar.zze.equals(zzneVarZze.zze)) {
                    zzf().zzh(zzoVar.zza, "_lair");
                }
                zza(zzoVar);
                boolean zZza = zzf().zza(zzneVar);
                if ("_sid".equals(zzncVar.zza)) {
                    long jZza = zzp().zza(zzoVar.zzv);
                    zzh zzhVarZzd = zzf().zzd(zzoVar.zza);
                    if (zzhVarZzd != null) {
                        zzhVarZzd.zzq(jZza);
                        if (zzhVarZzd.zzal()) {
                            zzf().zza(zzhVarZzd);
                        }
                    }
                }
                zzf().zzw();
                if (!zZza) {
                    zzj().zzg().zza("Too many unique user properties are set. Ignoring user property", this.zzm.zzk().zzc(zzneVar.zzc), zzneVar.zze);
                    zzq();
                    zznd.zza(this.zzah, zzoVar.zza, 9, (String) null, (String) null, 0);
                }
            } finally {
                zzf().zzu();
            }
        }
    }

    final void zzw() {
        boolean z;
        zzh zzhVarZzd;
        List<Pair<com.google.android.gms.internal.measurement.zzfi.zzj, Long>> list;
        com.google.android.gms.internal.measurement.zzfi.zzi.zza zzaVar;
        String strZzal;
        zzl().zzt();
        zzs();
        this.zzw = true;
        boolean z2 = false;
        try {
            Boolean boolZzab = this.zzm.zzr().zzab();
            try {
                if (boolZzab == null) {
                    zzj().zzu().zza("Upload data called on the client side before use of service was decided");
                    this.zzw = false;
                    zzaa();
                    return;
                }
                if (boolZzab.booleanValue()) {
                    zzj().zzg().zza("Upload called in the client side when service should be used");
                    this.zzw = false;
                    zzaa();
                    return;
                }
                if (this.zzp > 0) {
                    zzab();
                    this.zzw = false;
                    zzaa();
                    return;
                }
                zzl().zzt();
                if (this.zzz != null) {
                    zzj().zzp().zza("Uploading requested multiple times");
                    this.zzw = false;
                    zzaa();
                    return;
                }
                if (!zzh().zzu()) {
                    zzj().zzp().zza("Network not connected, ignoring upload request");
                    zzab();
                    this.zzw = false;
                    zzaa();
                    return;
                }
                long jCurrentTimeMillis = zzb().currentTimeMillis();
                int iZzb = zze().zzb(null, zzbi.zzar);
                zze();
                long jZzh = jCurrentTimeMillis - zzaf.zzh();
                for (int i = 0; i < iZzb && zza((String) null, jZzh); i++) {
                }
                if (zzpg.zza()) {
                    zzl().zzt();
                    for (String str : this.zzr) {
                        if (zzpg.zza() && zze().zze(str, zzbi.zzcf)) {
                            zzj().zzc().zza("Notifying app that trigger URIs are available. App ID", str);
                            Intent intent = new Intent();
                            intent.setAction("com.google.android.gms.measurement.TRIGGERS_AVAILABLE");
                            intent.setPackage(str);
                            this.zzm.zza().sendBroadcast(intent);
                        }
                    }
                    this.zzr.clear();
                }
                long jZza = this.zzj.zzc.zza();
                if (jZza != 0) {
                    zzj().zzc().zza("Uploading events. Elapsed time since last upload attempt (ms)", Long.valueOf(Math.abs(jCurrentTimeMillis - jZza)));
                }
                String strM31f_ = zzf().m31f_();
                if (!TextUtils.isEmpty(strM31f_)) {
                    if (this.zzab == -1) {
                        this.zzab = zzf().m27b_();
                    }
                    List<Pair<com.google.android.gms.internal.measurement.zzfi.zzj, Long>> listZza = zzf().zza(strM31f_, zze().zzb(strM31f_, zzbi.zzg), Math.max(0, zze().zzb(strM31f_, zzbi.zzh)));
                    if (!listZza.isEmpty()) {
                        if (zzb(strM31f_).zzg()) {
                            Iterator<Pair<com.google.android.gms.internal.measurement.zzfi.zzj, Long>> it = listZza.iterator();
                            while (true) {
                                if (!it.hasNext()) {
                                    strZzal = null;
                                    break;
                                }
                                com.google.android.gms.internal.measurement.zzfi.zzj zzjVar = (com.google.android.gms.internal.measurement.zzfi.zzj) it.next().first;
                                if (!zzjVar.zzal().isEmpty()) {
                                    strZzal = zzjVar.zzal();
                                    break;
                                }
                            }
                            if (strZzal != null) {
                                for (int i2 = 0; i2 < listZza.size(); i2++) {
                                    com.google.android.gms.internal.measurement.zzfi.zzj zzjVar2 = (com.google.android.gms.internal.measurement.zzfi.zzj) listZza.get(i2).first;
                                    if (!zzjVar2.zzal().isEmpty() && !zzjVar2.zzal().equals(strZzal)) {
                                        listZza = listZza.subList(0, i2);
                                        break;
                                    }
                                }
                            }
                        }
                        com.google.android.gms.internal.measurement.zzfi.zzi.zza zzaVarZzb = com.google.android.gms.internal.measurement.zzfi.zzi.zzb();
                        int size = listZza.size();
                        List<Long> arrayList = new ArrayList<>(listZza.size());
                        boolean z3 = zze().zzk(strM31f_) && zzb(strM31f_).zzg();
                        boolean zZzg = zzb(strM31f_).zzg();
                        boolean zZzh = zzb(strM31f_).zzh();
                        boolean z4 = zzps.zza() && zze().zze(strM31f_, zzbi.zzbt);
                        int i3 = 0;
                        while (i3 < size) {
                            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzby = ((com.google.android.gms.internal.measurement.zzfi.zzj) listZza.get(i3).first).zzby();
                            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar2 = zzaVarZzby;
                            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar3 = zzaVarZzby;
                            arrayList.add((Long) listZza.get(i3).second);
                            zze();
                            List<Pair<com.google.android.gms.internal.measurement.zzfi.zzj, Long>> list2 = listZza;
                            com.google.android.gms.internal.measurement.zzfi.zzi.zza zzaVar4 = zzaVarZzb;
                            zzaVar3.zzl(82001L).zzk(jCurrentTimeMillis).zzd(z2);
                            if (!z3) {
                                zzaVar3.zzh();
                            }
                            if (!zZzg) {
                                zzaVar3.zzo();
                                zzaVar3.zzk();
                            }
                            if (!zZzh) {
                                zzaVar3.zze();
                            }
                            zza(strM31f_, zzaVar3);
                            if (!z4) {
                                zzaVar3.zzp();
                            }
                            if (zznk.zza() && zze().zza(zzbi.zzcr)) {
                                String strZzv = zzaVar3.zzv();
                                if (TextUtils.isEmpty(strZzv) || strZzv.equals("00000000-0000-0000-0000-000000000000")) {
                                    ArrayList arrayList2 = new ArrayList(zzaVar3.zzw());
                                    Iterator it2 = arrayList2.iterator();
                                    boolean z5 = z2;
                                    boolean z6 = z5;
                                    while (it2.hasNext()) {
                                        com.google.android.gms.internal.measurement.zzfi.zze zzeVar = (com.google.android.gms.internal.measurement.zzfi.zze) it2.next();
                                        list2 = list2;
                                        if ("_fx".equals(zzeVar.zzg())) {
                                            it2.remove();
                                            z5 = true;
                                            z6 = true;
                                        } else if ("_f".equals(zzeVar.zzg())) {
                                            z6 = true;
                                        }
                                    }
                                    list = list2;
                                    if (z5) {
                                        zzaVar3.zzi();
                                        zzaVar3.zzb(arrayList2);
                                    }
                                    if (z6) {
                                        zza(zzaVar3.zzr(), true);
                                    }
                                } else {
                                    list = list2;
                                }
                                if (zzaVar3.zza() == 0) {
                                    zzaVar = zzaVar4;
                                }
                                i3++;
                                zzaVarZzb = zzaVar;
                                listZza = list;
                                z2 = false;
                            } else {
                                list = list2;
                            }
                            if (zze().zze(strM31f_, zzbi.zzbd)) {
                                zzaVar3.zza(zzp().zza(((com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) zzaVar3.zzab())).zzbv()));
                            }
                            zzaVar = zzaVar4;
                            zzaVar.zza(zzaVar3);
                            i3++;
                            zzaVarZzb = zzaVar;
                            listZza = list;
                            z2 = false;
                        }
                        com.google.android.gms.internal.measurement.zzfi.zzi.zza zzaVar5 = zzaVarZzb;
                        if (zznk.zza() && zze().zza(zzbi.zzcr) && zzaVar5.zza() == 0) {
                            zza(arrayList);
                            zza(false, 204, (Throwable) null, (byte[]) null, strM31f_);
                            this.zzw = false;
                            zzaa();
                            return;
                        }
                        Object objZza = zzj().zza(2) ? zzp().zza((com.google.android.gms.internal.measurement.zzfi.zzi) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab())) : null;
                        zzp();
                        byte[] bArrZzbv = ((com.google.android.gms.internal.measurement.zzfi.zzi) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab())).zzbv();
                        zzmq zzmqVarZza = this.zzk.zza(strM31f_);
                        try {
                            zza(arrayList);
                            this.zzj.zzd.zza(jCurrentTimeMillis);
                            Object objZzx = "?";
                            if (size > 0) {
                                objZzx = zzaVar5.zza(0).zzx();
                            }
                            zzj().zzp().zza("Uploading data. app, uncompressed size, data", objZzx, Integer.valueOf(bArrZzbv.length), objZza);
                            this.zzv = true;
                            zzfy zzfyVarZzh = zzh();
                            URL url = new URL(zzmqVarZza.zza());
                            Map<String, String> mapZzb = zzmqVarZza.zzb();
                            zzmr zzmrVar = new zzmr(this, strM31f_);
                            zzfyVarZzh.zzt();
                            zzfyVarZzh.zzak();
                            Preconditions.checkNotNull(url);
                            Preconditions.checkNotNull(bArrZzbv);
                            Preconditions.checkNotNull(zzmrVar);
                            zzfyVarZzh.zzl().zza(new zzgc(zzfyVarZzh, strM31f_, url, bArrZzbv, mapZzb, zzmrVar));
                        } catch (MalformedURLException unused) {
                            zzj().zzg().zza("Failed to parse upload URL. Not uploading. appId", zzfr.zza(strM31f_), zzmqVarZza.zza());
                        }
                    }
                } else {
                    this.zzab = -1L;
                    zzao zzaoVarZzf = zzf();
                    zze();
                    String strZza = zzaoVarZzf.zza(jCurrentTimeMillis - zzaf.zzh());
                    if (!TextUtils.isEmpty(strZza) && (zzhVarZzd = zzf().zzd(strZza)) != null) {
                        zzb(zzhVarZzd);
                    }
                }
                this.zzw = false;
                zzaa();
            } catch (Throwable th) {
                th = th;
                z = false;
                this.zzw = z;
                zzaa();
                throw th;
            }
        } catch (Throwable th2) {
            th = th2;
            z = false;
            this.zzw = z;
            zzaa();
            throw th;
        }
    }

    private final void zzc(zzbg zzbgVar, zzo zzoVar) {
        long jLongValue;
        zzne zzneVar;
        boolean z;
        zzbc zzbcVarZza;
        long j;
        String str;
        Pair<String, Boolean> pairZza;
        zzh zzhVarZzd;
        zzne zzneVarZze;
        zzh zzhVarZzd2;
        Preconditions.checkNotNull(zzoVar);
        Preconditions.checkNotEmpty(zzoVar.zza);
        long jNanoTime = System.nanoTime();
        zzl().zzt();
        zzs();
        String str2 = zzoVar.zza;
        zzp();
        if (zzmz.zza(zzbgVar, zzoVar)) {
            if (!zzoVar.zzh) {
                zza(zzoVar);
                return;
            }
            String str3 = "_err";
            if (zzi().zzd(str2, zzbgVar.zza)) {
                zzj().zzu().zza("Dropping blocked event. appId", zzfr.zza(str2), this.zzm.zzk().zza(zzbgVar.zza));
                boolean z2 = zzi().zzm(str2) || zzi().zzo(str2);
                if (!z2 && !"_err".equals(zzbgVar.zza)) {
                    zzq();
                    zznd.zza(this.zzah, str2, 11, "_ev", zzbgVar.zza, 0);
                }
                if (!z2 || (zzhVarZzd2 = zzf().zzd(str2)) == null) {
                    return;
                }
                long jAbs = Math.abs(zzb().currentTimeMillis() - Math.max(zzhVarZzd2.zzn(), zzhVarZzd2.zze()));
                zze();
                if (jAbs > zzbi.zzz.zza(null).longValue()) {
                    zzj().zzc().zza("Fetching config for blocked app");
                    zzb(zzhVarZzd2);
                    return;
                }
                return;
            }
            zzfv zzfvVarZza = zzfv.zza(zzbgVar);
            zzq().zza(zzfvVarZza, zze().zzd(str2));
            int iZza = (zzot.zza() && zze().zza(zzbi.zzcd)) ? zze().zza(str2, zzbi.zzaq, 10, 35) : 0;
            for (String str4 : new TreeSet(zzfvVarZza.zzb.keySet())) {
                if (FirebaseAnalytics.Param.ITEMS.equals(str4)) {
                    zzq().zza(zzfvVarZza.zzb.getParcelableArray(str4), iZza, zzot.zza() && zze().zza(zzbi.zzcd));
                }
            }
            zzbg zzbgVarZza = zzfvVarZza.zza();
            if (zzj().zza(2)) {
                zzj().zzp().zza("Logging event", this.zzm.zzk().zza(zzbgVarZza));
            }
            if (zzon.zza()) {
                zze().zza(zzbi.zzca);
            }
            zzf().zzp();
            try {
                zza(zzoVar);
                boolean z3 = "ecommerce_purchase".equals(zzbgVarZza.zza) || FirebaseAnalytics.Event.PURCHASE.equals(zzbgVarZza.zza) || FirebaseAnalytics.Event.REFUND.equals(zzbgVarZza.zza);
                if ("_iap".equals(zzbgVarZza.zza) || z3) {
                    String strZzd = zzbgVarZza.zzb.zzd(FirebaseAnalytics.Param.CURRENCY);
                    if (z3) {
                        double dDoubleValue = zzbgVarZza.zzb.zza("value").doubleValue() * 1000000.0d;
                        if (dDoubleValue == 0.0d) {
                            dDoubleValue = zzbgVarZza.zzb.zzb("value").longValue() * 1000000.0d;
                        }
                        if (dDoubleValue <= 9.223372036854776E18d && dDoubleValue >= -9.223372036854776E18d) {
                            jLongValue = Math.round(dDoubleValue);
                            if (FirebaseAnalytics.Event.REFUND.equals(zzbgVarZza.zza)) {
                                jLongValue = -jLongValue;
                            }
                        } else {
                            zzj().zzu().zza("Data lost. Currency value is too big. appId", zzfr.zza(str2), Double.valueOf(dDoubleValue));
                            zzf().zzw();
                            zzf().zzu();
                            return;
                        }
                    } else {
                        jLongValue = zzbgVarZza.zzb.zzb("value").longValue();
                    }
                    if (TextUtils.isEmpty(strZzd)) {
                        jNanoTime = jNanoTime;
                        str3 = "_err";
                    } else {
                        String upperCase = strZzd.toUpperCase(Locale.US);
                        if (upperCase.matches("[A-Z]{3}")) {
                            String str5 = "_ltv_" + upperCase;
                            zzne zzneVarZze2 = zzf().zze(str2, str5);
                            if (zzneVarZze2 == null || !(zzneVarZze2.zze instanceof Long)) {
                                zzao zzaoVarZzf = zzf();
                                int iZzb = zze().zzb(str2, zzbi.zzae) - 1;
                                Preconditions.checkNotEmpty(str2);
                                zzaoVarZzf.zzt();
                                zzaoVarZzf.zzak();
                                try {
                                    zzaoVarZzf.m30e_().execSQL("delete from user_attributes where app_id=? and name in (select name from user_attributes where app_id=? and name like '_ltv_%' order by set_timestamp desc limit ?,10);", new String[]{str2, str2, String.valueOf(iZzb)});
                                } catch (SQLiteException e) {
                                    zzaoVarZzf.zzj().zzg().zza("Error pruning currencies. appId", zzfr.zza(str2), e);
                                }
                                zzneVar = new zzne(str2, zzbgVarZza.zzc, str5, zzb().currentTimeMillis(), Long.valueOf(jLongValue));
                            } else {
                                zzneVar = new zzne(str2, zzbgVarZza.zzc, str5, zzb().currentTimeMillis(), Long.valueOf(((Long) zzneVarZze2.zze).longValue() + jLongValue));
                            }
                            zzne zzneVar2 = zzneVar;
                            if (!zzf().zza(zzneVar2)) {
                                zzj().zzg().zza("Too many unique user properties are set. Ignoring user property. appId", zzfr.zza(str2), this.zzm.zzk().zzc(zzneVar2.zzc), zzneVar2.zze);
                                zzq();
                                zznd.zza(this.zzah, str2, 9, (String) null, (String) null, 0);
                            }
                        } else {
                            jNanoTime = jNanoTime;
                            str3 = "_err";
                        }
                    }
                } else {
                    jNanoTime = jNanoTime;
                    str3 = "_err";
                }
                boolean zZzh = zznd.zzh(zzbgVarZza.zza);
                boolean zEquals = str3.equals(zzbgVarZza.zza);
                zzq();
                zzap zzapVarZza = zzf().zza(zzx(), str2, zznd.zza(zzbgVarZza.zzb) + 1, true, zZzh, false, zEquals, false);
                long j2 = zzapVarZza.zzb;
                zze();
                long jIntValue = j2 - ((long) zzbi.zzk.zza(null).intValue());
                if (jIntValue > 0) {
                    if (jIntValue % 1000 == 1) {
                        zzj().zzg().zza("Data loss. Too many events logged. appId, count", zzfr.zza(str2), Long.valueOf(zzapVarZza.zzb));
                    }
                    zzf().zzw();
                    zzf().zzu();
                    return;
                }
                if (zZzh) {
                    long j3 = zzapVarZza.zza;
                    zze();
                    long jIntValue2 = j3 - ((long) zzbi.zzm.zza(null).intValue());
                    if (jIntValue2 > 0) {
                        if (jIntValue2 % 1000 == 1) {
                            zzj().zzg().zza("Data loss. Too many public events logged. appId, count", zzfr.zza(str2), Long.valueOf(zzapVarZza.zza));
                        }
                        zzq();
                        zznd.zza(this.zzah, str2, 16, "_ev", zzbgVarZza.zza, 0);
                        zzf().zzw();
                        zzf().zzu();
                        return;
                    }
                }
                if (zEquals) {
                    z = false;
                    long jMax = zzapVarZza.zzd - ((long) Math.max(0, Math.min(1000000, zze().zzb(zzoVar.zza, zzbi.zzl))));
                    if (jMax > 0) {
                        if (jMax == 1) {
                            zzj().zzg().zza("Too many error events logged. appId, count", zzfr.zza(str2), Long.valueOf(zzapVarZza.zzd));
                        }
                        zzf().zzw();
                        zzf().zzu();
                        return;
                    }
                } else {
                    z = false;
                }
                Bundle bundleZzb = zzbgVarZza.zzb.zzb();
                zzq().zza(bundleZzb, "_o", zzbgVarZza.zzc);
                if (zzq().zzf(str2)) {
                    zzq().zza(bundleZzb, "_dbg", (Object) 1L);
                    zzq().zza(bundleZzb, "_r", (Object) 1L);
                }
                if ("_s".equals(zzbgVarZza.zza) && (zzneVarZze = zzf().zze(zzoVar.zza, "_sno")) != null && (zzneVarZze.zze instanceof Long)) {
                    zzq().zza(bundleZzb, "_sno", zzneVarZze.zze);
                }
                long jZza = zzf().zza(str2);
                if (jZza > 0) {
                    zzj().zzu().zza("Data lost. Too many events stored on disk, deleted. appId", zzfr.zza(str2), Long.valueOf(jZza));
                }
                zzhf zzhfVar = this.zzm;
                String str6 = zzbgVarZza.zzc;
                String str7 = zzbgVarZza.zza;
                long j4 = zzbgVarZza.zzd;
                boolean z4 = z;
                zzaz zzazVar = new zzaz(zzhfVar, str6, str2, str7, j4, 0L, bundleZzb);
                zzbc zzbcVarZzd = zzf().zzd(str2, zzazVar.zzb);
                if (zzbcVarZzd == null) {
                    if (zzf().zzb(str2) >= zze().zza(str2) && zZzh) {
                        zzj().zzg().zza("Too many event names used, ignoring event. appId, name, supported count", zzfr.zza(str2), this.zzm.zzk().zza(zzazVar.zzb), Integer.valueOf(zze().zza(str2)));
                        zzq();
                        zznd.zza(this.zzah, str2, 8, (String) null, (String) null, 0);
                        zzf().zzu();
                        return;
                    }
                    zzbcVarZza = new zzbc(str2, zzazVar.zzb, 0L, 0L, zzazVar.zzc, 0L, null, null, null, null);
                } else {
                    zzazVar = zzazVar.zza(this.zzm, zzbcVarZzd.zzf);
                    zzbcVarZza = zzbcVarZzd.zza(zzazVar.zzc);
                }
                zzf().zza(zzbcVarZza);
                zzl().zzt();
                zzs();
                Preconditions.checkNotNull(zzazVar);
                Preconditions.checkNotNull(zzoVar);
                Preconditions.checkNotEmpty(zzazVar.zza);
                Preconditions.checkArgument(zzazVar.zza.equals(zzoVar.zza));
                com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzp = com.google.android.gms.internal.measurement.zzfi.zzj.zzu().zzg(1).zzp(l11l11lI1lll.l111l1111l1Il);
                if (!TextUtils.isEmpty(zzoVar.zza)) {
                    zzaVarZzp.zzb(zzoVar.zza);
                }
                if (!TextUtils.isEmpty(zzoVar.zzd)) {
                    zzaVarZzp.zzd(zzoVar.zzd);
                }
                if (!TextUtils.isEmpty(zzoVar.zzc)) {
                    zzaVarZzp.zze(zzoVar.zzc);
                }
                if (zzps.zza() && !TextUtils.isEmpty(zzoVar.zzv) && (zze().zza(zzbi.zzbr) || zze().zze(zzoVar.zza, zzbi.zzbt))) {
                    zzaVarZzp.zzr(zzoVar.zzv);
                }
                if (zzoVar.zzj != -2147483648L) {
                    zzaVarZzp.zze((int) zzoVar.zzj);
                }
                zzaVarZzp.zzf(zzoVar.zze);
                if (!TextUtils.isEmpty(zzoVar.zzb)) {
                    zzaVarZzp.zzm(zzoVar.zzb);
                }
                zzih zzihVarZza = zzb((String) Preconditions.checkNotNull(zzoVar.zza)).zza(zzih.zza(zzoVar.zzt));
                zzaVarZzp.zzg(zzihVarZza.zze());
                if (zzaVarZzp.zzt().isEmpty() && !TextUtils.isEmpty(zzoVar.zzp)) {
                    zzaVarZzp.zza(zzoVar.zzp);
                }
                if (zzpg.zza() && zze().zze(zzoVar.zza, zzbi.zzcf)) {
                    zzq();
                    if (zznd.zzd(zzoVar.zza)) {
                        zzaVarZzp.zzd(zzoVar.zzaa);
                        long j5 = zzoVar.zzab;
                        j = 0;
                        if (!zzihVarZza.zzg() && j5 != 0) {
                            j5 = (j5 & (-2)) | 32;
                        }
                        zzaVarZzp.zza(j5 == 1 ? true : z4);
                        if (j5 != 0) {
                            com.google.android.gms.internal.measurement.zzfi.zzb.zza zzaVarZza = com.google.android.gms.internal.measurement.zzfi.zzb.zza();
                            zzaVarZza.zzc((j5 & 1) != 0 ? true : z4);
                            zzaVarZza.zze((2 & j5) != 0 ? true : z4);
                            zzaVarZza.zzf((4 & j5) != 0 ? true : z4);
                            zzaVarZza.zzg((8 & j5) != 0 ? true : z4);
                            zzaVarZza.zzb((16 & j5) != 0 ? true : z4);
                            zzaVarZza.zza((j5 & 32) != 0 ? true : z4);
                            zzaVarZza.zzd((64 & j5) != 0 ? true : z4);
                            zzaVarZzp.zza((com.google.android.gms.internal.measurement.zzfi.zzb) ((com.google.android.gms.internal.measurement.zzix) zzaVarZza.zzab()));
                        }
                    } else {
                        j = 0;
                    }
                } else {
                    j = 0;
                }
                if (zzoVar.zzf != j) {
                    zzaVarZzp.zzc(zzoVar.zzf);
                }
                zzaVarZzp.zzd(zzoVar.zzr);
                List<Integer> listZzu = zzp().zzu();
                if (listZzu != null) {
                    zzaVarZzp.zzc(listZzu);
                }
                zzih zzihVarZza2 = zzb((String) Preconditions.checkNotNull(zzoVar.zza)).zza(zzih.zza(zzoVar.zzt));
                if (zzihVarZza2.zzg() && zzoVar.zzn && (pairZza = this.zzj.zza(zzoVar.zza, zzihVarZza2)) != null && !TextUtils.isEmpty((CharSequence) pairZza.first) && zzoVar.zzn) {
                    zzaVarZzp.zzq((String) pairZza.first);
                    if (pairZza.second != null) {
                        zzaVarZzp.zzc(((Boolean) pairZza.second).booleanValue());
                    }
                    if (!zznk.zza() || !zze().zza(zzbi.zzcr) || zzazVar.zzb.equals("_fx") || ((String) pairZza.first).equals("00000000-0000-0000-0000-000000000000") || (zzhVarZzd = zzf().zzd(zzoVar.zza)) == null || !zzhVarZzd.zzan()) {
                        str = "_r";
                    } else {
                        zza(zzoVar.zza, z4);
                        Bundle bundle = new Bundle();
                        str = "_r";
                        bundle.putLong(str, 1L);
                        this.zzah.zza(zzoVar.zza, "_fx", bundle);
                    }
                } else {
                    str = "_r";
                }
                this.zzm.zzg().zzab();
                com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzi = zzaVarZzp.zzi(Build.MODEL);
                this.zzm.zzg().zzab();
                zzaVarZzi.zzo(Build.VERSION.RELEASE).zzi((int) this.zzm.zzg().zzg()).zzs(this.zzm.zzg().zzh());
                zzaVarZzp.zzj(zzoVar.zzx);
                if (this.zzm.zzac()) {
                    zzaVarZzp.zzr();
                    if (!TextUtils.isEmpty(null)) {
                        zzaVarZzp.zzj((String) null);
                    }
                }
                zzh zzhVarZzd3 = zzf().zzd(zzoVar.zza);
                if (zzhVarZzd3 == null) {
                    zzhVarZzd3 = new zzh(this.zzm, zzoVar.zza);
                    zzhVarZzd3.zzb(zza(zzihVarZza2));
                    zzhVarZzd3.zze(zzoVar.zzk);
                    zzhVarZzd3.zzf(zzoVar.zzb);
                    if (zzihVarZza2.zzg()) {
                        zzhVarZzd3.zzh(this.zzj.zza(zzoVar.zza, zzoVar.zzn));
                    }
                    zzhVarZzd3.zzo(j);
                    zzhVarZzd3.zzp(j);
                    zzhVarZzd3.zzn(j);
                    zzhVarZzd3.zzd(zzoVar.zzc);
                    zzhVarZzd3.zza(zzoVar.zzj);
                    zzhVarZzd3.zzc(zzoVar.zzd);
                    zzhVarZzd3.zzm(zzoVar.zze);
                    zzhVarZzd3.zzj(zzoVar.zzf);
                    zzhVarZzd3.zzb(zzoVar.zzh);
                    zzhVarZzd3.zzk(zzoVar.zzr);
                    zzf().zza(zzhVarZzd3);
                }
                if (zzihVarZza2.zzh() && !TextUtils.isEmpty(zzhVarZzd3.zzy())) {
                    zzaVarZzp.zzc((String) Preconditions.checkNotNull(zzhVarZzd3.zzy()));
                }
                if (!TextUtils.isEmpty(zzhVarZzd3.zzab())) {
                    zzaVarZzp.zzl((String) Preconditions.checkNotNull(zzhVarZzd3.zzab()));
                }
                List<zzne> listZzi = zzf().zzi(zzoVar.zza);
                for (?? r12 = z4; r12 < listZzi.size(); r12++) {
                    com.google.android.gms.internal.measurement.zzfi.zzn.zza zzaVarZzb = com.google.android.gms.internal.measurement.zzfi.zzn.zze().zza(listZzi.get(r12).zzc).zzb(listZzi.get(r12).zzd);
                    zzp().zza(zzaVarZzb, listZzi.get(r12).zze);
                    zzaVarZzp.zza(zzaVarZzb);
                    if ("_sid".equals(listZzi.get(r12).zzc) && zzhVarZzd3.zzs() != j && zzp().zza(zzoVar.zzv) != zzhVarZzd3.zzs()) {
                        zzaVarZzp.zzp();
                    }
                }
                try {
                    long jZza2 = zzf().zza((com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzp.zzab()));
                    zzao zzaoVarZzf2 = zzf();
                    if (zzazVar.zze != null) {
                        Iterator<String> it = zzazVar.zze.iterator();
                        while (true) {
                            if (it.hasNext()) {
                                if (str.equals(it.next())) {
                                }
                            } else {
                                boolean zZzc = zzi().zzc(zzazVar.zza, zzazVar.zzb);
                                zzap zzapVarZza2 = zzf().zza(zzx(), zzazVar.zza, false, false, false, false, false);
                                if (!zZzc || zzapVarZza2.zze >= zze().zze(zzazVar.zza)) {
                                    break;
                                }
                                zzf().zzw();
                                zzf().zzu();
                                zzab();
                                zzj().zzp().zza("Background event processing time, ms", Long.valueOf(((System.nanoTime() - jNanoTime) + 500000) / 1000000));
                            }
                            z4 = true;
                            break;
                        }
                    }
                    if (zzaoVarZzf2.zza(zzazVar, jZza2, z4)) {
                        this.zzp = j;
                    }
                } catch (IOException e2) {
                    zzj().zzg().zza("Data loss. Failed to insert raw event metadata. appId", zzfr.zza(zzaVarZzp.zzr()), e2);
                }
                zzf().zzw();
                zzf().zzu();
                zzab();
                zzj().zzp().zza("Background event processing time, ms", Long.valueOf(((System.nanoTime() - jNanoTime) + 500000) / 1000000));
            } catch (Throwable th) {
                zzf().zzu();
                throw th;
            }
        }
    }

    private static boolean zze(zzo zzoVar) {
        return (TextUtils.isEmpty(zzoVar.zzb) && TextUtils.isEmpty(zzoVar.zzp)) ? false : true;
    }

    private final boolean zza(String str, long j) {
        Throwable th;
        SQLiteException sQLiteException;
        String str2;
        ?? r8;
        ?? r4;
        com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzi;
        boolean z;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar2;
        int i;
        int i2;
        int i3;
        int i4;
        boolean z2;
        int i5;
        int i6;
        com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar3;
        int i7;
        long jLongValue;
        int i8;
        Iterator<com.google.android.gms.internal.measurement.zzfi.zze> it;
        int iZza;
        int i9;
        zza zzaVar4;
        String strZzx;
        zzh zzhVarZzd;
        long jZzp;
        long jZzr;
        String strZzw;
        zzao zzaoVarZzf;
        List<Long> list;
        StringBuilder sb;
        int i10;
        int iDelete;
        zzao zzaoVarZzf2;
        com.google.android.gms.internal.measurement.zzfc.zzd zzdVarZzc;
        HashMap map;
        ArrayList arrayList;
        SecureRandom secureRandomZzv;
        int i11;
        Iterator it2;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar5;
        long jZza;
        long jZza2;
        int iZzb;
        zzbc zzbcVarZza;
        long j2;
        Long l;
        boolean z3;
        Boolean boolValueOf;
        zza zzaVar6;
        SecureRandom secureRandom;
        long jZza3;
        HashMap map2;
        int i12;
        long j3;
        long j4;
        String str3;
        zzbc zzbcVarZzd;
        int i13;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar7;
        Iterator<com.google.android.gms.internal.measurement.zzfi.zzg> it3;
        String strZzp;
        zzmh zzmhVarZza;
        com.google.android.gms.internal.measurement.zzfi.zze zzeVarZza;
        String strZzx2;
        zzh zzhVarZzd2;
        com.google.android.gms.internal.measurement.zzfi.zze zzeVarZza2;
        com.google.android.gms.internal.measurement.zzfi.zzg zzgVarZza;
        Long lValueOf;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar8;
        int i14;
        String str4;
        boolean zZzc;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar9;
        String str5;
        boolean z4;
        boolean z5;
        int i15;
        com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar10;
        int i16;
        com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar11;
        boolean z6;
        int i17;
        com.google.android.gms.internal.measurement.zzfi.zzg zzgVarZzb;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar12;
        com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar13;
        int i18;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar14;
        int i19;
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar15;
        ArrayList arrayList2;
        int i20;
        int i21;
        int i22;
        String strZzh;
        int iCharCount;
        int iCodePointAt;
        String strZze;
        int i23;
        Object obj;
        String[] strArr;
        ?? r22;
        String string;
        SQLiteException e;
        Cursor cursorQuery;
        String[] strArr2;
        String str6;
        Cursor cursorQuery2;
        String[] strArr3;
        String str7 = "_ai";
        zzf().zzp();
        try {
            ?? r5 = 0;
            String str8 = null;
            zza zzaVar16 = new zza();
            zzao zzaoVarZzf3 = zzf();
            ?? MoveToNext = this.zzab;
            Preconditions.checkNotNull(zzaVar16);
            zzaoVarZzf3.zzt();
            zzaoVarZzf3.zzak();
            try {
                try {
                    SQLiteDatabase sQLiteDatabaseM30e_ = zzaoVarZzf3.m30e_();
                    try {
                        if (TextUtils.isEmpty(null)) {
                            if (MoveToNext != -1) {
                                strArr3 = new String[]{String.valueOf((long) MoveToNext), String.valueOf(j)};
                            } else {
                                strArr3 = new String[]{String.valueOf(j)};
                            }
                            ?? RawQuery = sQLiteDatabaseM30e_.rawQuery("select app_id, metadata_fingerprint from raw_events where " + (MoveToNext != -1 ? "rowid <= ? and " : "") + "app_id in (select app_id from apps where config_fetched_time >= ?) order by rowid limit 1;", strArr3);
                            if (RawQuery.moveToFirst()) {
                                string = RawQuery.getString(0);
                                try {
                                    String string2 = RawQuery.getString(1);
                                    RawQuery.close();
                                    r22 = RawQuery;
                                    str8 = string2;
                                    string = string;
                                    try {
                                        cursorQuery = sQLiteDatabaseM30e_.query("raw_events_metadata", new String[]{"metadata"}, "app_id = ? and metadata_fingerprint = ?", new String[]{string, str8}, null, null, "rowid", "2");
                                        try {
                                            try {
                                                if (!cursorQuery.moveToFirst()) {
                                                    zzaoVarZzf3.zzj().zzg().zza("Raw event metadata record is missing. appId", zzfr.zza(string));
                                                    if (cursorQuery != null) {
                                                        cursorQuery.close();
                                                    }
                                                } else {
                                                    try {
                                                        try {
                                                            com.google.android.gms.internal.measurement.zzfi.zzj zzjVar = (com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzj.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfi.zzj.zzu(), cursorQuery.getBlob(0))).zzab());
                                                            if (cursorQuery.moveToNext()) {
                                                                zzaoVarZzf3.zzj().zzu().zza("Get multiple raw event metadata records, expected one. appId", zzfr.zza(string));
                                                            }
                                                            cursorQuery.close();
                                                            zzaVar16.zza(zzjVar);
                                                            if (MoveToNext != -1) {
                                                                strArr2 = new String[]{string, str8, String.valueOf((long) MoveToNext)};
                                                                str6 = "app_id = ? and metadata_fingerprint = ? and rowid <= ?";
                                                            } else {
                                                                strArr2 = new String[]{string, str8};
                                                                str6 = "app_id = ? and metadata_fingerprint = ?";
                                                            }
                                                            cursorQuery2 = sQLiteDatabaseM30e_.query("raw_events", new String[]{"rowid", AppMeasurementSdk.ConditionalUserProperty.NAME, "timestamp", "data"}, str6, strArr2, null, null, "rowid", null);
                                                            if (!cursorQuery2.moveToFirst()) {
                                                                while (true) {
                                                                    long j5 = cursorQuery2.getLong(0);
                                                                    try {
                                                                        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar17 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfi.zze.zze(), cursorQuery2.getBlob(3));
                                                                        zzaVar17.zza(cursorQuery2.getString(1)).zzb(cursorQuery2.getLong(2));
                                                                        MoveToNext = zzaVar16.zza(j5, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar17.zzab()));
                                                                        if (MoveToNext == 0) {
                                                                            if (cursorQuery2 != null) {
                                                                                break;
                                                                            }
                                                                            cursorQuery2.close();
                                                                            break;
                                                                        }
                                                                        MoveToNext = cursorQuery2.moveToNext();
                                                                        if (MoveToNext == 0) {
                                                                            if (cursorQuery2 != null) {
                                                                                break;
                                                                            }
                                                                            cursorQuery2.close();
                                                                            break;
                                                                        }
                                                                    } catch (IOException e2) {
                                                                        zzaoVarZzf3.zzj().zzg().zza("Data loss. Failed to merge raw event. appId", zzfr.zza(string), e2);
                                                                    }
                                                                }
                                                            } else {
                                                                MoveToNext = zzaoVarZzf3.zzj().zzu();
                                                                MoveToNext.zza("Raw event data disappeared while in transaction. appId", zzfr.zza(string));
                                                                if (cursorQuery2 != null) {
                                                                    cursorQuery2.close();
                                                                }
                                                            }
                                                        } catch (IOException e3) {
                                                            MoveToNext = cursorQuery;
                                                            zzaoVarZzf3.zzj().zzg().zza("Data loss. Failed to merge raw event metadata. appId", zzfr.zza(string), e3);
                                                            if (MoveToNext != 0) {
                                                                MoveToNext.close();
                                                            }
                                                        }
                                                    } catch (SQLiteException e4) {
                                                        e = e4;
                                                        RawQuery = MoveToNext;
                                                        sQLiteException = e;
                                                        r4 = RawQuery;
                                                        r8 = string;
                                                        zzaoVarZzf3.zzj().zzg().zza("Data loss. Error selecting raw event. appId", zzfr.zza((String) r8), sQLiteException);
                                                        if (r4 != 0) {
                                                            r4.close();
                                                        }
                                                    } catch (Throwable th2) {
                                                        th = th2;
                                                        th = th;
                                                        r5 = MoveToNext;
                                                        if (r5 != 0) {
                                                            r5.close();
                                                            throw th;
                                                        }
                                                        throw th;
                                                    }
                                                }
                                            } catch (SQLiteException e5) {
                                                sQLiteException = e5;
                                                r4 = cursorQuery;
                                                r8 = string;
                                                zzaoVarZzf3.zzj().zzg().zza("Data loss. Error selecting raw event. appId", zzfr.zza((String) r8), sQLiteException);
                                                if (r4 != 0) {
                                                    r4.close();
                                                }
                                            } catch (Throwable th3) {
                                                th = th3;
                                                r5 = cursorQuery;
                                                if (r5 != 0) {
                                                    r5.close();
                                                    throw th;
                                                }
                                                throw th;
                                            }
                                        } catch (SQLiteException e6) {
                                            e = e6;
                                            MoveToNext = cursorQuery;
                                        } catch (Throwable th4) {
                                            th = th4;
                                            MoveToNext = cursorQuery;
                                        }
                                    } catch (SQLiteException e7) {
                                        sQLiteException = e7;
                                        r4 = r22;
                                        r8 = string;
                                    } catch (Throwable th5) {
                                        th = th5;
                                        r5 = r22;
                                    }
                                } catch (SQLiteException e8) {
                                    e = e8;
                                    sQLiteException = e;
                                    r4 = RawQuery;
                                    r8 = string;
                                    zzaoVarZzf3.zzj().zzg().zza("Data loss. Error selecting raw event. appId", zzfr.zza((String) r8), sQLiteException);
                                    if (r4 != 0) {
                                        r4.close();
                                    }
                                    if (zzaVar16.zzc != null) {
                                        com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzby = zzaVar16.zza.zzby();
                                        com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar18 = zzaVarZzby;
                                        zzaVarZzi = zzaVarZzby.zzi();
                                        z = false;
                                        zzaVar = null;
                                        zzaVar2 = null;
                                        i = 0;
                                        i2 = 0;
                                        i3 = -1;
                                        i4 = -1;
                                        while (true) {
                                            z2 = z;
                                            i5 = i2;
                                            i6 = i3;
                                            if (i < zzaVar16.zzc.size()) {
                                                break;
                                            }
                                            com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby2 = zzaVar16.zzc.get(i).zzby();
                                            com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar19 = zzaVarZzby2;
                                            zzaVar8 = zzaVarZzby2;
                                            i14 = i;
                                            if (zzi().zzd(zzaVar16.zza.zzx(), zzaVar8.zze())) {
                                                zzj().zzu().zza("Dropping blocked raw event. appId", zzfr.zza(zzaVar16.zza.zzx()), this.zzm.zzk().zza(zzaVar8.zze()));
                                                if (!zzi().zzm(zzaVar16.zza.zzx())) {
                                                    zzq();
                                                    zznd.zza(this.zzah, zzaVar16.zza.zzx(), 11, "_ev", zzaVar8.zze(), 0);
                                                }
                                                i2 = i5;
                                                str4 = str7;
                                                zzaVar9 = zzaVar;
                                                i3 = i6;
                                                i19 = i14;
                                                zzaVar13 = zzaVarZzi;
                                            } else {
                                                if (zzaVar8.zze().equals(zzii.zza(str7))) {
                                                    zzaVar8.zza(str7);
                                                    zzj().zzp().zza("Renaming ad_impression to _ai");
                                                    if (zzj().zza(5)) {
                                                        i23 = 0;
                                                        while (i23 < zzaVar8.zza()) {
                                                            String str9 = str7;
                                                            if (!FirebaseAnalytics.Param.AD_PLATFORM.equals(zzaVar8.zzb(i23).zzg())) {
                                                            }
                                                            i23++;
                                                            str7 = str9;
                                                        }
                                                    }
                                                }
                                                str4 = str7;
                                                zZzc = zzi().zzc(zzaVar16.zza.zzx(), zzaVar8.zze());
                                                if (zZzc) {
                                                    zzaVar9 = zzaVar;
                                                } else {
                                                    zzp();
                                                    strZze = zzaVar8.zze();
                                                    Preconditions.checkNotEmpty(strZze);
                                                    zzaVar9 = zzaVar;
                                                    if (strZze.hashCode() == 95027) {
                                                    }
                                                    zzaVar10 = zzaVarZzi;
                                                    str5 = "_et";
                                                    i4 = i4;
                                                    if (zZzc) {
                                                        arrayList2 = new ArrayList(zzaVar8.zzf());
                                                        i21 = -1;
                                                        i22 = -1;
                                                        for (i20 = 0; i20 < arrayList2.size(); i20++) {
                                                            if ("value".equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                                i21 = i20;
                                                            } else if (FirebaseAnalytics.Param.CURRENCY.equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                                i22 = i20;
                                                            }
                                                        }
                                                        if (i21 == -1) {
                                                            if (((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzl()) {
                                                            }
                                                            if (i22 == -1) {
                                                                strZzh = ((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i22)).zzh();
                                                                if (strZzh.length() != 3) {
                                                                    iCharCount = 0;
                                                                    while (iCharCount < strZzh.length()) {
                                                                        iCodePointAt = strZzh.codePointAt(iCharCount);
                                                                        if (!Character.isLetter(iCodePointAt)) {
                                                                            iCharCount += Character.charCount(iCodePointAt);
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            zzj().zzv().zza("Value parameter discarded. You must also supply a 3-letter ISO_4217 currency code in the currency parameter.");
                                                            zzaVar8.zza(i21);
                                                            zza(zzaVar8, "_c");
                                                            zza(zzaVar8, 19, FirebaseAnalytics.Param.CURRENCY);
                                                            break;
                                                        }
                                                    }
                                                    if ("_e".equals(zzaVar8.zze())) {
                                                        zzp();
                                                        if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), "_fr") == null) {
                                                            if (zzaVar2 != null) {
                                                                zzaVar15 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar2.clone());
                                                                if (zza(zzaVar8, zzaVar15)) {
                                                                    zzaVar13 = zzaVar10;
                                                                    int i24 = i4;
                                                                    zzaVar13.zza(i24, zzaVar15);
                                                                    i4 = i24;
                                                                    i3 = i6;
                                                                    zzaVar2 = null;
                                                                    zzaVar9 = null;
                                                                }
                                                            }
                                                            zzaVar13 = zzaVar10;
                                                            i3 = i5;
                                                            i4 = i4;
                                                            zzaVar9 = zzaVar8;
                                                        } else {
                                                            zzaVar13 = zzaVar10;
                                                            i18 = i4;
                                                            i3 = i6;
                                                            i4 = i18;
                                                        }
                                                    } else {
                                                        zzaVar13 = zzaVar10;
                                                        i18 = i4;
                                                        if ("_vs".equals(zzaVar8.zze())) {
                                                            zzp();
                                                            if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), str5) == null) {
                                                                if (zzaVar9 != null) {
                                                                    zzaVar14 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar9.clone());
                                                                    if (zza(zzaVar14, zzaVar8)) {
                                                                        zzaVar13.zza(i6, zzaVar14);
                                                                        i3 = i6;
                                                                        i4 = i18;
                                                                        zzaVar2 = null;
                                                                        zzaVar9 = null;
                                                                    }
                                                                }
                                                                i4 = i5;
                                                                i3 = i6;
                                                                zzaVar2 = zzaVar8;
                                                            } else {
                                                                i3 = i6;
                                                                i4 = i18;
                                                            }
                                                        } else {
                                                            i3 = i6;
                                                            i4 = i18;
                                                        }
                                                    }
                                                    i19 = i14;
                                                    zzaVar16.zzc.set(i19, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()));
                                                    i2 = i5 + 1;
                                                    zzaVar13.zza(zzaVar8);
                                                }
                                                str5 = "_et";
                                                z4 = false;
                                                z5 = false;
                                                i15 = 0;
                                                while (true) {
                                                    zzaVar10 = zzaVarZzi;
                                                    if (i15 < zzaVar8.zza()) {
                                                        break;
                                                    }
                                                    if ("_c".equals(zzaVar8.zzb(i15).zzg())) {
                                                        com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby3 = zzaVar8.zzb(i15).zzby();
                                                        com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar20 = zzaVarZzby3;
                                                        zzaVar8.zza(i15, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby3.zza(1L).zzab()));
                                                        zzaVar2 = zzaVar2;
                                                        z4 = true;
                                                    } else {
                                                        zzaVar12 = zzaVar2;
                                                        if ("_r".equals(zzaVar8.zzb(i15).zzg())) {
                                                            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby4 = zzaVar8.zzb(i15).zzby();
                                                            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar21 = zzaVarZzby4;
                                                            zzaVar2 = zzaVar12;
                                                            zzaVar8.zza(i15, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby4.zza(1L).zzab()));
                                                            z5 = true;
                                                        } else {
                                                            zzaVar2 = zzaVar12;
                                                        }
                                                    }
                                                    i15++;
                                                    zzaVarZzi = zzaVar10;
                                                }
                                                if (z4) {
                                                }
                                                if (!z5) {
                                                    zzj().zzp().zza("Marking event as real-time", this.zzm.zzk().zza(zzaVar8.zze()));
                                                    zzaVar8.zza(com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_r").zza(1L));
                                                }
                                                if (zzf().zza(zzx(), zzaVar16.zza.zzx(), false, false, false, false, true).zze > zze().zze(zzaVar16.zza.zzx())) {
                                                    zza(zzaVar8, "_r");
                                                } else {
                                                    z2 = true;
                                                }
                                                if (zznd.zzh(zzaVar8.zze())) {
                                                    zzj().zzu().zza("Too many conversions. Not logging as conversion. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                                    i16 = -1;
                                                    zzaVar11 = null;
                                                    z6 = false;
                                                    for (i17 = 0; i17 < zzaVar8.zza(); i17++) {
                                                        zzgVarZzb = zzaVar8.zzb(i17);
                                                        if ("_c".equals(zzgVarZzb.zzg())) {
                                                            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby5 = zzgVarZzb.zzby();
                                                            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar22 = zzaVarZzby5;
                                                            zzaVar11 = zzaVarZzby5;
                                                            i16 = i17;
                                                        } else if ("_err".equals(zzgVarZzb.zzg())) {
                                                            z6 = true;
                                                        }
                                                    }
                                                    if (!z6) {
                                                        if (zzaVar11 != null) {
                                                            zzaVar8.zza(i16, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzg.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar11.clone())).zza("_err").zza(10L).zzab()));
                                                        } else {
                                                            zzj().zzg().zza("Did not find conversion parameter. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                                        }
                                                    } else if (zzaVar11 != null) {
                                                        zzaVar8.zza(i16, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzg.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar11.clone())).zza("_err").zza(10L).zzab()));
                                                    } else {
                                                        zzj().zzg().zza("Did not find conversion parameter. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                                    }
                                                }
                                                if (zZzc) {
                                                    arrayList2 = new ArrayList(zzaVar8.zzf());
                                                    i21 = -1;
                                                    i22 = -1;
                                                    while (i20 < arrayList2.size()) {
                                                        if ("value".equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                            i21 = i20;
                                                        } else if (FirebaseAnalytics.Param.CURRENCY.equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                            i22 = i20;
                                                        }
                                                    }
                                                    if (i21 == -1) {
                                                        if (((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzl()) {
                                                        }
                                                        if (i22 == -1) {
                                                            strZzh = ((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i22)).zzh();
                                                            if (strZzh.length() != 3) {
                                                                iCharCount = 0;
                                                                while (iCharCount < strZzh.length()) {
                                                                    iCodePointAt = strZzh.codePointAt(iCharCount);
                                                                    if (!Character.isLetter(iCodePointAt)) {
                                                                        iCharCount += Character.charCount(iCodePointAt);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        zzj().zzv().zza("Value parameter discarded. You must also supply a 3-letter ISO_4217 currency code in the currency parameter.");
                                                        zzaVar8.zza(i21);
                                                        zza(zzaVar8, "_c");
                                                        zza(zzaVar8, 19, FirebaseAnalytics.Param.CURRENCY);
                                                        break;
                                                    }
                                                }
                                                if ("_e".equals(zzaVar8.zze())) {
                                                    zzp();
                                                    if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), "_fr") == null) {
                                                        if (zzaVar2 != null) {
                                                            zzaVar15 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar2.clone());
                                                            if (zza(zzaVar8, zzaVar15)) {
                                                                zzaVar13 = zzaVar10;
                                                                int i25 = i4;
                                                                zzaVar13.zza(i25, zzaVar15);
                                                                i4 = i25;
                                                                i3 = i6;
                                                                zzaVar2 = null;
                                                                zzaVar9 = null;
                                                            }
                                                        }
                                                        zzaVar13 = zzaVar10;
                                                        i3 = i5;
                                                        i4 = i4;
                                                        zzaVar9 = zzaVar8;
                                                    } else {
                                                        zzaVar13 = zzaVar10;
                                                        i18 = i4;
                                                        i3 = i6;
                                                        i4 = i18;
                                                    }
                                                } else {
                                                    zzaVar13 = zzaVar10;
                                                    i18 = i4;
                                                    if ("_vs".equals(zzaVar8.zze())) {
                                                        zzp();
                                                        if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), str5) == null) {
                                                            if (zzaVar9 != null) {
                                                                zzaVar14 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar9.clone());
                                                                if (zza(zzaVar14, zzaVar8)) {
                                                                    zzaVar13.zza(i6, zzaVar14);
                                                                    i3 = i6;
                                                                    i4 = i18;
                                                                    zzaVar2 = null;
                                                                    zzaVar9 = null;
                                                                }
                                                            }
                                                            i4 = i5;
                                                            i3 = i6;
                                                            zzaVar2 = zzaVar8;
                                                        } else {
                                                            i3 = i6;
                                                            i4 = i18;
                                                        }
                                                    } else {
                                                        i3 = i6;
                                                        i4 = i18;
                                                    }
                                                }
                                                i19 = i14;
                                                zzaVar16.zzc.set(i19, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()));
                                                i2 = i5 + 1;
                                                zzaVar13.zza(zzaVar8);
                                            }
                                            i = i19 + 1;
                                            zzaVarZzi = zzaVar13;
                                            z = z2;
                                            zzaVar = zzaVar9;
                                            str7 = str4;
                                        }
                                        zzaVar3 = zzaVarZzi;
                                        i7 = i5;
                                        jLongValue = 0;
                                        i8 = 0;
                                        while (i8 < i7) {
                                            zzeVarZza2 = zzaVar3.zza(i8);
                                            if ("_e".equals(zzeVarZza2.zzg())) {
                                                zzp();
                                                if (zzmz.zza(zzeVarZza2, "_fr") != null) {
                                                    zzaVar3.zzb(i8);
                                                    i7--;
                                                    i8--;
                                                } else {
                                                    zzp();
                                                    zzgVarZza = zzmz.zza(zzeVarZza2, "_et");
                                                    if (zzgVarZza == null) {
                                                        if (zzgVarZza.zzl()) {
                                                            lValueOf = Long.valueOf(zzgVarZza.zzd());
                                                        } else {
                                                            lValueOf = null;
                                                        }
                                                        if (lValueOf == null) {
                                                        }
                                                    }
                                                }
                                            } else {
                                                zzp();
                                                zzgVarZza = zzmz.zza(zzeVarZza2, "_et");
                                                if (zzgVarZza == null) {
                                                    if (zzgVarZza.zzl()) {
                                                        lValueOf = Long.valueOf(zzgVarZza.zzd());
                                                    } else {
                                                        lValueOf = null;
                                                    }
                                                    if (lValueOf == null) {
                                                    }
                                                }
                                            }
                                            i8++;
                                        }
                                        zza(zzaVar3, jLongValue, false);
                                        it = zzaVar3.zzw().iterator();
                                        while (it.hasNext()) {
                                            if ("_s".equals(it.next().zzg())) {
                                                zzf().zzh(zzaVar3.zzr(), "_se");
                                                break;
                                            }
                                        }
                                        if (zzmz.zza(zzaVar3, "_sid") >= 0) {
                                            zza(zzaVar3, jLongValue, true);
                                        } else {
                                            iZza = zzmz.zza(zzaVar3, "_se");
                                            if (iZza >= 0) {
                                                zzaVar3.zzc(iZza);
                                                zzj().zzg().zza("Session engagement user property is in the bundle without session ID. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                            }
                                        }
                                        zzp().zza(zzaVar3);
                                        if (zznp.zza()) {
                                            strZzx2 = zzaVar16.zza.zzx();
                                            zzl().zzt();
                                            zzs();
                                            if (zznp.zza()) {
                                                zzhVarZzd2 = zzf().zzd(strZzx2);
                                                if (zzhVarZzd2 == null) {
                                                    zzj().zzg().zza("Cannot fix consent fields without appInfo. appId", zzfr.zza(strZzx2));
                                                } else {
                                                    zza(zzhVarZzd2, zzaVar3);
                                                }
                                            }
                                        }
                                        zzaVar3.zzi(Long.MAX_VALUE).zze(Long.MIN_VALUE);
                                        for (i9 = 0; i9 < zzaVar3.zza(); i9++) {
                                            zzeVarZza = zzaVar3.zza(i9);
                                            if (zzeVarZza.zzd() < zzaVar3.zzd()) {
                                                zzaVar3.zzi(zzeVarZza.zzd());
                                            }
                                            if (zzeVarZza.zzd() > zzaVar3.zzc()) {
                                                zzaVar3.zze(zzeVarZza.zzd());
                                            }
                                        }
                                        zzaVar3.zzq();
                                        if (zzpg.zza()) {
                                            zzq();
                                            if (zznd.zzd(zzaVar16.zza.zzx())) {
                                                for (i13 = 0; i13 < zzaVar16.zzc.size(); i13++) {
                                                    com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby6 = zzaVar16.zzc.get(i13).zzby();
                                                    com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar23 = zzaVarZzby6;
                                                    zzaVar7 = zzaVarZzby6;
                                                    it3 = zzaVar7.zzf().iterator();
                                                    while (it3.hasNext()) {
                                                        if ("_c".equals(it3.next().zzg())) {
                                                            if (zzaVar16.zza.zza() >= zze().zzb(zzaVar16.zza.zzx(), zzbi.zzau)) {
                                                                if (zze().zze(zzaVar16.zza.zzx(), zzbi.zzch)) {
                                                                    strZzp = zzq().zzp();
                                                                    zzaVar7.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_tu").zzb(strZzp).zzab()));
                                                                } else {
                                                                    strZzp = null;
                                                                }
                                                                zzaVar7.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_tr").zza(1L).zzab()));
                                                                zzmhVarZza = zzp().zza(zzaVar16.zza.zzx(), zzaVar16.zza, zzaVar7, strZzp);
                                                                if (zzmhVarZza != null) {
                                                                    zzj().zzp().zza("Generated trigger URI. appId, uri", zzaVar16.zza.zzx(), zzmhVarZza.zza);
                                                                    zzf().zza(zzaVar16.zza.zzx(), zzmhVarZza);
                                                                    this.zzr.add(zzaVar16.zza.zzx());
                                                                }
                                                            }
                                                            zzaVar3.zza(i13, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar7.zzab()));
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        zzaVar3.zzf().zza(zzc().zza(zzaVar3.zzr(), zzaVar3.zzw(), zzaVar3.zzx(), Long.valueOf(zzaVar3.zzd()), Long.valueOf(zzaVar3.zzc())));
                                        if (zze().zzl(zzaVar16.zza.zzx())) {
                                            map = new HashMap();
                                            arrayList = new ArrayList();
                                            secureRandomZzv = zzq().zzv();
                                            i11 = 0;
                                            while (i11 < zzaVar3.zza()) {
                                                com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby7 = zzaVar3.zza(i11).zzby();
                                                com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar24 = zzaVarZzby7;
                                                zzaVar5 = zzaVarZzby7;
                                                if (zzaVar5.zze().equals("_ep")) {
                                                    zzp();
                                                    str3 = (String) zzmz.zzb((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()), "_en");
                                                    zzbcVarZzd = (zzbc) map.get(str3);
                                                    if (zzbcVarZzd == null) {
                                                        map.put(str3, zzbcVarZzd);
                                                    }
                                                    if (zzbcVarZzd != null) {
                                                        if (zzbcVarZzd.zzj != null) {
                                                            zzp();
                                                            zzmz.zza(zzaVar5, "_sr", zzbcVarZzd.zzj);
                                                        }
                                                        if (zzbcVarZzd.zzk != null) {
                                                            zzp();
                                                            zzmz.zza(zzaVar5, "_efs", (Object) 1L);
                                                        }
                                                        arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                    }
                                                    zzaVar3.zza(i11, zzaVar5);
                                                } else {
                                                    jZza = zzi().zza(zzaVar16.zza.zzx());
                                                    zzq();
                                                    jZza2 = zznd.zza(zzaVar5.zzc(), jZza);
                                                    com.google.android.gms.internal.measurement.zzfi.zze zzeVar = (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab());
                                                    Long l2 = 1L;
                                                    if (TextUtils.isEmpty("_dbg")) {
                                                        iZzb = zzi().zzb(zzaVar16.zza.zzx(), zzaVar5.zze());
                                                        break;
                                                    }
                                                    iZzb = zzi().zzb(zzaVar16.zza.zzx(), zzaVar5.zze());
                                                    break;
                                                    if (iZzb <= 0) {
                                                        zzj().zzu().zza("Sample rate must be positive. event, rate", zzaVar5.zze(), Integer.valueOf(iZzb));
                                                        arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                        zzaVar3.zza(i11, zzaVar5);
                                                    } else {
                                                        zzbcVarZza = (zzbc) map.get(zzaVar5.zze());
                                                        if (zzbcVarZza == null) {
                                                            j2 = jZza;
                                                            zzbcVarZza = zzf().zzd(zzaVar16.zza.zzx(), zzaVar5.zze());
                                                            if (zzbcVarZza == null) {
                                                                zzj().zzu().zza("Event being bundled has no eventAggregate. appId, eventName", zzaVar16.zza.zzx(), zzaVar5.zze());
                                                                zzbcVarZza = new zzbc(zzaVar16.zza.zzx(), zzaVar5.zze(), 1L, 1L, 1L, zzaVar5.zzc(), 0L, null, null, null, null);
                                                            }
                                                        } else {
                                                            j2 = jZza;
                                                        }
                                                        zzp();
                                                        l = (Long) zzmz.zzb((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()), "_eid");
                                                        if (l != null) {
                                                            z3 = true;
                                                        } else {
                                                            z3 = false;
                                                        }
                                                        boolValueOf = Boolean.valueOf(z3);
                                                        zzaVar6 = zzaVar16;
                                                        if (iZzb == 1) {
                                                            arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                            boolValueOf.getClass();
                                                            if (z3) {
                                                                map.put(zzaVar5.zze(), zzbcVarZza.zza(null, null, null));
                                                            }
                                                            zzaVar3.zza(i11, zzaVar5);
                                                            secureRandom = secureRandomZzv;
                                                            i12 = i11;
                                                            map2 = map;
                                                        } else {
                                                            if (secureRandomZzv.nextInt(iZzb) == 0) {
                                                                zzp();
                                                                SecureRandom secureRandom2 = secureRandomZzv;
                                                                int i26 = i11;
                                                                j4 = iZzb;
                                                                zzmz.zza(zzaVar5, "_sr", Long.valueOf(j4));
                                                                arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                                boolValueOf.getClass();
                                                                if (z3) {
                                                                    zzbcVarZza = zzbcVarZza.zza(null, Long.valueOf(j4), null);
                                                                }
                                                                map.put(zzaVar5.zze(), zzbcVarZza.zza(zzaVar5.zzc(), jZza2));
                                                                map2 = map;
                                                                secureRandom = secureRandom2;
                                                                i12 = i26;
                                                            } else {
                                                                secureRandom = secureRandomZzv;
                                                                int i27 = i11;
                                                                if (zzbcVarZza.zzh != null) {
                                                                    jZza3 = zzbcVarZza.zzh.longValue();
                                                                } else {
                                                                    zzq();
                                                                    jZza3 = zznd.zza(zzaVar5.zzb(), j2);
                                                                }
                                                                if (jZza3 != jZza2) {
                                                                    zzp();
                                                                    zzmz.zza(zzaVar5, "_efs", (Object) 1L);
                                                                    zzp();
                                                                    j3 = iZzb;
                                                                    zzmz.zza(zzaVar5, "_sr", Long.valueOf(j3));
                                                                    arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                                    boolValueOf.getClass();
                                                                    if (z3) {
                                                                        zzbcVarZza = zzbcVarZza.zza(null, Long.valueOf(j3), true);
                                                                    }
                                                                    map2 = map;
                                                                    map2.put(zzaVar5.zze(), zzbcVarZza.zza(zzaVar5.zzc(), jZza2));
                                                                } else {
                                                                    map2 = map;
                                                                    boolValueOf.getClass();
                                                                    if (z3) {
                                                                        map2.put(zzaVar5.zze(), zzbcVarZza.zza(l, null, null));
                                                                    }
                                                                }
                                                                i12 = i27;
                                                            }
                                                            zzaVar3.zza(i12, zzaVar5);
                                                        }
                                                    }
                                                    map = map2;
                                                    zzaVar16 = zzaVar6;
                                                    secureRandomZzv = secureRandom;
                                                    i11 = i12 + 1;
                                                }
                                                zzaVar6 = zzaVar16;
                                                secureRandom = secureRandomZzv;
                                                i12 = i11;
                                                map2 = map;
                                                map = map2;
                                                zzaVar16 = zzaVar6;
                                                secureRandomZzv = secureRandom;
                                                i11 = i12 + 1;
                                            }
                                            HashMap map3 = map;
                                            zza zzaVar25 = zzaVar16;
                                            if (arrayList.size() < zzaVar3.zza()) {
                                                zzaVar3.zzi().zzb(arrayList);
                                            }
                                            it2 = map3.entrySet().iterator();
                                            while (it2.hasNext()) {
                                                zzf().zza((zzbc) ((Map.Entry) it2.next()).getValue());
                                            }
                                            zzaVar4 = zzaVar25;
                                        } else {
                                            zzaVar4 = zzaVar16;
                                        }
                                        strZzx = zzaVar4.zza.zzx();
                                        zzhVarZzd = zzf().zzd(strZzx);
                                        if (zzhVarZzd == null) {
                                            zzj().zzg().zza("Bundling raw events w/o app info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                                        } else if (zzaVar3.zza() > 0) {
                                            jZzp = zzhVarZzd.zzp();
                                            if (jZzp != 0) {
                                                zzaVar3.zzg(jZzp);
                                            } else {
                                                zzaVar3.zzm();
                                            }
                                            jZzr = zzhVarZzd.zzr();
                                            if (jZzr == 0) {
                                                jZzp = jZzr;
                                            }
                                            if (jZzp != 0) {
                                                zzaVar3.zzh(jZzp);
                                            } else {
                                                zzaVar3.zzn();
                                            }
                                            zzhVarZzd.zzai();
                                            zzaVar3.zzf((int) zzhVarZzd.zzq());
                                            zzhVarZzd.zzp(zzaVar3.zzd());
                                            zzhVarZzd.zzn(zzaVar3.zzc());
                                            strZzw = zzhVarZzd.zzw();
                                            if (strZzw != null) {
                                                zzaVar3.zzn(strZzw);
                                            } else {
                                                zzaVar3.zzj();
                                            }
                                            zzf().zza(zzhVarZzd);
                                        }
                                        if (zzaVar3.zza() > 0) {
                                            zzdVarZzc = zzi().zzc(zzaVar4.zza.zzx());
                                            if (zzdVarZzc != null) {
                                                if (zzaVar4.zza.zzah().isEmpty()) {
                                                    zzaVar3.zzb(-1L);
                                                } else {
                                                    zzj().zzu().zza("Did not find measurement config or missing version info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                                                }
                                            } else if (zzaVar4.zza.zzah().isEmpty()) {
                                                zzaVar3.zzb(-1L);
                                            } else {
                                                zzj().zzu().zza("Did not find measurement config or missing version info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                                            }
                                            zzf().zza((com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) zzaVar3.zzab()), z2);
                                        }
                                        zzaoVarZzf = zzf();
                                        list = zzaVar4.zzb;
                                        Preconditions.checkNotNull(list);
                                        zzaoVarZzf.zzt();
                                        zzaoVarZzf.zzak();
                                        sb = new StringBuilder("rowid in (");
                                        for (i10 = 0; i10 < list.size(); i10++) {
                                            if (i10 != 0) {
                                                sb.append(",");
                                            }
                                            sb.append(list.get(i10).longValue());
                                        }
                                        sb.append(")");
                                        iDelete = zzaoVarZzf.m30e_().delete("raw_events", sb.toString(), null);
                                        if (iDelete != list.size()) {
                                            zzaoVarZzf.zzj().zzg().zza("Deleted fewer rows from raw events table than expected", Integer.valueOf(iDelete), Integer.valueOf(list.size()));
                                        }
                                        zzaoVarZzf2 = zzf();
                                        try {
                                            zzaoVarZzf2.m30e_().execSQL("delete from raw_events_metadata where app_id=? and metadata_fingerprint not in (select distinct metadata_fingerprint from raw_events where app_id=?)", new String[]{strZzx, strZzx});
                                        } catch (SQLiteException e9) {
                                            zzaoVarZzf2.zzj().zzg().zza("Failed to remove unused event metadata. appId", zzfr.zza(strZzx), e9);
                                        }
                                        zzf().zzw();
                                        zzf().zzu();
                                        return true;
                                    }
                                    zzf().zzw();
                                    zzf().zzu();
                                    return false;
                                }
                            } else if (RawQuery != 0) {
                                RawQuery.close();
                            }
                        } else {
                            if (MoveToNext != -1) {
                                try {
                                    obj = null;
                                    try {
                                        strArr = new String[]{null, String.valueOf((long) MoveToNext)};
                                    } catch (SQLiteException e10) {
                                        e = e10;
                                        sQLiteException = e;
                                        Object obj2 = obj;
                                        r8 = obj2;
                                        r4 = obj2;
                                        zzaoVarZzf3.zzj().zzg().zza("Data loss. Error selecting raw event. appId", zzfr.zza((String) r8), sQLiteException);
                                        if (r4 != 0) {
                                            r4.close();
                                        }
                                        if (zzaVar16.zzc != null) {
                                            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzby8 = zzaVar16.zza.zzby();
                                            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar110 = zzaVarZzby8;
                                            zzaVarZzi = zzaVarZzby8.zzi();
                                            z = false;
                                            zzaVar = null;
                                            zzaVar2 = null;
                                            i = 0;
                                            i2 = 0;
                                            i3 = -1;
                                            i4 = -1;
                                            while (true) {
                                                z2 = z;
                                                i5 = i2;
                                                i6 = i3;
                                                if (i < zzaVar16.zzc.size()) {
                                                    break;
                                                    break;
                                                }
                                                com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby9 = zzaVar16.zzc.get(i).zzby();
                                                com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar111 = zzaVarZzby9;
                                                zzaVar8 = zzaVarZzby9;
                                                i14 = i;
                                                if (zzi().zzd(zzaVar16.zza.zzx(), zzaVar8.zze())) {
                                                    zzj().zzu().zza("Dropping blocked raw event. appId", zzfr.zza(zzaVar16.zza.zzx()), this.zzm.zzk().zza(zzaVar8.zze()));
                                                    if (!zzi().zzm(zzaVar16.zza.zzx())) {
                                                        zzq();
                                                        zznd.zza(this.zzah, zzaVar16.zza.zzx(), 11, "_ev", zzaVar8.zze(), 0);
                                                    }
                                                    i2 = i5;
                                                    str4 = str7;
                                                    zzaVar9 = zzaVar;
                                                    i3 = i6;
                                                    i19 = i14;
                                                    zzaVar13 = zzaVarZzi;
                                                } else {
                                                    if (zzaVar8.zze().equals(zzii.zza(str7))) {
                                                        zzaVar8.zza(str7);
                                                        zzj().zzp().zza("Renaming ad_impression to _ai");
                                                        if (zzj().zza(5)) {
                                                            i23 = 0;
                                                            while (i23 < zzaVar8.zza()) {
                                                                String str10 = str7;
                                                                if (!FirebaseAnalytics.Param.AD_PLATFORM.equals(zzaVar8.zzb(i23).zzg())) {
                                                                }
                                                                i23++;
                                                                str7 = str10;
                                                            }
                                                        }
                                                    }
                                                    str4 = str7;
                                                    zZzc = zzi().zzc(zzaVar16.zza.zzx(), zzaVar8.zze());
                                                    if (zZzc) {
                                                        zzp();
                                                        strZze = zzaVar8.zze();
                                                        Preconditions.checkNotEmpty(strZze);
                                                        zzaVar9 = zzaVar;
                                                        if (strZze.hashCode() == 95027) {
                                                        }
                                                        zzaVar10 = zzaVarZzi;
                                                        str5 = "_et";
                                                        i4 = i4;
                                                        if (zZzc) {
                                                            arrayList2 = new ArrayList(zzaVar8.zzf());
                                                            i21 = -1;
                                                            i22 = -1;
                                                            while (i20 < arrayList2.size()) {
                                                                if ("value".equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                                    i21 = i20;
                                                                } else if (FirebaseAnalytics.Param.CURRENCY.equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                                    i22 = i20;
                                                                }
                                                            }
                                                            if (i21 == -1) {
                                                                if (((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzl()) {
                                                                }
                                                                if (i22 == -1) {
                                                                    strZzh = ((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i22)).zzh();
                                                                    if (strZzh.length() != 3) {
                                                                        iCharCount = 0;
                                                                        while (iCharCount < strZzh.length()) {
                                                                            iCodePointAt = strZzh.codePointAt(iCharCount);
                                                                            if (!Character.isLetter(iCodePointAt)) {
                                                                                iCharCount += Character.charCount(iCodePointAt);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                zzj().zzv().zza("Value parameter discarded. You must also supply a 3-letter ISO_4217 currency code in the currency parameter.");
                                                                zzaVar8.zza(i21);
                                                                zza(zzaVar8, "_c");
                                                                zza(zzaVar8, 19, FirebaseAnalytics.Param.CURRENCY);
                                                                break;
                                                            }
                                                        }
                                                        if ("_e".equals(zzaVar8.zze())) {
                                                            zzp();
                                                            if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), "_fr") == null) {
                                                                if (zzaVar2 != null) {
                                                                    zzaVar15 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar2.clone());
                                                                    if (zza(zzaVar8, zzaVar15)) {
                                                                        zzaVar13 = zzaVar10;
                                                                        int i28 = i4;
                                                                        zzaVar13.zza(i28, zzaVar15);
                                                                        i4 = i28;
                                                                        i3 = i6;
                                                                        zzaVar2 = null;
                                                                        zzaVar9 = null;
                                                                    }
                                                                }
                                                                zzaVar13 = zzaVar10;
                                                                i3 = i5;
                                                                i4 = i4;
                                                                zzaVar9 = zzaVar8;
                                                            } else {
                                                                zzaVar13 = zzaVar10;
                                                                i18 = i4;
                                                                i3 = i6;
                                                                i4 = i18;
                                                            }
                                                        } else {
                                                            zzaVar13 = zzaVar10;
                                                            i18 = i4;
                                                            if ("_vs".equals(zzaVar8.zze())) {
                                                                zzp();
                                                                if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), str5) == null) {
                                                                    if (zzaVar9 != null) {
                                                                        zzaVar14 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar9.clone());
                                                                        if (zza(zzaVar14, zzaVar8)) {
                                                                            zzaVar13.zza(i6, zzaVar14);
                                                                            i3 = i6;
                                                                            i4 = i18;
                                                                            zzaVar2 = null;
                                                                            zzaVar9 = null;
                                                                        }
                                                                    }
                                                                    i4 = i5;
                                                                    i3 = i6;
                                                                    zzaVar2 = zzaVar8;
                                                                } else {
                                                                    i3 = i6;
                                                                    i4 = i18;
                                                                }
                                                            } else {
                                                                i3 = i6;
                                                                i4 = i18;
                                                            }
                                                        }
                                                        i19 = i14;
                                                        zzaVar16.zzc.set(i19, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()));
                                                        i2 = i5 + 1;
                                                        zzaVar13.zza(zzaVar8);
                                                    } else {
                                                        zzaVar9 = zzaVar;
                                                    }
                                                    str5 = "_et";
                                                    z4 = false;
                                                    z5 = false;
                                                    i15 = 0;
                                                    while (true) {
                                                        zzaVar10 = zzaVarZzi;
                                                        if (i15 < zzaVar8.zza()) {
                                                            break;
                                                            break;
                                                        }
                                                        if ("_c".equals(zzaVar8.zzb(i15).zzg())) {
                                                            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby10 = zzaVar8.zzb(i15).zzby();
                                                            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar26 = zzaVarZzby10;
                                                            zzaVar8.zza(i15, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby10.zza(1L).zzab()));
                                                            zzaVar2 = zzaVar2;
                                                            z4 = true;
                                                        } else {
                                                            zzaVar12 = zzaVar2;
                                                            if ("_r".equals(zzaVar8.zzb(i15).zzg())) {
                                                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby11 = zzaVar8.zzb(i15).zzby();
                                                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar27 = zzaVarZzby11;
                                                                zzaVar2 = zzaVar12;
                                                                zzaVar8.zza(i15, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby11.zza(1L).zzab()));
                                                                z5 = true;
                                                            } else {
                                                                zzaVar2 = zzaVar12;
                                                            }
                                                        }
                                                        i15++;
                                                        zzaVarZzi = zzaVar10;
                                                    }
                                                    if (z4) {
                                                    }
                                                    if (!z5) {
                                                        zzj().zzp().zza("Marking event as real-time", this.zzm.zzk().zza(zzaVar8.zze()));
                                                        zzaVar8.zza(com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_r").zza(1L));
                                                    }
                                                    if (zzf().zza(zzx(), zzaVar16.zza.zzx(), false, false, false, false, true).zze > zze().zze(zzaVar16.zza.zzx())) {
                                                        zza(zzaVar8, "_r");
                                                    } else {
                                                        z2 = true;
                                                    }
                                                    if (zznd.zzh(zzaVar8.zze())) {
                                                        zzj().zzu().zza("Too many conversions. Not logging as conversion. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                                        i16 = -1;
                                                        zzaVar11 = null;
                                                        z6 = false;
                                                        while (i17 < zzaVar8.zza()) {
                                                            zzgVarZzb = zzaVar8.zzb(i17);
                                                            if ("_c".equals(zzgVarZzb.zzg())) {
                                                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby12 = zzgVarZzb.zzby();
                                                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar28 = zzaVarZzby12;
                                                                zzaVar11 = zzaVarZzby12;
                                                                i16 = i17;
                                                            } else if ("_err".equals(zzgVarZzb.zzg())) {
                                                                z6 = true;
                                                            }
                                                        }
                                                        if (!z6) {
                                                            if (zzaVar11 != null) {
                                                                zzaVar8.zza(i16, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzg.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar11.clone())).zza("_err").zza(10L).zzab()));
                                                            } else {
                                                                zzj().zzg().zza("Did not find conversion parameter. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                                            }
                                                        } else if (zzaVar11 != null) {
                                                            zzaVar8.zza(i16, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzg.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar11.clone())).zza("_err").zza(10L).zzab()));
                                                        } else {
                                                            zzj().zzg().zza("Did not find conversion parameter. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                                        }
                                                    }
                                                    if (zZzc) {
                                                        arrayList2 = new ArrayList(zzaVar8.zzf());
                                                        i21 = -1;
                                                        i22 = -1;
                                                        while (i20 < arrayList2.size()) {
                                                            if ("value".equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                                i21 = i20;
                                                            } else if (FirebaseAnalytics.Param.CURRENCY.equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                                i22 = i20;
                                                            }
                                                        }
                                                        if (i21 == -1) {
                                                            if (((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzl()) {
                                                            }
                                                            if (i22 == -1) {
                                                                strZzh = ((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i22)).zzh();
                                                                if (strZzh.length() != 3) {
                                                                    iCharCount = 0;
                                                                    while (iCharCount < strZzh.length()) {
                                                                        iCodePointAt = strZzh.codePointAt(iCharCount);
                                                                        if (!Character.isLetter(iCodePointAt)) {
                                                                            iCharCount += Character.charCount(iCodePointAt);
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            zzj().zzv().zza("Value parameter discarded. You must also supply a 3-letter ISO_4217 currency code in the currency parameter.");
                                                            zzaVar8.zza(i21);
                                                            zza(zzaVar8, "_c");
                                                            zza(zzaVar8, 19, FirebaseAnalytics.Param.CURRENCY);
                                                            break;
                                                        }
                                                    }
                                                    if ("_e".equals(zzaVar8.zze())) {
                                                        zzp();
                                                        if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), "_fr") == null) {
                                                            if (zzaVar2 != null) {
                                                                zzaVar15 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar2.clone());
                                                                if (zza(zzaVar8, zzaVar15)) {
                                                                    zzaVar13 = zzaVar10;
                                                                    int i29 = i4;
                                                                    zzaVar13.zza(i29, zzaVar15);
                                                                    i4 = i29;
                                                                    i3 = i6;
                                                                    zzaVar2 = null;
                                                                    zzaVar9 = null;
                                                                }
                                                            }
                                                            zzaVar13 = zzaVar10;
                                                            i3 = i5;
                                                            i4 = i4;
                                                            zzaVar9 = zzaVar8;
                                                        } else {
                                                            zzaVar13 = zzaVar10;
                                                            i18 = i4;
                                                            i3 = i6;
                                                            i4 = i18;
                                                        }
                                                    } else {
                                                        zzaVar13 = zzaVar10;
                                                        i18 = i4;
                                                        if ("_vs".equals(zzaVar8.zze())) {
                                                            zzp();
                                                            if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), str5) == null) {
                                                                if (zzaVar9 != null) {
                                                                    zzaVar14 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar9.clone());
                                                                    if (zza(zzaVar14, zzaVar8)) {
                                                                        zzaVar13.zza(i6, zzaVar14);
                                                                        i3 = i6;
                                                                        i4 = i18;
                                                                        zzaVar2 = null;
                                                                        zzaVar9 = null;
                                                                    }
                                                                }
                                                                i4 = i5;
                                                                i3 = i6;
                                                                zzaVar2 = zzaVar8;
                                                            } else {
                                                                i3 = i6;
                                                                i4 = i18;
                                                            }
                                                        } else {
                                                            i3 = i6;
                                                            i4 = i18;
                                                        }
                                                    }
                                                    i19 = i14;
                                                    zzaVar16.zzc.set(i19, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()));
                                                    i2 = i5 + 1;
                                                    zzaVar13.zza(zzaVar8);
                                                }
                                                i = i19 + 1;
                                                zzaVarZzi = zzaVar13;
                                                z = z2;
                                                zzaVar = zzaVar9;
                                                str7 = str4;
                                            }
                                            zzaVar3 = zzaVarZzi;
                                            i7 = i5;
                                            jLongValue = 0;
                                            i8 = 0;
                                            while (i8 < i7) {
                                                zzeVarZza2 = zzaVar3.zza(i8);
                                                if ("_e".equals(zzeVarZza2.zzg())) {
                                                    zzp();
                                                    if (zzmz.zza(zzeVarZza2, "_fr") != null) {
                                                        zzaVar3.zzb(i8);
                                                        i7--;
                                                        i8--;
                                                    } else {
                                                        zzp();
                                                        zzgVarZza = zzmz.zza(zzeVarZza2, "_et");
                                                        if (zzgVarZza == null) {
                                                            if (zzgVarZza.zzl()) {
                                                                lValueOf = Long.valueOf(zzgVarZza.zzd());
                                                            } else {
                                                                lValueOf = null;
                                                            }
                                                            if (lValueOf == null) {
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    zzp();
                                                    zzgVarZza = zzmz.zza(zzeVarZza2, "_et");
                                                    if (zzgVarZza == null) {
                                                        if (zzgVarZza.zzl()) {
                                                            lValueOf = Long.valueOf(zzgVarZza.zzd());
                                                        } else {
                                                            lValueOf = null;
                                                        }
                                                        if (lValueOf == null) {
                                                        }
                                                    }
                                                }
                                                i8++;
                                            }
                                            zza(zzaVar3, jLongValue, false);
                                            it = zzaVar3.zzw().iterator();
                                            while (it.hasNext()) {
                                                if ("_s".equals(it.next().zzg())) {
                                                    zzf().zzh(zzaVar3.zzr(), "_se");
                                                    break;
                                                }
                                            }
                                            if (zzmz.zza(zzaVar3, "_sid") >= 0) {
                                                zza(zzaVar3, jLongValue, true);
                                            } else {
                                                iZza = zzmz.zza(zzaVar3, "_se");
                                                if (iZza >= 0) {
                                                    zzaVar3.zzc(iZza);
                                                    zzj().zzg().zza("Session engagement user property is in the bundle without session ID. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                                }
                                            }
                                            zzp().zza(zzaVar3);
                                            if (zznp.zza()) {
                                                strZzx2 = zzaVar16.zza.zzx();
                                                zzl().zzt();
                                                zzs();
                                                if (zznp.zza()) {
                                                    zzhVarZzd2 = zzf().zzd(strZzx2);
                                                    if (zzhVarZzd2 == null) {
                                                        zzj().zzg().zza("Cannot fix consent fields without appInfo. appId", zzfr.zza(strZzx2));
                                                    } else {
                                                        zza(zzhVarZzd2, zzaVar3);
                                                    }
                                                }
                                            }
                                            zzaVar3.zzi(Long.MAX_VALUE).zze(Long.MIN_VALUE);
                                            while (i9 < zzaVar3.zza()) {
                                                zzeVarZza = zzaVar3.zza(i9);
                                                if (zzeVarZza.zzd() < zzaVar3.zzd()) {
                                                    zzaVar3.zzi(zzeVarZza.zzd());
                                                }
                                                if (zzeVarZza.zzd() > zzaVar3.zzc()) {
                                                    zzaVar3.zze(zzeVarZza.zzd());
                                                }
                                            }
                                            zzaVar3.zzq();
                                            if (zzpg.zza()) {
                                                zzq();
                                                if (zznd.zzd(zzaVar16.zza.zzx())) {
                                                    while (i13 < zzaVar16.zzc.size()) {
                                                        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby13 = zzaVar16.zzc.get(i13).zzby();
                                                        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar29 = zzaVarZzby13;
                                                        zzaVar7 = zzaVarZzby13;
                                                        it3 = zzaVar7.zzf().iterator();
                                                        while (it3.hasNext()) {
                                                            if ("_c".equals(it3.next().zzg())) {
                                                                if (zzaVar16.zza.zza() >= zze().zzb(zzaVar16.zza.zzx(), zzbi.zzau)) {
                                                                    if (zze().zze(zzaVar16.zza.zzx(), zzbi.zzch)) {
                                                                        strZzp = zzq().zzp();
                                                                        zzaVar7.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_tu").zzb(strZzp).zzab()));
                                                                    } else {
                                                                        strZzp = null;
                                                                    }
                                                                    zzaVar7.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_tr").zza(1L).zzab()));
                                                                    zzmhVarZza = zzp().zza(zzaVar16.zza.zzx(), zzaVar16.zza, zzaVar7, strZzp);
                                                                    if (zzmhVarZza != null) {
                                                                        zzj().zzp().zza("Generated trigger URI. appId, uri", zzaVar16.zza.zzx(), zzmhVarZza.zza);
                                                                        zzf().zza(zzaVar16.zza.zzx(), zzmhVarZza);
                                                                        this.zzr.add(zzaVar16.zza.zzx());
                                                                    }
                                                                }
                                                                zzaVar3.zza(i13, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar7.zzab()));
                                                                break;
                                                                break;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            zzaVar3.zzf().zza(zzc().zza(zzaVar3.zzr(), zzaVar3.zzw(), zzaVar3.zzx(), Long.valueOf(zzaVar3.zzd()), Long.valueOf(zzaVar3.zzc())));
                                            if (zze().zzl(zzaVar16.zza.zzx())) {
                                                map = new HashMap();
                                                arrayList = new ArrayList();
                                                secureRandomZzv = zzq().zzv();
                                                i11 = 0;
                                                while (i11 < zzaVar3.zza()) {
                                                    com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby14 = zzaVar3.zza(i11).zzby();
                                                    com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar210 = zzaVarZzby14;
                                                    zzaVar5 = zzaVarZzby14;
                                                    if (zzaVar5.zze().equals("_ep")) {
                                                        zzp();
                                                        str3 = (String) zzmz.zzb((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()), "_en");
                                                        zzbcVarZzd = (zzbc) map.get(str3);
                                                        if (zzbcVarZzd == null) {
                                                            map.put(str3, zzbcVarZzd);
                                                        }
                                                        if (zzbcVarZzd != null) {
                                                            if (zzbcVarZzd.zzj != null) {
                                                                zzp();
                                                                zzmz.zza(zzaVar5, "_sr", zzbcVarZzd.zzj);
                                                            }
                                                            if (zzbcVarZzd.zzk != null) {
                                                                zzp();
                                                                zzmz.zza(zzaVar5, "_efs", (Object) 1L);
                                                            }
                                                            arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                        }
                                                        zzaVar3.zza(i11, zzaVar5);
                                                    } else {
                                                        jZza = zzi().zza(zzaVar16.zza.zzx());
                                                        zzq();
                                                        jZza2 = zznd.zza(zzaVar5.zzc(), jZza);
                                                        com.google.android.gms.internal.measurement.zzfi.zze zzeVar2 = (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab());
                                                        Long l3 = 1L;
                                                        if (TextUtils.isEmpty("_dbg")) {
                                                            iZzb = zzi().zzb(zzaVar16.zza.zzx(), zzaVar5.zze());
                                                            break;
                                                        }
                                                        iZzb = zzi().zzb(zzaVar16.zza.zzx(), zzaVar5.zze());
                                                        break;
                                                        if (iZzb <= 0) {
                                                            zzj().zzu().zza("Sample rate must be positive. event, rate", zzaVar5.zze(), Integer.valueOf(iZzb));
                                                            arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                            zzaVar3.zza(i11, zzaVar5);
                                                        } else {
                                                            zzbcVarZza = (zzbc) map.get(zzaVar5.zze());
                                                            if (zzbcVarZza == null) {
                                                                j2 = jZza;
                                                                zzbcVarZza = zzf().zzd(zzaVar16.zza.zzx(), zzaVar5.zze());
                                                                if (zzbcVarZza == null) {
                                                                    zzj().zzu().zza("Event being bundled has no eventAggregate. appId, eventName", zzaVar16.zza.zzx(), zzaVar5.zze());
                                                                    zzbcVarZza = new zzbc(zzaVar16.zza.zzx(), zzaVar5.zze(), 1L, 1L, 1L, zzaVar5.zzc(), 0L, null, null, null, null);
                                                                }
                                                            } else {
                                                                j2 = jZza;
                                                            }
                                                            zzp();
                                                            l = (Long) zzmz.zzb((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()), "_eid");
                                                            if (l != null) {
                                                                z3 = true;
                                                            } else {
                                                                z3 = false;
                                                            }
                                                            boolValueOf = Boolean.valueOf(z3);
                                                            zzaVar6 = zzaVar16;
                                                            if (iZzb == 1) {
                                                                arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                                boolValueOf.getClass();
                                                                if (z3) {
                                                                    map.put(zzaVar5.zze(), zzbcVarZza.zza(null, null, null));
                                                                }
                                                                zzaVar3.zza(i11, zzaVar5);
                                                                secureRandom = secureRandomZzv;
                                                                i12 = i11;
                                                                map2 = map;
                                                            } else {
                                                                if (secureRandomZzv.nextInt(iZzb) == 0) {
                                                                    zzp();
                                                                    SecureRandom secureRandom3 = secureRandomZzv;
                                                                    int i210 = i11;
                                                                    j4 = iZzb;
                                                                    zzmz.zza(zzaVar5, "_sr", Long.valueOf(j4));
                                                                    arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                                    boolValueOf.getClass();
                                                                    if (z3) {
                                                                        zzbcVarZza = zzbcVarZza.zza(null, Long.valueOf(j4), null);
                                                                    }
                                                                    map.put(zzaVar5.zze(), zzbcVarZza.zza(zzaVar5.zzc(), jZza2));
                                                                    map2 = map;
                                                                    secureRandom = secureRandom3;
                                                                    i12 = i210;
                                                                } else {
                                                                    secureRandom = secureRandomZzv;
                                                                    int i211 = i11;
                                                                    if (zzbcVarZza.zzh != null) {
                                                                        jZza3 = zzbcVarZza.zzh.longValue();
                                                                    } else {
                                                                        zzq();
                                                                        jZza3 = zznd.zza(zzaVar5.zzb(), j2);
                                                                    }
                                                                    if (jZza3 != jZza2) {
                                                                        zzp();
                                                                        zzmz.zza(zzaVar5, "_efs", (Object) 1L);
                                                                        zzp();
                                                                        j3 = iZzb;
                                                                        zzmz.zza(zzaVar5, "_sr", Long.valueOf(j3));
                                                                        arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                                        boolValueOf.getClass();
                                                                        if (z3) {
                                                                            zzbcVarZza = zzbcVarZza.zza(null, Long.valueOf(j3), true);
                                                                        }
                                                                        map2 = map;
                                                                        map2.put(zzaVar5.zze(), zzbcVarZza.zza(zzaVar5.zzc(), jZza2));
                                                                    } else {
                                                                        map2 = map;
                                                                        boolValueOf.getClass();
                                                                        if (z3) {
                                                                            map2.put(zzaVar5.zze(), zzbcVarZza.zza(l, null, null));
                                                                        }
                                                                    }
                                                                    i12 = i211;
                                                                }
                                                                zzaVar3.zza(i12, zzaVar5);
                                                            }
                                                        }
                                                        map = map2;
                                                        zzaVar16 = zzaVar6;
                                                        secureRandomZzv = secureRandom;
                                                        i11 = i12 + 1;
                                                    }
                                                    zzaVar6 = zzaVar16;
                                                    secureRandom = secureRandomZzv;
                                                    i12 = i11;
                                                    map2 = map;
                                                    map = map2;
                                                    zzaVar16 = zzaVar6;
                                                    secureRandomZzv = secureRandom;
                                                    i11 = i12 + 1;
                                                }
                                                HashMap map4 = map;
                                                zza zzaVar211 = zzaVar16;
                                                if (arrayList.size() < zzaVar3.zza()) {
                                                    zzaVar3.zzi().zzb(arrayList);
                                                }
                                                it2 = map4.entrySet().iterator();
                                                while (it2.hasNext()) {
                                                    zzf().zza((zzbc) ((Map.Entry) it2.next()).getValue());
                                                }
                                                zzaVar4 = zzaVar211;
                                            } else {
                                                zzaVar4 = zzaVar16;
                                            }
                                            strZzx = zzaVar4.zza.zzx();
                                            zzhVarZzd = zzf().zzd(strZzx);
                                            if (zzhVarZzd == null) {
                                                zzj().zzg().zza("Bundling raw events w/o app info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                                            } else if (zzaVar3.zza() > 0) {
                                                jZzp = zzhVarZzd.zzp();
                                                if (jZzp != 0) {
                                                    zzaVar3.zzg(jZzp);
                                                } else {
                                                    zzaVar3.zzm();
                                                }
                                                jZzr = zzhVarZzd.zzr();
                                                if (jZzr == 0) {
                                                    jZzp = jZzr;
                                                }
                                                if (jZzp != 0) {
                                                    zzaVar3.zzh(jZzp);
                                                } else {
                                                    zzaVar3.zzn();
                                                }
                                                zzhVarZzd.zzai();
                                                zzaVar3.zzf((int) zzhVarZzd.zzq());
                                                zzhVarZzd.zzp(zzaVar3.zzd());
                                                zzhVarZzd.zzn(zzaVar3.zzc());
                                                strZzw = zzhVarZzd.zzw();
                                                if (strZzw != null) {
                                                    zzaVar3.zzn(strZzw);
                                                } else {
                                                    zzaVar3.zzj();
                                                }
                                                zzf().zza(zzhVarZzd);
                                            }
                                            if (zzaVar3.zza() > 0) {
                                                zzdVarZzc = zzi().zzc(zzaVar4.zza.zzx());
                                                if (zzdVarZzc != null) {
                                                    if (zzaVar4.zza.zzah().isEmpty()) {
                                                        zzaVar3.zzb(-1L);
                                                    } else {
                                                        zzj().zzu().zza("Did not find measurement config or missing version info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                                                    }
                                                } else if (zzaVar4.zza.zzah().isEmpty()) {
                                                    zzaVar3.zzb(-1L);
                                                } else {
                                                    zzj().zzu().zza("Did not find measurement config or missing version info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                                                }
                                                zzf().zza((com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) zzaVar3.zzab()), z2);
                                            }
                                            zzaoVarZzf = zzf();
                                            list = zzaVar4.zzb;
                                            Preconditions.checkNotNull(list);
                                            zzaoVarZzf.zzt();
                                            zzaoVarZzf.zzak();
                                            sb = new StringBuilder("rowid in (");
                                            while (i10 < list.size()) {
                                                if (i10 != 0) {
                                                    sb.append(",");
                                                }
                                                sb.append(list.get(i10).longValue());
                                            }
                                            sb.append(")");
                                            iDelete = zzaoVarZzf.m30e_().delete("raw_events", sb.toString(), null);
                                            if (iDelete != list.size()) {
                                                zzaoVarZzf.zzj().zzg().zza("Deleted fewer rows from raw events table than expected", Integer.valueOf(iDelete), Integer.valueOf(list.size()));
                                            }
                                            zzaoVarZzf2 = zzf();
                                            zzaoVarZzf2.m30e_().execSQL("delete from raw_events_metadata where app_id=? and metadata_fingerprint not in (select distinct metadata_fingerprint from raw_events where app_id=?)", new String[]{strZzx, strZzx});
                                            zzf().zzw();
                                            zzf().zzu();
                                            return true;
                                        }
                                        zzf().zzw();
                                        zzf().zzu();
                                        return false;
                                    } catch (Throwable th6) {
                                        th = th6;
                                        th = th;
                                        r5 = obj;
                                        if (r5 != 0) {
                                            r5.close();
                                            throw th;
                                        }
                                        throw th;
                                    }
                                } catch (SQLiteException e11) {
                                    e = e11;
                                    obj = null;
                                } catch (Throwable th7) {
                                    th = th7;
                                    obj = null;
                                }
                            } else {
                                strArr = new String[]{null};
                            }
                            Cursor cursorRawQuery = sQLiteDatabaseM30e_.rawQuery("select metadata_fingerprint from raw_events where app_id = ?" + (MoveToNext != -1 ? " and rowid <= ?" : "") + " order by rowid limit 1;", strArr);
                            if (cursorRawQuery.moveToFirst()) {
                                String string3 = cursorRawQuery.getString(0);
                                cursorRawQuery.close();
                                r22 = cursorRawQuery;
                                str8 = string3;
                                string = null;
                                cursorQuery = sQLiteDatabaseM30e_.query("raw_events_metadata", new String[]{"metadata"}, "app_id = ? and metadata_fingerprint = ?", new String[]{string, str8}, null, null, "rowid", "2");
                                if (!cursorQuery.moveToFirst()) {
                                    zzaoVarZzf3.zzj().zzg().zza("Raw event metadata record is missing. appId", zzfr.zza(string));
                                    if (cursorQuery != null) {
                                        cursorQuery.close();
                                    }
                                } else {
                                    com.google.android.gms.internal.measurement.zzfi.zzj zzjVar2 = (com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzj.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfi.zzj.zzu(), cursorQuery.getBlob(0))).zzab());
                                    if (cursorQuery.moveToNext()) {
                                        zzaoVarZzf3.zzj().zzu().zza("Get multiple raw event metadata records, expected one. appId", zzfr.zza(string));
                                    }
                                    cursorQuery.close();
                                    zzaVar16.zza(zzjVar2);
                                    if (MoveToNext != -1) {
                                        strArr2 = new String[]{string, str8, String.valueOf((long) MoveToNext)};
                                        str6 = "app_id = ? and metadata_fingerprint = ? and rowid <= ?";
                                    } else {
                                        strArr2 = new String[]{string, str8};
                                        str6 = "app_id = ? and metadata_fingerprint = ?";
                                    }
                                    cursorQuery2 = sQLiteDatabaseM30e_.query("raw_events", new String[]{"rowid", AppMeasurementSdk.ConditionalUserProperty.NAME, "timestamp", "data"}, str6, strArr2, null, null, "rowid", null);
                                    if (!cursorQuery2.moveToFirst()) {
                                        while (true) {
                                            long j6 = cursorQuery2.getLong(0);
                                            com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar112 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfi.zze.zze(), cursorQuery2.getBlob(3));
                                            zzaVar112.zza(cursorQuery2.getString(1)).zzb(cursorQuery2.getLong(2));
                                            MoveToNext = zzaVar16.zza(j6, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar112.zzab()));
                                            if (MoveToNext == 0) {
                                                if (cursorQuery2 != null) {
                                                    break;
                                                }
                                                cursorQuery2.close();
                                                break;
                                            }
                                            MoveToNext = cursorQuery2.moveToNext();
                                            if (MoveToNext == 0) {
                                                if (cursorQuery2 != null) {
                                                    break;
                                                }
                                                cursorQuery2.close();
                                                break;
                                            }
                                        }
                                    } else {
                                        MoveToNext = zzaoVarZzf3.zzj().zzu();
                                        MoveToNext.zza("Raw event data disappeared while in transaction. appId", zzfr.zza(string));
                                        if (cursorQuery2 != null) {
                                            cursorQuery2.close();
                                        }
                                    }
                                }
                            } else if (cursorRawQuery != null) {
                                cursorRawQuery.close();
                            }
                        }
                    } catch (SQLiteException e12) {
                        sQLiteException = e12;
                        str2 = str8;
                        r8 = 0;
                        r4 = str2;
                        zzaoVarZzf3.zzj().zzg().zza("Data loss. Error selecting raw event. appId", zzfr.zza((String) r8), sQLiteException);
                        if (r4 != 0) {
                            r4.close();
                        }
                        if (zzaVar16.zzc != null) {
                            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzby15 = zzaVar16.zza.zzby();
                            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar113 = zzaVarZzby15;
                            zzaVarZzi = zzaVarZzby15.zzi();
                            z = false;
                            zzaVar = null;
                            zzaVar2 = null;
                            i = 0;
                            i2 = 0;
                            i3 = -1;
                            i4 = -1;
                            while (true) {
                                z2 = z;
                                i5 = i2;
                                i6 = i3;
                                if (i < zzaVar16.zzc.size()) {
                                    break;
                                    break;
                                }
                                com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby16 = zzaVar16.zzc.get(i).zzby();
                                com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar114 = zzaVarZzby16;
                                zzaVar8 = zzaVarZzby16;
                                i14 = i;
                                if (zzi().zzd(zzaVar16.zza.zzx(), zzaVar8.zze())) {
                                    zzj().zzu().zza("Dropping blocked raw event. appId", zzfr.zza(zzaVar16.zza.zzx()), this.zzm.zzk().zza(zzaVar8.zze()));
                                    if (!zzi().zzm(zzaVar16.zza.zzx())) {
                                        zzq();
                                        zznd.zza(this.zzah, zzaVar16.zza.zzx(), 11, "_ev", zzaVar8.zze(), 0);
                                    }
                                    i2 = i5;
                                    str4 = str7;
                                    zzaVar9 = zzaVar;
                                    i3 = i6;
                                    i19 = i14;
                                    zzaVar13 = zzaVarZzi;
                                } else {
                                    if (zzaVar8.zze().equals(zzii.zza(str7))) {
                                        zzaVar8.zza(str7);
                                        zzj().zzp().zza("Renaming ad_impression to _ai");
                                        if (zzj().zza(5)) {
                                            i23 = 0;
                                            while (i23 < zzaVar8.zza()) {
                                                String str11 = str7;
                                                if (!FirebaseAnalytics.Param.AD_PLATFORM.equals(zzaVar8.zzb(i23).zzg())) {
                                                }
                                                i23++;
                                                str7 = str11;
                                            }
                                        }
                                    }
                                    str4 = str7;
                                    zZzc = zzi().zzc(zzaVar16.zza.zzx(), zzaVar8.zze());
                                    if (zZzc) {
                                        zzp();
                                        strZze = zzaVar8.zze();
                                        Preconditions.checkNotEmpty(strZze);
                                        zzaVar9 = zzaVar;
                                        if (strZze.hashCode() == 95027) {
                                        }
                                        zzaVar10 = zzaVarZzi;
                                        str5 = "_et";
                                        i4 = i4;
                                        if (zZzc) {
                                            arrayList2 = new ArrayList(zzaVar8.zzf());
                                            i21 = -1;
                                            i22 = -1;
                                            while (i20 < arrayList2.size()) {
                                                if ("value".equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                    i21 = i20;
                                                } else if (FirebaseAnalytics.Param.CURRENCY.equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                    i22 = i20;
                                                }
                                            }
                                            if (i21 == -1) {
                                                if (((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzl()) {
                                                }
                                                if (i22 == -1) {
                                                    strZzh = ((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i22)).zzh();
                                                    if (strZzh.length() != 3) {
                                                        iCharCount = 0;
                                                        while (iCharCount < strZzh.length()) {
                                                            iCodePointAt = strZzh.codePointAt(iCharCount);
                                                            if (!Character.isLetter(iCodePointAt)) {
                                                                iCharCount += Character.charCount(iCodePointAt);
                                                            }
                                                        }
                                                    }
                                                }
                                                zzj().zzv().zza("Value parameter discarded. You must also supply a 3-letter ISO_4217 currency code in the currency parameter.");
                                                zzaVar8.zza(i21);
                                                zza(zzaVar8, "_c");
                                                zza(zzaVar8, 19, FirebaseAnalytics.Param.CURRENCY);
                                                break;
                                            }
                                        }
                                        if ("_e".equals(zzaVar8.zze())) {
                                            zzp();
                                            if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), "_fr") == null) {
                                                if (zzaVar2 != null) {
                                                    zzaVar15 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar2.clone());
                                                    if (zza(zzaVar8, zzaVar15)) {
                                                        zzaVar13 = zzaVar10;
                                                        int i212 = i4;
                                                        zzaVar13.zza(i212, zzaVar15);
                                                        i4 = i212;
                                                        i3 = i6;
                                                        zzaVar2 = null;
                                                        zzaVar9 = null;
                                                    }
                                                }
                                                zzaVar13 = zzaVar10;
                                                i3 = i5;
                                                i4 = i4;
                                                zzaVar9 = zzaVar8;
                                            } else {
                                                zzaVar13 = zzaVar10;
                                                i18 = i4;
                                                i3 = i6;
                                                i4 = i18;
                                            }
                                        } else {
                                            zzaVar13 = zzaVar10;
                                            i18 = i4;
                                            if ("_vs".equals(zzaVar8.zze())) {
                                                zzp();
                                                if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), str5) == null) {
                                                    if (zzaVar9 != null) {
                                                        zzaVar14 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar9.clone());
                                                        if (zza(zzaVar14, zzaVar8)) {
                                                            zzaVar13.zza(i6, zzaVar14);
                                                            i3 = i6;
                                                            i4 = i18;
                                                            zzaVar2 = null;
                                                            zzaVar9 = null;
                                                        }
                                                    }
                                                    i4 = i5;
                                                    i3 = i6;
                                                    zzaVar2 = zzaVar8;
                                                } else {
                                                    i3 = i6;
                                                    i4 = i18;
                                                }
                                            } else {
                                                i3 = i6;
                                                i4 = i18;
                                            }
                                        }
                                        i19 = i14;
                                        zzaVar16.zzc.set(i19, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()));
                                        i2 = i5 + 1;
                                        zzaVar13.zza(zzaVar8);
                                    } else {
                                        zzaVar9 = zzaVar;
                                    }
                                    str5 = "_et";
                                    z4 = false;
                                    z5 = false;
                                    i15 = 0;
                                    while (true) {
                                        zzaVar10 = zzaVarZzi;
                                        if (i15 < zzaVar8.zza()) {
                                            break;
                                            break;
                                        }
                                        if ("_c".equals(zzaVar8.zzb(i15).zzg())) {
                                            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby17 = zzaVar8.zzb(i15).zzby();
                                            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar212 = zzaVarZzby17;
                                            zzaVar8.zza(i15, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby17.zza(1L).zzab()));
                                            zzaVar2 = zzaVar2;
                                            z4 = true;
                                        } else {
                                            zzaVar12 = zzaVar2;
                                            if ("_r".equals(zzaVar8.zzb(i15).zzg())) {
                                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby18 = zzaVar8.zzb(i15).zzby();
                                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar213 = zzaVarZzby18;
                                                zzaVar2 = zzaVar12;
                                                zzaVar8.zza(i15, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby18.zza(1L).zzab()));
                                                z5 = true;
                                            } else {
                                                zzaVar2 = zzaVar12;
                                            }
                                        }
                                        i15++;
                                        zzaVarZzi = zzaVar10;
                                    }
                                    if (z4) {
                                    }
                                    if (!z5) {
                                        zzj().zzp().zza("Marking event as real-time", this.zzm.zzk().zza(zzaVar8.zze()));
                                        zzaVar8.zza(com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_r").zza(1L));
                                    }
                                    if (zzf().zza(zzx(), zzaVar16.zza.zzx(), false, false, false, false, true).zze > zze().zze(zzaVar16.zza.zzx())) {
                                        zza(zzaVar8, "_r");
                                    } else {
                                        z2 = true;
                                    }
                                    if (zznd.zzh(zzaVar8.zze())) {
                                        zzj().zzu().zza("Too many conversions. Not logging as conversion. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                        i16 = -1;
                                        zzaVar11 = null;
                                        z6 = false;
                                        while (i17 < zzaVar8.zza()) {
                                            zzgVarZzb = zzaVar8.zzb(i17);
                                            if ("_c".equals(zzgVarZzb.zzg())) {
                                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby19 = zzgVarZzb.zzby();
                                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar214 = zzaVarZzby19;
                                                zzaVar11 = zzaVarZzby19;
                                                i16 = i17;
                                            } else if ("_err".equals(zzgVarZzb.zzg())) {
                                                z6 = true;
                                            }
                                        }
                                        if (!z6) {
                                            if (zzaVar11 != null) {
                                                zzaVar8.zza(i16, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzg.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar11.clone())).zza("_err").zza(10L).zzab()));
                                            } else {
                                                zzj().zzg().zza("Did not find conversion parameter. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                            }
                                        } else if (zzaVar11 != null) {
                                            zzaVar8.zza(i16, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzg.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar11.clone())).zza("_err").zza(10L).zzab()));
                                        } else {
                                            zzj().zzg().zza("Did not find conversion parameter. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                        }
                                    }
                                    if (zZzc) {
                                        arrayList2 = new ArrayList(zzaVar8.zzf());
                                        i21 = -1;
                                        i22 = -1;
                                        while (i20 < arrayList2.size()) {
                                            if ("value".equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                i21 = i20;
                                            } else if (FirebaseAnalytics.Param.CURRENCY.equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                                i22 = i20;
                                            }
                                        }
                                        if (i21 == -1) {
                                            if (((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzl()) {
                                            }
                                            if (i22 == -1) {
                                                strZzh = ((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i22)).zzh();
                                                if (strZzh.length() != 3) {
                                                    iCharCount = 0;
                                                    while (iCharCount < strZzh.length()) {
                                                        iCodePointAt = strZzh.codePointAt(iCharCount);
                                                        if (!Character.isLetter(iCodePointAt)) {
                                                            iCharCount += Character.charCount(iCodePointAt);
                                                        }
                                                    }
                                                }
                                            }
                                            zzj().zzv().zza("Value parameter discarded. You must also supply a 3-letter ISO_4217 currency code in the currency parameter.");
                                            zzaVar8.zza(i21);
                                            zza(zzaVar8, "_c");
                                            zza(zzaVar8, 19, FirebaseAnalytics.Param.CURRENCY);
                                            break;
                                        }
                                    }
                                    if ("_e".equals(zzaVar8.zze())) {
                                        zzp();
                                        if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), "_fr") == null) {
                                            if (zzaVar2 != null) {
                                                zzaVar15 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar2.clone());
                                                if (zza(zzaVar8, zzaVar15)) {
                                                    zzaVar13 = zzaVar10;
                                                    int i213 = i4;
                                                    zzaVar13.zza(i213, zzaVar15);
                                                    i4 = i213;
                                                    i3 = i6;
                                                    zzaVar2 = null;
                                                    zzaVar9 = null;
                                                }
                                            }
                                            zzaVar13 = zzaVar10;
                                            i3 = i5;
                                            i4 = i4;
                                            zzaVar9 = zzaVar8;
                                        } else {
                                            zzaVar13 = zzaVar10;
                                            i18 = i4;
                                            i3 = i6;
                                            i4 = i18;
                                        }
                                    } else {
                                        zzaVar13 = zzaVar10;
                                        i18 = i4;
                                        if ("_vs".equals(zzaVar8.zze())) {
                                            zzp();
                                            if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), str5) == null) {
                                                if (zzaVar9 != null) {
                                                    zzaVar14 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar9.clone());
                                                    if (zza(zzaVar14, zzaVar8)) {
                                                        zzaVar13.zza(i6, zzaVar14);
                                                        i3 = i6;
                                                        i4 = i18;
                                                        zzaVar2 = null;
                                                        zzaVar9 = null;
                                                    }
                                                }
                                                i4 = i5;
                                                i3 = i6;
                                                zzaVar2 = zzaVar8;
                                            } else {
                                                i3 = i6;
                                                i4 = i18;
                                            }
                                        } else {
                                            i3 = i6;
                                            i4 = i18;
                                        }
                                    }
                                    i19 = i14;
                                    zzaVar16.zzc.set(i19, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()));
                                    i2 = i5 + 1;
                                    zzaVar13.zza(zzaVar8);
                                }
                                i = i19 + 1;
                                zzaVarZzi = zzaVar13;
                                z = z2;
                                zzaVar = zzaVar9;
                                str7 = str4;
                            }
                            zzaVar3 = zzaVarZzi;
                            i7 = i5;
                            jLongValue = 0;
                            i8 = 0;
                            while (i8 < i7) {
                                zzeVarZza2 = zzaVar3.zza(i8);
                                if ("_e".equals(zzeVarZza2.zzg())) {
                                    zzp();
                                    if (zzmz.zza(zzeVarZza2, "_fr") != null) {
                                        zzaVar3.zzb(i8);
                                        i7--;
                                        i8--;
                                    } else {
                                        zzp();
                                        zzgVarZza = zzmz.zza(zzeVarZza2, "_et");
                                        if (zzgVarZza == null) {
                                            if (zzgVarZza.zzl()) {
                                                lValueOf = Long.valueOf(zzgVarZza.zzd());
                                            } else {
                                                lValueOf = null;
                                            }
                                            if (lValueOf == null) {
                                            }
                                        }
                                    }
                                } else {
                                    zzp();
                                    zzgVarZza = zzmz.zza(zzeVarZza2, "_et");
                                    if (zzgVarZza == null) {
                                        if (zzgVarZza.zzl()) {
                                            lValueOf = Long.valueOf(zzgVarZza.zzd());
                                        } else {
                                            lValueOf = null;
                                        }
                                        if (lValueOf == null) {
                                        }
                                    }
                                }
                                i8++;
                            }
                            zza(zzaVar3, jLongValue, false);
                            it = zzaVar3.zzw().iterator();
                            while (it.hasNext()) {
                                if ("_s".equals(it.next().zzg())) {
                                    zzf().zzh(zzaVar3.zzr(), "_se");
                                    break;
                                }
                            }
                            if (zzmz.zza(zzaVar3, "_sid") >= 0) {
                                zza(zzaVar3, jLongValue, true);
                            } else {
                                iZza = zzmz.zza(zzaVar3, "_se");
                                if (iZza >= 0) {
                                    zzaVar3.zzc(iZza);
                                    zzj().zzg().zza("Session engagement user property is in the bundle without session ID. appId", zzfr.zza(zzaVar16.zza.zzx()));
                                }
                            }
                            zzp().zza(zzaVar3);
                            if (zznp.zza()) {
                                strZzx2 = zzaVar16.zza.zzx();
                                zzl().zzt();
                                zzs();
                                if (zznp.zza()) {
                                    zzhVarZzd2 = zzf().zzd(strZzx2);
                                    if (zzhVarZzd2 == null) {
                                        zzj().zzg().zza("Cannot fix consent fields without appInfo. appId", zzfr.zza(strZzx2));
                                    } else {
                                        zza(zzhVarZzd2, zzaVar3);
                                    }
                                }
                            }
                            zzaVar3.zzi(Long.MAX_VALUE).zze(Long.MIN_VALUE);
                            while (i9 < zzaVar3.zza()) {
                                zzeVarZza = zzaVar3.zza(i9);
                                if (zzeVarZza.zzd() < zzaVar3.zzd()) {
                                    zzaVar3.zzi(zzeVarZza.zzd());
                                }
                                if (zzeVarZza.zzd() > zzaVar3.zzc()) {
                                    zzaVar3.zze(zzeVarZza.zzd());
                                }
                            }
                            zzaVar3.zzq();
                            if (zzpg.zza()) {
                                zzq();
                                if (zznd.zzd(zzaVar16.zza.zzx())) {
                                    while (i13 < zzaVar16.zzc.size()) {
                                        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby110 = zzaVar16.zzc.get(i13).zzby();
                                        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar215 = zzaVarZzby110;
                                        zzaVar7 = zzaVarZzby110;
                                        it3 = zzaVar7.zzf().iterator();
                                        while (it3.hasNext()) {
                                            if ("_c".equals(it3.next().zzg())) {
                                                if (zzaVar16.zza.zza() >= zze().zzb(zzaVar16.zza.zzx(), zzbi.zzau)) {
                                                    if (zze().zze(zzaVar16.zza.zzx(), zzbi.zzch)) {
                                                        strZzp = zzq().zzp();
                                                        zzaVar7.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_tu").zzb(strZzp).zzab()));
                                                    } else {
                                                        strZzp = null;
                                                    }
                                                    zzaVar7.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_tr").zza(1L).zzab()));
                                                    zzmhVarZza = zzp().zza(zzaVar16.zza.zzx(), zzaVar16.zza, zzaVar7, strZzp);
                                                    if (zzmhVarZza != null) {
                                                        zzj().zzp().zza("Generated trigger URI. appId, uri", zzaVar16.zza.zzx(), zzmhVarZza.zza);
                                                        zzf().zza(zzaVar16.zza.zzx(), zzmhVarZza);
                                                        this.zzr.add(zzaVar16.zza.zzx());
                                                    }
                                                }
                                                zzaVar3.zza(i13, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar7.zzab()));
                                                break;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                            zzaVar3.zzf().zza(zzc().zza(zzaVar3.zzr(), zzaVar3.zzw(), zzaVar3.zzx(), Long.valueOf(zzaVar3.zzd()), Long.valueOf(zzaVar3.zzc())));
                            if (zze().zzl(zzaVar16.zza.zzx())) {
                                map = new HashMap();
                                arrayList = new ArrayList();
                                secureRandomZzv = zzq().zzv();
                                i11 = 0;
                                while (i11 < zzaVar3.zza()) {
                                    com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby111 = zzaVar3.zza(i11).zzby();
                                    com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar216 = zzaVarZzby111;
                                    zzaVar5 = zzaVarZzby111;
                                    if (zzaVar5.zze().equals("_ep")) {
                                        zzp();
                                        str3 = (String) zzmz.zzb((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()), "_en");
                                        zzbcVarZzd = (zzbc) map.get(str3);
                                        if (zzbcVarZzd == null) {
                                            map.put(str3, zzbcVarZzd);
                                        }
                                        if (zzbcVarZzd != null) {
                                            if (zzbcVarZzd.zzj != null) {
                                                zzp();
                                                zzmz.zza(zzaVar5, "_sr", zzbcVarZzd.zzj);
                                            }
                                            if (zzbcVarZzd.zzk != null) {
                                                zzp();
                                                zzmz.zza(zzaVar5, "_efs", (Object) 1L);
                                            }
                                            arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                        }
                                        zzaVar3.zza(i11, zzaVar5);
                                    } else {
                                        jZza = zzi().zza(zzaVar16.zza.zzx());
                                        zzq();
                                        jZza2 = zznd.zza(zzaVar5.zzc(), jZza);
                                        com.google.android.gms.internal.measurement.zzfi.zze zzeVar3 = (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab());
                                        Long l4 = 1L;
                                        if (TextUtils.isEmpty("_dbg")) {
                                            iZzb = zzi().zzb(zzaVar16.zza.zzx(), zzaVar5.zze());
                                            break;
                                        }
                                        iZzb = zzi().zzb(zzaVar16.zza.zzx(), zzaVar5.zze());
                                        break;
                                        if (iZzb <= 0) {
                                            zzj().zzu().zza("Sample rate must be positive. event, rate", zzaVar5.zze(), Integer.valueOf(iZzb));
                                            arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                            zzaVar3.zza(i11, zzaVar5);
                                        } else {
                                            zzbcVarZza = (zzbc) map.get(zzaVar5.zze());
                                            if (zzbcVarZza == null) {
                                                j2 = jZza;
                                                zzbcVarZza = zzf().zzd(zzaVar16.zza.zzx(), zzaVar5.zze());
                                                if (zzbcVarZza == null) {
                                                    zzj().zzu().zza("Event being bundled has no eventAggregate. appId, eventName", zzaVar16.zza.zzx(), zzaVar5.zze());
                                                    zzbcVarZza = new zzbc(zzaVar16.zza.zzx(), zzaVar5.zze(), 1L, 1L, 1L, zzaVar5.zzc(), 0L, null, null, null, null);
                                                }
                                            } else {
                                                j2 = jZza;
                                            }
                                            zzp();
                                            l = (Long) zzmz.zzb((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()), "_eid");
                                            if (l != null) {
                                                z3 = true;
                                            } else {
                                                z3 = false;
                                            }
                                            boolValueOf = Boolean.valueOf(z3);
                                            zzaVar6 = zzaVar16;
                                            if (iZzb == 1) {
                                                arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                boolValueOf.getClass();
                                                if (z3) {
                                                    map.put(zzaVar5.zze(), zzbcVarZza.zza(null, null, null));
                                                }
                                                zzaVar3.zza(i11, zzaVar5);
                                                secureRandom = secureRandomZzv;
                                                i12 = i11;
                                                map2 = map;
                                            } else {
                                                if (secureRandomZzv.nextInt(iZzb) == 0) {
                                                    zzp();
                                                    SecureRandom secureRandom4 = secureRandomZzv;
                                                    int i214 = i11;
                                                    j4 = iZzb;
                                                    zzmz.zza(zzaVar5, "_sr", Long.valueOf(j4));
                                                    arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                    boolValueOf.getClass();
                                                    if (z3) {
                                                        zzbcVarZza = zzbcVarZza.zza(null, Long.valueOf(j4), null);
                                                    }
                                                    map.put(zzaVar5.zze(), zzbcVarZza.zza(zzaVar5.zzc(), jZza2));
                                                    map2 = map;
                                                    secureRandom = secureRandom4;
                                                    i12 = i214;
                                                } else {
                                                    secureRandom = secureRandomZzv;
                                                    int i215 = i11;
                                                    if (zzbcVarZza.zzh != null) {
                                                        jZza3 = zzbcVarZza.zzh.longValue();
                                                    } else {
                                                        zzq();
                                                        jZza3 = zznd.zza(zzaVar5.zzb(), j2);
                                                    }
                                                    if (jZza3 != jZza2) {
                                                        zzp();
                                                        zzmz.zza(zzaVar5, "_efs", (Object) 1L);
                                                        zzp();
                                                        j3 = iZzb;
                                                        zzmz.zza(zzaVar5, "_sr", Long.valueOf(j3));
                                                        arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                                        boolValueOf.getClass();
                                                        if (z3) {
                                                            zzbcVarZza = zzbcVarZza.zza(null, Long.valueOf(j3), true);
                                                        }
                                                        map2 = map;
                                                        map2.put(zzaVar5.zze(), zzbcVarZza.zza(zzaVar5.zzc(), jZza2));
                                                    } else {
                                                        map2 = map;
                                                        boolValueOf.getClass();
                                                        if (z3) {
                                                            map2.put(zzaVar5.zze(), zzbcVarZza.zza(l, null, null));
                                                        }
                                                    }
                                                    i12 = i215;
                                                }
                                                zzaVar3.zza(i12, zzaVar5);
                                            }
                                        }
                                        map = map2;
                                        zzaVar16 = zzaVar6;
                                        secureRandomZzv = secureRandom;
                                        i11 = i12 + 1;
                                    }
                                    zzaVar6 = zzaVar16;
                                    secureRandom = secureRandomZzv;
                                    i12 = i11;
                                    map2 = map;
                                    map = map2;
                                    zzaVar16 = zzaVar6;
                                    secureRandomZzv = secureRandom;
                                    i11 = i12 + 1;
                                }
                                HashMap map5 = map;
                                zza zzaVar217 = zzaVar16;
                                if (arrayList.size() < zzaVar3.zza()) {
                                    zzaVar3.zzi().zzb(arrayList);
                                }
                                it2 = map5.entrySet().iterator();
                                while (it2.hasNext()) {
                                    zzf().zza((zzbc) ((Map.Entry) it2.next()).getValue());
                                }
                                zzaVar4 = zzaVar217;
                            } else {
                                zzaVar4 = zzaVar16;
                            }
                            strZzx = zzaVar4.zza.zzx();
                            zzhVarZzd = zzf().zzd(strZzx);
                            if (zzhVarZzd == null) {
                                zzj().zzg().zza("Bundling raw events w/o app info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                            } else if (zzaVar3.zza() > 0) {
                                jZzp = zzhVarZzd.zzp();
                                if (jZzp != 0) {
                                    zzaVar3.zzg(jZzp);
                                } else {
                                    zzaVar3.zzm();
                                }
                                jZzr = zzhVarZzd.zzr();
                                if (jZzr == 0) {
                                    jZzp = jZzr;
                                }
                                if (jZzp != 0) {
                                    zzaVar3.zzh(jZzp);
                                } else {
                                    zzaVar3.zzn();
                                }
                                zzhVarZzd.zzai();
                                zzaVar3.zzf((int) zzhVarZzd.zzq());
                                zzhVarZzd.zzp(zzaVar3.zzd());
                                zzhVarZzd.zzn(zzaVar3.zzc());
                                strZzw = zzhVarZzd.zzw();
                                if (strZzw != null) {
                                    zzaVar3.zzn(strZzw);
                                } else {
                                    zzaVar3.zzj();
                                }
                                zzf().zza(zzhVarZzd);
                            }
                            if (zzaVar3.zza() > 0) {
                                zzdVarZzc = zzi().zzc(zzaVar4.zza.zzx());
                                if (zzdVarZzc != null) {
                                    if (zzaVar4.zza.zzah().isEmpty()) {
                                        zzaVar3.zzb(-1L);
                                    } else {
                                        zzj().zzu().zza("Did not find measurement config or missing version info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                                    }
                                } else if (zzaVar4.zza.zzah().isEmpty()) {
                                    zzaVar3.zzb(-1L);
                                } else {
                                    zzj().zzu().zza("Did not find measurement config or missing version info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                                }
                                zzf().zza((com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) zzaVar3.zzab()), z2);
                            }
                            zzaoVarZzf = zzf();
                            list = zzaVar4.zzb;
                            Preconditions.checkNotNull(list);
                            zzaoVarZzf.zzt();
                            zzaoVarZzf.zzak();
                            sb = new StringBuilder("rowid in (");
                            while (i10 < list.size()) {
                                if (i10 != 0) {
                                    sb.append(",");
                                }
                                sb.append(list.get(i10).longValue());
                            }
                            sb.append(")");
                            iDelete = zzaoVarZzf.m30e_().delete("raw_events", sb.toString(), null);
                            if (iDelete != list.size()) {
                                zzaoVarZzf.zzj().zzg().zza("Deleted fewer rows from raw events table than expected", Integer.valueOf(iDelete), Integer.valueOf(list.size()));
                            }
                            zzaoVarZzf2 = zzf();
                            zzaoVarZzf2.m30e_().execSQL("delete from raw_events_metadata where app_id=? and metadata_fingerprint not in (select distinct metadata_fingerprint from raw_events where app_id=?)", new String[]{strZzx, strZzx});
                            zzf().zzw();
                            zzf().zzu();
                            return true;
                        }
                        zzf().zzw();
                        zzf().zzu();
                        return false;
                    }
                } catch (Throwable th8) {
                    th = th8;
                }
            } catch (SQLiteException e13) {
                sQLiteException = e13;
                str2 = null;
            } catch (Throwable th9) {
                th = th9;
                r5 = 0;
            }
            if (zzaVar16.zzc != null && !zzaVar16.zzc.isEmpty()) {
                com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzby112 = zzaVar16.zza.zzby();
                com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar115 = zzaVarZzby112;
                zzaVarZzi = zzaVarZzby112.zzi();
                z = false;
                zzaVar = null;
                zzaVar2 = null;
                i = 0;
                i2 = 0;
                i3 = -1;
                i4 = -1;
                while (true) {
                    z2 = z;
                    i5 = i2;
                    i6 = i3;
                    if (i < zzaVar16.zzc.size()) {
                        break;
                        break;
                    }
                    com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby113 = zzaVar16.zzc.get(i).zzby();
                    com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar116 = zzaVarZzby113;
                    zzaVar8 = zzaVarZzby113;
                    i14 = i;
                    if (zzi().zzd(zzaVar16.zza.zzx(), zzaVar8.zze())) {
                        zzj().zzu().zza("Dropping blocked raw event. appId", zzfr.zza(zzaVar16.zza.zzx()), this.zzm.zzk().zza(zzaVar8.zze()));
                        if (!zzi().zzm(zzaVar16.zza.zzx()) && !zzi().zzo(zzaVar16.zza.zzx()) && !"_err".equals(zzaVar8.zze())) {
                            zzq();
                            zznd.zza(this.zzah, zzaVar16.zza.zzx(), 11, "_ev", zzaVar8.zze(), 0);
                        }
                        i2 = i5;
                        str4 = str7;
                        zzaVar9 = zzaVar;
                        i3 = i6;
                        i19 = i14;
                        zzaVar13 = zzaVarZzi;
                    } else {
                        if (zzaVar8.zze().equals(zzii.zza(str7))) {
                            zzaVar8.zza(str7);
                            zzj().zzp().zza("Renaming ad_impression to _ai");
                            if (zzj().zza(5)) {
                                i23 = 0;
                                while (i23 < zzaVar8.zza()) {
                                    String str12 = str7;
                                    if (!FirebaseAnalytics.Param.AD_PLATFORM.equals(zzaVar8.zzb(i23).zzg()) && !zzaVar8.zzb(i23).zzh().isEmpty() && "admob".equalsIgnoreCase(zzaVar8.zzb(i23).zzh())) {
                                        zzj().zzv().zza("AdMob ad impression logged from app. Potentially duplicative.");
                                    }
                                    i23++;
                                    str7 = str12;
                                }
                            }
                        }
                        str4 = str7;
                        zZzc = zzi().zzc(zzaVar16.zza.zzx(), zzaVar8.zze());
                        if (zZzc) {
                            zzp();
                            strZze = zzaVar8.zze();
                            Preconditions.checkNotEmpty(strZze);
                            zzaVar9 = zzaVar;
                            if (strZze.hashCode() == 95027 || !strZze.equals("_ui")) {
                                zzaVar10 = zzaVarZzi;
                                str5 = "_et";
                                i4 = i4;
                            }
                            if (zZzc) {
                                arrayList2 = new ArrayList(zzaVar8.zzf());
                                i21 = -1;
                                i22 = -1;
                                while (i20 < arrayList2.size()) {
                                    if ("value".equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                        i21 = i20;
                                    } else if (FirebaseAnalytics.Param.CURRENCY.equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                        i22 = i20;
                                    }
                                }
                                if (i21 == -1) {
                                    if (((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzl() && !((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzj()) {
                                        zzj().zzv().zza("Value must be specified with a numeric type.");
                                        zzaVar8.zza(i21);
                                        zza(zzaVar8, "_c");
                                        zza(zzaVar8, 18, "value");
                                    } else {
                                        if (i22 == -1) {
                                            strZzh = ((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i22)).zzh();
                                            if (strZzh.length() != 3) {
                                                iCharCount = 0;
                                                while (iCharCount < strZzh.length()) {
                                                    iCodePointAt = strZzh.codePointAt(iCharCount);
                                                    if (!Character.isLetter(iCodePointAt)) {
                                                        iCharCount += Character.charCount(iCodePointAt);
                                                    }
                                                }
                                            }
                                        }
                                        zzj().zzv().zza("Value parameter discarded. You must also supply a 3-letter ISO_4217 currency code in the currency parameter.");
                                        zzaVar8.zza(i21);
                                        zza(zzaVar8, "_c");
                                        zza(zzaVar8, 19, FirebaseAnalytics.Param.CURRENCY);
                                        break;
                                    }
                                }
                            }
                            if ("_e".equals(zzaVar8.zze())) {
                                zzp();
                                if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), "_fr") == null) {
                                    if (zzaVar2 != null && Math.abs(zzaVar2.zzc() - zzaVar8.zzc()) <= 1000) {
                                        zzaVar15 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar2.clone());
                                        if (zza(zzaVar8, zzaVar15)) {
                                            zzaVar13 = zzaVar10;
                                            int i216 = i4;
                                            zzaVar13.zza(i216, zzaVar15);
                                            i4 = i216;
                                            i3 = i6;
                                            zzaVar2 = null;
                                            zzaVar9 = null;
                                        }
                                    }
                                    zzaVar13 = zzaVar10;
                                    i3 = i5;
                                    i4 = i4;
                                    zzaVar9 = zzaVar8;
                                } else {
                                    zzaVar13 = zzaVar10;
                                    i18 = i4;
                                    i3 = i6;
                                    i4 = i18;
                                }
                            } else {
                                zzaVar13 = zzaVar10;
                                i18 = i4;
                                if ("_vs".equals(zzaVar8.zze())) {
                                    zzp();
                                    if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), str5) == null) {
                                        if (zzaVar9 != null && Math.abs(zzaVar9.zzc() - zzaVar8.zzc()) <= 1000) {
                                            zzaVar14 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar9.clone());
                                            if (zza(zzaVar14, zzaVar8)) {
                                                zzaVar13.zza(i6, zzaVar14);
                                                i3 = i6;
                                                i4 = i18;
                                                zzaVar2 = null;
                                                zzaVar9 = null;
                                            }
                                        }
                                        i4 = i5;
                                        i3 = i6;
                                        zzaVar2 = zzaVar8;
                                    } else {
                                        i3 = i6;
                                        i4 = i18;
                                    }
                                } else {
                                    i3 = i6;
                                    i4 = i18;
                                }
                            }
                            i19 = i14;
                            zzaVar16.zzc.set(i19, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()));
                            i2 = i5 + 1;
                            zzaVar13.zza(zzaVar8);
                        } else {
                            zzaVar9 = zzaVar;
                        }
                        str5 = "_et";
                        z4 = false;
                        z5 = false;
                        i15 = 0;
                        while (true) {
                            zzaVar10 = zzaVarZzi;
                            if (i15 < zzaVar8.zza()) {
                                break;
                                break;
                            }
                            if ("_c".equals(zzaVar8.zzb(i15).zzg())) {
                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby114 = zzaVar8.zzb(i15).zzby();
                                com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar218 = zzaVarZzby114;
                                zzaVar8.zza(i15, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby114.zza(1L).zzab()));
                                zzaVar2 = zzaVar2;
                                z4 = true;
                            } else {
                                zzaVar12 = zzaVar2;
                                if ("_r".equals(zzaVar8.zzb(i15).zzg())) {
                                    com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby115 = zzaVar8.zzb(i15).zzby();
                                    com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar219 = zzaVarZzby115;
                                    zzaVar2 = zzaVar12;
                                    zzaVar8.zza(i15, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby115.zza(1L).zzab()));
                                    z5 = true;
                                } else {
                                    zzaVar2 = zzaVar12;
                                }
                            }
                            i15++;
                            zzaVarZzi = zzaVar10;
                        }
                        if (z4 && zZzc) {
                            zzj().zzp().zza("Marking event as conversion", this.zzm.zzk().zza(zzaVar8.zze()));
                            zzaVar8.zza(com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_c").zza(1L));
                        }
                        if (!z5) {
                            zzj().zzp().zza("Marking event as real-time", this.zzm.zzk().zza(zzaVar8.zze()));
                            zzaVar8.zza(com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_r").zza(1L));
                        }
                        if (zzf().zza(zzx(), zzaVar16.zza.zzx(), false, false, false, false, true).zze > zze().zze(zzaVar16.zza.zzx())) {
                            zza(zzaVar8, "_r");
                        } else {
                            z2 = true;
                        }
                        if (zznd.zzh(zzaVar8.zze()) && zZzc && zzf().zza(zzx(), zzaVar16.zza.zzx(), false, false, true, false, false).zzc > zze().zzb(zzaVar16.zza.zzx(), zzbi.zzn)) {
                            zzj().zzu().zza("Too many conversions. Not logging as conversion. appId", zzfr.zza(zzaVar16.zza.zzx()));
                            i16 = -1;
                            zzaVar11 = null;
                            z6 = false;
                            while (i17 < zzaVar8.zza()) {
                                zzgVarZzb = zzaVar8.zzb(i17);
                                if ("_c".equals(zzgVarZzb.zzg())) {
                                    com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZzby116 = zzgVarZzb.zzby();
                                    com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar2110 = zzaVarZzby116;
                                    zzaVar11 = zzaVarZzby116;
                                    i16 = i17;
                                } else if ("_err".equals(zzgVarZzb.zzg())) {
                                    z6 = true;
                                }
                            }
                            if (!z6 && zzaVar11 != null) {
                                zzaVar8.zza(i16);
                            } else if (zzaVar11 != null) {
                                zzaVar8.zza(i16, (com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzg.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar11.clone())).zza("_err").zza(10L).zzab()));
                            } else {
                                zzj().zzg().zza("Did not find conversion parameter. appId", zzfr.zza(zzaVar16.zza.zzx()));
                            }
                        }
                        if (zZzc) {
                            arrayList2 = new ArrayList(zzaVar8.zzf());
                            i21 = -1;
                            i22 = -1;
                            while (i20 < arrayList2.size()) {
                                if ("value".equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                    i21 = i20;
                                } else if (FirebaseAnalytics.Param.CURRENCY.equals(((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i20)).zzg())) {
                                    i22 = i20;
                                }
                            }
                            if (i21 == -1) {
                                if (((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i21)).zzl()) {
                                }
                                if (i22 == -1) {
                                    strZzh = ((com.google.android.gms.internal.measurement.zzfi.zzg) arrayList2.get(i22)).zzh();
                                    if (strZzh.length() != 3) {
                                        iCharCount = 0;
                                        while (iCharCount < strZzh.length()) {
                                            iCodePointAt = strZzh.codePointAt(iCharCount);
                                            if (!Character.isLetter(iCodePointAt)) {
                                                iCharCount += Character.charCount(iCodePointAt);
                                            }
                                        }
                                    }
                                }
                                zzj().zzv().zza("Value parameter discarded. You must also supply a 3-letter ISO_4217 currency code in the currency parameter.");
                                zzaVar8.zza(i21);
                                zza(zzaVar8, "_c");
                                zza(zzaVar8, 19, FirebaseAnalytics.Param.CURRENCY);
                                break;
                            }
                        }
                        if ("_e".equals(zzaVar8.zze())) {
                            zzp();
                            if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), "_fr") == null) {
                                if (zzaVar2 != null) {
                                    zzaVar15 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar2.clone());
                                    if (zza(zzaVar8, zzaVar15)) {
                                        zzaVar13 = zzaVar10;
                                        int i217 = i4;
                                        zzaVar13.zza(i217, zzaVar15);
                                        i4 = i217;
                                        i3 = i6;
                                        zzaVar2 = null;
                                        zzaVar9 = null;
                                    }
                                }
                                zzaVar13 = zzaVar10;
                                i3 = i5;
                                i4 = i4;
                                zzaVar9 = zzaVar8;
                            } else {
                                zzaVar13 = zzaVar10;
                                i18 = i4;
                                i3 = i6;
                                i4 = i18;
                            }
                        } else {
                            zzaVar13 = zzaVar10;
                            i18 = i4;
                            if ("_vs".equals(zzaVar8.zze())) {
                                zzp();
                                if (zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()), str5) == null) {
                                    if (zzaVar9 != null) {
                                        zzaVar14 = (com.google.android.gms.internal.measurement.zzfi.zze.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVar9.clone());
                                        if (zza(zzaVar14, zzaVar8)) {
                                            zzaVar13.zza(i6, zzaVar14);
                                            i3 = i6;
                                            i4 = i18;
                                            zzaVar2 = null;
                                            zzaVar9 = null;
                                        }
                                    }
                                    i4 = i5;
                                    i3 = i6;
                                    zzaVar2 = zzaVar8;
                                } else {
                                    i3 = i6;
                                    i4 = i18;
                                }
                            } else {
                                i3 = i6;
                                i4 = i18;
                            }
                        }
                        i19 = i14;
                        zzaVar16.zzc.set(i19, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar8.zzab()));
                        i2 = i5 + 1;
                        zzaVar13.zza(zzaVar8);
                    }
                    i = i19 + 1;
                    zzaVarZzi = zzaVar13;
                    z = z2;
                    zzaVar = zzaVar9;
                    str7 = str4;
                }
                zzaVar3 = zzaVarZzi;
                i7 = i5;
                jLongValue = 0;
                i8 = 0;
                while (i8 < i7) {
                    zzeVarZza2 = zzaVar3.zza(i8);
                    if ("_e".equals(zzeVarZza2.zzg())) {
                        zzp();
                        if (zzmz.zza(zzeVarZza2, "_fr") != null) {
                            zzaVar3.zzb(i8);
                            i7--;
                            i8--;
                        } else {
                            zzp();
                            zzgVarZza = zzmz.zza(zzeVarZza2, "_et");
                            if (zzgVarZza == null) {
                                if (zzgVarZza.zzl()) {
                                    lValueOf = Long.valueOf(zzgVarZza.zzd());
                                } else {
                                    lValueOf = null;
                                }
                                if (lValueOf == null && lValueOf.longValue() > 0) {
                                    jLongValue += lValueOf.longValue();
                                }
                            }
                        }
                    } else {
                        zzp();
                        zzgVarZza = zzmz.zza(zzeVarZza2, "_et");
                        if (zzgVarZza == null) {
                            if (zzgVarZza.zzl()) {
                                lValueOf = Long.valueOf(zzgVarZza.zzd());
                            } else {
                                lValueOf = null;
                            }
                            if (lValueOf == null) {
                            }
                        }
                    }
                    i8++;
                }
                zza(zzaVar3, jLongValue, false);
                it = zzaVar3.zzw().iterator();
                while (it.hasNext()) {
                    if ("_s".equals(it.next().zzg())) {
                        zzf().zzh(zzaVar3.zzr(), "_se");
                        break;
                    }
                }
                if (zzmz.zza(zzaVar3, "_sid") >= 0) {
                    zza(zzaVar3, jLongValue, true);
                } else {
                    iZza = zzmz.zza(zzaVar3, "_se");
                    if (iZza >= 0) {
                        zzaVar3.zzc(iZza);
                        zzj().zzg().zza("Session engagement user property is in the bundle without session ID. appId", zzfr.zza(zzaVar16.zza.zzx()));
                    }
                }
                zzp().zza(zzaVar3);
                if (zznp.zza() && zze().zza(zzbi.zzcm)) {
                    strZzx2 = zzaVar16.zza.zzx();
                    zzl().zzt();
                    zzs();
                    if (zznp.zza()) {
                        zzhVarZzd2 = zzf().zzd(strZzx2);
                        if (zzhVarZzd2 == null) {
                            zzj().zzg().zza("Cannot fix consent fields without appInfo. appId", zzfr.zza(strZzx2));
                        } else {
                            zza(zzhVarZzd2, zzaVar3);
                        }
                    }
                }
                zzaVar3.zzi(Long.MAX_VALUE).zze(Long.MIN_VALUE);
                while (i9 < zzaVar3.zza()) {
                    zzeVarZza = zzaVar3.zza(i9);
                    if (zzeVarZza.zzd() < zzaVar3.zzd()) {
                        zzaVar3.zzi(zzeVarZza.zzd());
                    }
                    if (zzeVarZza.zzd() > zzaVar3.zzc()) {
                        zzaVar3.zze(zzeVarZza.zzd());
                    }
                }
                zzaVar3.zzq();
                if (zzpg.zza() && zze().zze(zzaVar16.zza.zzx(), zzbi.zzcf)) {
                    zzq();
                    if (zznd.zzd(zzaVar16.zza.zzx()) && zzb(zzaVar16.zza.zzx()).zzg() && zzaVar16.zza.zzar()) {
                        while (i13 < zzaVar16.zzc.size()) {
                            com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby117 = zzaVar16.zzc.get(i13).zzby();
                            com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar2111 = zzaVarZzby117;
                            zzaVar7 = zzaVarZzby117;
                            it3 = zzaVar7.zzf().iterator();
                            while (it3.hasNext()) {
                                if ("_c".equals(it3.next().zzg())) {
                                    if (zzaVar16.zza.zza() >= zze().zzb(zzaVar16.zza.zzx(), zzbi.zzau)) {
                                        if (zze().zze(zzaVar16.zza.zzx(), zzbi.zzch)) {
                                            strZzp = zzq().zzp();
                                            zzaVar7.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_tu").zzb(strZzp).zzab()));
                                        } else {
                                            strZzp = null;
                                        }
                                        zzaVar7.zza((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza("_tr").zza(1L).zzab()));
                                        zzmhVarZza = zzp().zza(zzaVar16.zza.zzx(), zzaVar16.zza, zzaVar7, strZzp);
                                        if (zzmhVarZza != null) {
                                            zzj().zzp().zza("Generated trigger URI. appId, uri", zzaVar16.zza.zzx(), zzmhVarZza.zza);
                                            zzf().zza(zzaVar16.zza.zzx(), zzmhVarZza);
                                            this.zzr.add(zzaVar16.zza.zzx());
                                        }
                                    }
                                    zzaVar3.zza(i13, (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar7.zzab()));
                                    break;
                                    break;
                                }
                            }
                        }
                    }
                }
                zzaVar3.zzf().zza(zzc().zza(zzaVar3.zzr(), zzaVar3.zzw(), zzaVar3.zzx(), Long.valueOf(zzaVar3.zzd()), Long.valueOf(zzaVar3.zzc())));
                if (zze().zzl(zzaVar16.zza.zzx())) {
                    map = new HashMap();
                    arrayList = new ArrayList();
                    secureRandomZzv = zzq().zzv();
                    i11 = 0;
                    while (i11 < zzaVar3.zza()) {
                        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZzby118 = zzaVar3.zza(i11).zzby();
                        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar2112 = zzaVarZzby118;
                        zzaVar5 = zzaVarZzby118;
                        if (zzaVar5.zze().equals("_ep")) {
                            zzp();
                            str3 = (String) zzmz.zzb((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()), "_en");
                            zzbcVarZzd = (zzbc) map.get(str3);
                            if (zzbcVarZzd == null && (zzbcVarZzd = zzf().zzd(zzaVar16.zza.zzx(), (String) Preconditions.checkNotNull(str3))) != null) {
                                map.put(str3, zzbcVarZzd);
                            }
                            if (zzbcVarZzd != null && zzbcVarZzd.zzi == null) {
                                if (zzbcVarZzd.zzj != null && zzbcVarZzd.zzj.longValue() > 1) {
                                    zzp();
                                    zzmz.zza(zzaVar5, "_sr", zzbcVarZzd.zzj);
                                }
                                if (zzbcVarZzd.zzk != null && zzbcVarZzd.zzk.booleanValue()) {
                                    zzp();
                                    zzmz.zza(zzaVar5, "_efs", (Object) 1L);
                                }
                                arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                            }
                            zzaVar3.zza(i11, zzaVar5);
                        } else {
                            jZza = zzi().zza(zzaVar16.zza.zzx());
                            zzq();
                            jZza2 = zznd.zza(zzaVar5.zzc(), jZza);
                            com.google.android.gms.internal.measurement.zzfi.zze zzeVar4 = (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab());
                            Long l5 = 1L;
                            if (TextUtils.isEmpty("_dbg") && l5 != null) {
                                Iterator<com.google.android.gms.internal.measurement.zzfi.zzg> it4 = zzeVar4.zzh().iterator();
                                while (true) {
                                    if (it4.hasNext()) {
                                        com.google.android.gms.internal.measurement.zzfi.zzg next = it4.next();
                                        Iterator<com.google.android.gms.internal.measurement.zzfi.zzg> it5 = it4;
                                        if ("_dbg".equals(next.zzg())) {
                                            if ((!(l5 instanceof Long) || !l5.equals(Long.valueOf(next.zzd()))) && ((!(l5 instanceof String) || !l5.equals(next.zzh())) && (!(l5 instanceof Double) || !l5.equals(Double.valueOf(next.zza()))))) {
                                                break;
                                            }
                                            iZzb = 1;
                                            break;
                                        }
                                        it4 = it5;
                                    }
                                    iZzb = zzi().zzb(zzaVar16.zza.zzx(), zzaVar5.zze());
                                    break;
                                }
                            }
                            iZzb = zzi().zzb(zzaVar16.zza.zzx(), zzaVar5.zze());
                            break;
                            if (iZzb <= 0) {
                                zzj().zzu().zza("Sample rate must be positive. event, rate", zzaVar5.zze(), Integer.valueOf(iZzb));
                                arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                zzaVar3.zza(i11, zzaVar5);
                            } else {
                                zzbcVarZza = (zzbc) map.get(zzaVar5.zze());
                                if (zzbcVarZza == null) {
                                    j2 = jZza;
                                    zzbcVarZza = zzf().zzd(zzaVar16.zza.zzx(), zzaVar5.zze());
                                    if (zzbcVarZza == null) {
                                        zzj().zzu().zza("Event being bundled has no eventAggregate. appId, eventName", zzaVar16.zza.zzx(), zzaVar5.zze());
                                        zzbcVarZza = new zzbc(zzaVar16.zza.zzx(), zzaVar5.zze(), 1L, 1L, 1L, zzaVar5.zzc(), 0L, null, null, null, null);
                                    }
                                } else {
                                    j2 = jZza;
                                }
                                zzp();
                                l = (Long) zzmz.zzb((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()), "_eid");
                                if (l != null) {
                                    z3 = true;
                                } else {
                                    z3 = false;
                                }
                                boolValueOf = Boolean.valueOf(z3);
                                zzaVar6 = zzaVar16;
                                if (iZzb == 1) {
                                    arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                    boolValueOf.getClass();
                                    if (z3 && (zzbcVarZza.zzi != null || zzbcVarZza.zzj != null || zzbcVarZza.zzk != null)) {
                                        map.put(zzaVar5.zze(), zzbcVarZza.zza(null, null, null));
                                    }
                                    zzaVar3.zza(i11, zzaVar5);
                                    secureRandom = secureRandomZzv;
                                    i12 = i11;
                                    map2 = map;
                                } else {
                                    if (secureRandomZzv.nextInt(iZzb) == 0) {
                                        zzp();
                                        SecureRandom secureRandom5 = secureRandomZzv;
                                        int i218 = i11;
                                        j4 = iZzb;
                                        zzmz.zza(zzaVar5, "_sr", Long.valueOf(j4));
                                        arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                        boolValueOf.getClass();
                                        if (z3) {
                                            zzbcVarZza = zzbcVarZza.zza(null, Long.valueOf(j4), null);
                                        }
                                        map.put(zzaVar5.zze(), zzbcVarZza.zza(zzaVar5.zzc(), jZza2));
                                        map2 = map;
                                        secureRandom = secureRandom5;
                                        i12 = i218;
                                    } else {
                                        secureRandom = secureRandomZzv;
                                        int i219 = i11;
                                        if (zzbcVarZza.zzh != null) {
                                            jZza3 = zzbcVarZza.zzh.longValue();
                                        } else {
                                            zzq();
                                            jZza3 = zznd.zza(zzaVar5.zzb(), j2);
                                        }
                                        if (jZza3 != jZza2) {
                                            zzp();
                                            zzmz.zza(zzaVar5, "_efs", (Object) 1L);
                                            zzp();
                                            j3 = iZzb;
                                            zzmz.zza(zzaVar5, "_sr", Long.valueOf(j3));
                                            arrayList.add((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar5.zzab()));
                                            boolValueOf.getClass();
                                            if (z3) {
                                                zzbcVarZza = zzbcVarZza.zza(null, Long.valueOf(j3), true);
                                            }
                                            map2 = map;
                                            map2.put(zzaVar5.zze(), zzbcVarZza.zza(zzaVar5.zzc(), jZza2));
                                        } else {
                                            map2 = map;
                                            boolValueOf.getClass();
                                            if (z3) {
                                                map2.put(zzaVar5.zze(), zzbcVarZza.zza(l, null, null));
                                            }
                                        }
                                        i12 = i219;
                                    }
                                    zzaVar3.zza(i12, zzaVar5);
                                }
                            }
                            map = map2;
                            zzaVar16 = zzaVar6;
                            secureRandomZzv = secureRandom;
                            i11 = i12 + 1;
                        }
                        zzaVar6 = zzaVar16;
                        secureRandom = secureRandomZzv;
                        i12 = i11;
                        map2 = map;
                        map = map2;
                        zzaVar16 = zzaVar6;
                        secureRandomZzv = secureRandom;
                        i11 = i12 + 1;
                    }
                    HashMap map6 = map;
                    zza zzaVar2113 = zzaVar16;
                    if (arrayList.size() < zzaVar3.zza()) {
                        zzaVar3.zzi().zzb(arrayList);
                    }
                    it2 = map6.entrySet().iterator();
                    while (it2.hasNext()) {
                        zzf().zza((zzbc) ((Map.Entry) it2.next()).getValue());
                    }
                    zzaVar4 = zzaVar2113;
                } else {
                    zzaVar4 = zzaVar16;
                }
                strZzx = zzaVar4.zza.zzx();
                zzhVarZzd = zzf().zzd(strZzx);
                if (zzhVarZzd == null) {
                    zzj().zzg().zza("Bundling raw events w/o app info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                } else if (zzaVar3.zza() > 0) {
                    jZzp = zzhVarZzd.zzp();
                    if (jZzp != 0) {
                        zzaVar3.zzg(jZzp);
                    } else {
                        zzaVar3.zzm();
                    }
                    jZzr = zzhVarZzd.zzr();
                    if (jZzr == 0) {
                        jZzp = jZzr;
                    }
                    if (jZzp != 0) {
                        zzaVar3.zzh(jZzp);
                    } else {
                        zzaVar3.zzn();
                    }
                    zzhVarZzd.zzai();
                    zzaVar3.zzf((int) zzhVarZzd.zzq());
                    zzhVarZzd.zzp(zzaVar3.zzd());
                    zzhVarZzd.zzn(zzaVar3.zzc());
                    strZzw = zzhVarZzd.zzw();
                    if (strZzw != null) {
                        zzaVar3.zzn(strZzw);
                    } else {
                        zzaVar3.zzj();
                    }
                    zzf().zza(zzhVarZzd);
                }
                if (zzaVar3.zza() > 0) {
                    zzdVarZzc = zzi().zzc(zzaVar4.zza.zzx());
                    if (zzdVarZzc != null || !zzdVarZzc.zzs()) {
                        if (zzaVar4.zza.zzah().isEmpty()) {
                            zzaVar3.zzb(-1L);
                        } else {
                            zzj().zzu().zza("Did not find measurement config or missing version info. appId", zzfr.zza(zzaVar4.zza.zzx()));
                        }
                    } else {
                        zzaVar3.zzb(zzdVarZzc.zzc());
                    }
                    zzf().zza((com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) zzaVar3.zzab()), z2);
                }
                zzaoVarZzf = zzf();
                list = zzaVar4.zzb;
                Preconditions.checkNotNull(list);
                zzaoVarZzf.zzt();
                zzaoVarZzf.zzak();
                sb = new StringBuilder("rowid in (");
                while (i10 < list.size()) {
                    if (i10 != 0) {
                        sb.append(",");
                    }
                    sb.append(list.get(i10).longValue());
                }
                sb.append(")");
                iDelete = zzaoVarZzf.m30e_().delete("raw_events", sb.toString(), null);
                if (iDelete != list.size()) {
                    zzaoVarZzf.zzj().zzg().zza("Deleted fewer rows from raw events table than expected", Integer.valueOf(iDelete), Integer.valueOf(list.size()));
                }
                zzaoVarZzf2 = zzf();
                zzaoVarZzf2.m30e_().execSQL("delete from raw_events_metadata where app_id=? and metadata_fingerprint not in (select distinct metadata_fingerprint from raw_events where app_id=?)", new String[]{strZzx, strZzx});
                zzf().zzw();
                zzf().zzu();
                return true;
            }
            zzf().zzw();
            zzf().zzu();
            return false;
        } catch (Throwable th10) {
            zzf().zzu();
            throw th10;
        }
    }

    private final boolean zzac() {
        zzl().zzt();
        zzs();
        return zzf().zzx() || !TextUtils.isEmpty(zzf().m31f_());
    }

    private final boolean zzad() {
        zzl().zzt();
        FileLock fileLock = this.zzx;
        if (fileLock != null && fileLock.isValid()) {
            zzj().zzp().zza("Storage concurrent access okay");
            return true;
        }
        try {
            FileChannel channel = new RandomAccessFile(new File(this.zzm.zza().getFilesDir(), "google_app_measurement.db"), "rw").getChannel();
            this.zzy = channel;
            FileLock fileLockTryLock = channel.tryLock();
            this.zzx = fileLockTryLock;
            if (fileLockTryLock != null) {
                zzj().zzp().zza("Storage concurrent access okay");
                return true;
            }
            zzj().zzg().zza("Storage concurrent data access panic");
            return false;
        } catch (FileNotFoundException e) {
            zzj().zzg().zza("Failed to acquire storage lock", e);
            return false;
        } catch (IOException e2) {
            zzj().zzg().zza("Failed to access storage lock file", e2);
            return false;
        } catch (OverlappingFileLockException e3) {
            zzj().zzu().zza("Storage lock already acquired", e3);
            return false;
        }
    }

    private final boolean zza(com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar, com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar2) {
        Preconditions.checkArgument("_e".equals(zzaVar.zze()));
        zzp();
        com.google.android.gms.internal.measurement.zzfi.zzg zzgVarZza = zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar.zzab()), "_sc");
        String strZzh = zzgVarZza == null ? null : zzgVarZza.zzh();
        zzp();
        com.google.android.gms.internal.measurement.zzfi.zzg zzgVarZza2 = zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar2.zzab()), "_pc");
        String strZzh2 = zzgVarZza2 != null ? zzgVarZza2.zzh() : null;
        if (strZzh2 == null || !strZzh2.equals(strZzh)) {
            return false;
        }
        Preconditions.checkArgument("_e".equals(zzaVar.zze()));
        zzp();
        com.google.android.gms.internal.measurement.zzfi.zzg zzgVarZza3 = zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar.zzab()), "_et");
        if (zzgVarZza3 == null || !zzgVarZza3.zzl() || zzgVarZza3.zzd() <= 0) {
            return true;
        }
        long jZzd = zzgVarZza3.zzd();
        zzp();
        com.google.android.gms.internal.measurement.zzfi.zzg zzgVarZza4 = zzmz.zza((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVar2.zzab()), "_et");
        if (zzgVarZza4 != null && zzgVarZza4.zzd() > 0) {
            jZzd += zzgVarZza4.zzd();
        }
        zzp();
        zzmz.zza(zzaVar2, "_et", Long.valueOf(jZzd));
        zzp();
        zzmz.zza(zzaVar, "_fr", (Object) 1L);
        return true;
    }

    private final boolean zza(int i, FileChannel fileChannel) {
        zzl().zzt();
        if (fileChannel == null || !fileChannel.isOpen()) {
            zzj().zzg().zza("Bad channel to read from");
            return false;
        }
        ByteBuffer byteBufferAllocate = ByteBuffer.allocate(4);
        byteBufferAllocate.putInt(i);
        byteBufferAllocate.flip();
        try {
            fileChannel.truncate(0L);
            fileChannel.write(byteBufferAllocate);
            fileChannel.force(true);
            if (fileChannel.size() != 4) {
                zzj().zzg().zza("Error writing to channel. Bytes written", Long.valueOf(fileChannel.size()));
            }
            return true;
        } catch (IOException e) {
            zzj().zzg().zza("Failed to write to channel", e);
            return false;
        }
    }
}
