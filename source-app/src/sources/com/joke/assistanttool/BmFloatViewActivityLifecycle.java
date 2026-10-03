package com.joke.assistanttool;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

public class BmFloatViewActivityLifecycle implements Application.ActivityLifecycleCallbacks {
    private Activity activity;
    private BmFloatView floatView;

    public BmFloatViewActivityLifecycle(Activity activity, BmFloatView floatView) {
        this.activity = activity;
        this.floatView = floatView;
    }

    public void register() {
        if (this.activity == null) {
            return;
        }
        this.activity.getApplication().registerActivityLifecycleCallbacks(this);
    }

    public void unregister() {
        if (this.activity == null) {
            return;
        }
        this.activity.getApplication().unregisterActivityLifecycleCallbacks(this);
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
    }

    @Override
    public void onActivityStarted(Activity activity) {
    }

    @Override
    public void onActivityResumed(Activity activity) {
    }

    @Override
    public void onActivityPaused(Activity activity) {
        if (this.activity != activity || !activity.isFinishing() || this.floatView == null || !this.floatView.isShowing()) {
            return;
        }
        this.floatView.cancel();
    }

    @Override
    public void onActivityStopped(Activity activity) {
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
        if (this.activity != activity) {
            return;
        }
        this.activity = null;
        if (this.floatView == null) {
            return;
        }
        this.floatView.recycle();
        this.floatView = null;
    }
}
