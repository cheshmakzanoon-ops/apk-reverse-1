package androidx.compose.p002ui.graphics.drawscope;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.ImageBitmap;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.FontScaling;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\bf\u0018\u00002\u00020\u0001J\b\u0010\u0002\u001a\u00020\u0003H&ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u0004À\u0006\u0003"}, d2 = {"Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "drawContent", "", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface ContentDrawScope extends DrawScope {
    void drawContent();

    public final class CC {
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public static final class DefaultImpls {
        @Deprecated
        public static void m5127drawImageAZ2fEMs(ContentDrawScope contentDrawScope, ImageBitmap imageBitmap, long j, long j2, long j3, long j4, float f, DrawStyle drawStyle, ColorFilter colorFilter, int i, int i2) {
            DrawScope.CC.m5169drawImageAZ2fEMs$default(contentDrawScope, imageBitmap, j, j2, j3, j4, f, drawStyle, colorFilter, i, 0, Fields.RotationY, null);
        }

        @Deprecated
        public static long m5128getCenterF1C5BW0(ContentDrawScope contentDrawScope) {
            return DrawScope.CC.m5144$default$getCenterF1C5BW0(contentDrawScope);
        }

        @Deprecated
        public static long m5129getSizeNHjbRc(ContentDrawScope contentDrawScope) {
            return DrawScope.CC.m5145$default$getSizeNHjbRc(contentDrawScope);
        }

        @Deprecated
        public static void m5130recordJVtK1S4(ContentDrawScope contentDrawScope, GraphicsLayer graphicsLayer, long j, Function1<? super DrawScope, Unit> function1) {
            DrawScope.CC.m5146$default$recordJVtK1S4(contentDrawScope, graphicsLayer, j, function1);
        }

        @Deprecated
        public static int m5131roundToPxR2X_6o(ContentDrawScope contentDrawScope, long j) {
            return Density.-CC.$default$roundToPx--R2X_6o(contentDrawScope, j);
        }

        @Deprecated
        public static int m5132roundToPx0680j_4(ContentDrawScope contentDrawScope, float f) {
            return Density.-CC.$default$roundToPx-0680j_4(contentDrawScope, f);
        }

        @Deprecated
        public static float m5133toDpGaN1DYA(ContentDrawScope contentDrawScope, long j) {
            return FontScaling.-CC.$default$toDp-GaN1DYA(contentDrawScope, j);
        }

        @Deprecated
        public static float m5134toDpu2uoSUM(ContentDrawScope contentDrawScope, float f) {
            return Density.-CC.$default$toDp-u2uoSUM(contentDrawScope, f);
        }

        @Deprecated
        public static float m5135toDpu2uoSUM(ContentDrawScope contentDrawScope, int i) {
            return Density.-CC.$default$toDp-u2uoSUM(contentDrawScope, i);
        }

        @Deprecated
        public static long m5136toDpSizekrfVVM(ContentDrawScope contentDrawScope, long j) {
            return Density.-CC.$default$toDpSize-k-rfVVM(contentDrawScope, j);
        }

        @Deprecated
        public static float m5137toPxR2X_6o(ContentDrawScope contentDrawScope, long j) {
            return Density.-CC.$default$toPx--R2X_6o(contentDrawScope, j);
        }

        @Deprecated
        public static float m5138toPx0680j_4(ContentDrawScope contentDrawScope, float f) {
            return Density.-CC.$default$toPx-0680j_4(contentDrawScope, f);
        }

        @Deprecated
        public static Rect toRect(ContentDrawScope contentDrawScope, DpRect dpRect) {
            return Density.-CC.$default$toRect(contentDrawScope, dpRect);
        }

        @Deprecated
        public static long m5139toSizeXkaWNTQ(ContentDrawScope contentDrawScope, long j) {
            return Density.-CC.$default$toSize-XkaWNTQ(contentDrawScope, j);
        }

        @Deprecated
        public static long m5140toSp0xMU5do(ContentDrawScope contentDrawScope, float f) {
            return FontScaling.-CC.$default$toSp-0xMU5do(contentDrawScope, f);
        }

        @Deprecated
        public static long m5141toSpkPz2Gy4(ContentDrawScope contentDrawScope, float f) {
            return Density.-CC.$default$toSp-kPz2Gy4(contentDrawScope, f);
        }

        @Deprecated
        public static long m5142toSpkPz2Gy4(ContentDrawScope contentDrawScope, int i) {
            return Density.-CC.$default$toSp-kPz2Gy4(contentDrawScope, i);
        }
    }
}
