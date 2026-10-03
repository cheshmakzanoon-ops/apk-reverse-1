package com.joke.speedfloatingball;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import com.joke.assistanttool.BmFloatMenuView;
import com.joke.assistanttool.utils.BmParentUILoad;
import com.joke.connectdevice.utils.ActivityRegistry;

public final class JokeInit {
    private static final JokeInit INSTANCE = new JokeInit();
    private BmFloatMenuView existingView;
    private boolean initialized;

    public static JokeInit getSingleton() {
        return INSTANCE;
    }

    public synchronized void initRegister(Application application) {
        if (this.initialized) {
            return;
        }
        this.initialized = true;
        application.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            }

            @Override
            public void onActivityStarted(Activity activity) {
            }

            @Override
            public void onActivityResumed(Activity activity) {
                BmParentUILoad.addActivity(activity);
                BmParentUILoad.initContent(activity.getBaseContext());
                if (JokeInit.this.existingView != null) {
                    JokeInit.this.existingView.recycle();
                }
                JokeInit.this.existingView = new BmFloatMenuView(activity);
                JokeInit.this.existingView.show();
            }

            @Override
            public void onActivityPaused(Activity activity) {
                BmParentUILoad.remoreActivity(activity);
                if (JokeInit.this.existingView != null) {
                    JokeInit.this.existingView.recycle();
                    JokeInit.this.existingView = null;
                }
            }

            @Override
            public void onActivityStopped(Activity activity) {
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
            }

            @Override
            public void onActivityDestroyed(Activity activity) {
            }
        });
    }

    public void initRegister(Application application, String ignored) {
        initRegister(application);
    }

    public Activity getActivity() {
        return ActivityRegistry.getInstance().getActivity();
    }
}
