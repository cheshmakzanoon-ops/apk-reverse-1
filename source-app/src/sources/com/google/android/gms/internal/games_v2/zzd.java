package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.Scopes;
import com.google.android.gms.common.api.Scope;
import java.util.List;

final class zzd extends zze {
    zzd() {
        super(null);
    }

    @Override
    public final List getImpliedScopes(Object obj) {
        return zzhd.zzj(new Scope(Scopes.GAMES));
    }
}
