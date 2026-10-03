package com.google.firebase.crashlytics.internal.analytics;

import android.os.Bundle;
import com.google.firebase.crashlytics.internal.Logger;

public class UnavailableAnalyticsEventLogger implements AnalyticsEventLogger {
    @Override
    public void logEvent(String str, Bundle bundle) {
        Logger.getLogger().m336d("Skipping logging Crashlytics event to Firebase, no Firebase Analytics");
    }
}
