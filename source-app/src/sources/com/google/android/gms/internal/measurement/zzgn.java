package com.google.android.gms.internal.measurement;

import android.content.Context;
import com.google.common.base.Optional;
import com.google.common.base.Preconditions;
import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import java.util.Collection;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import javax.annotation.Nullable;

public abstract class zzgn<T> {

    @Nullable
    private static volatile zzgu zzb;
    private static volatile boolean zzc;
    private final zzgv zzg;
    private final String zzh;
    private final T zzi;
    private volatile int zzj;
    private volatile T zzk;
    private final boolean zzl;
    private static final Object zza = new Object();
    private static final AtomicReference<Collection<zzgn<?>>> zzd = new AtomicReference<>();
    private static zzgy zze = new zzgy(new zzhb() {
        @Override
        public final boolean zza() {
            return zzgn.zzd();
        }
    });
    private static final AtomicInteger zzf = new AtomicInteger();

    static boolean zzd() {
        return true;
    }

    abstract T zza(Object obj);

    static zzgn zza(zzgv zzgvVar, String str, Boolean bool, boolean z) {
        return new zzgq(zzgvVar, str, bool, true);
    }

    static zzgn zza(zzgv zzgvVar, String str, Double d, boolean z) {
        return new zzgt(zzgvVar, str, d, true);
    }

    static zzgn zza(zzgv zzgvVar, String str, Long l, boolean z) {
        return new zzgr(zzgvVar, str, l, true);
    }

    static zzgn zza(zzgv zzgvVar, String str, String str2, boolean z) {
        return new zzgs(zzgvVar, str, str2, true);
    }

    public final T zza() {
        T tZzb;
        if (!this.zzl) {
            Preconditions.checkState(zze.zza(this.zzh), "Attempt to access PhenotypeFlag not via codegen. All new PhenotypeFlags must be accessed through codegen APIs. If you believe you are seeing this error by mistake, you can add your flag to the exemption list located at //java/com/google/android/libraries/phenotype/client/lockdown/flags.textproto. Send the addition CL to ph-reviews@. See go/phenotype-android-codegen for information about generated code. See go/ph-lockdown for more information about this error.");
        }
        int i = zzf.get();
        if (this.zzj < i) {
            synchronized (this) {
                if (this.zzj < i) {
                    zzgu zzguVar = zzb;
                    Optional<zzgh> optionalAbsent = Optional.absent();
                    String strZza = null;
                    if (zzguVar != null) {
                        optionalAbsent = zzguVar.zzb().get();
                        if (optionalAbsent.isPresent()) {
                            strZza = optionalAbsent.get().zza(this.zzg.zzb, this.zzg.zza, this.zzg.zzd, this.zzh);
                        }
                    }
                    Preconditions.checkState(zzguVar != null, "Must call PhenotypeFlagInitializer.maybeInit() first");
                    if (this.zzg.zzf) {
                        tZzb = zza(zzguVar);
                        if (tZzb == null && (tZzb = zzb(zzguVar)) == null) {
                            tZzb = this.zzi;
                        }
                    } else {
                        tZzb = zzb(zzguVar);
                        if (tZzb == null && (tZzb = zza(zzguVar)) == null) {
                            tZzb = this.zzi;
                        }
                    }
                    if (optionalAbsent.isPresent()) {
                        tZzb = strZza == null ? this.zzi : zza((Object) strZza);
                    }
                    this.zzk = tZzb;
                    this.zzj = i;
                }
            }
        }
        return this.zzk;
    }

    @Nullable
    private final T zza(zzgu zzguVar) {
        if (!this.zzg.zze && (this.zzg.zzh == null || this.zzg.zzh.apply(zzguVar.zza()).booleanValue())) {
            Object objZza = zzgg.zza(zzguVar.zza()).zza(this.zzg.zze ? null : zza(this.zzg.zzc));
            if (objZza != null) {
                return zza(objZza);
            }
        }
        return null;
    }

    @Nullable
    private final T zzb(zzgu zzguVar) {
        zzgb zzgbVarZza;
        Object objZza;
        if (this.zzg.zzb != null) {
            if (!zzgl.zza(zzguVar.zza(), this.zzg.zzb)) {
                zzgbVarZza = null;
            } else if (this.zzg.zzg) {
                zzgbVarZza = zzfy.zza(zzguVar.zza().getContentResolver(), zzgk.zza(zzgk.zza(zzguVar.zza(), this.zzg.zzb.getLastPathSegment())), new Runnable() {
                    @Override
                    public final void run() {
                        zzgn.zzc();
                    }
                });
            } else {
                zzgbVarZza = zzfy.zza(zzguVar.zza().getContentResolver(), this.zzg.zzb, new Runnable() {
                    @Override
                    public final void run() {
                        zzgn.zzc();
                    }
                });
            }
        } else {
            zzgbVarZza = zzgw.zza(zzguVar.zza(), this.zzg.zza, new Runnable() {
                @Override
                public final void run() {
                    zzgn.zzc();
                }
            });
        }
        if (zzgbVarZza == null || (objZza = zzgbVarZza.zza(zzb())) == null) {
            return null;
        }
        return zza(objZza);
    }

    public final String zzb() {
        return zza(this.zzg.zzd);
    }

    private final String zza(String str) {
        if (str != null && str.isEmpty()) {
            return this.zzh;
        }
        return str + this.zzh;
    }

    private zzgn(zzgv zzgvVar, String str, T t, boolean z) {
        this.zzj = -1;
        if (zzgvVar.zza == null && zzgvVar.zzb == null) {
            throw new IllegalArgumentException("Must pass a valid SharedPreferences file name or ContentProvider URI");
        }
        if (zzgvVar.zza != null && zzgvVar.zzb != null) {
            throw new IllegalArgumentException("Must pass one of SharedPreferences file name or ContentProvider URI");
        }
        this.zzg = zzgvVar;
        this.zzh = str;
        this.zzi = t;
        this.zzl = z;
    }

    public static void zzc() {
        zzf.incrementAndGet();
    }

    public static void zzb(final Context context) {
        if (zzb != null || context == null) {
            return;
        }
        Object obj = zza;
        synchronized (obj) {
            if (zzb == null && context != null) {
                synchronized (obj) {
                    zzgu zzguVar = zzb;
                    Context applicationContext = context.getApplicationContext();
                    if (applicationContext != null) {
                        context = applicationContext;
                    }
                    if (zzguVar == null || zzguVar.zza() != context) {
                        zzfy.zzc();
                        zzgw.zza();
                        zzgg.zza();
                        zzb = new zzfv(context, Suppliers.memoize(new Supplier() {
                            @Override
                            public final Object get() {
                                return zzgj.zza.zza(context);
                            }
                        }));
                        zzf.incrementAndGet();
                    }
                }
            }
        }
    }
}
