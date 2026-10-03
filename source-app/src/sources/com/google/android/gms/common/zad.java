package com.google.android.gms.common;

import android.content.Context;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import com.google.android.gms.internal.base.zau;

final class zad extends zau {
    final GoogleApiAvailability zaa;
    private final Context zab;

    public zad(GoogleApiAvailability googleApiAvailability, Context context) {
        super(Looper.myLooper() == null ? Looper.getMainLooper() : Looper.myLooper());
        this.zaa = googleApiAvailability;
        this.zab = context.getApplicationContext();
    }

    @Override
    public final void handleMessage(Message message) {
        if (message.what != 1) {
            Log.w("GoogleApiAvailability", "Don't know how to handle this message: " + message.what);
            return;
        }
        GoogleApiAvailability googleApiAvailability = this.zaa;
        int iIsGooglePlayServicesAvailable = googleApiAvailability.isGooglePlayServicesAvailable(this.zab);
        if (googleApiAvailability.isUserResolvableError(iIsGooglePlayServicesAvailable)) {
            this.zaa.showErrorNotification(this.zab, iIsGooglePlayServicesAvailable);
        }
    }
}
