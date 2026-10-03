package com.google.android.gms.auth.api.accounttransfer;

final class zzh extends AccountTransferClient.zza<DeviceMetaData> {
    private final zzg zzas;

    zzh(zzg zzgVar, AccountTransferClient.zzb zzbVar) {
        super(zzbVar);
        this.zzas = zzgVar;
    }

    @Override
    public final void zza(DeviceMetaData deviceMetaData) {
        this.zzas.setResult(deviceMetaData);
    }
}
