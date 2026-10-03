package com.google.accompanist.drawablepainter;

import android.graphics.drawable.Animatable;
import android.graphics.drawable.Drawable;
import androidx.compose.p000ui.unit.LayoutDirection;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.RememberObserver;
import androidx.compose.runtime.SnapshotMutationPolicy;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.ui.geometry.Size;
import androidx.compose.ui.graphics.AndroidCanvas_androidKt;
import androidx.compose.ui.graphics.AndroidColorFilter_androidKt;
import androidx.compose.ui.graphics.Canvas;
import androidx.compose.ui.graphics.ColorFilter;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.graphics.painter.Painter;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0010\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020#H\u0014J\u0012\u0010$\u001a\u00020!2\b\u0010%\u001a\u0004\u0018\u00010&H\u0014J\u0010\u0010'\u001a\u00020!2\u0006\u0010(\u001a\u00020)H\u0014J\b\u0010*\u001a\u00020+H\u0016J\b\u0010,\u001a\u00020+H\u0016J\b\u0010-\u001a\u00020+H\u0016J\f\u0010.\u001a\u00020+*\u00020/H\u0014R\u001b\u0010\u0006\u001a\u00020\u00078BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\n\u0010\u000b\u001a\u0004\b\b\u0010\tR+\u0010\u000e\u001a\u00020\r2\u0006\u0010\f\u001a\u00020\r8B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u0013\u0010\u0014\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R4\u0010\u0018\u001a\u00020\u00172\u0006\u0010\f\u001a\u00020\u00178B@BX\u0082\u008e\u0002ø\u0001\u0000ø\u0001\u0001ø\u0001\u0002¢\u0006\u0012\n\u0004\b\u001d\u0010\u0014\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001cR\u001d\u0010\u001e\u001a\u00020\u00178VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001ø\u0001\u0002¢\u0006\u0006\u001a\u0004\b\u001f\u0010\u001a\u0082\u0002\u000f\n\u0002\b\u0019\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u00060"}, d2 = {"Lcom/google/accompanist/drawablepainter/DrawablePainter;", "Landroidx/compose/ui/graphics/painter/Painter;", "Landroidx/compose/runtime/RememberObserver;", "drawable", "Landroid/graphics/drawable/Drawable;", "(Landroid/graphics/drawable/Drawable;)V", "callback", "Landroid/graphics/drawable/Drawable$Callback;", "getCallback", "()Landroid/graphics/drawable/Drawable$Callback;", "callback$delegate", "Lkotlin/Lazy;", "<set-?>", "", "drawInvalidateTick", "getDrawInvalidateTick", "()I", "setDrawInvalidateTick", "(I)V", "drawInvalidateTick$delegate", "Landroidx/compose/runtime/MutableState;", "getDrawable", "()Landroid/graphics/drawable/Drawable;", "Landroidx/compose/ui/geometry/Size;", "drawableIntrinsicSize", "getDrawableIntrinsicSize-NH-jbRc", "()J", "setDrawableIntrinsicSize-uvyYCjk", "(J)V", "drawableIntrinsicSize$delegate", "intrinsicSize", "getIntrinsicSize-NH-jbRc", "applyAlpha", "", "alpha", "", "applyColorFilter", "colorFilter", "Landroidx/compose/ui/graphics/ColorFilter;", "applyLayoutDirection", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "onAbandoned", "", "onForgotten", "onRemembered", "onDraw", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "drawablepainter_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class DrawablePainter extends Painter implements RememberObserver {
    public static final int $stable = 8;

    private final Lazy callback;

    private final MutableState drawInvalidateTick;
    private final Drawable drawable;

    private final MutableState drawableIntrinsicSize;

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[LayoutDirection.values().length];
            try {
                iArr[LayoutDirection.Ltr.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[LayoutDirection.Rtl.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public final Drawable getDrawable() {
        return this.drawable;
    }

    public DrawablePainter(Drawable drawable) {
        Intrinsics.checkNotNullParameter(drawable, "drawable");
        this.drawable = drawable;
        this.drawInvalidateTick = SnapshotStateKt.mutableStateOf$default(0, (SnapshotMutationPolicy) null, 2, (Object) null);
        this.drawableIntrinsicSize = SnapshotStateKt.mutableStateOf$default(Size.box-impl(DrawablePainterKt.getIntrinsicSize(drawable)), (SnapshotMutationPolicy) null, 2, (Object) null);
        this.callback = LazyKt.lazy(new Function0<DrawablePainter$callback$2.C10931>() {
            {
                super(0);
            }

            public final C10931 m2583invoke() {
                final DrawablePainter drawablePainter = this.this$0;
                return new Drawable.Callback() {
                    @Override
                    public void invalidateDrawable(Drawable d) {
                        Intrinsics.checkNotNullParameter(d, "d");
                        DrawablePainter drawablePainter2 = drawablePainter;
                        drawablePainter2.setDrawInvalidateTick(drawablePainter2.getDrawInvalidateTick() + 1);
                        DrawablePainter drawablePainter3 = drawablePainter;
                        drawablePainter3.m2581setDrawableIntrinsicSizeuvyYCjk(DrawablePainterKt.getIntrinsicSize(drawablePainter3.getDrawable()));
                    }

                    @Override
                    public void scheduleDrawable(Drawable d, Runnable what, long time) {
                        Intrinsics.checkNotNullParameter(d, "d");
                        Intrinsics.checkNotNullParameter(what, "what");
                        DrawablePainterKt.getMAIN_HANDLER().postAtTime(what, time);
                    }

                    @Override
                    public void unscheduleDrawable(Drawable d, Runnable what) {
                        Intrinsics.checkNotNullParameter(d, "d");
                        Intrinsics.checkNotNullParameter(what, "what");
                        DrawablePainterKt.getMAIN_HANDLER().removeCallbacks(what);
                    }
                };
            }
        });
        if (drawable.getIntrinsicWidth() < 0 || drawable.getIntrinsicHeight() < 0) {
            return;
        }
        drawable.setBounds(0, 0, drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight());
    }

    public final int getDrawInvalidateTick() {
        return ((Number) this.drawInvalidateTick.getValue()).intValue();
    }

    public final void setDrawInvalidateTick(int i) {
        this.drawInvalidateTick.setValue(Integer.valueOf(i));
    }

    private final long m2580getDrawableIntrinsicSizeNHjbRc() {
        return ((Size) this.drawableIntrinsicSize.getValue()).unbox-impl();
    }

    public final void m2581setDrawableIntrinsicSizeuvyYCjk(long j) {
        this.drawableIntrinsicSize.setValue(Size.box-impl(j));
    }

    private final Drawable.Callback getCallback() {
        return (Drawable.Callback) this.callback.getValue();
    }

    public void onRemembered() {
        this.drawable.setCallback(getCallback());
        this.drawable.setVisible(true, true);
        Object obj = this.drawable;
        if (obj instanceof Animatable) {
            ((Animatable) obj).start();
        }
    }

    public void onAbandoned() {
        onForgotten();
    }

    public void onForgotten() {
        Object obj = this.drawable;
        if (obj instanceof Animatable) {
            ((Animatable) obj).stop();
        }
        this.drawable.setVisible(false, false);
        this.drawable.setCallback(null);
    }

    protected boolean applyAlpha(float alpha) {
        this.drawable.setAlpha(RangesKt.coerceIn(MathKt.roundToInt(alpha * 255), 0, 255));
        return true;
    }

    protected boolean applyColorFilter(ColorFilter colorFilter) {
        this.drawable.setColorFilter(colorFilter != null ? AndroidColorFilter_androidKt.asAndroidColorFilter(colorFilter) : null);
        return true;
    }

    protected boolean applyLayoutDirection(LayoutDirection layoutDirection) throws NoWhenBranchMatchedException {
        Intrinsics.checkNotNullParameter(layoutDirection, "layoutDirection");
        Drawable drawable = this.drawable;
        int i = WhenMappings.$EnumSwitchMapping$0[layoutDirection.ordinal()];
        int i2 = 1;
        if (i == 1) {
            i2 = 0;
        } else if (i != 2) {
            throw new NoWhenBranchMatchedException();
        }
        return drawable.setLayoutDirection(i2);
    }

    public long m2582getIntrinsicSizeNHjbRc() {
        return m2580getDrawableIntrinsicSizeNHjbRc();
    }

    protected void onDraw(DrawScope drawScope) {
        Intrinsics.checkNotNullParameter(drawScope, "<this>");
        Canvas canvas = drawScope.getDrawContext().getCanvas();
        getDrawInvalidateTick();
        this.drawable.setBounds(0, 0, MathKt.roundToInt(Size.getWidth-impl(drawScope.getSize-NH-jbRc())), MathKt.roundToInt(Size.getHeight-impl(drawScope.getSize-NH-jbRc())));
        try {
            canvas.save();
            this.drawable.draw(AndroidCanvas_androidKt.getNativeCanvas(canvas));
        } finally {
            canvas.restore();
        }
    }
}
