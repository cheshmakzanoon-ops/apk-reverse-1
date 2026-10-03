package com.google.android.gms.internal.measurement;

import com.google.android.gms.internal.measurement.zzhd;
import com.google.android.gms.internal.measurement.zzhf;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public abstract class zzhd<MessageType extends zzhd<MessageType, BuilderType>, BuilderType extends zzhf<MessageType, BuilderType>> implements zzkj {
    protected int zza = 0;

    int zzbt() {
        throw new UnsupportedOperationException();
    }

    int zza(zzlb zzlbVar) {
        int iZzbt = zzbt();
        if (iZzbt != -1) {
            return iZzbt;
        }
        int iZza = zzlbVar.zza(this);
        zzc(iZza);
        return iZza;
    }

    @Override
    public final zzhm zzbu() {
        try {
            zzhv zzhvVarZzc = zzhm.zzc(zzbw());
            zza(zzhvVarZzc.zzb());
            return zzhvVarZzc.zza();
        } catch (IOException e) {
            throw new RuntimeException("Serializing " + getClass().getName() + " to a ByteString threw an IOException (should never happen).", e);
        }
    }

    protected static <T> void zza(Iterable<T> iterable, List<? super T> list) {
        zziz.zza(iterable);
        if (iterable instanceof zzjp) {
            List<?> listZzb = ((zzjp) iterable).zzb();
            zzjp zzjpVar = (zzjp) list;
            int size = list.size();
            for (Object obj : listZzb) {
                if (obj == null) {
                    String str = "Element at index " + (zzjpVar.size() - size) + " is null.";
                    for (int size2 = zzjpVar.size() - 1; size2 >= size; size2--) {
                        zzjpVar.remove(size2);
                    }
                    throw new NullPointerException(str);
                }
                if (obj instanceof zzhm) {
                    zzjpVar.zza((zzhm) obj);
                } else {
                    zzjpVar.add((String) obj);
                }
            }
            return;
        }
        if (iterable instanceof zzkv) {
            list.addAll((Collection) iterable);
            return;
        }
        if ((list instanceof ArrayList) && (iterable instanceof Collection)) {
            ((ArrayList) list).ensureCapacity(list.size() + ((Collection) iterable).size());
        }
        int size3 = list.size();
        for (T t : iterable) {
            if (t == null) {
                String str2 = "Element at index " + (list.size() - size3) + " is null.";
                for (int size4 = list.size() - 1; size4 >= size3; size4--) {
                    list.remove(size4);
                }
                throw new NullPointerException(str2);
            }
            list.add(t);
        }
    }

    void zzc(int i) {
        throw new UnsupportedOperationException();
    }

    public final byte[] zzbv() {
        try {
            byte[] bArr = new byte[zzbw()];
            zzig zzigVarZzb = zzig.zzb(bArr);
            zza(zzigVarZzb);
            zzigVarZzb.zzb();
            return bArr;
        } catch (IOException e) {
            throw new RuntimeException("Serializing " + getClass().getName() + " to a byte array threw an IOException (should never happen).", e);
        }
    }
}
