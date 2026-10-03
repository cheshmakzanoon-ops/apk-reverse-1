package androidx.compose.p002ui.input.pointer;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.platform.ViewConfiguration;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.FontScaling;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bf\u0018\u00002\u00020\u0001J=\u0010\u0016\u001a\u0002H\u0017\"\u0004\b\u0000\u0010\u00172'\u0010\u0018\u001a#\b\u0001\u0012\u0004\u0012\u00020\u001a\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00170\u001b\u0012\u0006\u0012\u0004\u0018\u00010\u001c0\u0019¢\u0006\u0002\b\u001dH¦@¢\u0006\u0002\u0010\u001eR\u001a\u0010\u0002\u001a\u00020\u00038VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005R*\u0010\b\u001a\u00020\u00072\u0006\u0010\u0006\u001a\u00020\u00078V@VX\u0096\u000e¢\u0006\u0012\u0012\u0004\b\t\u0010\n\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u0018\u0010\u000f\u001a\u00020\u0010X¦\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0005R\u0012\u0010\u0012\u001a\u00020\u0013X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0015ø\u0001\u0002\u0082\u0002\u0011\n\u0005\b¡\u001e0\u0001\n\u0002\b!\n\u0004\b!0\u0001¨\u0006\u001fÀ\u0006\u0003"}, d2 = {"Landroidx/compose/ui/input/pointer/PointerInputScope;", "Landroidx/compose/ui/unit/Density;", "extendedTouchPadding", "Landroidx/compose/ui/geometry/Size;", "getExtendedTouchPadding-NH-jbRc", "()J", "<anonymous parameter 0>", "", "interceptOutOfBoundsChildEvents", "getInterceptOutOfBoundsChildEvents$annotations", "()V", "getInterceptOutOfBoundsChildEvents", "()Z", "setInterceptOutOfBoundsChildEvents", "(Z)V", "size", "Landroidx/compose/ui/unit/IntSize;", "getSize-YbymL2g", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "getViewConfiguration", "()Landroidx/compose/ui/platform/ViewConfiguration;", "awaitPointerEventScope", "R", "block", "Lkotlin/Function2;", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface PointerInputScope extends Density {
    <R> Object awaitPointerEventScope(Function2<? super AwaitPointerEventScope, ? super Continuation<? super R>, ? extends Object> function2, Continuation<? super R> continuation);

    long mo667getExtendedTouchPaddingNHjbRc();

    boolean getInterceptOutOfBoundsChildEvents();

    long mo668getSizeYbymL2g();

    ViewConfiguration getViewConfiguration();

    void setInterceptOutOfBoundsChildEvents(boolean z);

    public final class CC {
        public static boolean $default$getInterceptOutOfBoundsChildEvents(PointerInputScope _this) {
            return false;
        }

        public static void $default$setInterceptOutOfBoundsChildEvents(PointerInputScope _this, boolean z) {
        }

        public static long m5871$default$getExtendedTouchPaddingNHjbRc(PointerInputScope _this) {
            return Size.INSTANCE.m4424getZeroNHjbRc();
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public static final class DefaultImpls {
        public static void getInterceptOutOfBoundsChildEvents$annotations() {
        }

        @Deprecated
        public static int m5886roundToPxR2X_6o(PointerInputScope pointerInputScope, long j) {
            return Density.-CC.$default$roundToPx--R2X_6o(pointerInputScope, j);
        }

        @Deprecated
        public static int m5887roundToPx0680j_4(PointerInputScope pointerInputScope, float f) {
            return Density.-CC.$default$roundToPx-0680j_4(pointerInputScope, f);
        }

        @Deprecated
        public static float m5888toDpGaN1DYA(PointerInputScope pointerInputScope, long j) {
            return FontScaling.-CC.$default$toDp-GaN1DYA(pointerInputScope, j);
        }

        @Deprecated
        public static float m5889toDpu2uoSUM(PointerInputScope pointerInputScope, float f) {
            return Density.-CC.$default$toDp-u2uoSUM(pointerInputScope, f);
        }

        @Deprecated
        public static float m5890toDpu2uoSUM(PointerInputScope pointerInputScope, int i) {
            return Density.-CC.$default$toDp-u2uoSUM(pointerInputScope, i);
        }

        @Deprecated
        public static long m5891toDpSizekrfVVM(PointerInputScope pointerInputScope, long j) {
            return Density.-CC.$default$toDpSize-k-rfVVM(pointerInputScope, j);
        }

        @Deprecated
        public static float m5892toPxR2X_6o(PointerInputScope pointerInputScope, long j) {
            return Density.-CC.$default$toPx--R2X_6o(pointerInputScope, j);
        }

        @Deprecated
        public static float m5893toPx0680j_4(PointerInputScope pointerInputScope, float f) {
            return Density.-CC.$default$toPx-0680j_4(pointerInputScope, f);
        }

        @Deprecated
        public static Rect toRect(PointerInputScope pointerInputScope, DpRect dpRect) {
            return Density.-CC.$default$toRect(pointerInputScope, dpRect);
        }

        @Deprecated
        public static long m5894toSizeXkaWNTQ(PointerInputScope pointerInputScope, long j) {
            return Density.-CC.$default$toSize-XkaWNTQ(pointerInputScope, j);
        }

        @Deprecated
        public static long m5895toSp0xMU5do(PointerInputScope pointerInputScope, float f) {
            return FontScaling.-CC.$default$toSp-0xMU5do(pointerInputScope, f);
        }

        @Deprecated
        public static long m5896toSpkPz2Gy4(PointerInputScope pointerInputScope, float f) {
            return Density.-CC.$default$toSp-kPz2Gy4(pointerInputScope, f);
        }

        @Deprecated
        public static long m5897toSpkPz2Gy4(PointerInputScope pointerInputScope, int i) {
            return Density.-CC.$default$toSp-kPz2Gy4(pointerInputScope, i);
        }

        @Deprecated
        public static long m5885getExtendedTouchPaddingNHjbRc(PointerInputScope pointerInputScope) {
            return CC.m5871$default$getExtendedTouchPaddingNHjbRc(pointerInputScope);
        }

        @Deprecated
        public static boolean getInterceptOutOfBoundsChildEvents(PointerInputScope pointerInputScope) {
            return CC.$default$getInterceptOutOfBoundsChildEvents(pointerInputScope);
        }

        @Deprecated
        public static void setInterceptOutOfBoundsChildEvents(PointerInputScope pointerInputScope, boolean z) {
            CC.$default$setInterceptOutOfBoundsChildEvents(pointerInputScope, z);
        }
    }
}
