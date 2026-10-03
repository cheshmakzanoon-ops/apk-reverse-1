package com.google.android.gms.auth.api.accounttransfer;

final class zzf extends AccountTransferClient.zza<byte[]> {
    private final zze zzaq;

    zzf(zze zzeVar, AccountTransferClient.zzb zzbVar) {
        super(zzbVar);
        this.zzaq = zzeVar;
    }

    @Override
    public final void zza(byte[] bArr) {
        this.zzaq.setResult(bArr);
    }
}
