package androidx.compose.material3;

import androidx.compose.p002ui.graphics.Color;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\b\b\u0001\u0018\u00002\u00020\u0001B=\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003¢\u0006\u0002\u0010\nJV\u0010\u0014\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u0003ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0016J\u0013\u0010\u0017\u001a\u00020\u00182\b\u0010\u0019\u001a\u0004\u0018\u00010\u0001H\u0096\u0002J\b\u0010\u001a\u001a\u00020\u001bH\u0016J%\u0010\u001c\u001a\u00020\u00032\u0006\u0010\u001d\u001a\u00020\u00182\u0006\u0010\u001e\u001a\u00020\u0018H\u0007ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010 J%\u0010!\u001a\u00020\u00032\u0006\u0010\u001d\u001a\u00020\u00182\u0006\u0010\u001e\u001a\u00020\u0018H\u0007ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\"\u0010 R\u0019\u0010\b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u000b\u0010\fR\u0019\u0010\t\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u000e\u0010\fR\u0019\u0010\u0002\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u000f\u0010\fR\u0019\u0010\u0005\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u0010\u0010\fR\u0019\u0010\u0004\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u0011\u0010\fR\u0019\u0010\u0006\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u0012\u0010\fR\u0019\u0010\u0007\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u0013\u0010\f\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006#"}, d2 = {"Landroidx/compose/material3/NavigationItemColors;", "", "selectedIconColor", "Landroidx/compose/ui/graphics/Color;", "selectedTextColor", "selectedIndicatorColor", "unselectedIconColor", "unselectedTextColor", "disabledIconColor", "disabledTextColor", "(JJJJJJJLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getDisabledIconColor-0d7_KjU", "()J", "J", "getDisabledTextColor-0d7_KjU", "getSelectedIconColor-0d7_KjU", "getSelectedIndicatorColor-0d7_KjU", "getSelectedTextColor-0d7_KjU", "getUnselectedIconColor-0d7_KjU", "getUnselectedTextColor-0d7_KjU", "copy", "copy-4JmcsL4", "(JJJJJJJ)Landroidx/compose/material3/NavigationItemColors;", "equals", "", "other", "hashCode", "", "iconColor", "selected", "enabled", "iconColor-WaAFU9c", "(ZZ)J", "textColor", "textColor-WaAFU9c", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class NavigationItemColors {
    public static final int $stable = 0;
    private final long disabledIconColor;
    private final long disabledTextColor;
    private final long selectedIconColor;
    private final long selectedIndicatorColor;
    private final long selectedTextColor;
    private final long unselectedIconColor;
    private final long unselectedTextColor;

    public NavigationItemColors(long j, long j2, long j3, long j4, long j5, long j6, long j7, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, j2, j3, j4, j5, j6, j7);
    }

    private NavigationItemColors(long j, long j2, long j3, long j4, long j5, long j6, long j7) {
        this.selectedIconColor = j;
        this.selectedTextColor = j2;
        this.selectedIndicatorColor = j3;
        this.unselectedIconColor = j4;
        this.unselectedTextColor = j5;
        this.disabledIconColor = j6;
        this.disabledTextColor = j7;
    }

    public final long getSelectedIconColor() {
        return this.selectedIconColor;
    }

    public final long getSelectedTextColor() {
        return this.selectedTextColor;
    }

    public final long getSelectedIndicatorColor() {
        return this.selectedIndicatorColor;
    }

    public final long getUnselectedIconColor() {
        return this.unselectedIconColor;
    }

    public final long getUnselectedTextColor() {
        return this.unselectedTextColor;
    }

    public final long getDisabledIconColor() {
        return this.disabledIconColor;
    }

    public final long getDisabledTextColor() {
        return this.disabledTextColor;
    }

    public final NavigationItemColors m2595copy4JmcsL4(long selectedIconColor, long selectedTextColor, long selectedIndicatorColor, long unselectedIconColor, long unselectedTextColor, long disabledIconColor, long disabledTextColor) {
        return new NavigationItemColors(selectedIconColor != 16 ? selectedIconColor : this.selectedIconColor, selectedTextColor != 16 ? selectedTextColor : this.selectedTextColor, selectedIndicatorColor != 16 ? selectedIndicatorColor : this.selectedIndicatorColor, unselectedIconColor != 16 ? unselectedIconColor : this.unselectedIconColor, unselectedTextColor != 16 ? unselectedTextColor : this.unselectedTextColor, disabledIconColor != 16 ? disabledIconColor : this.disabledIconColor, disabledTextColor != 16 ? disabledTextColor : this.disabledTextColor, null);
    }

    public final long m2603iconColorWaAFU9c(boolean selected, boolean enabled) {
        if (!enabled) {
            return this.disabledIconColor;
        }
        if (selected) {
            return this.selectedIconColor;
        }
        return this.unselectedIconColor;
    }

    public final long m2604textColorWaAFU9c(boolean selected, boolean enabled) {
        if (!enabled) {
            return this.disabledTextColor;
        }
        if (selected) {
            return this.selectedTextColor;
        }
        return this.unselectedTextColor;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (other == null || !(other instanceof NavigationItemColors)) {
            return false;
        }
        NavigationItemColors navigationItemColors = (NavigationItemColors) other;
        return Color.m4591equalsimpl0(this.selectedIconColor, navigationItemColors.selectedIconColor) && Color.m4591equalsimpl0(this.unselectedIconColor, navigationItemColors.unselectedIconColor) && Color.m4591equalsimpl0(this.selectedTextColor, navigationItemColors.selectedTextColor) && Color.m4591equalsimpl0(this.unselectedTextColor, navigationItemColors.unselectedTextColor) && Color.m4591equalsimpl0(this.selectedIndicatorColor, navigationItemColors.selectedIndicatorColor) && Color.m4591equalsimpl0(this.disabledIconColor, navigationItemColors.disabledIconColor) && Color.m4591equalsimpl0(this.disabledTextColor, navigationItemColors.disabledTextColor);
    }

    public int hashCode() {
        return (((((((((((Color.m4597hashCodeimpl(this.selectedIconColor) * 31) + Color.m4597hashCodeimpl(this.unselectedIconColor)) * 31) + Color.m4597hashCodeimpl(this.selectedTextColor)) * 31) + Color.m4597hashCodeimpl(this.unselectedTextColor)) * 31) + Color.m4597hashCodeimpl(this.selectedIndicatorColor)) * 31) + Color.m4597hashCodeimpl(this.disabledIconColor)) * 31) + Color.m4597hashCodeimpl(this.disabledTextColor);
    }
}
