package androidx.compose.material.icons.sharp;

import androidx.compose.material.icons.Icons;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.SolidColor;
import androidx.compose.p002ui.graphics.StrokeCap;
import androidx.compose.p002ui.graphics.StrokeJoin;
import androidx.compose.p002ui.graphics.vector.ImageVector;
import androidx.compose.p002ui.graphics.vector.PathBuilder;
import androidx.compose.p002ui.graphics.vector.VectorKt;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\"\u0010\u0010\u0000\u001a\u0004\u0018\u00010\u0001X\u0082\u000e¢\u0006\u0002\n\u0000\"\u0015\u0010\u0002\u001a\u00020\u0001*\u00020\u00038F¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005¨\u0006\u0006"}, d2 = {"_search", "Landroidx/compose/ui/graphics/vector/ImageVector;", "Search", "Landroidx/compose/material/icons/Icons$Sharp;", "getSearch", "(Landroidx/compose/material/icons/Icons$Sharp;)Landroidx/compose/ui/graphics/vector/ImageVector;", "material-icons-core_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SearchKt {
    private static ImageVector _search;

    public static final ImageVector getSearch(Icons.Sharp sharp) {
        ImageVector imageVector = _search;
        if (imageVector != null) {
            Intrinsics.checkNotNull(imageVector);
            return imageVector;
        }
        ImageVector.Builder builder = new ImageVector.Builder("Sharp.Search", Dp.constructor-impl(24.0f), Dp.constructor-impl(24.0f), 24.0f, 24.0f, 0L, 0, false, 96, null);
        int defaultFillType = VectorKt.getDefaultFillType();
        SolidColor solidColor = new SolidColor(Color.INSTANCE.m4616getBlack0d7_KjU(), null);
        int iM4963getButtKaPHkGw = StrokeCap.INSTANCE.m4963getButtKaPHkGw();
        int iM4973getBevelLxFBmk8 = StrokeJoin.INSTANCE.m4973getBevelLxFBmk8();
        PathBuilder pathBuilder = new PathBuilder();
        pathBuilder.moveTo(15.5f, 14.0f);
        pathBuilder.horizontalLineToRelative(-0.79f);
        pathBuilder.lineToRelative(-0.28f, -0.27f);
        pathBuilder.curveTo(15.41f, 12.59f, 16.0f, 11.11f, 16.0f, 9.5f);
        pathBuilder.curveTo(16.0f, 5.91f, 13.09f, 3.0f, 9.5f, 3.0f);
        pathBuilder.reflectiveCurveTo(3.0f, 5.91f, 3.0f, 9.5f);
        pathBuilder.reflectiveCurveTo(5.91f, 16.0f, 9.5f, 16.0f);
        pathBuilder.curveToRelative(1.61f, 0.0f, 3.09f, -0.59f, 4.23f, -1.57f);
        pathBuilder.lineToRelative(0.27f, 0.28f);
        pathBuilder.verticalLineToRelative(0.79f);
        pathBuilder.lineToRelative(5.0f, 4.99f);
        pathBuilder.lineTo(20.49f, 19.0f);
        pathBuilder.lineToRelative(-4.99f, -5.0f);
        pathBuilder.close();
        pathBuilder.moveTo(9.5f, 14.0f);
        pathBuilder.curveTo(7.01f, 14.0f, 5.0f, 11.99f, 5.0f, 9.5f);
        pathBuilder.reflectiveCurveTo(7.01f, 5.0f, 9.5f, 5.0f);
        pathBuilder.reflectiveCurveTo(14.0f, 7.01f, 14.0f, 9.5f);
        pathBuilder.reflectiveCurveTo(11.99f, 14.0f, 9.5f, 14.0f);
        pathBuilder.close();
        ImageVector imageVectorBuild = ImageVector.Builder.m5318addPathoIyEayM$default(builder, pathBuilder.getNodes(), defaultFillType, "", solidColor, 1.0f, null, 1.0f, 1.0f, iM4963getButtKaPHkGw, iM4973getBevelLxFBmk8, 1.0f, 0.0f, 0.0f, 0.0f, 14336, null).build();
        _search = imageVectorBuild;
        Intrinsics.checkNotNull(imageVectorBuild);
        return imageVectorBuild;
    }
}
