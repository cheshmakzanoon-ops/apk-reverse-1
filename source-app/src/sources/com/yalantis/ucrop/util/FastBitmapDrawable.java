package com.yalantis.ucrop.util;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;

public class FastBitmapDrawable extends Drawable {
    private Bitmap mBitmap;
    private int mHeight;
    private int mWidth;
    private final Paint mPaint = new Paint(2);
    private int mAlpha = 255;

    @Override
    public int getOpacity() {
        return -3;
    }

    public FastBitmapDrawable(Bitmap bitmap) {
        setBitmap(bitmap);
    }

    @Override
    public void draw(Canvas canvas) {
        Bitmap bitmap = this.mBitmap;
        if (bitmap == null || bitmap.isRecycled()) {
            return;
        }
        canvas.drawBitmap(this.mBitmap, (Rect) null, getBounds(), this.mPaint);
    }

    @Override
    public void setColorFilter(ColorFilter colorFilter) {
        this.mPaint.setColorFilter(colorFilter);
    }

    @Override
    public void setFilterBitmap(boolean z) {
        this.mPaint.setFilterBitmap(z);
    }

    @Override
    public int getAlpha() {
        return this.mAlpha;
    }

    @Override
    public void setAlpha(int i) {
        this.mAlpha = i;
        this.mPaint.setAlpha(i);
    }

    @Override
    public int getIntrinsicWidth() {
        return this.mWidth;
    }

    @Override
    public int getIntrinsicHeight() {
        return this.mHeight;
    }

    @Override
    public int getMinimumWidth() {
        return this.mWidth;
    }

    @Override
    public int getMinimumHeight() {
        return this.mHeight;
    }

    public Bitmap getBitmap() {
        return this.mBitmap;
    }

    public void setBitmap(Bitmap bitmap) {
        this.mBitmap = bitmap;
        if (bitmap != null) {
            this.mWidth = bitmap.getWidth();
            this.mHeight = this.mBitmap.getHeight();
        } else {
            this.mHeight = 0;
            this.mWidth = 0;
        }
    }
}
