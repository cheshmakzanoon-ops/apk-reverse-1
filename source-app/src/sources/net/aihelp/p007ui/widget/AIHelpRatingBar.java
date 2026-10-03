package net.aihelp.p007ui.widget;

import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import androidx.core.graphics.drawable.DrawableCompat;
import androidx.vectordrawable.graphics.drawable.VectorDrawableCompat;
import net.aihelp.common.CustomConfig;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AIHelpRatingBar extends View {
    private int mCurrGrade;
    private Bitmap mFocusedDrawable;
    private int mGradeLevel;
    private OnStatusChangedListener mListener;
    private int mSpacing;
    private int mStarHeight;
    private int mStarWidth;
    private Bitmap mUnfocusedDrawable;

    public interface OnStatusChangedListener {
        void onRateStatusChanged(int i);
    }

    public int getSelectGrade() {
        return this.mCurrGrade;
    }

    public boolean isFullStar() {
        return this.mCurrGrade == this.mGradeLevel;
    }

    public AIHelpRatingBar(Context context) {
        this(context, null);
    }

    public AIHelpRatingBar(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpRatingBar(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.mStarWidth = 30;
        this.mStarHeight = 30;
        int[] styleable = ResResolver.getStyleable("aihelp_rating_bar");
        if (styleable != null) {
            TypedArray typedArrayObtainStyledAttributes = context.obtainStyledAttributes(attributeSet, styleable);
            int resourceId = typedArrayObtainStyledAttributes.getResourceId(ResResolver.getStyleableFieldIndex("aihelp_rating_bar", "aihelp_rating_bar_focused"), ResResolver.getDrawableId("aihelp_svg_star_selected"));
            int resourceId2 = typedArrayObtainStyledAttributes.getResourceId(ResResolver.getStyleableFieldIndex("aihelp_rating_bar", "aihelp_rating_bar_unfocused"), ResResolver.getDrawableId("aihelp_svg_star_unselected"));
            this.mSpacing = typedArrayObtainStyledAttributes.getDimensionPixelSize(ResResolver.getStyleableFieldIndex("aihelp_rating_bar", "aihelp_rating_bar_horizontal_spacing"), dip2px(context, 27.0d));
            this.mGradeLevel = typedArrayObtainStyledAttributes.getInt(ResResolver.getStyleableFieldIndex("aihelp_rating_bar", "aihelp_rating_bar_grade_level"), 5);
            this.mCurrGrade = typedArrayObtainStyledAttributes.getInt(ResResolver.getStyleableFieldIndex("aihelp_rating_bar", "aihelp_rating_bar_default_grade"), this.mGradeLevel);
            typedArrayObtainStyledAttributes.recycle();
            if (resourceId != 0) {
                this.mFocusedDrawable = getDrawableBitmap(context, resourceId, Styles.getColor(CustomConfig.CommonSetting.highlightedColor));
            }
            if (resourceId2 != 0) {
                this.mUnfocusedDrawable = getDrawableBitmap(context, resourceId2, Styles.getColorWithAlpha(CustomConfig.CommonSetting.highlightedColor, 0.20000000298023224d));
            }
            Bitmap bitmap = this.mFocusedDrawable;
            if (bitmap != null) {
                this.mStarWidth = bitmap.getWidth();
                this.mStarHeight = this.mFocusedDrawable.getHeight();
            }
        }
    }

    protected int dip2px(Context context, double d) {
        return context == null ? (int) d : (int) ((d * ((double) context.getResources().getDisplayMetrics().density)) + 0.5d);
    }

    @Override
    protected void onMeasure(int i, int i2) {
        super.onMeasure(i, i2);
        int i3 = this.mStarWidth;
        int i4 = this.mGradeLevel;
        setMeasuredDimension((i3 * i4) + (this.mSpacing * (i4 - 1)), this.mStarHeight);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (this.mFocusedDrawable == null || this.mUnfocusedDrawable == null) {
            return;
        }
        if (Styles.isLayoutRtl(this)) {
            canvas.translate(getWidth(), 0.0f);
            canvas.scale(-1.0f, 1.0f);
        }
        for (int i = 0; i < this.mGradeLevel; i++) {
            int i2 = this.mStarWidth;
            int i3 = i2 * i;
            if (i > 0) {
                i3 = (this.mSpacing * i) + (i2 * i);
            }
            if (this.mCurrGrade > i) {
                canvas.drawBitmap(this.mFocusedDrawable, i3, 0.0f, (Paint) null);
            } else {
                canvas.drawBitmap(this.mUnfocusedDrawable, i3, 0.0f, (Paint) null);
            }
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent motionEvent) {
        if (this.mFocusedDrawable != null && this.mUnfocusedDrawable != null) {
            if (Styles.isLayoutRtl(this)) {
                motionEvent.setLocation(getWidth() - motionEvent.getX(), motionEvent.getY());
            }
            int action = motionEvent.getAction();
            if (action == 1 || action == 2) {
                float x = motionEvent.getX();
                if (x < 0.0f) {
                    x = 0.0f;
                }
                int width = ((int) (x / (this.mFocusedDrawable.getWidth() + this.mSpacing))) + 1;
                if (width < 0) {
                    width = 1;
                } else {
                    int i = this.mGradeLevel;
                    if (width > i) {
                        width = i;
                    }
                }
                if (this.mCurrGrade == width) {
                    return true;
                }
                this.mCurrGrade = width;
                OnStatusChangedListener onStatusChangedListener = this.mListener;
                if (onStatusChangedListener != null) {
                    onStatusChangedListener.onRateStatusChanged(width);
                }
                invalidate();
            }
        }
        return true;
    }

    public static Bitmap getDrawableBitmap(Context context, int i, int i2) {
        VectorDrawableCompat vectorDrawableCompatCreate = VectorDrawableCompat.create(context.getResources(), i, (Resources.Theme) null);
        if (vectorDrawableCompatCreate != null) {
            DrawableCompat.setTint(DrawableCompat.wrap(vectorDrawableCompatCreate).mutate(), i2);
        }
        Bitmap bitmapCreateBitmap = Bitmap.createBitmap(vectorDrawableCompatCreate.getIntrinsicWidth(), vectorDrawableCompatCreate.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmapCreateBitmap);
        vectorDrawableCompatCreate.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        vectorDrawableCompatCreate.draw(canvas);
        return bitmapCreateBitmap;
    }

    public void setOnStatusChangedListener(OnStatusChangedListener onStatusChangedListener) {
        this.mListener = onStatusChangedListener;
    }
}
