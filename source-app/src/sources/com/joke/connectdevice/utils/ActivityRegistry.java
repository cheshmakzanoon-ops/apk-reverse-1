package com.joke.connectdevice.utils;

import android.app.Activity;
import java.util.ArrayList;
import java.util.List;

public class ActivityRegistry {
    private static final ActivityRegistry INSTANCE = new ActivityRegistry();
    private final List<Activity> activities = new ArrayList();

    public static ActivityRegistry getInstance() {
        return INSTANCE;
    }

    public void addActivity(Activity activity) {
        if (!this.activities.contains(activity)) {
            this.activities.add(activity);
        }
    }

    public void remoreActivity(Activity activity) {
        this.activities.remove(activity);
    }

    public Activity getActivity() {
        for (int i = this.activities.size() - 1; i >= 0; i--) {
            Activity activity = this.activities.get(i);
            if (activity != null && !activity.isFinishing() && !activity.isDestroyed()) {
                return activity;
            }
        }
        return null;
    }

    public void finish() {
        for (Activity activity : new ArrayList(this.activities)) {
            if (activity != null && !activity.isFinishing()) {
                activity.finish();
            }
        }
        this.activities.clear();
    }
}
