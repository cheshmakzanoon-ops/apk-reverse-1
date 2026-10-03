package com.google.android.gms.measurement.internal;

import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Pair;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.util.Clock;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import org.checkerframework.dataflow.qual.Pure;

public final class zzls extends zzmo {
    public final zzgi zza;
    public final zzgi zzb;
    public final zzgi zzc;
    public final zzgi zzd;
    public final zzgi zze;
    private final Map<String, zzlr> zzg;

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    @Override
    protected final boolean zzc() {
        return false;
    }

    @Deprecated
    private final Pair<String, Boolean> zza(String str) {
        zzlr zzlrVar;
        AdvertisingIdClient.Info advertisingIdInfo;
        zzt();
        long jElapsedRealtime = zzb().elapsedRealtime();
        zzlr zzlrVar2 = this.zzg.get(str);
        if (zzlrVar2 != null && jElapsedRealtime < zzlrVar2.zzc) {
            return new Pair<>(zzlrVar2.zza, Boolean.valueOf(zzlrVar2.zzb));
        }
        AdvertisingIdClient.setShouldSkipGmsCoreVersionCheck(true);
        long jZzf = zze().zzf(str) + jElapsedRealtime;
        try {
            long jZzc = zze().zzc(str, zzbi.zzb);
            if (jZzc > 0) {
                try {
                    advertisingIdInfo = AdvertisingIdClient.getAdvertisingIdInfo(zza());
                } catch (PackageManager.NameNotFoundException unused) {
                    if (zzlrVar2 != null && jElapsedRealtime < zzlrVar2.zzc + jZzc) {
                        return new Pair<>(zzlrVar2.zza, Boolean.valueOf(zzlrVar2.zzb));
                    }
                    advertisingIdInfo = null;
                }
            } else {
                advertisingIdInfo = AdvertisingIdClient.getAdvertisingIdInfo(zza());
            }
            if (advertisingIdInfo == null) {
                return new Pair<>("00000000-0000-0000-0000-000000000000", false);
            }
            String id = advertisingIdInfo.getId();
            zzlrVar = id != null ? new zzlr(id, advertisingIdInfo.isLimitAdTrackingEnabled(), jZzf) : new zzlr("", advertisingIdInfo.isLimitAdTrackingEnabled(), jZzf);
            this.zzg.put(str, zzlrVar);
            AdvertisingIdClient.setShouldSkipGmsCoreVersionCheck(false);
            return new Pair<>(zzlrVar.zza, Boolean.valueOf(zzlrVar.zzb));
        } catch (Exception e) {
            zzj().zzc().zza("Unable to get advertising id", e);
            zzlrVar = new zzlr("", false, jZzf);
        }
    }

    final Pair<String, Boolean> zza(String str, zzih zzihVar) {
        if (zzihVar.zzg()) {
            return zza(str);
        }
        return new Pair<>("", false);
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

    @Deprecated
    final String zza(String str, boolean z) {
        String str2;
        zzt();
        if (!z) {
            str2 = "00000000-0000-0000-0000-000000000000";
        } else {
            str2 = (String) zza(str).first;
        }
        MessageDigest messageDigestZzu = zznd.zzu();
        if (messageDigestZzu == null) {
            return null;
        }
        return String.format(Locale.US, "%032X", new BigInteger(1, messageDigestZzu.digest(str2.getBytes())));
    }

    zzls(zzmp zzmpVar) {
        super(zzmpVar);
        this.zzg = new HashMap();
        zzgd zzgdVarZzk = zzk();
        zzgdVarZzk.getClass();
        this.zza = new zzgi(zzgdVarZzk, "last_delete_stale", 0L);
        zzgd zzgdVarZzk2 = zzk();
        zzgdVarZzk2.getClass();
        this.zzb = new zzgi(zzgdVarZzk2, "backoff", 0L);
        zzgd zzgdVarZzk3 = zzk();
        zzgdVarZzk3.getClass();
        this.zzc = new zzgi(zzgdVarZzk3, "last_upload", 0L);
        zzgd zzgdVarZzk4 = zzk();
        zzgdVarZzk4.getClass();
        this.zzd = new zzgi(zzgdVarZzk4, "last_upload_attempt", 0L);
        zzgd zzgdVarZzk5 = zzk();
        zzgdVarZzk5.getClass();
        this.zze = new zzgi(zzgdVarZzk5, "midnight_offset", 0L);
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
}
