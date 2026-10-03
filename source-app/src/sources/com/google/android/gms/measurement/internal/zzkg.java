package com.google.android.gms.measurement.internal;

import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Pair;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.internal.measurement.zznp;
import com.google.android.gms.internal.measurement.zzps;
import com.ishumei.smantifraud.l11l11lI1lll;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

final class zzkg extends zzmo {
    private static String zza(String str, String str2) {
        throw new SecurityException("This implementation should not be used.");
    }

    @Override
    protected final boolean zzc() {
        return false;
    }

    public zzkg(zzmp zzmpVar) {
        super(zzmpVar);
    }

    public final byte[] zza(zzbg zzbgVar, String str) {
        zzne next;
        long j;
        zzbc zzbcVarZza;
        zzt();
        this.zzu.zzy();
        Preconditions.checkNotNull(zzbgVar);
        Preconditions.checkNotEmpty(str);
        if (!zze().zze(str, zzbi.zzbc)) {
            zzj().zzc().zza("Generating ScionPayload disabled. packageName", str);
            return new byte[0];
        }
        if (!"_iap".equals(zzbgVar.zza) && !"_iapx".equals(zzbgVar.zza)) {
            zzj().zzc().zza("Generating a payload for this event is not available. package_name, event_name", str, zzbgVar.zza);
            return null;
        }
        com.google.android.gms.internal.measurement.zzfi.zzi.zza zzaVarZzb = com.google.android.gms.internal.measurement.zzfi.zzi.zzb();
        zzh().zzp();
        try {
            zzh zzhVarZzd = zzh().zzd(str);
            if (zzhVarZzd == null) {
                zzj().zzc().zza("Log and bundle not available. package_name", str);
                byte[] bArr = new byte[0];
                zzh().zzu();
                return bArr;
            }
            if (!zzhVarZzd.zzak()) {
                zzj().zzc().zza("Log and bundle disabled. package_name", str);
                byte[] bArr2 = new byte[0];
                zzh().zzu();
                return bArr2;
            }
            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzp = com.google.android.gms.internal.measurement.zzfi.zzj.zzu().zzg(1).zzp(l11l11lI1lll.l111l1111l1Il);
            if (!TextUtils.isEmpty(zzhVarZzd.zzx())) {
                zzaVarZzp.zzb(zzhVarZzd.zzx());
            }
            if (!TextUtils.isEmpty(zzhVarZzd.zzz())) {
                zzaVarZzp.zzd((String) Preconditions.checkNotNull(zzhVarZzd.zzz()));
            }
            if (!TextUtils.isEmpty(zzhVarZzd.zzaa())) {
                zzaVarZzp.zze((String) Preconditions.checkNotNull(zzhVarZzd.zzaa()));
            }
            if (zzhVarZzd.zzc() != -2147483648L) {
                zzaVarZzp.zze((int) zzhVarZzd.zzc());
            }
            zzaVarZzp.zzf(zzhVarZzd.zzo()).zzd(zzhVarZzd.zzm());
            String strZzac = zzhVarZzd.zzac();
            String strZzv = zzhVarZzd.zzv();
            if (!TextUtils.isEmpty(strZzac)) {
                zzaVarZzp.zzm(strZzac);
            } else if (!TextUtils.isEmpty(strZzv)) {
                zzaVarZzp.zza(strZzv);
            }
            zzaVarZzp.zzj(zzhVarZzd.zzt());
            zzih zzihVarZzb = this.zzf.zzb(str);
            zzaVarZzp.zzc(zzhVarZzd.zzl());
            if (this.zzu.zzac() && zze().zzk(zzaVarZzp.zzr()) && zzihVarZzb.zzg() && !TextUtils.isEmpty(null)) {
                zzaVarZzp.zzj((String) null);
            }
            zzaVarZzp.zzg(zzihVarZzb.zze());
            if (zzihVarZzb.zzg() && zzhVarZzd.zzaj()) {
                Pair<String, Boolean> pairZza = zzn().zza(zzhVarZzd.zzx(), zzihVarZzb);
                if (zzhVarZzd.zzaj() && pairZza != null && !TextUtils.isEmpty((CharSequence) pairZza.first)) {
                    try {
                        zzaVarZzp.zzq(zza((String) pairZza.first, Long.toString(zzbgVar.zzd)));
                        if (pairZza.second != null) {
                            zzaVarZzp.zzc(((Boolean) pairZza.second).booleanValue());
                        }
                    } catch (SecurityException e) {
                        zzj().zzc().zza("Resettable device id encryption failed", e.getMessage());
                        byte[] bArr3 = new byte[0];
                        zzh().zzu();
                        return bArr3;
                    }
                }
            }
            zzf().zzab();
            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVarZzi = zzaVarZzp.zzi(Build.MODEL);
            zzf().zzab();
            zzaVarZzi.zzo(Build.VERSION.RELEASE).zzi((int) zzf().zzg()).zzs(zzf().zzh());
            try {
                if (zzihVarZzb.zzh() && zzhVarZzd.zzy() != null) {
                    zzaVarZzp.zzc(zza((String) Preconditions.checkNotNull(zzhVarZzd.zzy()), Long.toString(zzbgVar.zzd)));
                }
                if (!TextUtils.isEmpty(zzhVarZzd.zzab())) {
                    zzaVarZzp.zzl((String) Preconditions.checkNotNull(zzhVarZzd.zzab()));
                }
                String strZzx = zzhVarZzd.zzx();
                List<zzne> listZzi = zzh().zzi(strZzx);
                Iterator<zzne> it = listZzi.iterator();
                do {
                    if (!it.hasNext()) {
                        next = null;
                        break;
                    }
                    next = it.next();
                } while (!"_lte".equals(next.zzc));
                if (next == null || next.zze == null) {
                    zzne zzneVar = new zzne(strZzx, "auto", "_lte", zzb().currentTimeMillis(), 0L);
                    listZzi.add(zzneVar);
                    zzh().zza(zzneVar);
                }
                com.google.android.gms.internal.measurement.zzfi.zzn[] zznVarArr = new com.google.android.gms.internal.measurement.zzfi.zzn[listZzi.size()];
                for (int i = 0; i < listZzi.size(); i++) {
                    com.google.android.gms.internal.measurement.zzfi.zzn.zza zzaVarZzb2 = com.google.android.gms.internal.measurement.zzfi.zzn.zze().zza(listZzi.get(i).zzc).zzb(listZzi.get(i).zzd);
                    mo32g_().zza(zzaVarZzb2, listZzi.get(i).zze);
                    zznVarArr[i] = (com.google.android.gms.internal.measurement.zzfi.zzn) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzb2.zzab());
                }
                zzaVarZzp.zze(Arrays.asList(zznVarArr));
                mo32g_().zza(zzaVarZzp);
                if (zznp.zza() && zze().zza(zzbi.zzcm)) {
                    this.zzf.zza(zzhVarZzd, zzaVarZzp);
                }
                zzfv zzfvVarZza = zzfv.zza(zzbgVar);
                zzq().zza(zzfvVarZza.zzb, zzh().zzc(str));
                zzq().zza(zzfvVarZza, zze().zzd(str));
                Bundle bundle = zzfvVarZza.zzb;
                bundle.putLong("_c", 1L);
                zzj().zzc().zza("Marking in-app purchase as real-time");
                bundle.putLong("_r", 1L);
                bundle.putString("_o", zzbgVar.zzc);
                if (zzq().zzf(zzaVarZzp.zzr())) {
                    zzq().zza(bundle, "_dbg", (Object) 1L);
                    zzq().zza(bundle, "_r", (Object) 1L);
                }
                zzbc zzbcVarZzd = zzh().zzd(str, zzbgVar.zza);
                if (zzbcVarZzd == null) {
                    zzbcVarZza = new zzbc(str, zzbgVar.zza, 0L, 0L, zzbgVar.zzd, 0L, null, null, null, null);
                    j = 0;
                } else {
                    j = zzbcVarZzd.zzf;
                    zzbcVarZza = zzbcVarZzd.zza(zzbgVar.zzd);
                }
                zzh().zza(zzbcVarZza);
                zzaz zzazVar = new zzaz(this.zzu, zzbgVar.zzc, str, zzbgVar.zza, zzbgVar.zzd, j, bundle);
                com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZza = com.google.android.gms.internal.measurement.zzfi.zze.zze().zzb(zzazVar.zzc).zza(zzazVar.zzb).zza(zzazVar.zzd);
                for (String str2 : zzazVar.zze) {
                    com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZza2 = com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza(str2);
                    Object objZzc = zzazVar.zze.zzc(str2);
                    if (objZzc != null) {
                        mo32g_().zza(zzaVarZza2, objZzc);
                        zzaVarZza.zza(zzaVarZza2);
                    }
                }
                zzaVarZzp.zza(zzaVarZza).zza(com.google.android.gms.internal.measurement.zzfi.zzk.zza().zza(com.google.android.gms.internal.measurement.zzfi.zzf.zza().zza(zzbcVarZza.zzc).zza(zzbgVar.zza)));
                zzaVarZzp.zza(zzg().zza(zzhVarZzd.zzx(), Collections.emptyList(), zzaVarZzp.zzx(), Long.valueOf(zzaVarZza.zzc()), Long.valueOf(zzaVarZza.zzc())));
                if (zzaVarZza.zzg()) {
                    zzaVarZzp.zzi(zzaVarZza.zzc()).zze(zzaVarZza.zzc());
                }
                long jZzp = zzhVarZzd.zzp();
                if (jZzp != 0) {
                    zzaVarZzp.zzg(jZzp);
                }
                long jZzr = zzhVarZzd.zzr();
                if (jZzr != 0) {
                    zzaVarZzp.zzh(jZzr);
                } else if (jZzp != 0) {
                    zzaVarZzp.zzh(jZzp);
                }
                String strZzaf = zzhVarZzd.zzaf();
                if (zzps.zza() && zze().zze(str, zzbi.zzbt) && strZzaf != null) {
                    zzaVarZzp.zzr(strZzaf);
                }
                zzhVarZzd.zzai();
                zzaVarZzp.zzf((int) zzhVarZzd.zzq()).zzl(82001L).zzk(zzb().currentTimeMillis()).zzd(Boolean.TRUE.booleanValue());
                if (zze().zza(zzbi.zzbw)) {
                    this.zzf.zza(zzaVarZzp.zzr(), zzaVarZzp);
                }
                zzaVarZzb.zza(zzaVarZzp);
                zzhVarZzd.zzp(zzaVarZzp.zzd());
                zzhVarZzd.zzn(zzaVarZzp.zzc());
                zzh().zza(zzhVarZzd);
                zzh().zzw();
                zzh().zzu();
                try {
                    return mo32g_().zzb(((com.google.android.gms.internal.measurement.zzfi.zzi) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzb.zzab())).zzbv());
                } catch (IOException e2) {
                    zzj().zzg().zza("Data loss. Failed to bundle and serialize. appId", zzfr.zza(str), e2);
                    return 0;
                }
            } catch (SecurityException e3) {
                zzj().zzc().zza("app instance id encryption failed", e3.getMessage());
                byte[] bArr4 = new byte[0];
                zzh().zzu();
                return bArr4;
            }
        } catch (Throwable th) {
            zzh().zzu();
            throw th;
        }
    }
}
