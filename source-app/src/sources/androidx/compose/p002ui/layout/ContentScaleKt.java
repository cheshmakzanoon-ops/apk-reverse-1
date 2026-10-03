package androidx.compose.p002ui.layout;

import androidx.compose.p002ui.geometry.Size;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\u001a\"\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0003H\u0002ø\u0001\u0000¢\u0006\u0004\b\u0005\u0010\u0006\u001a\"\u0010\u0007\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0003H\u0002ø\u0001\u0000¢\u0006\u0004\b\b\u0010\u0006\u001a\"\u0010\t\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0003H\u0002ø\u0001\u0000¢\u0006\u0004\b\n\u0010\u0006\u001a\"\u0010\u000b\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0003H\u0002ø\u0001\u0000¢\u0006\u0004\b\f\u0010\u0006\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\r"}, d2 = {"computeFillHeight", "", "srcSize", "Landroidx/compose/ui/geometry/Size;", "dstSize", "computeFillHeight-iLBOSCw", "(JJ)F", "computeFillMaxDimension", "computeFillMaxDimension-iLBOSCw", "computeFillMinDimension", "computeFillMinDimension-iLBOSCw", "computeFillWidth", "computeFillWidth-iLBOSCw", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ContentScaleKt {
    public static final float m6023computeFillMaxDimensioniLBOSCw(long j, long j2) {
        return Math.max(m6025computeFillWidthiLBOSCw(j, j2), m6022computeFillHeightiLBOSCw(j, j2));
    }

    public static final float m6024computeFillMinDimensioniLBOSCw(long j, long j2) {
        return Math.min(m6025computeFillWidthiLBOSCw(j, j2), m6022computeFillHeightiLBOSCw(j, j2));
    }

    public static final float m6025computeFillWidthiLBOSCw(long j, long j2) {
        return Size.m4415getWidthimpl(j2) / Size.m4415getWidthimpl(j);
    }

    public static final float m6022computeFillHeightiLBOSCw(long j, long j2) {
        return Size.m4412getHeightimpl(j2) / Size.m4412getHeightimpl(j);
    }
}
