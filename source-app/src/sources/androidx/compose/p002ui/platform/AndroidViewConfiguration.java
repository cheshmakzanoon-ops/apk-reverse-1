package androidx.compose.p002ui.platform;

import android.os.Build;
import android.view.ViewConfiguration;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0005\n\u0002\u0010\u0007\n\u0002\b\u000b\b\u0007\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0014\u0010\u0005\u001a\u00020\u00068VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\bR\u0014\u0010\t\u001a\u00020\u00068VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\bR\u0014\u0010\u000b\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u000f\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u000eR\u0014\u0010\u0011\u001a\u00020\u00068VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\bR\u0014\u0010\u0013\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u000eR\u0014\u0010\u0015\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0016\u0010\u000eR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0017"}, d2 = {"Landroidx/compose/ui/platform/AndroidViewConfiguration;", "Landroidx/compose/ui/platform/ViewConfiguration;", "viewConfiguration", "Landroid/view/ViewConfiguration;", "(Landroid/view/ViewConfiguration;)V", "doubleTapMinTimeMillis", "", "getDoubleTapMinTimeMillis", "()J", "doubleTapTimeoutMillis", "getDoubleTapTimeoutMillis", "handwritingGestureLineMargin", "", "getHandwritingGestureLineMargin", "()F", "handwritingSlop", "getHandwritingSlop", "longPressTimeoutMillis", "getLongPressTimeoutMillis", "maximumFlingVelocity", "getMaximumFlingVelocity", "touchSlop", "getTouchSlop", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class AndroidViewConfiguration implements ViewConfiguration {
    public static final int $stable = 8;
    private final ViewConfiguration viewConfiguration;

    @Override
    public long getDoubleTapMinTimeMillis() {
        return 40L;
    }

    @Override
    public long mo6237getMinimumTouchTargetSizeMYxV2XQ() {
        return ViewConfiguration.CC.m6583$default$getMinimumTouchTargetSizeMYxV2XQ(this);
    }

    public AndroidViewConfiguration(ViewConfiguration viewConfiguration) {
        this.viewConfiguration = viewConfiguration;
    }

    @Override
    public long getLongPressTimeoutMillis() {
        return ViewConfiguration.getLongPressTimeout();
    }

    @Override
    public long getDoubleTapTimeoutMillis() {
        return ViewConfiguration.getDoubleTapTimeout();
    }

    @Override
    public float getTouchSlop() {
        return this.viewConfiguration.getScaledTouchSlop();
    }

    @Override
    public float getHandwritingSlop() {
        if (Build.VERSION.SDK_INT >= 34) {
            return AndroidViewConfigurationApi34.INSTANCE.getScaledHandwritingSlop(this.viewConfiguration);
        }
        return ViewConfiguration.CC.$default$getHandwritingSlop(this);
    }

    @Override
    public float getMaximumFlingVelocity() {
        return this.viewConfiguration.getScaledMaximumFlingVelocity();
    }

    @Override
    public float getHandwritingGestureLineMargin() {
        if (Build.VERSION.SDK_INT >= 34) {
            return AndroidViewConfigurationApi34.INSTANCE.getScaledHandwritingGestureLineMargin(this.viewConfiguration);
        }
        return ViewConfiguration.CC.$default$getHandwritingGestureLineMargin(this);
    }
}
