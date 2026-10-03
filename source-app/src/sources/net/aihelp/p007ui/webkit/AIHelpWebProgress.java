package net.aihelp.p007ui.webkit;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Shader;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.LinearInterpolator;
import android.widget.FrameLayout;
import net.aihelp.common.CustomConfig;
import net.aihelp.utils.Styles;

public class AIHelpWebProgress extends FrameLayout {
    private static int CURRENT_MAX_DECELERATE_SPEED_DURATION = 450;
    private static int CURRENT_MAX_UNIFORM_SPEED_DURATION = 8000;
    public static final int DO_END_ALPHA_DURATION = 630;
    public static final int DO_END_PROGRESS_DURATION = 500;
    public static final int FINISH = 2;
    public static final int MAX_DECELERATE_SPEED_DURATION = 450;
    public static final int MAX_UNIFORM_SPEED_DURATION = 8000;
    public static final int STARTED = 1;
    public static final int UN_START = 0;
    public static String WEB_PROGRESS_COLOR = "#2483D9";
    public static int WEB_PROGRESS_DEFAULT_HEIGHT = 3;
    private int TAG;
    private boolean isShow;
    private Animator mAnimator;
    private AnimatorListenerAdapter mAnimatorListenerAdapter;
    private ValueAnimator.AnimatorUpdateListener mAnimatorUpdateListener;
    private int mColor;
    private float mCurrentProgress;
    private Paint mPaint;
    private int mTargetHeight;
    private int mTargetWidth;

    @Override
    protected void onDraw(Canvas canvas) {
    }

    public AIHelpWebProgress(Context context) {
        this(context, null);
    }

    public AIHelpWebProgress(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpWebProgress(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.mTargetWidth = 0;
        this.TAG = 0;
        this.isShow = false;
        this.mCurrentProgress = 0.0f;
        this.mAnimatorUpdateListener = new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator valueAnimator) {
                AIHelpWebProgress.this.mCurrentProgress = ((Float) valueAnimator.getAnimatedValue()).floatValue();
                AIHelpWebProgress.this.invalidate();
            }
        };
        this.mAnimatorListenerAdapter = new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animator) {
                AIHelpWebProgress.this.doEnd();
            }
        };
        init(context, attributeSet, i);
    }

    private void init(Context context, AttributeSet attributeSet, int i) {
        this.mPaint = new Paint();
        this.mColor = Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor);
        this.mPaint.setAntiAlias(true);
        this.mPaint.setColor(this.mColor);
        this.mPaint.setDither(true);
        this.mPaint.setStrokeCap(Paint.Cap.SQUARE);
        this.mTargetWidth = Styles.getScreenWidth(context);
        this.mTargetHeight = dip2px(WEB_PROGRESS_DEFAULT_HEIGHT);
    }

    public void setColor(int i) {
        this.mColor = i;
        this.mPaint.setColor(i);
    }

    public void setColor(String str) {
        setColor(Color.parseColor(str));
    }

    public void setColor(int i, int i2) {
        this.mPaint.setShader(new LinearGradient(0.0f, 0.0f, this.mTargetWidth, this.mTargetHeight, i, i2, Shader.TileMode.CLAMP));
    }

    public void setColor(String str, String str2) {
        setColor(Color.parseColor(str), Color.parseColor(str2));
    }

    @Override
    protected void onMeasure(int i, int i2) {
        int mode = View.MeasureSpec.getMode(i);
        int size = View.MeasureSpec.getSize(i);
        int mode2 = View.MeasureSpec.getMode(i2);
        int size2 = View.MeasureSpec.getSize(i2);
        if (mode == Integer.MIN_VALUE) {
            size = Math.min(size, Styles.getScreenWidth(getContext()));
        }
        if (mode2 == Integer.MIN_VALUE) {
            size2 = this.mTargetHeight;
        }
        setMeasuredDimension(size, size2);
    }

    @Override
    protected void dispatchDraw(Canvas canvas) {
        if (Styles.isLayoutRtl(this)) {
            canvas.translate(getWidth(), 0.0f);
            canvas.scale(-1.0f, 1.0f);
        }
        float f = this.mCurrentProgress / 100.0f;
        float width = getWidth();
        Float.valueOf(width).getClass();
        canvas.drawRect(0.0f, 0.0f, f * width, getHeight(), this.mPaint);
    }

    @Override
    protected void onSizeChanged(int i, int i2, int i3, int i4) {
        super.onSizeChanged(i, i2, i3, i4);
        this.mTargetWidth = getMeasuredWidth();
        int screenWidth = Styles.getScreenWidth(getContext());
        int i5 = this.mTargetWidth;
        if (i5 >= screenWidth) {
            CURRENT_MAX_DECELERATE_SPEED_DURATION = MAX_DECELERATE_SPEED_DURATION;
            CURRENT_MAX_UNIFORM_SPEED_DURATION = MAX_UNIFORM_SPEED_DURATION;
        } else {
            float f = i5 / screenWidth;
            CURRENT_MAX_UNIFORM_SPEED_DURATION = (int) (8000.0f * f);
            CURRENT_MAX_DECELERATE_SPEED_DURATION = (int) (f * 450.0f);
        }
    }

    private void setFinish() {
        this.isShow = false;
        this.TAG = 2;
    }

    private void startAnim(boolean z) {
        ValueAnimator valueAnimatorOfFloat;
        float f = z ? 100.0f : 95.0f;
        Animator animator = this.mAnimator;
        if (animator != null && animator.isStarted()) {
            this.mAnimator.cancel();
        }
        float f2 = this.mCurrentProgress;
        if (f2 == 0.0f) {
            f2 = 1.0E-8f;
        }
        this.mCurrentProgress = f2;
        if (!z) {
            ValueAnimator valueAnimatorOfFloat2 = ValueAnimator.ofFloat(f2, f);
            float f3 = (1.0f - (this.mCurrentProgress / 100.0f)) - 0.05f;
            valueAnimatorOfFloat2.setInterpolator(new LinearInterpolator());
            valueAnimatorOfFloat2.setDuration((long) (f3 * CURRENT_MAX_UNIFORM_SPEED_DURATION));
            valueAnimatorOfFloat2.addUpdateListener(this.mAnimatorUpdateListener);
            valueAnimatorOfFloat2.start();
            this.mAnimator = valueAnimatorOfFloat2;
        } else {
            if (f2 < 95.0f) {
                valueAnimatorOfFloat = ValueAnimator.ofFloat(f2, 95.0f);
                float f4 = (1.0f - (this.mCurrentProgress / 100.0f)) - 0.05f;
                valueAnimatorOfFloat.setInterpolator(new LinearInterpolator());
                valueAnimatorOfFloat.setDuration((long) (f4 * CURRENT_MAX_DECELERATE_SPEED_DURATION));
                valueAnimatorOfFloat.setInterpolator(new DecelerateInterpolator());
                valueAnimatorOfFloat.addUpdateListener(this.mAnimatorUpdateListener);
            } else {
                valueAnimatorOfFloat = null;
            }
            ObjectAnimator objectAnimatorOfFloat = ObjectAnimator.ofFloat(this, "alpha", 1.0f, 0.0f);
            objectAnimatorOfFloat.setDuration(630L);
            ValueAnimator valueAnimatorOfFloat3 = ValueAnimator.ofFloat(95.0f, 100.0f);
            valueAnimatorOfFloat3.setDuration(500L);
            valueAnimatorOfFloat3.addUpdateListener(this.mAnimatorUpdateListener);
            AnimatorSet animatorSet = new AnimatorSet();
            animatorSet.playTogether(objectAnimatorOfFloat, valueAnimatorOfFloat3);
            if (valueAnimatorOfFloat != null) {
                AnimatorSet animatorSet2 = new AnimatorSet();
                animatorSet2.play(animatorSet).after(valueAnimatorOfFloat);
                animatorSet = animatorSet2;
            }
            animatorSet.addListener(this.mAnimatorListenerAdapter);
            animatorSet.start();
            this.mAnimator = animatorSet;
        }
        this.TAG = 1;
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        Animator animator = this.mAnimator;
        if (animator == null || !animator.isStarted()) {
            return;
        }
        this.mAnimator.cancel();
        this.mAnimator = null;
    }

    public void doEnd() {
        if (this.TAG == 2 && this.mCurrentProgress == 100.0f) {
            setVisibility(8);
            this.mCurrentProgress = 0.0f;
            setAlpha(1.0f);
        }
        this.TAG = 0;
    }

    public void reset() {
        this.mCurrentProgress = 0.0f;
        Animator animator = this.mAnimator;
        if (animator == null || !animator.isStarted()) {
            return;
        }
        this.mAnimator.cancel();
    }

    public void setProgress(int i) {
        float f = i;
        Float.valueOf(f).getClass();
        setProgress(f);
    }

    public FrameLayout.LayoutParams offerLayoutParams() {
        return new FrameLayout.LayoutParams(this.mTargetWidth, this.mTargetHeight);
    }

    private int dip2px(float f) {
        return (int) ((f * getContext().getResources().getDisplayMetrics().density) + 0.5f);
    }

    public void setProgress(float f) {
        if (this.TAG == 0 && f == 100.0f) {
            setVisibility(8);
            return;
        }
        if (getVisibility() == 8) {
            setVisibility(0);
        }
        if (f >= 95.0f && this.TAG != 2) {
            startAnim(true);
        }
    }

    public void show() {
        this.isShow = true;
        setVisibility(0);
        this.mCurrentProgress = 0.0f;
        startAnim(false);
    }

    public void hide() {
        setWebProgress(100);
    }

    public void setWebProgress(int i) {
        if (i >= 0 && i < 95) {
            if (!this.isShow) {
                show();
                return;
            } else {
                setProgress(i);
                return;
            }
        }
        setProgress(i);
        setFinish();
    }
}
