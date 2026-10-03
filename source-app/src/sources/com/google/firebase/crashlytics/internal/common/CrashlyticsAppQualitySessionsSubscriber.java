package com.google.firebase.crashlytics.internal.common;

import com.google.firebase.crashlytics.internal.Logger;
import com.google.firebase.sessions.api.SessionSubscriber;

public class CrashlyticsAppQualitySessionsSubscriber implements SessionSubscriber {
    private String appQualitySessionId = null;
    private final DataCollectionArbiter dataCollectionArbiter;

    public CrashlyticsAppQualitySessionsSubscriber(DataCollectionArbiter dataCollectionArbiter) {
        this.dataCollectionArbiter = dataCollectionArbiter;
    }

    public String getAppQualitySessionId() {
        return this.appQualitySessionId;
    }

    @Override
    public void onSessionChanged(SessionSubscriber.SessionDetails sessionDetails) {
        Logger.getLogger().m336d("App Quality Sessions session changed: " + sessionDetails);
        this.appQualitySessionId = sessionDetails.getSessionId();
    }

    @Override
    public boolean isDataCollectionEnabled() {
        return this.dataCollectionArbiter.isAutomaticDataCollectionEnabled();
    }

    @Override
    public SessionSubscriber.Name getSessionSubscriberName() {
        return SessionSubscriber.Name.CRASHLYTICS;
    }
}
