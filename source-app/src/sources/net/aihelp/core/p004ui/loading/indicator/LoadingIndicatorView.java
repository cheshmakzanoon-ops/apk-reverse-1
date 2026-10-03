package net.aihelp.core.p004ui.loading.indicator;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;
import net.aihelp.utils.ResResolver;

public class LoadingIndicatorView extends View {
    public static final int DEFAULT_SIZE = 45;
    private boolean mHasAnimation;
    int mIndicatorColor;
    BallSpinFadeLoaderIndicator mIndicatorController;
    Paint mPaint;

    public LoadingIndicatorView(Context context) {
        super(context.getApplicationContext());
        this.mIndicatorColor = -1;
        init(null, 0);
    }

    public LoadingIndicatorView(Context context, AttributeSet attributeSet) {
        super(context.getApplicationContext(), attributeSet);
        this.mIndicatorColor = -1;
        init(attributeSet, 0);
    }

    public LoadingIndicatorView(Context context, AttributeSet attributeSet, int i) {
        super(context.getApplicationContext(), attributeSet, i);
        this.mIndicatorColor = -1;
        init(attributeSet, i);
    }

    public LoadingIndicatorView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context.getApplicationContext(), attributeSet, i, i2);
        this.mIndicatorColor = -1;
        init(attributeSet, i);
    }

    private void init(AttributeSet attributeSet, int i) {
        int[] styleable = ResResolver.getStyleable("aihelp_loading_indicator_view");
        if (styleable != null) {
            TypedArray typedArrayObtainStyledAttributes = getContext().obtainStyledAttributes(attributeSet, styleable);
            this.mIndicatorColor = typedArrayObtainStyledAttributes.getColor(ResResolver.getStyleableFieldIndex("aihelp_loading_indicator_view", "aihelp_loading_color"), -1);
            typedArrayObtainStyledAttributes.recycle();
        }
        Paint paint = new Paint();
        this.mPaint = paint;
        paint.setColor(this.mIndicatorColor);
        this.mPaint.setStyle(Paint.Style.FILL);
        this.mPaint.setAntiAlias(true);
        BallSpinFadeLoaderIndicator ballSpinFadeLoaderIndicator = new BallSpinFadeLoaderIndicator();
        this.mIndicatorController = ballSpinFadeLoaderIndicator;
        ballSpinFadeLoaderIndicator.setTarget(this);
    }

    @Override
    protected void onMeasure(int i, int i2) {
        setMeasuredDimension(measureDimension(dp2px(45), i), measureDimension(dp2px(45), i2));
    }

    private int measureDimension(int i, int i2) {
        int mode = View.MeasureSpec.getMode(i2);
        int size = View.MeasureSpec.getSize(i2);
        if (mode == 1073741824) {
            return size;
        }
        return mode == Integer.MIN_VALUE ? Math.min(i, size) : i;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        drawIndicator(canvas);
    }

    public void setIndicatorColor(int i) {
        this.mIndicatorColor = i;
        this.mPaint.setColor(i);
        invalidate();
    }

    @Override
    protected void onLayout(boolean z, int i, int i2, int i3, int i4) {
        super.onLayout(z, i, i2, i3, i4);
        if (this.mHasAnimation) {
            return;
        }
        this.mHasAnimation = true;
        applyAnimation();
    }

    void drawIndicator(Canvas canvas) {
        BallSpinFadeLoaderIndicator ballSpinFadeLoaderIndicator = this.mIndicatorController;
        if (ballSpinFadeLoaderIndicator != null) {
            ballSpinFadeLoaderIndicator.draw(canvas, this.mPaint);
        }
    }

    void applyAnimation() {
        BallSpinFadeLoaderIndicator ballSpinFadeLoaderIndicator = this.mIndicatorController;
        if (ballSpinFadeLoaderIndicator != null) {
            ballSpinFadeLoaderIndicator.setTarget(this);
            this.mIndicatorController.createAnimation();
        }
    }

    private int dp2px(int i) {
        return ((int) getContext().getResources().getDisplayMetrics().density) * i;
    }

    @Override
    protected void onWindowVisibilityChanged(int i) {
        super.onWindowVisibilityChanged(i);
        BallSpinFadeLoaderIndicator ballSpinFadeLoaderIndicator = this.mIndicatorController;
        if (ballSpinFadeLoaderIndicator != null) {
            if (i == 0) {
                ballSpinFadeLoaderIndicator.setTarget(this);
                postInvalidate();
            } else {
                ballSpinFadeLoaderIndicator.setTarget(null);
            }
        }
    }
}
