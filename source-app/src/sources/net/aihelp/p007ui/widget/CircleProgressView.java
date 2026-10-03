package net.aihelp.p007ui.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.View;

public class CircleProgressView extends View {
    private int mBorderWidth;
    private int mCurrentStep;
    private int mInnerColor;
    private Paint mInnerPaint;
    private Paint mOutPaint;
    private int mOuterColor;
    private int mStepMax;
    private int mStepTextColor;
    private int mStepTextSize;
    private Paint mTextPaint;

    public CircleProgressView(Context context) {
        this(context, null);
    }

    public CircleProgressView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public CircleProgressView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.mOuterColor = -7829368;
        this.mInnerColor = -1;
        this.mBorderWidth = 18;
        this.mStepMax = 100;
        this.mCurrentStep = 0;
        Paint paint = new Paint();
        this.mOutPaint = paint;
        paint.setAntiAlias(true);
        this.mOutPaint.setStrokeWidth(this.mBorderWidth);
        this.mOutPaint.setColor(this.mOuterColor);
        this.mOutPaint.setStrokeCap(Paint.Cap.ROUND);
        this.mOutPaint.setStyle(Paint.Style.STROKE);
        Paint paint2 = new Paint();
        this.mInnerPaint = paint2;
        paint2.setAntiAlias(true);
        this.mInnerPaint.setStrokeWidth(this.mBorderWidth);
        this.mInnerPaint.setColor(this.mInnerColor);
        this.mInnerPaint.setStrokeCap(Paint.Cap.ROUND);
        this.mInnerPaint.setStyle(Paint.Style.STROKE);
        Paint paint3 = new Paint();
        this.mTextPaint = paint3;
        paint3.setAntiAlias(true);
        this.mTextPaint.setColor(this.mStepTextColor);
        this.mTextPaint.setTextSize(this.mStepTextSize);
    }

    @Override
    protected void onMeasure(int i, int i2) {
        super.onMeasure(i, i2);
        int size = View.MeasureSpec.getSize(i);
        int size2 = View.MeasureSpec.getSize(i2);
        int i3 = size > size2 ? size2 : size;
        if (size > size2) {
            size = size2;
        }
        setMeasuredDimension(i3, size);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        int i = this.mBorderWidth;
        RectF rectF = new RectF(i / 2, i / 2, getWidth() - (this.mBorderWidth / 2), getHeight() - (this.mBorderWidth / 2));
        canvas.drawArc(rectF, -90.0f, 360.0f, false, this.mOutPaint);
        int i2 = this.mStepMax;
        if (i2 == 0) {
            return;
        }
        canvas.drawArc(rectF, -90.0f, (this.mCurrentStep / i2) * 360.0f, false, this.mInnerPaint);
        String str = this.mCurrentStep + "";
        Rect rect = new Rect();
        this.mTextPaint.getTextBounds(str, 0, str.length(), rect);
        int width = (getWidth() / 2) - (rect.width() / 2);
        Paint.FontMetricsInt fontMetricsInt = this.mTextPaint.getFontMetricsInt();
        canvas.drawText(str, width, (getHeight() / 2) + (((fontMetricsInt.bottom - fontMetricsInt.top) / 2) - fontMetricsInt.bottom), this.mTextPaint);
    }

    public synchronized void setStepMax(int i) {
        this.mStepMax = i;
    }

    public synchronized void setCurrentStep(int i) {
        this.mCurrentStep = i;
        invalidate();
    }
}
