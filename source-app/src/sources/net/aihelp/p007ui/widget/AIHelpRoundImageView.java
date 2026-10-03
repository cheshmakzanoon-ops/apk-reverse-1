package net.aihelp.p007ui.widget;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.util.AttributeSet;
import androidx.appcompat.widget.AppCompatImageView;

public class AIHelpRoundImageView extends AppCompatImageView {
    private static final int DEFAULT_BORDER_COLOR = 0;
    private static final int DEFAULT_BORDER_WIDTH = 0;
    private static final int DEFAULT_FILL_COLOR = 0;
    private int borderColor;
    private Paint borderPaint;
    private int borderWidth;
    private final Rect bounds;

    private float f103cx;

    private float f104cy;
    private int fillColor;
    private Paint fillPaint;
    private Paint imagePaint;
    private Paint portPaint;
    private float radius;
    private boolean roundDisable;
    private RoundMode roundMode;

    public enum RoundMode {
        ROUND_VIEW,
        ROUND_DRAWABLE
    }

    public AIHelpRoundImageView(Context context) {
        super(context);
        this.roundMode = RoundMode.ROUND_DRAWABLE;
        this.borderColor = 0;
        this.borderWidth = 0;
        this.fillColor = 0;
        this.bounds = new Rect();
        this.radius = 0.0f;
        this.f103cx = 0.0f;
        this.f104cy = 0.0f;
        initView();
    }

    public AIHelpRoundImageView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        this.roundMode = RoundMode.ROUND_DRAWABLE;
        this.borderColor = 0;
        this.borderWidth = 0;
        this.fillColor = 0;
        this.bounds = new Rect();
        this.radius = 0.0f;
        this.f103cx = 0.0f;
        this.f104cy = 0.0f;
        initView();
    }

    public AIHelpRoundImageView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.roundMode = RoundMode.ROUND_DRAWABLE;
        this.borderColor = 0;
        this.borderWidth = 0;
        this.fillColor = 0;
        this.bounds = new Rect();
        this.radius = 0.0f;
        this.f103cx = 0.0f;
        this.f104cy = 0.0f;
        initView();
    }

    private void initView() {
        Paint paint = new Paint();
        this.portPaint = paint;
        paint.setAntiAlias(true);
        Paint paint2 = new Paint();
        this.borderPaint = paint2;
        paint2.setAntiAlias(true);
        this.borderPaint.setColor(0);
        this.borderPaint.setStrokeWidth(0.0f);
        this.borderPaint.setStyle(Paint.Style.STROKE);
        Paint paint3 = new Paint();
        this.fillPaint = paint3;
        paint3.setAntiAlias(true);
        this.fillPaint.setColor(0);
        this.fillPaint.setStyle(Paint.Style.FILL);
        Paint paint4 = new Paint();
        this.imagePaint = paint4;
        paint4.setAntiAlias(true);
        this.imagePaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
    }

    public void setRoundMode(RoundMode roundMode) {
        if (roundMode == null || this.roundMode == roundMode) {
            return;
        }
        this.roundMode = roundMode;
        invalidate();
    }

    public void setRoundDisable(boolean z) {
        if (this.roundDisable != z) {
            this.roundDisable = z;
            invalidate();
        }
    }

    public boolean isRoundDisable() {
        return this.roundDisable;
    }

    public void setBorderColor(int i) {
        if (this.borderColor != i) {
            this.borderColor = i;
            this.borderPaint.setColor(i);
            invalidate();
        }
    }

    public void setBorderWidth(int i) {
        if (this.borderWidth != i) {
            this.borderWidth = i;
            this.borderPaint.setStrokeWidth(i);
            invalidate();
        }
    }

    public void setFillColor(int i) {
        if (this.fillColor != i) {
            this.fillColor = i;
            this.fillPaint.setColor(i);
            invalidate();
        }
    }

    protected void onDraw(Canvas canvas) {
        if (this.roundDisable) {
            super.onDraw(canvas);
            return;
        }
        if (getDrawable() == null && this.roundMode == RoundMode.ROUND_DRAWABLE) {
            super.onDraw(canvas);
            return;
        }
        computeRoundBounds();
        drawCircle(canvas);
        drawImage(canvas);
    }

    private void drawImage(Canvas canvas) {
        Bitmap bitmapCreateBitmap = Bitmap.createBitmap(getWidth(), getHeight(), Bitmap.Config.ARGB_4444);
        super.onDraw(new Canvas(bitmapCreateBitmap));
        Bitmap bitmapCreateBitmap2 = Bitmap.createBitmap(getWidth(), getHeight(), Bitmap.Config.ARGB_4444);
        Canvas canvas2 = new Canvas(bitmapCreateBitmap2);
        int saveCount = canvas2.getSaveCount();
        canvas2.save();
        adjustCanvas(canvas2);
        canvas2.drawCircle(this.f103cx, this.f104cy, this.radius, this.portPaint);
        canvas2.restoreToCount(saveCount);
        canvas2.drawBitmap(bitmapCreateBitmap, 0.0f, 0.0f, this.imagePaint);
        bitmapCreateBitmap.recycle();
        canvas.drawBitmap(bitmapCreateBitmap2, 0.0f, 0.0f, (Paint) null);
        bitmapCreateBitmap2.recycle();
    }

    private void drawCircle(Canvas canvas) {
        int saveCount = canvas.getSaveCount();
        canvas.save();
        adjustCanvas(canvas);
        canvas.drawCircle(this.f103cx, this.f104cy, this.radius, this.fillPaint);
        int i = this.borderWidth;
        if (i > 0) {
            canvas.drawCircle(this.f103cx, this.f104cy, this.radius - (i / 2.0f), this.borderPaint);
        }
        canvas.restoreToCount(saveCount);
    }

    private void computeRoundBounds() {
        if (this.roundMode == RoundMode.ROUND_VIEW) {
            this.bounds.left = getPaddingLeft();
            this.bounds.top = getPaddingTop();
            this.bounds.right = getWidth() - getPaddingRight();
            this.bounds.bottom = getHeight() - getPaddingBottom();
        } else if (this.roundMode == RoundMode.ROUND_DRAWABLE) {
            getDrawable().copyBounds(this.bounds);
        }
        this.radius = Math.min(this.bounds.width(), this.bounds.height()) / 2.0f;
        this.f103cx = this.bounds.left + (this.bounds.width() / 2.0f);
        this.f104cy = this.bounds.top + (this.bounds.height() / 2.0f);
    }

    private void adjustCanvas(Canvas canvas) {
        if (this.roundMode == RoundMode.ROUND_DRAWABLE) {
            if (getCropToPadding()) {
                int scrollX = getScrollX();
                int scrollY = getScrollY();
                canvas.clipRect(getPaddingLeft() + scrollX, getPaddingTop() + scrollY, ((scrollX + getRight()) - getLeft()) - getPaddingRight(), ((scrollY + getBottom()) - getTop()) - getPaddingBottom());
            }
            canvas.translate(getPaddingLeft(), getPaddingTop());
            if (getImageMatrix() != null) {
                canvas.concat(new Matrix(getImageMatrix()));
            }
        }
    }
}
