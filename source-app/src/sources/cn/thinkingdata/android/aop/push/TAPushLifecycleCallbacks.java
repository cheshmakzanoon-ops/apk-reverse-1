package cn.thinkingdata.android.aop.push;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

public class TAPushLifecycleCallbacks implements Application.ActivityLifecycleCallbacks {
    private static final String TAG = "ThinkingAnalytics.TAPushLifecycle";

    @Override
    public void onActivityCreated(Activity activity, Bundle bundle) {
        TAPushProcess.getInstance().onNotificationClick(activity, activity.getIntent());
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
    }

    @Override
    public void onActivityPaused(Activity activity) {
    }

    @Override
    public void onActivityResumed(Activity activity) {
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
    }

    @Override
    public void onActivityStarted(Activity activity) {
        TAPushProcess.getInstance().onNotificationClick(activity, activity.getIntent());
    }

    @Override
    public void onActivityStopped(Activity activity) {
    }
}
