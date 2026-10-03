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

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\bg\u0018\u00002\u00020\u0001J\u0018\u0010\u0011\u001a\u00020\u00032\b\b\u0002\u0010\u0012\u001a\u00020\u0013H¦@¢\u0006\u0002\u0010\u0014JE\u0010\u0015\u001a\u0002H\u0016\"\u0004\b\u0000\u0010\u00162\u0006\u0010\u0017\u001a\u00020\u00182'\u0010\u0019\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0000\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00160\u001b\u0012\u0006\u0012\u0004\u0018\u00010\u001c0\u001a¢\u0006\u0002\b\u001dH\u0096@¢\u0006\u0002\u0010\u001eJG\u0010\u001f\u001a\u0004\u0018\u0001H\u0016\"\u0004\b\u0000\u0010\u00162\u0006\u0010\u0017\u001a\u00020\u00182'\u0010\u0019\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0000\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00160\u001b\u0012\u0006\u0012\u0004\u0018\u00010\u001c0\u001a¢\u0006\u0002\b\u001dH\u0096@¢\u0006\u0002\u0010\u001eR\u0012\u0010\u0002\u001a\u00020\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005R\u001a\u0010\u0006\u001a\u00020\u00078VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\b\u0010\tR\u0018\u0010\n\u001a\u00020\u000bX¦\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\f\u0010\tR\u0012\u0010\r\u001a\u00020\u000eX¦\u0004¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010ø\u0001\u0002\u0082\u0002\u0011\n\u0005\b¡\u001e0\u0001\n\u0002\b!\n\u0004\b!0\u0001¨\u0006 À\u0006\u0003"}, d2 = {"Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;", "Landroidx/compose/ui/unit/Density;", "currentEvent", "Landroidx/compose/ui/input/pointer/PointerEvent;", "getCurrentEvent", "()Landroidx/compose/ui/input/pointer/PointerEvent;", "extendedTouchPadding", "Landroidx/compose/ui/geometry/Size;", "getExtendedTouchPadding-NH-jbRc", "()J", "size", "Landroidx/compose/ui/unit/IntSize;", "getSize-YbymL2g", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "getViewConfiguration", "()Landroidx/compose/ui/platform/ViewConfiguration;", "awaitPointerEvent", "pass", "Landroidx/compose/ui/input/pointer/PointerEventPass;", "(Landroidx/compose/ui/input/pointer/PointerEventPass;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "withTimeout", "T", "timeMillis", "", "block", "Lkotlin/Function2;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(JLkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "withTimeoutOrNull", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface AwaitPointerEventScope extends Density {
    Object awaitPointerEvent(PointerEventPass pointerEventPass, Continuation<? super PointerEvent> continuation);

    PointerEvent getCurrentEvent();

    long mo5742getExtendedTouchPaddingNHjbRc();

    long mo5743getSizeYbymL2g();

    ViewConfiguration getViewConfiguration();

    <T> Object withTimeout(long j, Function2<? super AwaitPointerEventScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation);

    <T> Object withTimeoutOrNull(long j, Function2<? super AwaitPointerEventScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation);

    public final class CC {
        public static long m5744$default$getExtendedTouchPaddingNHjbRc(AwaitPointerEventScope _this) {
            return Size.INSTANCE.m4424getZeroNHjbRc();
        }

        public static Object awaitPointerEvent$default(AwaitPointerEventScope awaitPointerEventScope, PointerEventPass pointerEventPass, Continuation continuation, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: awaitPointerEvent");
            }
            if ((i & 1) != 0) {
                pointerEventPass = PointerEventPass.Main;
            }
            return awaitPointerEventScope.awaitPointerEvent(pointerEventPass, continuation);
        }

        public static <T> Object withTimeoutOrNull$suspendImpl(AwaitPointerEventScope awaitPointerEventScope, long j, Function2<? super AwaitPointerEventScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) {
            return function2.invoke(awaitPointerEventScope, continuation);
        }

        public static <T> Object withTimeout$suspendImpl(AwaitPointerEventScope awaitPointerEventScope, long j, Function2<? super AwaitPointerEventScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) {
            return function2.invoke(awaitPointerEventScope, continuation);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public static final class DefaultImpls {
        @Deprecated
        public static int m5759roundToPxR2X_6o(AwaitPointerEventScope awaitPointerEventScope, long j) {
            return Density.-CC.$default$roundToPx--R2X_6o(awaitPointerEventScope, j);
        }

        @Deprecated
        public static int m5760roundToPx0680j_4(AwaitPointerEventScope awaitPointerEventScope, float f) {
            return Density.-CC.$default$roundToPx-0680j_4(awaitPointerEventScope, f);
        }

        @Deprecated
        public static float m5761toDpGaN1DYA(AwaitPointerEventScope awaitPointerEventScope, long j) {
            return FontScaling.-CC.$default$toDp-GaN1DYA(awaitPointerEventScope, j);
        }

        @Deprecated
        public static float m5762toDpu2uoSUM(AwaitPointerEventScope awaitPointerEventScope, float f) {
            return Density.-CC.$default$toDp-u2uoSUM(awaitPointerEventScope, f);
        }

        @Deprecated
        public static float m5763toDpu2uoSUM(AwaitPointerEventScope awaitPointerEventScope, int i) {
            return Density.-CC.$default$toDp-u2uoSUM(awaitPointerEventScope, i);
        }

        @Deprecated
        public static long m5764toDpSizekrfVVM(AwaitPointerEventScope awaitPointerEventScope, long j) {
            return Density.-CC.$default$toDpSize-k-rfVVM(awaitPointerEventScope, j);
        }

        @Deprecated
        public static float m5765toPxR2X_6o(AwaitPointerEventScope awaitPointerEventScope, long j) {
            return Density.-CC.$default$toPx--R2X_6o(awaitPointerEventScope, j);
        }

        @Deprecated
        public static float m5766toPx0680j_4(AwaitPointerEventScope awaitPointerEventScope, float f) {
            return Density.-CC.$default$toPx-0680j_4(awaitPointerEventScope, f);
        }

        @Deprecated
        public static Rect toRect(AwaitPointerEventScope awaitPointerEventScope, DpRect dpRect) {
            return Density.-CC.$default$toRect(awaitPointerEventScope, dpRect);
        }

        @Deprecated
        public static long m5767toSizeXkaWNTQ(AwaitPointerEventScope awaitPointerEventScope, long j) {
            return Density.-CC.$default$toSize-XkaWNTQ(awaitPointerEventScope, j);
        }

        @Deprecated
        public static long m5768toSp0xMU5do(AwaitPointerEventScope awaitPointerEventScope, float f) {
            return FontScaling.-CC.$default$toSp-0xMU5do(awaitPointerEventScope, f);
        }

        @Deprecated
        public static long m5769toSpkPz2Gy4(AwaitPointerEventScope awaitPointerEventScope, float f) {
            return Density.-CC.$default$toSp-kPz2Gy4(awaitPointerEventScope, f);
        }

        @Deprecated
        public static long m5770toSpkPz2Gy4(AwaitPointerEventScope awaitPointerEventScope, int i) {
            return Density.-CC.$default$toSp-kPz2Gy4(awaitPointerEventScope, i);
        }

        @Deprecated
        public static long m5758getExtendedTouchPaddingNHjbRc(AwaitPointerEventScope awaitPointerEventScope) {
            return CC.m5744$default$getExtendedTouchPaddingNHjbRc(awaitPointerEventScope);
        }

        @Deprecated
        public static <T> Object withTimeoutOrNull(AwaitPointerEventScope awaitPointerEventScope, long j, Function2<? super AwaitPointerEventScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) {
            return CC.withTimeoutOrNull$suspendImpl(awaitPointerEventScope, j, function2, continuation);
        }

        @Deprecated
        public static <T> Object withTimeout(AwaitPointerEventScope awaitPointerEventScope, long j, Function2<? super AwaitPointerEventScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) {
            return CC.withTimeout$suspendImpl(awaitPointerEventScope, j, function2, continuation);
        }
    }
}
