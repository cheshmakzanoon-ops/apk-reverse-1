package com.google.android.gms.common.api.internal;

import android.os.Bundle;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.internal.Preconditions;

final class zaat implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {
    final zaaw zaa;

    zaat(zaaw zaawVar, zaas zaasVar) {
        this.zaa = zaawVar;
    }

    @Override
    public final void onConnected(Bundle bundle) {
        ((com.google.android.gms.signin.zae) Preconditions.checkNotNull(this.zaa.zak)).zad(new zaar(this.zaa));
    }

    @Override
    public final void onConnectionFailed(ConnectionResult connectionResult) {
        this.zaa.zab.lock();
        try {
            if (this.zaa.zaI(connectionResult)) {
                this.zaa.zaA();
                this.zaa.zaF();
            } else {
                this.zaa.zaD(connectionResult);
            }
        } finally {
            this.zaa.zab.unlock();
        }
    }

    @Override
    public final void onConnectionSuspended(int i) {
    }
}
