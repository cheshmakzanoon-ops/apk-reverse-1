package net.aihelp.core.p004ui.loading.indicator;

import android.animation.ValueAnimator;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.View;

public class BallSpinFadeLoaderIndicator {
    public static final int ALPHA = 255;
    public static final float SCALE = 1.0f;
    private View mTarget;
    float[] scaleFloats = {1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f};
    int[] alphas = {255, 255, 255, 255, 255, 255, 255, 255};

    public void setTarget(View view) {
        this.mTarget = view;
    }

    public View getTarget() {
        return this.mTarget;
    }

    public int getWidth() {
        View view = this.mTarget;
        if (view != null) {
            return view.getWidth();
        }
        return 0;
    }

    public int getHeight() {
        View view = this.mTarget;
        if (view != null) {
            return view.getHeight();
        }
        return 0;
    }

    public void postInvalidate() {
        View view = this.mTarget;
        if (view != null) {
            view.postInvalidate();
        }
    }

    public void draw(Canvas canvas, Paint paint) {
        float width = getWidth() / 10.0f;
        for (int i = 0; i < 8; i++) {
            canvas.save();
            Point pointCircleAt = circleAt(getWidth(), getHeight(), (getWidth() / 2.0f) - width, 0.7853981633974483d * ((double) i));
            canvas.translate(pointCircleAt.f96x, pointCircleAt.f97y);
            float f = this.scaleFloats[i];
            canvas.scale(f, f);
            paint.setAlpha(this.alphas[i]);
            canvas.drawCircle(0.0f, 0.0f, width, paint);
            canvas.restore();
        }
    }

    Point circleAt(int i, int i2, float f, double d) {
        double d2 = f;
        return new Point((float) (((double) (i / 2)) + (Math.cos(d) * d2)), (float) (((double) (i2 / 2)) + (d2 * Math.sin(d))));
    }

    public void createAnimation() {
        int[] iArr = {0, 120, 240, 360, 480, 600, 720, 780, 840};
        for (final int i = 0; i < 8; i++) {
            ValueAnimator valueAnimatorOfFloat = ValueAnimator.ofFloat(1.0f, 0.4f, 1.0f);
            valueAnimatorOfFloat.setDuration(1000L);
            valueAnimatorOfFloat.setRepeatCount(-1);
            valueAnimatorOfFloat.setStartDelay(iArr[i]);
            valueAnimatorOfFloat.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    BallSpinFadeLoaderIndicator.this.scaleFloats[i] = ((Float) valueAnimator.getAnimatedValue()).floatValue();
                    BallSpinFadeLoaderIndicator.this.postInvalidate();
                }
            });
            valueAnimatorOfFloat.start();
            ValueAnimator valueAnimatorOfInt = ValueAnimator.ofInt(255, 77, 255);
            valueAnimatorOfInt.setDuration(1000L);
            valueAnimatorOfInt.setRepeatCount(-1);
            valueAnimatorOfInt.setStartDelay(iArr[i]);
            valueAnimatorOfInt.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                @Override
                public void onAnimationUpdate(ValueAnimator valueAnimator) {
                    BallSpinFadeLoaderIndicator.this.alphas[i] = ((Integer) valueAnimator.getAnimatedValue()).intValue();
                    BallSpinFadeLoaderIndicator.this.postInvalidate();
                }
            });
            valueAnimatorOfInt.start();
        }
    }

    private static final class Point {

        private float f96x;

        private float f97y;

        private Point(float f, float f2) {
            this.f96x = f;
            this.f97y = f2;
        }
    }
}
