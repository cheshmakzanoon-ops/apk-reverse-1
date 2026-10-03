package androidx.compose.material3;

import androidx.compose.material.ripple.RippleAlpha;
import androidx.compose.p002ui.graphics.Color;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u001b\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u0001H\u0096\u0002J\b\u0010\u000f\u001a\u00020\u0010H\u0016J\b\u0010\u0011\u001a\u00020\u0012H\u0016R\u0019\u0010\u0002\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\t\u001a\u0004\b\u0007\u0010\bR\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0013"}, d2 = {"Landroidx/compose/material3/RippleConfiguration;", "", "color", "Landroidx/compose/ui/graphics/Color;", "rippleAlpha", "Landroidx/compose/material/ripple/RippleAlpha;", "(JLandroidx/compose/material/ripple/RippleAlpha;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "getColor-0d7_KjU", "()J", "J", "getRippleAlpha", "()Landroidx/compose/material/ripple/RippleAlpha;", "equals", "", "other", "hashCode", "", "toString", "", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class RippleConfiguration {
    public static final int $stable = 0;
    private final long color;
    private final RippleAlpha rippleAlpha;

    public RippleConfiguration(long j, RippleAlpha rippleAlpha, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, rippleAlpha);
    }

    private RippleConfiguration(long j, RippleAlpha rippleAlpha) {
        this.color = j;
        this.rippleAlpha = rippleAlpha;
    }

    public RippleConfiguration(long j, RippleAlpha rippleAlpha, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j, (i & 2) != 0 ? null : rippleAlpha, null);
    }

    public final long getColor() {
        return this.color;
    }

    public final RippleAlpha getRippleAlpha() {
        return this.rippleAlpha;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof RippleConfiguration)) {
            return false;
        }
        RippleConfiguration rippleConfiguration = (RippleConfiguration) other;
        return Color.m4591equalsimpl0(this.color, rippleConfiguration.color) && Intrinsics.areEqual(this.rippleAlpha, rippleConfiguration.rippleAlpha);
    }

    public int hashCode() {
        int iM4597hashCodeimpl = Color.m4597hashCodeimpl(this.color) * 31;
        RippleAlpha rippleAlpha = this.rippleAlpha;
        return iM4597hashCodeimpl + (rippleAlpha != null ? rippleAlpha.hashCode() : 0);
    }

    public String toString() {
        return "RippleConfiguration(color=" + ((Object) Color.m4598toStringimpl(this.color)) + ", rippleAlpha=" + this.rippleAlpha + ')';
    }
}
