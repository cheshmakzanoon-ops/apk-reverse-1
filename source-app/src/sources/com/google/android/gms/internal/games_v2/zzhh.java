package com.google.android.gms.internal.games_v2;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public final class zzhh {
    private final List zza = new ArrayList();

    public final zzhh zza(zzhw zzhwVar) {
        if (zzhwVar.zzb()) {
            throw new IllegalArgumentException(zzfv.zza("range must not be empty, but was %s", zzhwVar));
        }
        this.zza.add(zzhwVar);
        return this;
    }

    final zzhh zzb(zzhh zzhhVar) {
        Iterator it = zzhhVar.zza.iterator();
        while (it.hasNext()) {
            zza((zzhw) it.next());
        }
        return this;
    }

    public final zzhi zzc() {
        List list = this.zza;
        zzgz zzgzVar = new zzgz(list.size());
        int i = zzhw.zzc;
        Collections.sort(list, zzhv.zza);
        Iterator it = list.iterator();
        zzhn zzhnVar = it instanceof zzhn ? (zzhn) it : new zzhn(it);
        while (zzhnVar.hasNext()) {
            zzhw zzhwVarZzd = (zzhw) zzhnVar.next();
            while (zzhnVar.hasNext()) {
                zzhw zzhwVar = (zzhw) zzhnVar.zza();
                if (zzhwVarZzd.zza.compareTo(zzhwVar.zzb) > 0 || zzhwVar.zza.compareTo(zzhwVarZzd.zzb) > 0) {
                    break;
                }
                zzfu.zza(zzhwVarZzd.zzc(zzhwVar).zzb(), "Overlapping ranges not permitted but found %s overlapping %s", zzhwVarZzd, zzhwVar);
                zzhwVarZzd = zzhwVarZzd.zzd((zzhw) zzhnVar.next());
            }
            zzgzVar.zzd(zzhwVarZzd);
        }
        zzhd zzhdVarZze = zzgzVar.zze();
        if (zzhdVarZze.isEmpty()) {
            return zzhi.zza();
        }
        if (zzhdVarZze.size() == 1) {
            zzim zzimVarListIterator = zzhdVarZze.listIterator(0);
            Object next = zzimVarListIterator.next();
            if (zzimVarListIterator.hasNext()) {
                StringBuilder sb = new StringBuilder("expected one element but was: <");
                sb.append(next);
                for (int i2 = 0; i2 < 4 && zzimVarListIterator.hasNext(); i2++) {
                    sb.append(", ");
                    sb.append(zzimVarListIterator.next());
                }
                if (zzimVarListIterator.hasNext()) {
                    sb.append(", ...");
                }
                sb.append('>');
                throw new IllegalArgumentException(sb.toString());
            }
            if (((zzhw) next).equals(zzhw.zza())) {
                return zzhi.zzb();
            }
        }
        return new zzhi(zzhdVarZze);
    }
}
