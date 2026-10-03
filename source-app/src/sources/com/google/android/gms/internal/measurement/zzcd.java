package com.google.android.gms.internal.measurement;

import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;

public abstract class zzcd {
    private static zzcd zza = new zzcg();

    public static synchronized zzcd zza() {
        return zza;
    }

    public abstract URLConnection zza(URL url, String str) throws IOException;
}
