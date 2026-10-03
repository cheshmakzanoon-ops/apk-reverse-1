package com.joke.assistanttool.utils;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.text.style.ImageSpan;

public class CenterAlignImageSpan extends ImageSpan {
    public CenterAlignImageSpan(Drawable drawable) {
        super(drawable);
    }

    public CenterAlignImageSpan(Bitmap bitmap) {
        super(bitmap);
    }

    @Override
    public void draw(Canvas canvas, CharSequence text, int start, int end, float x, int top, int y, int bottom, Paint paint) {
        Drawable drawable = getDrawable();
        Paint.FontMetricsInt fontMetrics = paint.getFontMetricsInt();
        int transY = ((((fontMetrics.descent + y) + y) + fontMetrics.ascent) / 2) - (drawable.getBounds().bottom / 2);
        canvas.save();
        canvas.translate(x, transY);
        drawable.draw(canvas);
        canvas.restore();
    }
}
