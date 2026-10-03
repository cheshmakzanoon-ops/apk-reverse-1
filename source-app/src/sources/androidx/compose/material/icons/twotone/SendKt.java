package androidx.compose.material.icons.twotone;

import androidx.compose.material.icons.Icons;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.SolidColor;
import androidx.compose.p002ui.graphics.StrokeCap;
import androidx.compose.p002ui.graphics.StrokeJoin;
import androidx.compose.p002ui.graphics.vector.ImageVector;
import androidx.compose.p002ui.graphics.vector.PathBuilder;
import androidx.compose.p002ui.graphics.vector.VectorKt;
import androidx.compose.ui.unit.Dp;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\"\u0010\u0010\u0000\u001a\u0004\u0018\u00010\u0001X\u0082\u000e¢\u0006\u0002\n\u0000\"\u001e\u0010\u0002\u001a\u00020\u0001*\u00020\u00038FX\u0087\u0004¢\u0006\f\u0012\u0004\b\u0004\u0010\u0005\u001a\u0004\b\u0006\u0010\u0007¨\u0006\b"}, d2 = {"_send", "Landroidx/compose/ui/graphics/vector/ImageVector;", "Send", "Landroidx/compose/material/icons/Icons$TwoTone;", "getSend$annotations", "(Landroidx/compose/material/icons/Icons$TwoTone;)V", "getSend", "(Landroidx/compose/material/icons/Icons$TwoTone;)Landroidx/compose/ui/graphics/vector/ImageVector;", "material-icons-core_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SendKt {
    private static ImageVector _send;

    @Deprecated(message = "Use the AutoMirrored version at Icons.AutoMirrored.TwoTone.Send", replaceWith = @ReplaceWith(expression = "Icons.AutoMirrored.TwoTone.Send", imports = {"androidx.compose.material.icons.automirrored.twotone.Send"}))
    public static void getSend$annotations(Icons.TwoTone twoTone) {
    }

    public static final ImageVector getSend(Icons.TwoTone twoTone) {
        ImageVector imageVector = _send;
        if (imageVector != null) {
            Intrinsics.checkNotNull(imageVector);
            return imageVector;
        }
        ImageVector.Builder builder = new ImageVector.Builder("TwoTone.Send", Dp.constructor-impl(24.0f), Dp.constructor-impl(24.0f), 24.0f, 24.0f, 0L, 0, false, 96, null);
        int defaultFillType = VectorKt.getDefaultFillType();
        SolidColor solidColor = new SolidColor(Color.INSTANCE.m4616getBlack0d7_KjU(), null);
        int iM4963getButtKaPHkGw = StrokeCap.INSTANCE.m4963getButtKaPHkGw();
        int iM4973getBevelLxFBmk8 = StrokeJoin.INSTANCE.m4973getBevelLxFBmk8();
        PathBuilder pathBuilder = new PathBuilder();
        pathBuilder.moveTo(4.0f, 8.25f);
        pathBuilder.lineToRelative(7.51f, 1.0f);
        pathBuilder.lineToRelative(-7.5f, -3.22f);
        pathBuilder.close();
        pathBuilder.moveTo(4.01f, 17.97f);
        pathBuilder.lineToRelative(7.5f, -3.22f);
        pathBuilder.lineToRelative(-7.51f, 1.0f);
        pathBuilder.close();
        ImageVector.Builder.m5318addPathoIyEayM$default(builder, pathBuilder.getNodes(), defaultFillType, "", solidColor, 0.3f, null, 0.3f, 1.0f, iM4963getButtKaPHkGw, iM4973getBevelLxFBmk8, 1.0f, 0.0f, 0.0f, 0.0f, 14336, null);
        int defaultFillType2 = VectorKt.getDefaultFillType();
        SolidColor solidColor2 = new SolidColor(Color.INSTANCE.m4616getBlack0d7_KjU(), null);
        int iM4963getButtKaPHkGw2 = StrokeCap.INSTANCE.m4963getButtKaPHkGw();
        int iM4973getBevelLxFBmk9 = StrokeJoin.INSTANCE.m4973getBevelLxFBmk8();
        PathBuilder pathBuilder2 = new PathBuilder();
        pathBuilder2.moveTo(2.01f, 3.0f);
        pathBuilder2.lineTo(2.0f, 10.0f);
        pathBuilder2.lineToRelative(15.0f, 2.0f);
        pathBuilder2.lineToRelative(-15.0f, 2.0f);
        pathBuilder2.lineToRelative(0.01f, 7.0f);
        pathBuilder2.lineTo(23.0f, 12.0f);
        pathBuilder2.lineTo(2.01f, 3.0f);
        pathBuilder2.close();
        pathBuilder2.moveTo(4.0f, 8.25f);
        pathBuilder2.lineTo(4.0f, 6.03f);
        pathBuilder2.lineToRelative(7.51f, 3.22f);
        pathBuilder2.lineToRelative(-7.51f, -1.0f);
        pathBuilder2.close();
        pathBuilder2.moveTo(4.01f, 17.97f);
        pathBuilder2.verticalLineToRelative(-2.22f);
        pathBuilder2.lineToRelative(7.51f, -1.0f);
        pathBuilder2.lineToRelative(-7.51f, 3.22f);
        pathBuilder2.close();
        ImageVector imageVectorBuild = ImageVector.Builder.m5318addPathoIyEayM$default(builder, pathBuilder2.getNodes(), defaultFillType2, "", solidColor2, 1.0f, null, 1.0f, 1.0f, iM4963getButtKaPHkGw2, iM4973getBevelLxFBmk9, 1.0f, 0.0f, 0.0f, 0.0f, 14336, null).build();
        _send = imageVectorBuild;
        Intrinsics.checkNotNull(imageVectorBuild);
        return imageVectorBuild;
    }
}
