package com.google.android.gms.common.api.internal;

import com.google.android.gms.common.api.Api;
import java.util.ArrayList;

final class zaap extends zaav {
    final zaaw zaa;
    private final ArrayList zac;

    public zaap(zaaw zaawVar, ArrayList arrayList) {
        super(zaawVar, null);
        this.zaa = zaawVar;
        this.zac = arrayList;
    }

    @Override
    public final void zaa() {
        zaaw zaawVar = this.zaa;
        zaawVar.zaa.zag.zad = zaaw.zao(zaawVar);
        ArrayList arrayList = this.zac;
        int size = arrayList.size();
        for (int i = 0; i < size; i++) {
            Api.Client client = (Api.Client) arrayList.get(i);
            zaaw zaawVar2 = this.zaa;
            client.getRemoteService(zaawVar2.zao, zaawVar2.zaa.zag.zad);
        }
    }
}
