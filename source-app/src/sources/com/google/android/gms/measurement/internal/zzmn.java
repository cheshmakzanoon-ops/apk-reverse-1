package com.google.android.gms.measurement.internal;

import android.content.Context;
import android.net.Uri;
import android.text.TextUtils;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.internal.measurement.zzqd;
import java.util.HashMap;
import org.checkerframework.dataflow.qual.Pure;

public final class zzmn extends zzml {
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

    public final zzmq zza(String str) {
        if (zzqd.zza() && zze().zza(zzbi.zzbu)) {
            zzj().zzp().zza("sgtm feature flag enabled.");
            zzh zzhVarZzd = zzh().zzd(str);
            if (zzhVarZzd == null) {
                return new zzmq(zzb(str));
            }
            zzmq zzmqVar = null;
            if (zzhVarZzd.zzam()) {
                zzj().zzp().zza("sgtm upload enabled in manifest.");
                com.google.android.gms.internal.measurement.zzfc.zzd zzdVarZzc = zzm().zzc(zzhVarZzd.zzx());
                if (zzdVarZzc != null) {
                    String strZzj = zzdVarZzc.zzj();
                    if (!TextUtils.isEmpty(strZzj)) {
                        String strZzi = zzdVarZzc.zzi();
                        zzj().zzp().zza("sgtm configured with upload_url, server_info", strZzj, TextUtils.isEmpty(strZzi) ? "Y" : "N");
                        if (TextUtils.isEmpty(strZzi)) {
                            zzmqVar = new zzmq(strZzj);
                        } else {
                            HashMap map = new HashMap();
                            map.put("x-google-sgtm-server-info", strZzi);
                            zzmqVar = new zzmq(strZzj, map);
                        }
                    }
                }
            }
            if (zzmqVar != null) {
                return zzmqVar;
            }
        }
        return new zzmq(zzb(str));
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

    private final String zzb(String str) throws Throwable {
        String strZzf = zzm().zzf(str);
        if (!TextUtils.isEmpty(strZzf)) {
            Uri uri = Uri.parse(zzbi.zzq.zza(null));
            Uri.Builder builderBuildUpon = uri.buildUpon();
            builderBuildUpon.authority(strZzf + "." + uri.getAuthority());
            return builderBuildUpon.build().toString();
        }
        return zzbi.zzq.zza(null);
    }

    zzmn(zzmp zzmpVar) {
        super(zzmpVar);
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
