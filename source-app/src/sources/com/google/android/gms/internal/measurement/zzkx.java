package com.google.android.gms.internal.measurement;

import j$.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

final class zzkx {
    private static final zzkx zza = new zzkx();
    private final ConcurrentMap<Class<?>, zzlb<?>> zzc = new ConcurrentHashMap();
    private final zzle zzb = new zzjx();

    public static zzkx zza() {
        return zza;
    }

    public final <T> zzlb<T> zza(Class<T> cls) {
        zziz.zza(cls, "messageType");
        zzlb<T> zzlbVar = (zzlb) this.zzc.get(cls);
        if (zzlbVar != null) {
            return zzlbVar;
        }
        zzlb<T> zzlbVarZza = this.zzb.zza(cls);
        zziz.zza(cls, "messageType");
        zziz.zza(zzlbVarZza, "schema");
        zzlb<T> zzlbVar2 = (zzlb) this.zzc.putIfAbsent(cls, zzlbVarZza);
        return zzlbVar2 != null ? zzlbVar2 : zzlbVarZza;
    }

    public final <T> zzlb<T> zza(T t) {
        return zza((Class) t.getClass());
    }

    private zzkx() {
    }
}
