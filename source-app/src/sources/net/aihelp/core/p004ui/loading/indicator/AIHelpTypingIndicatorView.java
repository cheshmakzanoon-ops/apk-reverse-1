package net.aihelp.core.p004ui.loading.indicator;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ValueAnimator;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.LinearInterpolator;
import android.widget.LinearLayout;
import java.util.Iterator;
import net.aihelp.common.CustomConfig;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AIHelpTypingIndicatorView extends LinearLayout {
    private static final int ALPHA_DARK = 179;
    private static final int ALPHA_LIGHT = 76;
    private final long ANIMATION_DURATION;
    private final long LOOP_START_DELAY;
    AnimatorSet dotAnimatorSet;
    Animator[] dotAnimators;
    private float dotDiameter;
    private DotView[] dots;
    private int interDotPadding;
    private int lightDotColor;

    public AIHelpTypingIndicatorView(Context context) {
        this(context, null);
    }

    public AIHelpTypingIndicatorView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpTypingIndicatorView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.ANIMATION_DURATION = 900L;
        this.LOOP_START_DELAY = 450L;
        this.dotAnimators = new Animator[3];
        initAttributes(context, attributeSet);
        setup();
    }

    private void initAttributes(Context context, AttributeSet attributeSet) {
        int[] styleable = ResResolver.getStyleable("aihelp_indicator_view");
        if (styleable != null) {
            TypedArray typedArrayObtainStyledAttributes = getContext().obtainStyledAttributes(attributeSet, styleable);
            int color = typedArrayObtainStyledAttributes.getColor(ResResolver.getStyleableFieldIndex("aihelp_indicator_view", "aihelp_dot_color"), Styles.getColor(CustomConfig.CommonSetting.textColor));
            this.lightDotColor = Color.argb(76, Color.red(color), Color.green(color), Color.blue(color));
            this.interDotPadding = typedArrayObtainStyledAttributes.getDimensionPixelSize(ResResolver.getStyleableFieldIndex("aihelp_indicator_view", "aihelp_dot_padding"), Styles.dpToPx(context, 8.0f));
            this.dotDiameter = typedArrayObtainStyledAttributes.getDimensionPixelSize(ResResolver.getStyleableFieldIndex("aihelp_indicator_view", "aihelp_dot_diameter"), Styles.dpToPx(context, 5.0f));
            typedArrayObtainStyledAttributes.recycle();
        }
    }

    @Override
    protected void onWindowVisibilityChanged(int i) {
        super.onWindowVisibilityChanged(i);
        if (i == 0) {
            startTypingAnimation();
        } else {
            stopTypingAnimation();
        }
    }

    private void startTypingAnimation() {
        if (this.dotAnimatorSet == null) {
            AnimatorSet animatorSet = new AnimatorSet();
            this.dotAnimatorSet = animatorSet;
            animatorSet.playTogether(this.dotAnimators);
            this.dotAnimatorSet.addListener(new Animator.AnimatorListener() {
                @Override
                public void onAnimationCancel(Animator animator) {
                }

                @Override
                public void onAnimationRepeat(Animator animator) {
                }

                @Override
                public void onAnimationStart(Animator animator) {
                }

                @Override
                public void onAnimationEnd(Animator animator) {
                    animator.setStartDelay(AIHelpTypingIndicatorView.this.LOOP_START_DELAY);
                    animator.start();
                }
            });
            this.dotAnimatorSet.start();
        }
    }

    private void stopTypingAnimation() {
        AnimatorSet animatorSet = this.dotAnimatorSet;
        if (animatorSet != null) {
            Iterator<Animator> it = animatorSet.getChildAnimations().iterator();
            while (it.hasNext()) {
                it.next().cancel();
            }
            this.dotAnimatorSet.cancel();
            this.dotAnimatorSet.removeAllListeners();
            this.dotAnimatorSet = null;
            for (DotView dotView : this.dots) {
                dotView.setDotColor(this.lightDotColor);
            }
        }
    }

    private void setup() {
        removeAllViews();
        this.dots = new DotView[3];
        for (int i = 0; i < 3; i++) {
            this.dots[i] = new DotView(getContext(), this.lightDotColor);
            int i2 = this.interDotPadding;
            float f = i2 / 2.0f;
            float f2 = i2 / 2.0f;
            long j = 0;
            if (i == 0) {
                f = 0.0f;
            } else if (i == 1) {
                j = this.LOOP_START_DELAY / 2;
            } else if (i == 2) {
                j = this.LOOP_START_DELAY;
                f2 = 0.0f;
            }
            float f3 = this.dotDiameter;
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams((int) f3, (int) f3);
            layoutParams.setMargins((int) f, 0, (int) f2, 0);
            addView(this.dots[i], layoutParams);
            this.dotAnimators[i] = getAnimator(j, this.dots[i]);
        }
    }

    public ValueAnimator getAnimator(long j, ValueAnimator.AnimatorUpdateListener animatorUpdateListener) {
        ValueAnimator valueAnimatorOfInt = ValueAnimator.ofInt(76, ALPHA_DARK, 76);
        valueAnimatorOfInt.setStartDelay(j);
        valueAnimatorOfInt.setDuration(this.ANIMATION_DURATION);
        valueAnimatorOfInt.setInterpolator(new LinearInterpolator());
        valueAnimatorOfInt.addUpdateListener(animatorUpdateListener);
        return valueAnimatorOfInt;
    }

    public static class DotView extends View implements ValueAnimator.AnimatorUpdateListener {
        private float centerX;
        private float centerY;
        private int dotColor;
        private RectF ovalRectF;
        private Paint paint;
        private float radius;

        public DotView(Context context, int i) {
            super(context);
            this.centerX = -1.0f;
            this.centerY = -1.0f;
            this.dotColor = i;
            setup();
        }

        public DotView(Context context, AttributeSet attributeSet) {
            this(context, attributeSet, 0);
        }

        public DotView(Context context, AttributeSet attributeSet, int i) {
            super(context, attributeSet, i);
            this.centerX = -1.0f;
            this.centerY = -1.0f;
        }

        public void setDotColor(int i) {
            this.dotColor = i;
            invalidate();
        }

        @Override
        protected void onDraw(Canvas canvas) {
            canvas.drawOval(this.ovalRectF, this.paint);
        }

        @Override
        protected void onLayout(boolean z, int i, int i2, int i3, int i4) {
            super.onLayout(z, i, i2, i3, i4);
            this.centerX = getWidth() / 2;
            float height = getHeight() / 2;
            this.centerY = height;
            this.radius = Math.min(this.centerX, height);
            updateOvalRectF();
        }

        private void updateOvalRectF() {
            this.ovalRectF.left = this.centerX - this.radius;
            this.ovalRectF.right = this.centerX + this.radius;
            this.ovalRectF.top = this.centerY - this.radius;
            this.ovalRectF.bottom = this.centerY + this.radius;
        }

        private void setup() {
            this.ovalRectF = new RectF();
            Paint paint = new Paint();
            this.paint = paint;
            paint.setAntiAlias(true);
            this.paint.setColor(this.dotColor);
        }

        @Override
        public void onAnimationUpdate(ValueAnimator valueAnimator) {
            int iArgb = Color.argb(((Integer) valueAnimator.getAnimatedValue()).intValue(), Color.red(this.dotColor), Color.green(this.dotColor), Color.blue(this.dotColor));
            this.dotColor = iArgb;
            this.paint.setColor(iArgb);
            invalidate();
        }
    }
}
