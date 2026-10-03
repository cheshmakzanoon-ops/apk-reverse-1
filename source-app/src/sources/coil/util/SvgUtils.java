package coil.util;

import android.graphics.Bitmap;
import android.os.Build;
import androidx.compose.ui.graphics.Api26Bitmap$;
import androidx.constraintlayout.widget.ConstraintLayout;
import coil.size.Dimension;
import coil.size.Scale;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import okio.BufferedSource;
import okio.ByteString;

@Metadata(d1 = {"\u00002\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a$\u0010\u0004\u001a\u00020\u0005*\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u00052\u0006\u0010\n\u001a\u00020\u0005H\u0000\u001a\u0014\u0010\u000b\u001a\u00020\f*\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0000\u001a\u000e\u0010\u0010\u001a\u00020\u0002*\u0004\u0018\u00010\u0002H\u0000\"\u0018\u0010\u0000\u001a\u00020\u0001*\u00020\u00028@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0000\u0010\u0003¨\u0006\u0011"}, d2 = {"isHardware", "", "Landroid/graphics/Bitmap$Config;", "(Landroid/graphics/Bitmap$Config;)Z", "indexOf", "", "Lokio/BufferedSource;", "bytes", "Lokio/ByteString;", "fromIndex", "toIndex", "toPx", "", "Lcoil/size/Dimension;", "scale", "Lcoil/size/Scale;", "toSoftware", "coil-svg_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class SvgUtils {

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[Scale.values().length];
            try {
                iArr[Scale.FILL.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[Scale.FIT.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final long indexOf(BufferedSource bufferedSource, ByteString byteString, long j, long j2) {
        if (byteString.size() <= 0) {
            throw new IllegalArgumentException("bytes is empty".toString());
        }
        byte b = byteString.getByte(0);
        long size = j2 - ((long) byteString.size());
        long j3 = j;
        while (j3 < size) {
            long jIndexOf = bufferedSource.indexOf(b, j3, size);
            if (jIndexOf == -1 || bufferedSource.rangeEquals(jIndexOf, byteString)) {
                return jIndexOf;
            }
            j3 = jIndexOf + 1;
        }
        return -1L;
    }

    public static final boolean isHardware(Bitmap.Config config) {
        return Build.VERSION.SDK_INT >= 26 && config == Api26Bitmap$.ExternalSyntheticApiModelOutline0.m();
    }

    public static final Bitmap.Config toSoftware(Bitmap.Config config) {
        return (config == null || isHardware(config)) ? Bitmap.Config.ARGB_8888 : config;
    }

    public static final float toPx(Dimension dimension, Scale scale) throws NoWhenBranchMatchedException {
        if (dimension instanceof Dimension.Pixels) {
            return ((Dimension.Pixels) dimension).px;
        }
        int i = WhenMappings.$EnumSwitchMapping$0[scale.ordinal()];
        if (i == 1) {
            return Float.MIN_VALUE;
        }
        if (i == 2) {
            return Float.MAX_VALUE;
        }
        throw new NoWhenBranchMatchedException();
    }
}
