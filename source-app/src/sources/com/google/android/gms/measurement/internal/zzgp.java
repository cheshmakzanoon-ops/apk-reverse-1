package com.google.android.gms.measurement.internal;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteException;
import android.text.TextUtils;
import androidx.collection.ArrayMap;
import androidx.collection.LruCache;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.Clock;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.ishumei.smantifraud.l11l11lI1lll;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.concurrent.Callable;
import org.checkerframework.dataflow.qual.Pure;

public final class zzgp extends zzmo implements zzah {
    final LruCache<String, com.google.android.gms.internal.measurement.zzb> zza;
    final com.google.android.gms.internal.measurement.zzv zzb;
    private final Map<String, Map<String, String>> zzc;
    private final Map<String, Set<String>> zzd;
    private final Map<String, Map<String, Boolean>> zze;
    private final Map<String, Map<String, Boolean>> zzg;
    private final Map<String, com.google.android.gms.internal.measurement.zzfc.zzd> zzh;
    private final Map<String, Map<String, Integer>> zzi;
    private final Map<String, String> zzj;
    private final Map<String, String> zzk;
    private final Map<String, String> zzl;

    final int zzb(String str, String str2) throws Throwable {
        Integer num;
        zzt();
        zzv(str);
        Map<String, Integer> map = this.zzi.get(str);
        if (map == null || (num = map.get(str2)) == null) {
            return 1;
        }
        return num.intValue();
    }

    @Override
    protected final boolean zzc() {
        return false;
    }

    final long zza(String str) throws Throwable {
        String strZza = zza(str, "measurement.account.time_zone_offset_minutes");
        if (TextUtils.isEmpty(strZza)) {
            return 0L;
        }
        try {
            return Long.parseLong(strZza);
        } catch (NumberFormatException e) {
            zzj().zzu().zza("Unable to parse timezone offset. appId", zzfr.zza(str), e);
            return 0L;
        }
    }

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    static com.google.android.gms.internal.measurement.zzb zza(zzgp zzgpVar, String str) throws Throwable {
        zzgpVar.zzak();
        Preconditions.checkNotEmpty(str);
        if (!zzgpVar.zzl(str)) {
            return null;
        }
        if (zzgpVar.zzh.containsKey(str) && zzgpVar.zzh.get(str) != null) {
            zzgpVar.zza(str, zzgpVar.zzh.get(str));
        } else {
            zzgpVar.zzv(str);
        }
        return (com.google.android.gms.internal.measurement.zzb) zzgpVar.zza.snapshot().get(str);
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
    }

    @Override
    public final zzt zzg() {
        return super.zzg();
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
    public final zzao zzh() {
        return super.zzh();
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
    public final zzgp zzm() {
        return super.zzm();
    }

    @Override
    @Pure
    public final zzgy zzl() {
        return super.zzl();
    }

    final zzih.zza zza(String str, zzih.zza zzaVar) throws Throwable {
        zzt();
        zzv(str);
        com.google.android.gms.internal.measurement.zzfc.zza zzaVarZzb = zzb(str);
        if (zzaVarZzb == null) {
            return null;
        }
        for (com.google.android.gms.internal.measurement.zzfc.zza.zzc zzcVar : zzaVarZzb.zze()) {
            if (zzaVar == zza(zzcVar.zzc())) {
                return zza(zzcVar.zzb());
            }
        }
        return null;
    }

    private static zzih.zza zza(com.google.android.gms.internal.measurement.zzfc.zza.zze zzeVar) {
        int i = zzgw.zzb[zzeVar.ordinal()];
        if (i == 1) {
            return zzih.zza.AD_STORAGE;
        }
        if (i == 2) {
            return zzih.zza.ANALYTICS_STORAGE;
        }
        if (i == 3) {
            return zzih.zza.AD_USER_DATA;
        }
        if (i != 4) {
            return null;
        }
        return zzih.zza.AD_PERSONALIZATION;
    }

    @Override
    public final zzls zzn() {
        return super.zzn();
    }

    @Override
    public final zzmn zzo() {
        return super.zzo();
    }

    @Override
    public final zzmz mo32g_() {
        return super.mo32g_();
    }

    @Override
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    final com.google.android.gms.internal.measurement.zzfc.zza zzb(String str) throws Throwable {
        zzt();
        zzv(str);
        com.google.android.gms.internal.measurement.zzfc.zzd zzdVarZzc = zzc(str);
        if (zzdVarZzc == null || !zzdVarZzc.zzq()) {
            return null;
        }
        return zzdVarZzc.zzd();
    }

    protected final com.google.android.gms.internal.measurement.zzfc.zzd zzc(String str) {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        zzv(str);
        return this.zzh.get(str);
    }

    private final com.google.android.gms.internal.measurement.zzfc.zzd zza(String str, byte[] bArr) {
        if (bArr == null) {
            return com.google.android.gms.internal.measurement.zzfc.zzd.zzg();
        }
        try {
            com.google.android.gms.internal.measurement.zzfc.zzd zzdVar = (com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfc.zzd.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfc.zzd.zze(), bArr)).zzab());
            zzj().zzp().zza("Parsed config. version, gmp_app_id", zzdVar.zzs() ? Long.valueOf(zzdVar.zzc()) : null, zzdVar.zzr() ? zzdVar.zzh() : null);
            return zzdVar;
        } catch (com.google.android.gms.internal.measurement.zzji e) {
            zzj().zzu().zza("Unable to merge remote config. appId", zzfr.zza(str), e);
            return com.google.android.gms.internal.measurement.zzfc.zzd.zzg();
        } catch (RuntimeException e2) {
            zzj().zzu().zza("Unable to merge remote config. appId", zzfr.zza(str), e2);
            return com.google.android.gms.internal.measurement.zzfc.zzd.zzg();
        }
    }

    @Override
    public final String zza(String str, String str2) throws Throwable {
        zzt();
        zzv(str);
        Map<String, String> map = this.zzc.get(str);
        if (map != null) {
            return map.get(str2);
        }
        return null;
    }

    protected final String zzd(String str) {
        zzt();
        return this.zzl.get(str);
    }

    protected final String zze(String str) {
        zzt();
        return this.zzk.get(str);
    }

    final String zzf(String str) throws Throwable {
        zzt();
        zzv(str);
        return this.zzj.get(str);
    }

    private static Map<String, String> zza(com.google.android.gms.internal.measurement.zzfc.zzd zzdVar) {
        ArrayMap arrayMap = new ArrayMap();
        if (zzdVar != null) {
            for (com.google.android.gms.internal.measurement.zzfc.zzg zzgVar : zzdVar.zzo()) {
                arrayMap.put(zzgVar.zzb(), zzgVar.zzc());
            }
        }
        return arrayMap;
    }

    final Set<String> zzg(String str) {
        zzt();
        zzv(str);
        return this.zzd.get(str);
    }

    final SortedSet<String> zzh(String str) {
        zzt();
        zzv(str);
        TreeSet treeSet = new TreeSet();
        com.google.android.gms.internal.measurement.zzfc.zza zzaVarZzb = zzb(str);
        if (zzaVarZzb == null) {
            return treeSet;
        }
        Iterator<com.google.android.gms.internal.measurement.zzfc.zza.zzf> it = zzaVarZzb.zzc().iterator();
        while (it.hasNext()) {
            treeSet.add(it.next().zzb());
        }
        return treeSet;
    }

    zzgp(zzmp zzmpVar) {
        super(zzmpVar);
        this.zzc = new ArrayMap();
        this.zzd = new ArrayMap();
        this.zze = new ArrayMap();
        this.zzg = new ArrayMap();
        this.zzh = new ArrayMap();
        this.zzj = new ArrayMap();
        this.zzk = new ArrayMap();
        this.zzl = new ArrayMap();
        this.zzi = new ArrayMap();
        this.zza = new zzgv(this, 20);
        this.zzb = new zzgu(this);
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

    protected final void zzi(String str) {
        zzt();
        this.zzk.put(str, null);
    }

    private final void zza(String str, com.google.android.gms.internal.measurement.zzfc.zzd.zza zzaVar) {
        HashSet hashSet = new HashSet();
        Map<String, Boolean> arrayMap = new ArrayMap<>();
        Map<String, Boolean> arrayMap2 = new ArrayMap<>();
        Map<String, Integer> arrayMap3 = new ArrayMap<>();
        if (zzaVar != null) {
            Iterator<com.google.android.gms.internal.measurement.zzfc.zzb> it = zzaVar.zze().iterator();
            while (it.hasNext()) {
                hashSet.add(it.next().zzb());
            }
            for (int i = 0; i < zzaVar.zza(); i++) {
                com.google.android.gms.internal.measurement.zzfc.zzc.zza zzaVarZzby = zzaVar.zza(i).zzby();
                if (zzaVarZzby.zzb().isEmpty()) {
                    zzj().zzu().zza("EventConfig contained null event name");
                } else {
                    String strZzb = zzaVarZzby.zzb();
                    String strZzb2 = zzii.zzb(zzaVarZzby.zzb());
                    if (!TextUtils.isEmpty(strZzb2)) {
                        zzaVarZzby = zzaVarZzby.zza(strZzb2);
                        zzaVar.zza(i, zzaVarZzby);
                    }
                    if (zzaVarZzby.zze() && zzaVarZzby.zzc()) {
                        arrayMap.put(strZzb, true);
                    }
                    if (zzaVarZzby.zzf() && zzaVarZzby.zzd()) {
                        arrayMap2.put(zzaVarZzby.zzb(), true);
                    }
                    if (zzaVarZzby.zzg()) {
                        if (zzaVarZzby.zza() < 2 || zzaVarZzby.zza() > 65535) {
                            zzj().zzu().zza("Invalid sampling rate. Event name, sample rate", zzaVarZzby.zzb(), Integer.valueOf(zzaVarZzby.zza()));
                        } else {
                            arrayMap3.put(zzaVarZzby.zzb(), Integer.valueOf(zzaVarZzby.zza()));
                        }
                    }
                }
            }
        }
        this.zzd.put(str, hashSet);
        this.zze.put(str, arrayMap);
        this.zzg.put(str, arrayMap2);
        this.zzi.put(str, arrayMap3);
    }

    private final void zzv(String str) throws Throwable {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        if (this.zzh.get(str) == null) {
            zzaq zzaqVarZze = zzh().zze(str);
            if (zzaqVarZze == null) {
                this.zzc.put(str, null);
                this.zze.put(str, null);
                this.zzd.put(str, null);
                this.zzg.put(str, null);
                this.zzh.put(str, null);
                this.zzj.put(str, null);
                this.zzk.put(str, null);
                this.zzl.put(str, null);
                this.zzi.put(str, null);
                return;
            }
            com.google.android.gms.internal.measurement.zzfc.zzd.zza zzaVarZzby = zza(str, zzaqVarZze.zza).zzby();
            zza(str, zzaVarZzby);
            this.zzc.put(str, zza((com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby.zzab())));
            this.zzh.put(str, (com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby.zzab()));
            zza(str, (com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby.zzab()));
            this.zzj.put(str, zzaVarZzby.zzc());
            this.zzk.put(str, zzaqVarZze.zzb);
            this.zzl.put(str, zzaqVarZze.zzc);
        }
    }

    private final void zza(final String str, com.google.android.gms.internal.measurement.zzfc.zzd zzdVar) {
        if (zzdVar.zza() == 0) {
            this.zza.remove(str);
            return;
        }
        zzj().zzp().zza("EES programs found", Integer.valueOf(zzdVar.zza()));
        com.google.android.gms.internal.measurement.zzfp.zzc zzcVar = zzdVar.zzn().get(0);
        try {
            com.google.android.gms.internal.measurement.zzb zzbVar = new com.google.android.gms.internal.measurement.zzb();
            zzbVar.zza("internal.remoteConfig", new Callable() {
                @Override
                public final Object call() {
                    return new com.google.android.gms.internal.measurement.zzm("internal.remoteConfig", new zzgx(this.zza, str));
                }
            });
            zzbVar.zza("internal.appMetadata", new Callable() {
                @Override
                public final Object call() {
                    final zzgp zzgpVar = this.zza;
                    final String str2 = str;
                    return new com.google.android.gms.internal.measurement.zzx("internal.appMetadata", new Callable() {
                        @Override
                        public final Object call() {
                            zzgp zzgpVar2 = zzgpVar;
                            String str3 = str2;
                            zzh zzhVarZzd = zzgpVar2.zzh().zzd(str3);
                            HashMap map = new HashMap();
                            map.put("platform", l11l11lI1lll.l111l1111l1Il);
                            map.put("package_name", str3);
                            map.put("gmp_version", 82001L);
                            if (zzhVarZzd != null) {
                                String strZzaa = zzhVarZzd.zzaa();
                                if (strZzaa != null) {
                                    map.put("app_version", strZzaa);
                                }
                                map.put("app_version_int", Long.valueOf(zzhVarZzd.zzc()));
                                map.put("dynamite_version", Long.valueOf(zzhVarZzd.zzm()));
                            }
                            return map;
                        }
                    });
                }
            });
            zzbVar.zza("internal.logger", new Callable() {
                @Override
                public final Object call() {
                    return new com.google.android.gms.internal.measurement.zzr(this.zza.zzb);
                }
            });
            zzbVar.zza(zzcVar);
            this.zza.put(str, zzbVar);
            zzj().zzp().zza("EES program loaded for appId, activities", str, Integer.valueOf(zzcVar.zza().zza()));
            Iterator<com.google.android.gms.internal.measurement.zzfp.zzb> it = zzcVar.zza().zzd().iterator();
            while (it.hasNext()) {
                zzj().zzp().zza("EES program activity", it.next().zzb());
            }
        } catch (com.google.android.gms.internal.measurement.zzc unused) {
            zzj().zzg().zza("Failed to load EES program. appId", str);
        }
    }

    final void zzj(String str) {
        zzt();
        this.zzh.remove(str);
    }

    final boolean zzk(String str) {
        zzt();
        com.google.android.gms.internal.measurement.zzfc.zzd zzdVarZzc = zzc(str);
        if (zzdVarZzc == null) {
            return false;
        }
        return zzdVarZzc.zzp();
    }

    public final boolean zzl(String str) {
        com.google.android.gms.internal.measurement.zzfc.zzd zzdVar;
        return (TextUtils.isEmpty(str) || (zzdVar = this.zzh.get(str)) == null || zzdVar.zza() == 0) ? false : true;
    }

    final boolean zzm(String str) {
        return "1".equals(zza(str, "measurement.upload.blacklist_internal"));
    }

    final boolean zzb(String str, zzih.zza zzaVar) throws Throwable {
        zzt();
        zzv(str);
        com.google.android.gms.internal.measurement.zzfc.zza zzaVarZzb = zzb(str);
        if (zzaVarZzb == null) {
            return false;
        }
        for (com.google.android.gms.internal.measurement.zzfc.zza.zzb zzbVar : zzaVarZzb.zzd()) {
            if (zzaVar == zza(zzbVar.zzc())) {
                if (zzbVar.zzb() == com.google.android.gms.internal.measurement.zzfc.zza.zzd.GRANTED) {
                    return true;
                }
            }
        }
        return false;
    }

    final boolean zzn(String str) {
        zzt();
        zzv(str);
        com.google.android.gms.internal.measurement.zzfc.zza zzaVarZzb = zzb(str);
        return zzaVarZzb == null || !zzaVarZzb.zzg() || zzaVarZzb.zzf();
    }

    final boolean zzc(String str, String str2) throws Throwable {
        Boolean bool;
        zzt();
        zzv(str);
        if ("ecommerce_purchase".equals(str2) || FirebaseAnalytics.Event.PURCHASE.equals(str2) || FirebaseAnalytics.Event.REFUND.equals(str2)) {
            return true;
        }
        Map<String, Boolean> map = this.zzg.get(str);
        if (map == null || (bool = map.get(str2)) == null) {
            return false;
        }
        return bool.booleanValue();
    }

    final boolean zzd(String str, String str2) throws Throwable {
        Boolean bool;
        zzt();
        zzv(str);
        if (zzm(str) && zznd.zzg(str2)) {
            return true;
        }
        if (zzo(str) && zznd.zzh(str2)) {
            return true;
        }
        Map<String, Boolean> map = this.zze.get(str);
        if (map == null || (bool = map.get(str2)) == null) {
            return false;
        }
        return bool.booleanValue();
    }

    final boolean zzo(String str) {
        return "1".equals(zza(str, "measurement.upload.blacklist_public"));
    }

    protected final boolean zza(String str, byte[] bArr, String str2, String str3) {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        com.google.android.gms.internal.measurement.zzfc.zzd.zza zzaVarZzby = zza(str, bArr).zzby();
        if (zzaVarZzby == null) {
            return false;
        }
        zza(str, zzaVarZzby);
        zza(str, (com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby.zzab()));
        this.zzh.put(str, (com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby.zzab()));
        this.zzj.put(str, zzaVarZzby.zzc());
        this.zzk.put(str, str2);
        this.zzl.put(str, str3);
        this.zzc.put(str, zza((com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby.zzab())));
        zzh().zza(str, new ArrayList(zzaVarZzby.zzd()));
        try {
            zzaVarZzby.zzb();
            bArr = ((com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby.zzab())).zzbv();
        } catch (RuntimeException e) {
            zzj().zzu().zza("Unable to serialize reduced-size config. Storing full config instead. appId", zzfr.zza(str), e);
        }
        zzao zzaoVarZzh = zzh();
        Preconditions.checkNotEmpty(str);
        zzaoVarZzh.zzt();
        zzaoVarZzh.zzak();
        ContentValues contentValues = new ContentValues();
        contentValues.put("remote_config", bArr);
        contentValues.put("config_last_modified_time", str2);
        contentValues.put("e_tag", str3);
        try {
            if (zzaoVarZzh.m30e_().update("apps", contentValues, "app_id = ?", new String[]{str}) == 0) {
                zzaoVarZzh.zzj().zzg().zza("Failed to update remote config (got 0). appId", zzfr.zza(str));
            }
        } catch (SQLiteException e2) {
            zzaoVarZzh.zzj().zzg().zza("Error storing remote config. appId", zzfr.zza(str), e2);
        }
        this.zzh.put(str, (com.google.android.gms.internal.measurement.zzfc.zzd) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzby.zzab()));
        return true;
    }

    final boolean zzp(String str) throws Throwable {
        zzt();
        zzv(str);
        return this.zzd.get(str) != null && this.zzd.get(str).contains("app_instance_id");
    }

    final boolean zzq(String str) throws Throwable {
        zzt();
        zzv(str);
        if (this.zzd.get(str) != null) {
            return this.zzd.get(str).contains("device_model") || this.zzd.get(str).contains("device_info");
        }
        return false;
    }

    final boolean zzr(String str) throws Throwable {
        zzt();
        zzv(str);
        return this.zzd.get(str) != null && this.zzd.get(str).contains("enhanced_user_id");
    }

    final boolean zzs(String str) throws Throwable {
        zzt();
        zzv(str);
        return this.zzd.get(str) != null && this.zzd.get(str).contains("google_signals");
    }

    final boolean zzt(String str) throws Throwable {
        zzt();
        zzv(str);
        if (this.zzd.get(str) != null) {
            return this.zzd.get(str).contains("os_version") || this.zzd.get(str).contains("device_info");
        }
        return false;
    }

    final boolean zzu(String str) throws Throwable {
        zzt();
        zzv(str);
        return this.zzd.get(str) != null && this.zzd.get(str).contains("user_id");
    }
}
