package com.google.android.gms.common.api.internal;

final class zabl implements BackgroundDetector.BackgroundStateChangeListener {
    final GoogleApiManager zaa;

    zabl(GoogleApiManager googleApiManager) {
        this.zaa = googleApiManager;
    }

    @Override
    public final void onBackgroundStateChanged(boolean z) {
        GoogleApiManager googleApiManager = this.zaa;
        googleApiManager.zar.sendMessage(googleApiManager.zar.obtainMessage(1, Boolean.valueOf(z)));
    }
}
