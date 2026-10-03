package com.android.billingclient.api;

import android.content.Context;
import com.google.android.gms.internal.play_billing.zziu;
import com.google.android.gms.internal.play_billing.zziw;
import com.google.android.gms.internal.play_billing.zziy;
import com.google.android.gms.internal.play_billing.zzja;
import com.google.android.gms.internal.play_billing.zzji;
import com.google.android.gms.internal.play_billing.zzjp;
import com.google.android.gms.internal.play_billing.zzjr;
import com.google.android.gms.internal.play_billing.zzjz;
import com.google.android.gms.internal.play_billing.zzkf;
import com.google.android.gms.internal.play_billing.zzkh;
import com.google.android.gms.internal.play_billing.zzkn;
import com.google.android.gms.internal.play_billing.zzkr;

final class zzdl implements zzcz {
    private zzjr zzb;
    private final zzdn zzc;

    zzdl(Context context, zzjr zzjrVar) {
        this.zzc = new zzdn(context);
        this.zzb = zzjrVar;
    }

    private final void zzl(zziw zziwVar, zzjr zzjrVar) {
        if (zziwVar == null) {
            return;
        }
        try {
            zzkf zzkfVarZza = zzkh.zza();
            zzkfVarZza.zzd(zzjrVar);
            zzkfVarZza.zza(zziwVar);
            this.zzc.zza(zzkfVarZza.zzi());
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    private final void zzm(zzja zzjaVar, zzjr zzjrVar) {
        if (zzjaVar == null) {
            return;
        }
        try {
            zzkf zzkfVarZza = zzkh.zza();
            zzkfVarZza.zzd(zzjrVar);
            zzkfVarZza.zzb(zzjaVar);
            this.zzc.zza((zzkh) zzkfVarZza.zzi());
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zza(zziw zziwVar) {
        try {
            zzl(zziwVar, this.zzb);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzb(zziw zziwVar, int i) {
        try {
            zzjp zzjpVarZzq = this.zzb.zzq();
            zzjpVarZzq.zzc(i);
            this.zzb = zzjpVarZzq.zzi();
            zza(zziwVar);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzc(zziw zziwVar, int i, long j) {
        try {
            zzjp zzjpVarZzq = this.zzb.zzq();
            zzjpVarZzq.zzc(i);
            zzjr zzjrVar = (zzjr) zzjpVarZzq.zzi();
            this.zzb = zzjrVar;
            if (j != 0) {
                zzjp zzjpVarZzq2 = zzjrVar.zzq();
                zzjpVarZzq2.zze(j);
                zzjrVar = (zzjr) zzjpVarZzq2.zzi();
            }
            zzl(zziwVar, zzjrVar);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzd(zziw zziwVar, long j, boolean z) {
        zzjr zzjrVar;
        try {
            zziu zziuVarZzq = zziwVar.zzq();
            zzjz zzjzVarZzq = zziwVar.zze().zzq();
            zzjzVarZzq.zza(z);
            zziuVarZzq.zzd(zzjzVarZzq);
            zziw zziwVar2 = (zziw) zziuVarZzq.zzi();
            if (j == 0) {
                zzjrVar = this.zzb;
            } else {
                zzjp zzjpVarZzq = this.zzb.zzq();
                zzjpVarZzq.zze(j);
                zzjrVar = (zzjr) zzjpVarZzq.zzi();
            }
            zzl(zziwVar2, zzjrVar);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zze(zziw zziwVar, int i, long j, boolean z) {
        zzjr zzjrVar;
        try {
            zzjp zzjpVarZzq = this.zzb.zzq();
            zzjpVarZzq.zzc(i);
            this.zzb = zzjpVarZzq.zzi();
            zziu zziuVarZzq = zziwVar.zzq();
            zzjz zzjzVarZzq = zziwVar.zze().zzq();
            zzjzVarZzq.zza(z);
            zziuVarZzq.zzd(zzjzVarZzq);
            zziw zziwVar2 = (zziw) zziuVarZzq.zzi();
            if (j == 0) {
                zzjrVar = this.zzb;
            } else {
                zzjp zzjpVarZzq2 = this.zzb.zzq();
                zzjpVarZzq2.zze(j);
                zzjrVar = (zzjr) zzjpVarZzq2.zzi();
            }
            zzl(zziwVar2, zzjrVar);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzf(zzja zzjaVar) {
        try {
            zzm(zzjaVar, this.zzb);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzg(zzja zzjaVar, int i) {
        try {
            zzjp zzjpVarZzq = this.zzb.zzq();
            zzjpVarZzq.zzc(i);
            this.zzb = zzjpVarZzq.zzi();
            zzf(zzjaVar);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzh(zzja zzjaVar, long j, boolean z) {
        zzjr zzjrVar;
        try {
            zziy zziyVarZzq = zzjaVar.zzq();
            zzjz zzjzVarZzq = zzjaVar.zzc().zzq();
            zzjzVarZzq.zza(z);
            zziyVarZzq.zzc(zzjzVarZzq);
            zzja zzjaVar2 = (zzja) zziyVarZzq.zzi();
            if (j == 0) {
                zzjrVar = this.zzb;
            } else {
                zzjp zzjpVarZzq = this.zzb.zzq();
                zzjpVarZzq.zze(j);
                zzjrVar = (zzjr) zzjpVarZzq.zzi();
            }
            zzm(zzjaVar2, zzjrVar);
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzi(zzji zzjiVar) {
        try {
            zzkf zzkfVarZza = zzkh.zza();
            zzkfVarZza.zzd(this.zzb);
            zzkfVarZza.zzc(zzjiVar);
            this.zzc.zza(zzkfVarZza.zzi());
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzj(zzkn zzknVar) {
        try {
            zzdn zzdnVar = this.zzc;
            zzkf zzkfVarZza = zzkh.zza();
            zzkfVarZza.zzd(this.zzb);
            zzkfVarZza.zze(zzknVar);
            zzdnVar.zza((zzkh) zzkfVarZza.zzi());
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }

    @Override
    public final void zzk(zzkr zzkrVar) {
        if (zzkrVar == null) {
            return;
        }
        try {
            zzkf zzkfVarZza = zzkh.zza();
            zzkfVarZza.zzd(this.zzb);
            zzkfVarZza.zzp(zzkrVar);
            this.zzc.zza((zzkh) zzkfVarZza.zzi());
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to log.", th);
        }
    }
}
