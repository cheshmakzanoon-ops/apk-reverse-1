package com.android.billingclient.api;

import com.facebook.internal.security.CertificateUtil;
import com.google.android.gms.internal.play_billing.zziu;
import com.google.android.gms.internal.play_billing.zziw;
import com.google.android.gms.internal.play_billing.zziy;
import com.google.android.gms.internal.play_billing.zzja;
import com.google.android.gms.internal.play_billing.zzjb;
import com.google.android.gms.internal.play_billing.zzjd;
import com.google.android.gms.internal.play_billing.zzjf;
import com.google.android.gms.internal.play_billing.zzjk;

public final class zzcy {
    public static final int zza = 0;

    static {
        int i = zzcz.zza;
    }

    public static String zza(Exception exc) {
        if (exc == null) {
            return null;
        }
        try {
            String str = exc.getClass().getSimpleName() + CertificateUtil.DELIMITER + com.google.android.gms.internal.play_billing.zzbm.zzc(exc.getMessage());
            int i = com.google.android.gms.internal.play_billing.zzc.zza;
            return str.length() > 40 ? str.substring(0, 40) : str;
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to get truncated exception info", th);
            return null;
        }
    }

    public static zziw zzb(zzjd zzjdVar, int i, BillingResult billingResult, String str, zzjk zzjkVar) {
        try {
            zzjb zzjbVarZza = zzjf.zza();
            zzjbVarZza.zzp(billingResult.getResponseCode());
            zzjbVarZza.zzb(billingResult.getDebugMessage());
            if (billingResult.getOnPurchasesUpdatedSubResponseCode() != 0) {
                zzjbVarZza.zzd(billingResult.getOnPurchasesUpdatedSubResponseCode());
            }
            if (zzjdVar != null) {
                zzjbVarZza.zze(zzjdVar);
            }
            if (str != null) {
                zzjbVarZza.zza(str);
            }
            zziu zziuVarZza = zziw.zza();
            zziuVarZza.zzb(zzjbVarZza);
            zziuVarZza.zzp(i);
            if (!zzjkVar.equals(zzjk.zza)) {
                zziuVarZza.zza(zzjkVar);
            }
            return zziuVarZza.zzi();
        } catch (Throwable th) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to create logging payload", th);
            return null;
        }
    }

    public static zzja zzc(int i, zzjk zzjkVar) {
        try {
            zziy zziyVarZza = zzja.zza();
            zziyVarZza.zze(i);
            if (!zzjkVar.equals(zzjk.zza)) {
                zziyVarZza.zza(zzjkVar);
            }
            return zziyVarZza.zzi();
        } catch (Exception e) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingLogger", "Unable to create logging payload", e);
            return null;
        }
    }
}
