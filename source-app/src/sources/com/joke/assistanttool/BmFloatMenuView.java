package com.joke.assistanttool;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.DisplayMetrics;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import com.joke.connectdevice.utils.DraggableUtils;

public class BmFloatMenuView implements BmFloatView {
    private final BmFloatMenuLayout contentView;
    private final Context context;
    private final LinearLayout floatLogoView;
    private final BmFloatViewActivityLifecycle lifecycle;
    private final SharedPreferences preferences;
    private final int screenHeight;
    private final int screenWidth;
    private boolean showing;
    private final boolean verticalScreen;
    private final WindowManager windowManager;
    private final WindowManager.LayoutParams windowParams;

    public BmFloatMenuView(Activity activity) {
        this.context = activity;
        this.windowManager = activity.getWindowManager();
        this.preferences = activity.getSharedPreferences("bmFloatMenu", 0);
        this.lifecycle = new BmFloatViewActivityLifecycle(activity, this);
        DisplayMetrics metrics = new DisplayMetrics();
        this.windowManager.getDefaultDisplay().getMetrics(metrics);
        this.screenWidth = metrics.widthPixels;
        this.screenHeight = metrics.heightPixels;
        this.verticalScreen = this.screenHeight >= this.screenWidth;
        this.windowParams = new WindowManager.LayoutParams();
        this.windowParams.height = -2;
        this.windowParams.width = -2;
        this.windowParams.format = -3;
        this.windowParams.packageName = activity.getPackageName();
        this.windowParams.flags = 40;
        this.windowParams.gravity = 8388659;
        this.windowParams.x = this.preferences.getInt("float_x_" + this.verticalScreen, 0);
        this.windowParams.y = this.preferences.getInt("float_y_" + this.verticalScreen, this.screenHeight / 5);
        this.contentView = new BmFloatMenuLayout(activity);
        this.floatLogoView = this.contentView.getLogoView();
        DraggableUtils draggableUtils = new DraggableUtils();
        draggableUtils.setDraggable(this.contentView, this.windowManager, this.windowParams, new DraggableUtils.DraggableListener() {
            @Override
            public void onPositionChanged(View v) {
            }

            @Override
            public void onTouchListener(MotionEvent event) {
                if (event.getAction() == 1 || event.getAction() == 3) {
                    BmFloatMenuView.this.moveToSide();
                }
            }
        });
    }

    public void show() {
        if (this.showing) {
            update();
            return;
        }
        Context context = this.context;
        if (context instanceof Activity) {
            Activity activity = (Activity) context;
            if (activity.isFinishing() || activity.isDestroyed()) {
                return;
            }
        }
        try {
            if (this.contentView.getParent() != null) {
                this.windowManager.removeViewImmediate(this.contentView);
            }
            this.windowManager.addView(this.contentView, this.windowParams);
            this.showing = true;
            this.lifecycle.register();
        } catch (RuntimeException e) {
        }
    }

    public void update() {
        if (!this.showing) {
            return;
        }
        this.windowManager.updateViewLayout(this.contentView, this.windowParams);
    }

    @Override
    public boolean isShowing() {
        return this.showing;
    }

    @Override
    public void cancel() {
        if (!this.showing) {
            return;
        }
        try {
            this.lifecycle.unregister();
            this.windowManager.removeViewImmediate(this.contentView);
        } catch (RuntimeException e) {
        } finally {
            this.showing = false;
        }
    }

    @Override
    public void recycle() {
        if (this.showing) {
            cancel();
        }
    }

    public void moveToSide() {
        if (this.windowParams.x > this.screenWidth / 2) {
            int marginX = this.floatLogoView != null ? this.floatLogoView.getMeasuredWidth() / 2 : 10;
            this.windowParams.x = this.screenWidth - marginX;
        } else {
            this.windowParams.x = 0;
        }
        this.preferences.edit().putInt("float_x_" + this.verticalScreen, this.windowParams.x).putInt("float_y_" + this.verticalScreen, this.windowParams.y).apply();
        update();
    }
}
