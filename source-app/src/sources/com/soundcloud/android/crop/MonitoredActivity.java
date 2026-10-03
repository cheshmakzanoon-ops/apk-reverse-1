package com.soundcloud.android.crop;

import android.app.Activity;
import android.os.Bundle;
import java.util.ArrayList;
import java.util.Iterator;

abstract class MonitoredActivity extends Activity {
    private final ArrayList<LifeCycleListener> listeners = new ArrayList<>();

    public static class LifeCycleAdapter implements LifeCycleListener {
        @Override
        public void onActivityCreated(MonitoredActivity monitoredActivity) {
        }

        @Override
        public void onActivityDestroyed(MonitoredActivity monitoredActivity) {
        }

        @Override
        public void onActivityStarted(MonitoredActivity monitoredActivity) {
        }

        @Override
        public void onActivityStopped(MonitoredActivity monitoredActivity) {
        }
    }

    public interface LifeCycleListener {
        void onActivityCreated(MonitoredActivity monitoredActivity);

        void onActivityDestroyed(MonitoredActivity monitoredActivity);

        void onActivityStarted(MonitoredActivity monitoredActivity);

        void onActivityStopped(MonitoredActivity monitoredActivity);
    }

    MonitoredActivity() {
    }

    public void addLifeCycleListener(LifeCycleListener lifeCycleListener) {
        if (this.listeners.contains(lifeCycleListener)) {
            return;
        }
        this.listeners.add(lifeCycleListener);
    }

    public void removeLifeCycleListener(LifeCycleListener lifeCycleListener) {
        this.listeners.remove(lifeCycleListener);
    }

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        Iterator<LifeCycleListener> it = this.listeners.iterator();
        while (it.hasNext()) {
            it.next().onActivityCreated(this);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Iterator<LifeCycleListener> it = this.listeners.iterator();
        while (it.hasNext()) {
            it.next().onActivityDestroyed(this);
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        Iterator<LifeCycleListener> it = this.listeners.iterator();
        while (it.hasNext()) {
            it.next().onActivityStarted(this);
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        Iterator<LifeCycleListener> it = this.listeners.iterator();
        while (it.hasNext()) {
            it.next().onActivityStopped(this);
        }
    }
}
