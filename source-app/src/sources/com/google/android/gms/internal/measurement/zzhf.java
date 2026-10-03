package com.google.android.gms.internal.measurement;

import com.google.android.gms.internal.measurement.zzhd;
import com.google.android.gms.internal.measurement.zzhf;
import java.io.IOException;

public abstract class zzhf<MessageType extends zzhd<MessageType, BuilderType>, BuilderType extends zzhf<MessageType, BuilderType>> implements zzkm {
    @Override
    public abstract BuilderType zzb(zzib zzibVar, zzik zzikVar) throws IOException;

    @Override
    public abstract BuilderType clone();

    public BuilderType zza(byte[] bArr, int i, int i2) throws zzji {
        try {
            zzib zzibVarZza = zzib.zza(bArr, 0, i2, false);
            zzb(zzibVarZza, zzik.zza);
            zzibVarZza.zzb(0);
            return this;
        } catch (zzji e) {
            throw e;
        } catch (IOException e2) {
            throw new RuntimeException(zza("byte array"), e2);
        }
    }

    public BuilderType zza(byte[] bArr, int i, int i2, zzik zzikVar) throws zzji {
        try {
            zzib zzibVarZza = zzib.zza(bArr, 0, i2, false);
            zzb(zzibVarZza, zzikVar);
            zzibVarZza.zzb(0);
            return this;
        } catch (zzji e) {
            throw e;
        } catch (IOException e2) {
            throw new RuntimeException(zza("byte array"), e2);
        }
    }

    @Override
    public final zzkm zza(byte[] bArr) throws zzji {
        return zza(bArr, 0, bArr.length);
    }

    @Override
    public final zzkm zza(byte[] bArr, zzik zzikVar) throws zzji {
        return zza(bArr, 0, bArr.length, zzikVar);
    }

    private final String zza(String str) {
        return "Reading " + getClass().getName() + " from a " + str + " threw an IOException (should never happen).";
    }
}
