package net.aihelp.p007ui.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.View;

public class PieProgressView extends View {
    private int currentProgress;

    private int f105cx;

    private int f106cy;
    private int gap;
    private int maxProgress;
    private int ovalCircle;

    Paint f107p;
    private int radiusCircle;

    RectF f108rf;

    public PieProgressView(Context context) {
        super(context);
        this.maxProgress = 100;
        this.currentProgress = 0;
        this.gap = 7;
        init(context);
    }

    public PieProgressView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        this.maxProgress = 100;
        this.currentProgress = 0;
        this.gap = 7;
        init(context);
    }

    public PieProgressView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.maxProgress = 100;
        this.currentProgress = 0;
        this.gap = 7;
        init(context);
    }

    private void init(Context context) {
        Paint paint = new Paint();
        this.f107p = paint;
        paint.setAntiAlias(true);
    }

    @Override
    protected void onMeasure(int i, int i2) {
        super.onMeasure(i, i2);
        int measuredWidth = getMeasuredWidth();
        int measuredHeight = getMeasuredHeight();
        int iDip2px = measuredWidth > measuredHeight ? measuredHeight / 2 : (measuredWidth / 2) - dip2px(getContext(), 1.0f);
        this.radiusCircle = iDip2px;
        this.ovalCircle = iDip2px - this.gap;
        this.f105cx = measuredWidth / 2;
        this.f106cy = measuredHeight / 2;
        int i3 = this.f105cx;
        int i4 = this.ovalCircle;
        int i5 = this.f106cy;
        this.f108rf = new RectF(i3 - i4, i5 - i4, i3 + i4, i5 + i4);
    }

    public void setProgress(int i) {
        this.currentProgress = i;
        invalidate();
    }

    public void setMaxProgress(int i) {
        this.maxProgress = i;
        invalidate();
    }

    public int getProgress() {
        return this.currentProgress;
    }

    public int getMax() {
        return this.maxProgress;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        this.f107p.reset();
        this.f107p.setColor(-1);
        this.f107p.setColor(-65536);
        this.f107p.setStyle(Paint.Style.STROKE);
        this.f107p.setStrokeWidth(dip2px(getContext(), 1.0f));
        canvas.drawCircle(this.f105cx, this.f106cy, this.radiusCircle, this.f107p);
        this.f107p.setStyle(Paint.Style.FILL);
        canvas.drawArc(this.f108rf, -90.0f, (this.currentProgress * 360.0f) / this.maxProgress, true, this.f107p);
    }

    public static int dip2px(Context context, float f) {
        return (int) ((f * context.getResources().getDisplayMetrics().density) + 0.5f);
    }
}
