package androidx.compose.foundation.gestures;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.FontScaling;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;

@Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\bf\u0018\u00002\u00020\u0001J\u000e\u0010\u0002\u001a\u00020\u0003H¦@¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0005\u001a\u00020\u0006H¦@¢\u0006\u0002\u0010\u0004ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u0007À\u0006\u0003"}, d2 = {"Landroidx/compose/foundation/gestures/PressGestureScope;", "Landroidx/compose/ui/unit/Density;", "awaitRelease", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "tryAwaitRelease", "", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface PressGestureScope extends Density {
    Object awaitRelease(Continuation<? super Unit> continuation);

    Object tryAwaitRelease(Continuation<? super Boolean> continuation);

    public final class CC {
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public static final class DefaultImpls {
        @Deprecated
        public static int m790roundToPxR2X_6o(PressGestureScope pressGestureScope, long j) {
            return Density.-CC.$default$roundToPx--R2X_6o(pressGestureScope, j);
        }

        @Deprecated
        public static int m791roundToPx0680j_4(PressGestureScope pressGestureScope, float f) {
            return Density.-CC.$default$roundToPx-0680j_4(pressGestureScope, f);
        }

        @Deprecated
        public static float m792toDpGaN1DYA(PressGestureScope pressGestureScope, long j) {
            return FontScaling.-CC.$default$toDp-GaN1DYA(pressGestureScope, j);
        }

        @Deprecated
        public static float m793toDpu2uoSUM(PressGestureScope pressGestureScope, float f) {
            return Density.-CC.$default$toDp-u2uoSUM(pressGestureScope, f);
        }

        @Deprecated
        public static float m794toDpu2uoSUM(PressGestureScope pressGestureScope, int i) {
            return Density.-CC.$default$toDp-u2uoSUM(pressGestureScope, i);
        }

        @Deprecated
        public static long m795toDpSizekrfVVM(PressGestureScope pressGestureScope, long j) {
            return Density.-CC.$default$toDpSize-k-rfVVM(pressGestureScope, j);
        }

        @Deprecated
        public static float m796toPxR2X_6o(PressGestureScope pressGestureScope, long j) {
            return Density.-CC.$default$toPx--R2X_6o(pressGestureScope, j);
        }

        @Deprecated
        public static float m797toPx0680j_4(PressGestureScope pressGestureScope, float f) {
            return Density.-CC.$default$toPx-0680j_4(pressGestureScope, f);
        }

        @Deprecated
        public static Rect toRect(PressGestureScope pressGestureScope, DpRect dpRect) {
            return Density.-CC.$default$toRect(pressGestureScope, dpRect);
        }

        @Deprecated
        public static long m798toSizeXkaWNTQ(PressGestureScope pressGestureScope, long j) {
            return Density.-CC.$default$toSize-XkaWNTQ(pressGestureScope, j);
        }

        @Deprecated
        public static long m799toSp0xMU5do(PressGestureScope pressGestureScope, float f) {
            return FontScaling.-CC.$default$toSp-0xMU5do(pressGestureScope, f);
        }

        @Deprecated
        public static long m800toSpkPz2Gy4(PressGestureScope pressGestureScope, float f) {
            return Density.-CC.$default$toSp-kPz2Gy4(pressGestureScope, f);
        }

        @Deprecated
        public static long m801toSpkPz2Gy4(PressGestureScope pressGestureScope, int i) {
            return Density.-CC.$default$toSp-kPz2Gy4(pressGestureScope, i);
        }
    }
}
