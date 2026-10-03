package androidx.compose.p002ui.graphics;

import android.graphics.Shader;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0007\u0018\u00002\u00020\u0001BA\b\u0000\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0010\b\u0002\u0010\u0005\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0003\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\b\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\u001e\u0010\u0013\u001a\u00060\u0014j\u0002`\u00152\u0006\u0010\u0016\u001a\u00020\u000fH\u0016ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001cH\u0096\u0002J\b\u0010\u001d\u001a\u00020\u001eH\u0016J\b\u0010\u001f\u001a\u00020 H\u0016R\u0014\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\t\u001a\u00020\bX\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\rR\u001a\u0010\u000e\u001a\u00020\u000f8VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R\u0016\u0010\u0007\u001a\u00020\bX\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\rR\u0016\u0010\u0005\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\n\u001a\u00020\u000bX\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0012\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006!"}, d2 = {"Landroidx/compose/ui/graphics/LinearGradient;", "Landroidx/compose/ui/graphics/ShaderBrush;", "colors", "", "Landroidx/compose/ui/graphics/Color;", "stops", "", "start", "Landroidx/compose/ui/geometry/Offset;", "end", "tileMode", "Landroidx/compose/ui/graphics/TileMode;", "(Ljava/util/List;Ljava/util/List;JJILkotlin/jvm/internal/DefaultConstructorMarker;)V", "J", "intrinsicSize", "Landroidx/compose/ui/geometry/Size;", "getIntrinsicSize-NH-jbRc", "()J", "I", "createShader", "Landroid/graphics/Shader;", "Landroidx/compose/ui/graphics/Shader;", "size", "createShader-uvyYCjk", "(J)Landroid/graphics/Shader;", "equals", "", "other", "", "hashCode", "", "toString", "", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LinearGradient extends ShaderBrush {
    private final List<Color> colors;
    private final long end;
    private final long start;
    private final List<Float> stops;
    private final int tileMode;

    public LinearGradient(List list, List list2, long j, long j2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(list, list2, j, j2, i);
    }

    public LinearGradient(List list, List list2, long j, long j2, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(list, (i2 & 2) != 0 ? null : list2, j, j2, (i2 & 16) != 0 ? TileMode.INSTANCE.m4983getClamp3opZhB0() : i, null);
    }

    private LinearGradient(List<Color> list, List<Float> list2, long j, long j2, int i) {
        this.colors = list;
        this.stops = list2;
        this.start = j;
        this.end = j2;
        this.tileMode = i;
    }

    @Override
    public long getIntrinsicSize() {
        float fAbs;
        float fM4346getXimpl = Offset.m4346getXimpl(this.start);
        float fAbs2 = Float.NaN;
        if (Float.isInfinite(fM4346getXimpl) || Float.isNaN(fM4346getXimpl)) {
            fAbs = Float.NaN;
        } else {
            float fM4346getXimpl2 = Offset.m4346getXimpl(this.end);
            if (Float.isInfinite(fM4346getXimpl2) || Float.isNaN(fM4346getXimpl2)) {
                fAbs = Float.NaN;
            } else {
                fAbs = Math.abs(Offset.m4346getXimpl(this.start) - Offset.m4346getXimpl(this.end));
            }
        }
        float fM4347getYimpl = Offset.m4347getYimpl(this.start);
        if (!Float.isInfinite(fM4347getYimpl) && !Float.isNaN(fM4347getYimpl)) {
            float fM4347getYimpl2 = Offset.m4347getYimpl(this.end);
            if (!Float.isInfinite(fM4347getYimpl2) && !Float.isNaN(fM4347getYimpl2)) {
                fAbs2 = Math.abs(Offset.m4347getYimpl(this.start) - Offset.m4347getYimpl(this.end));
            }
        }
        return SizeKt.Size(fAbs, fAbs2);
    }

    @Override
    public Shader mo4559createShaderuvyYCjk(long size) {
        return ShaderKt.m4925LinearGradientShaderVjE6UOU(OffsetKt.Offset(Offset.m4346getXimpl(this.start) == Float.POSITIVE_INFINITY ? Size.m4415getWidthimpl(size) : Offset.m4346getXimpl(this.start), Offset.m4347getYimpl(this.start) == Float.POSITIVE_INFINITY ? Size.m4412getHeightimpl(size) : Offset.m4347getYimpl(this.start)), OffsetKt.Offset(Offset.m4346getXimpl(this.end) == Float.POSITIVE_INFINITY ? Size.m4415getWidthimpl(size) : Offset.m4346getXimpl(this.end), Offset.m4347getYimpl(this.end) == Float.POSITIVE_INFINITY ? Size.m4412getHeightimpl(size) : Offset.m4347getYimpl(this.end)), this.colors, this.stops, this.tileMode);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof LinearGradient)) {
            return false;
        }
        LinearGradient linearGradient = (LinearGradient) other;
        return Intrinsics.areEqual(this.colors, linearGradient.colors) && Intrinsics.areEqual(this.stops, linearGradient.stops) && Offset.m4343equalsimpl0(this.start, linearGradient.start) && Offset.m4343equalsimpl0(this.end, linearGradient.end) && TileMode.m4979equalsimpl0(this.tileMode, linearGradient.tileMode);
    }

    public int hashCode() {
        int iHashCode = this.colors.hashCode() * 31;
        List<Float> list = this.stops;
        return ((((((iHashCode + (list != null ? list.hashCode() : 0)) * 31) + Offset.m4348hashCodeimpl(this.start)) * 31) + Offset.m4348hashCodeimpl(this.end)) * 31) + TileMode.m4980hashCodeimpl(this.tileMode);
    }

    public String toString() {
        String str;
        String str2 = "";
        if (OffsetKt.m4363isFinitek4lQ0M(this.start)) {
            str = "start=" + ((Object) Offset.m4354toStringimpl(this.start)) + ", ";
        } else {
            str = "";
        }
        if (OffsetKt.m4363isFinitek4lQ0M(this.end)) {
            str2 = "end=" + ((Object) Offset.m4354toStringimpl(this.end)) + ", ";
        }
        return "LinearGradient(colors=" + this.colors + ", stops=" + this.stops + ", " + str + str2 + "tileMode=" + ((Object) TileMode.m4981toStringimpl(this.tileMode)) + ')';
    }
}
