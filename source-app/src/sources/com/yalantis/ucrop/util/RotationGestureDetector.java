package com.yalantis.ucrop.util;

import android.view.MotionEvent;

public class RotationGestureDetector {
    private static final int INVALID_POINTER_INDEX = -1;

    private float f545fX;

    private float f546fY;
    private float mAngle;
    private boolean mIsFirstTouch;
    private OnRotationGestureListener mListener;
    private int mPointerIndex1 = -1;
    private int mPointerIndex2 = -1;

    private float f547sX;

    private float f548sY;

    public interface OnRotationGestureListener {
        boolean onRotation(RotationGestureDetector rotationGestureDetector);
    }

    public static class SimpleOnRotationGestureListener implements OnRotationGestureListener {
        @Override
        public boolean onRotation(RotationGestureDetector rotationGestureDetector) {
            return false;
        }
    }

    public RotationGestureDetector(OnRotationGestureListener onRotationGestureListener) {
        this.mListener = onRotationGestureListener;
    }

    public float getAngle() {
        return this.mAngle;
    }

    public boolean onTouchEvent(MotionEvent motionEvent) {
        int actionMasked = motionEvent.getActionMasked();
        if (actionMasked == 0) {
            this.f547sX = motionEvent.getX();
            this.f548sY = motionEvent.getY();
            this.mPointerIndex1 = motionEvent.findPointerIndex(motionEvent.getPointerId(0));
            this.mAngle = 0.0f;
            this.mIsFirstTouch = true;
        } else if (actionMasked == 1) {
            this.mPointerIndex1 = -1;
        } else if (actionMasked != 2) {
            if (actionMasked == 5) {
                this.f545fX = motionEvent.getX();
                this.f546fY = motionEvent.getY();
                this.mPointerIndex2 = motionEvent.findPointerIndex(motionEvent.getPointerId(motionEvent.getActionIndex()));
                this.mAngle = 0.0f;
                this.mIsFirstTouch = true;
            } else if (actionMasked == 6) {
                this.mPointerIndex2 = -1;
            }
        } else if (this.mPointerIndex1 != -1 && this.mPointerIndex2 != -1 && motionEvent.getPointerCount() > this.mPointerIndex2) {
            float x = motionEvent.getX(this.mPointerIndex1);
            float y = motionEvent.getY(this.mPointerIndex1);
            float x2 = motionEvent.getX(this.mPointerIndex2);
            float y2 = motionEvent.getY(this.mPointerIndex2);
            if (this.mIsFirstTouch) {
                this.mAngle = 0.0f;
                this.mIsFirstTouch = false;
            } else {
                calculateAngleBetweenLines(this.f545fX, this.f546fY, this.f547sX, this.f548sY, x2, y2, x, y);
            }
            OnRotationGestureListener onRotationGestureListener = this.mListener;
            if (onRotationGestureListener != null) {
                onRotationGestureListener.onRotation(this);
            }
            this.f545fX = x2;
            this.f546fY = y2;
            this.f547sX = x;
            this.f548sY = y;
        }
        return true;
    }

    private float calculateAngleBetweenLines(float f, float f2, float f3, float f4, float f5, float f6, float f7, float f8) {
        return calculateAngleDelta((float) Math.toDegrees((float) Math.atan2(f2 - f4, f - f3)), (float) Math.toDegrees((float) Math.atan2(f6 - f8, f5 - f7)));
    }

    private float calculateAngleDelta(float f, float f2) {
        float f3 = (f2 % 360.0f) - (f % 360.0f);
        this.mAngle = f3;
        if (f3 < -180.0f) {
            this.mAngle = f3 + 360.0f;
        } else if (f3 > 180.0f) {
            this.mAngle = f3 - 360.0f;
        }
        return this.mAngle;
    }
}
