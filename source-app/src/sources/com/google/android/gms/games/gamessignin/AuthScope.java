package com.google.android.gms.games.gamessignin;

import com.google.android.gms.common.Scopes;
import com.google.android.gms.internal.games_v2.zzhd;
import com.google.android.gms.internal.games_v2.zzhf;
import com.google.android.gms.internal.games_v2.zzhg;
import j$.util.Collection;
import j$.util.Objects;
import java.util.List;

public enum AuthScope {
    EMAIL(Scopes.EMAIL),
    PROFILE(Scopes.PROFILE),
    OPEN_ID(Scopes.OPEN_ID),
    GAMES_LITE(Scopes.GAMES_LITE),
    DRIVE_APP_FOLDER(Scopes.DRIVE_APPFOLDER);

    private static final zzhg zzd;
    private final String zzc;

    static {
        zzhf zzhfVar = new zzhf();
        for (AuthScope authScope : values()) {
            zzhfVar.zza(authScope.zzc, authScope);
        }
        zzd = zzhfVar.zzb();
    }

    AuthScope(String str) {
        this.zzc = str;
    }

    public static zzhd zza(List list) {
        Objects.requireNonNull(list, "Input scopes list cannot be null");
        return (zzhd) Collection.-EL.stream(list).map(zzb.zza).distinct().collect(zzhd.zzh());
    }

    public static zzhd zzb(List list) {
        Objects.requireNonNull(list, "Input values list cannot be null");
        return (zzhd) Collection.-EL.stream(list).map(zza.zza).collect(zzhd.zzh());
    }

    static AuthScope zzc(String str) {
        Objects.requireNonNull(str, "Input list of scope strings must not be null");
        AuthScope authScope = (AuthScope) zzd.get(str);
        if (authScope != null) {
            return authScope;
        }
        String.valueOf(str);
        throw new IllegalArgumentException("Invalid scope: ".concat(String.valueOf(str)));
    }

    public String getValue() {
        return this.zzc;
    }
}
