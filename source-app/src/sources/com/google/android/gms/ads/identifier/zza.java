package com.google.android.gms.ads.identifier;

import android.net.Uri;
import java.util.Map;

final class zza extends Thread {
    final Map zza;

    zza(AdvertisingIdClient advertisingIdClient, Map map) {
        this.zza = map;
    }

    @Override
    public final void run() {
        Map map = this.zza;
        Uri.Builder builderBuildUpon = Uri.parse("https://pagead2.googlesyndication.com/pagead/gen_204?id=gmob-apps").buildUpon();
        for (String str : map.keySet()) {
            builderBuildUpon.appendQueryParameter(str, (String) map.get(str));
        }
        zzc.zza(builderBuildUpon.build().toString());
    }
}
