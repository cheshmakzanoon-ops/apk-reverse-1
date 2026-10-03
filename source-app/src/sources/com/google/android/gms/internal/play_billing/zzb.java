package com.google.android.gms.internal.play_billing;

enum zzb {
    RESPONSE_CODE_UNSPECIFIED(-999),
    SERVICE_TIMEOUT(-3),
    FEATURE_NOT_SUPPORTED(-2),
    SERVICE_DISCONNECTED(-1),
    OK(0),
    USER_CANCELED(1),
    SERVICE_UNAVAILABLE(2),
    BILLING_UNAVAILABLE(3),
    ITEM_UNAVAILABLE(4),
    DEVELOPER_ERROR(5),
    ERROR(6),
    ITEM_ALREADY_OWNED(7),
    ITEM_NOT_OWNED(8),
    EXPIRED_OFFER_TOKEN(11),
    NETWORK_ERROR(12);

    private static final zzbz zzp;
    private final int zzr;

    static {
        zzby zzbyVar = new zzby();
        for (zzb zzbVar : values()) {
            zzbyVar.zza(Integer.valueOf(zzbVar.zzr), zzbVar);
        }
        zzp = zzbyVar.zzb();
    }

    zzb(int i) {
        this.zzr = i;
    }

    static zzb zza(int i) {
        zzbz zzbzVar = zzp;
        Integer numValueOf = Integer.valueOf(i);
        return !zzbzVar.containsKey(numValueOf) ? RESPONSE_CODE_UNSPECIFIED : (zzb) zzbzVar.get(numValueOf);
    }
}
