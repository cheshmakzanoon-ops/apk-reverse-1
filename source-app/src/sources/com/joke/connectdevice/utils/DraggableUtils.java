package com.joke.connectdevice.utils;

import android.content.res.Resources;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import com.joke.plugin.bmJiasu.JiaSuModeConfig;

public class DraggableUtils {

    public interface DraggableListener {
        void onPositionChanged(View view);

        void onTouchListener(MotionEvent motionEvent);
    }

    public void setDraggable(final View parentView, final WindowManager windowManager, final WindowManager.LayoutParams windowParams, final DraggableListener draggableListener) {
        parentView.setOnTouchListener(new View.OnTouchListener(this) {
            private float downRawX;
            private float downRawY;
            private boolean moved;
            final DraggableUtils this$0;

            {
                this.this$0 = this;
            }

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (draggableListener != null) {
                    draggableListener.onTouchListener(event);
                }
                switch (event.getAction()) {
                    case 0:
                        this.downRawX = event.getRawX();
                        this.downRawY = event.getRawY();
                        this.moved = false;
                        return false;
                    case JiaSuModeConfig.MODE_CORE1:
                    case 3:
                        return this.moved;
                    case 2:
                        float moveX = event.getRawX() - this.downRawX;
                        float moveY = event.getRawY() - this.downRawY;
                        this.downRawX = event.getRawX();
                        this.downRawY = event.getRawY();
                        windowParams.x += (int) moveX;
                        windowParams.y += (int) moveY;
                        windowParams.gravity = 8388659;
                        windowManager.updateViewLayout(parentView, windowParams);
                        this.moved = this.moved || this.this$0.isTouchMove(moveX, moveY);
                        if (draggableListener != null) {
                            draggableListener.onPositionChanged(v);
                        }
                        return false;
                    default:
                        return false;
                }
            }
        });
    }

    public boolean isTouchMove(float deltaX, float deltaY) {
        float minTouchSlop = TypedValue.applyDimension(1, 1.0f, Resources.getSystem().getDisplayMetrics());
        return Math.abs(deltaX) >= minTouchSlop || Math.abs(deltaY) >= minTouchSlop;
    }
}
