package com.google.android.gms.internal.measurement;

import android.content.Context;
import com.google.common.base.Optional;
import com.google.common.base.Supplier;
import javax.annotation.Nullable;

final class zzfv extends zzgu {
    private final Context zza;

    @Nullable
    private final Supplier<Optional<zzgh>> zzb;

    public final int hashCode() {
        int iHashCode = (this.zza.hashCode() ^ 1000003) * 1000003;
        Supplier<Optional<zzgh>> supplier = this.zzb;
        return iHashCode ^ (supplier == null ? 0 : supplier.hashCode());
    }

    @Override
    final Context zza() {
        return this.zza;
    }

    @Override
    @Nullable
    final Supplier<Optional<zzgh>> zzb() {
        return this.zzb;
    }

    public final String toString() {
        return "FlagsContext{context=" + String.valueOf(this.zza) + ", hermeticFileOverrides=" + String.valueOf(this.zzb) + "}";
    }

    zzfv(Context context, @Nullable Supplier<Optional<zzgh>> supplier) {
        if (context == null) {
            throw new NullPointerException("Null context");
        }
        this.zza = context;
        this.zzb = supplier;
    }

    public final boolean equals(Object obj) {
        Supplier<Optional<zzgh>> supplier;
        if (obj == this) {
            return true;
        }
        if (obj instanceof zzgu) {
            zzgu zzguVar = (zzgu) obj;
            if (this.zza.equals(zzguVar.zza()) && ((supplier = this.zzb) != null ? supplier.equals(zzguVar.zzb()) : zzguVar.zzb() == null)) {
                return true;
            }
        }
        return false;
    }
}
