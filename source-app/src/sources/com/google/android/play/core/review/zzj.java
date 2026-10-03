package com.google.android.play.core.review;

import android.os.Bundle;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public final class zzj {
    private static final Set zza = new HashSet(Arrays.asList("native", "unity"));
    private static final Map zzb = new HashMap();
    private static final com.google.android.play.core.review.internal.zzi zzc = new com.google.android.play.core.review.internal.zzi("PlayCoreVersion");

    public static Bundle zza() {
        Bundle bundle = new Bundle();
        Map mapZzb = zzb();
        bundle.putInt("playcore_version_code", ((Integer) mapZzb.get("java")).intValue());
        if (mapZzb.containsKey("native")) {
            bundle.putInt("playcore_native_version", ((Integer) mapZzb.get("native")).intValue());
        }
        if (mapZzb.containsKey("unity")) {
            bundle.putInt("playcore_unity_version", ((Integer) mapZzb.get("unity")).intValue());
        }
        return bundle;
    }

    public static synchronized Map zzb() {
        Map map;
        map = zzb;
        map.put("java", 11004);
        return map;
    }
}
