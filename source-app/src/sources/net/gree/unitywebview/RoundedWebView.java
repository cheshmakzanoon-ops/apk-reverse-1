package net.gree.unitywebview;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.webkit.WebView;

public class RoundedWebView extends WebView {
    private Context context;
    private int dpRadius;
    private int height;
    private int radius;
    private int width;

    public RoundedWebView(Context context, int i) {
        super(context);
        this.dpRadius = i;
        initialize(context);
    }

    public RoundedWebView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet);
        this.dpRadius = i;
        initialize(context);
    }

    public RoundedWebView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i);
        this.dpRadius = i2;
        initialize(context);
    }

    private void initialize(Context context) {
        this.context = context;
    }

    private float dpToPx(Context context, int i) {
        return TypedValue.applyDimension(1, i, context.getResources().getDisplayMetrics());
    }

    @Override
    protected void onSizeChanged(int i, int i2, int i3, int i4) {
        super.onSizeChanged(i, i2, i3, i4);
        this.width = i;
        this.height = i2;
        this.radius = (int) dpToPx(this.context, this.dpRadius);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        Path path = new Path();
        path.setFillType(Path.FillType.INVERSE_WINDING);
        RectF rectF = new RectF(0.0f, getScrollY(), this.width, getScrollY() + this.height);
        int i = this.radius;
        path.addRoundRect(rectF, i, i, Path.Direction.CW);
        canvas.drawPath(path, createPorterDuffClearPaint());
    }

    private Paint createPorterDuffClearPaint() {
        Paint paint = new Paint();
        paint.setColor(0);
        paint.setStyle(Paint.Style.FILL);
        paint.setAntiAlias(true);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
        return paint;
    }
}
