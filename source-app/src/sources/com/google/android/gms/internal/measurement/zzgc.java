package com.google.android.gms.internal.measurement;

import android.net.Uri;
import androidx.collection.SimpleArrayMap;
import javax.annotation.Nullable;

public final class zzgc implements zzgh {
    private final SimpleArrayMap<String, SimpleArrayMap<String, String>> zza;

    @Override
    @Nullable
    public final String zza(@Nullable Uri uri, @Nullable String str, @Nullable String str2, String str3) {
        SimpleArrayMap simpleArrayMap;
        if (uri == null) {
            if (str == null) {
                simpleArrayMap = null;
            }
            if (simpleArrayMap == null) {
                return null;
            }
            if (str2 != null) {
                str3 = str2 + str3;
            }
            return (String) simpleArrayMap.get(str3);
        }
        str = uri.toString();
        simpleArrayMap = (SimpleArrayMap) this.zza.get(str);
        if (simpleArrayMap == null) {
            return null;
        }
        if (str2 != null) {
            str3 = str2 + str3;
        }
        return (String) simpleArrayMap.get(str3);
    }

    zzgc(SimpleArrayMap<String, SimpleArrayMap<String, String>> simpleArrayMap) {
        this.zza = simpleArrayMap;
    }
}
