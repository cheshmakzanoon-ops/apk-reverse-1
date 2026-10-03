package androidx.compose.foundation.gestures;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerEvent;
import androidx.compose.p002ui.input.pointer.PointerEventKt;
import androidx.compose.p002ui.input.pointer.PointerEventPass;
import androidx.compose.p002ui.input.pointer.PointerEventTimeoutCancellationException;
import androidx.compose.p002ui.input.pointer.PointerId;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.p002ui.input.pointer.PointerType;
import androidx.compose.p002ui.platform.ViewConfiguration;
import androidx.compose.ui.unit.Dp;
import java.util.List;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000|\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a!\u0010\u0006\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0086@ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\f\u001a5\u0010\r\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0012\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00100\u000fH\u0082Hø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012\u001a!\u0010\u0013\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0086@ø\u0001\u0000¢\u0006\u0004\b\u0014\u0010\f\u001aa\u0010\u0015\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u0016\u001a\u00020\u001726\u0010\u0018\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u001e0\u0019H\u0080@ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010 \u001aY\u0010!\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\n26\u0010\"\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u001e0\u0019H\u0086@ø\u0001\u0000¢\u0006\u0004\b#\u0010$\u001a!\u0010%\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0086@ø\u0001\u0000¢\u0006\u0004\b&\u0010\f\u001aM\u0010'\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u0016\u001a\u00020\u00172\b\u0010(\u001a\u0004\u0018\u00010)2\u0018\u0010\u0018\u001a\u0014\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u001e0\u0019H\u0082Hø\u0001\u0000¢\u0006\u0004\b+\u0010,\u001aY\u0010-\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\n26\u0010\"\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110*¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u001e0\u0019H\u0086@ø\u0001\u0000¢\u0006\u0004\b.\u0010$\u001a!\u0010/\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0086@ø\u0001\u0000¢\u0006\u0004\b0\u0010\f\u001aa\u00101\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u0016\u001a\u00020\u001726\u0010\"\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u001e0\u0019H\u0080@ø\u0001\u0000¢\u0006\u0004\b2\u0010 \u001aY\u00103\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\n26\u0010\"\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u001e0\u0019H\u0086@ø\u0001\u0000¢\u0006\u0004\b4\u0010$\u001a\u0080\u0001\u00105\u001a\u00020\u001e*\u0002062\u0014\b\u0002\u00107\u001a\u000e\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u001e0\u000f2\u000e\b\u0002\u00108\u001a\b\u0012\u0004\u0012\u00020\u001e092\u000e\b\u0002\u0010:\u001a\b\u0012\u0004\u0012\u00020\u001e0926\u0010;\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110*¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(<\u0012\u0004\u0012\u00020\u001e0\u0019H\u0086@¢\u0006\u0002\u0010=\u001aà\u0001\u00105\u001a\u00020\u001e*\u0002062K\u00107\u001aG\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(?\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(@\u0012\u0013\u0012\u00110*¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(A\u0012\u0004\u0012\u00020\u001e0>2!\u00108\u001a\u001d\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0004\u0012\u00020\u001e0\u000f2\f\u0010:\u001a\b\u0012\u0004\u0012\u00020\u001e092\f\u0010B\u001a\b\u0012\u0004\u0012\u00020\u0010092\b\u0010C\u001a\u0004\u0018\u00010)26\u0010;\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110*¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(<\u0012\u0004\u0012\u00020\u001e0\u0019H\u0080@¢\u0006\u0002\u0010D\u001a\u0080\u0001\u0010E\u001a\u00020\u001e*\u0002062\u0014\b\u0002\u00107\u001a\u000e\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u001e0\u000f2\u000e\b\u0002\u00108\u001a\b\u0012\u0004\u0012\u00020\u001e092\u000e\b\u0002\u0010:\u001a\b\u0012\u0004\u0012\u00020\u001e0926\u0010;\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110*¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(<\u0012\u0004\u0012\u00020\u001e0\u0019H\u0086@¢\u0006\u0002\u0010=\u001a\u0080\u0001\u0010F\u001a\u00020\u001e*\u0002062\u0014\b\u0002\u00107\u001a\u000e\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u001e0\u000f2\u000e\b\u0002\u00108\u001a\b\u0012\u0004\u0012\u00020\u001e092\u000e\b\u0002\u0010:\u001a\b\u0012\u0004\u0012\u00020\u001e0926\u0010G\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(<\u0012\u0004\u0012\u00020\u001e0\u0019H\u0086@¢\u0006\u0002\u0010=\u001a\u0080\u0001\u0010H\u001a\u00020\u001e*\u0002062\u0014\b\u0002\u00107\u001a\u000e\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u001e0\u000f2\u000e\b\u0002\u00108\u001a\b\u0012\u0004\u0012\u00020\u001e092\u000e\b\u0002\u0010:\u001a\b\u0012\u0004\u0012\u00020\u001e0926\u0010I\u001a2\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(\u001c\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u001a\u0012\b\b\u001b\u0012\u0004\b\b(<\u0012\u0004\u0012\u00020\u001e0\u0019H\u0086@¢\u0006\u0002\u0010=\u001a3\u0010J\u001a\u00020\u0010*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0012\u0010;\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u001e0\u000fH\u0086@ø\u0001\u0000¢\u0006\u0004\bK\u0010\u0012\u001aS\u0010J\u001a\u0004\u0018\u00010\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0012\u0010;\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u001e0\u000f2\b\u0010(\u001a\u0004\u0018\u00010)2\u0012\u0010L\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00100\u000fH\u0080Hø\u0001\u0000¢\u0006\u0004\bM\u0010N\u001a3\u0010O\u001a\u00020\u0010*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0012\u0010;\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u001e0\u000fH\u0086@ø\u0001\u0000¢\u0006\u0004\bP\u0010\u0012\u001a\u001e\u0010Q\u001a\u00020\u0010*\u00020R2\u0006\u0010\t\u001a\u00020\nH\u0002ø\u0001\u0000¢\u0006\u0004\bS\u0010T\u001a\u001e\u0010U\u001a\u00020\u0005*\u00020V2\u0006\u0010\u0016\u001a\u00020\u0017H\u0000ø\u0001\u0000¢\u0006\u0004\bW\u0010X\u001a3\u0010Y\u001a\u00020\u0010*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0012\u0010;\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u001e0\u000fH\u0086@ø\u0001\u0000¢\u0006\u0004\bZ\u0010\u0012\"\u0010\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\u0003\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006["}, d2 = {"defaultTouchSlop", "Landroidx/compose/ui/unit/Dp;", "F", "mouseSlop", "mouseToTouchSlopRatio", "", "awaitDragOrCancellation", "Landroidx/compose/ui/input/pointer/PointerInputChange;", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;", "pointerId", "Landroidx/compose/ui/input/pointer/PointerId;", "awaitDragOrCancellation-rnUCldI", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitDragOrUp", "hasDragged", "Lkotlin/Function1;", "", "awaitDragOrUp-jO51t88", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;JLkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitHorizontalDragOrCancellation", "awaitHorizontalDragOrCancellation-rnUCldI", "awaitHorizontalPointerSlopOrCancellation", "pointerType", "Landroidx/compose/ui/input/pointer/PointerType;", "onPointerSlopReached", "Lkotlin/Function2;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "change", "overSlop", "", "awaitHorizontalPointerSlopOrCancellation-gDDlDlE", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;JILkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitHorizontalTouchSlopOrCancellation", "onTouchSlopReached", "awaitHorizontalTouchSlopOrCancellation-jO51t88", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;JLkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitLongPressOrCancellation", "awaitLongPressOrCancellation-rnUCldI", "awaitPointerSlopOrCancellation", "orientation", "Landroidx/compose/foundation/gestures/Orientation;", "Landroidx/compose/ui/geometry/Offset;", "awaitPointerSlopOrCancellation-pn7EDYM", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;JILandroidx/compose/foundation/gestures/Orientation;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitTouchSlopOrCancellation", "awaitTouchSlopOrCancellation-jO51t88", "awaitVerticalDragOrCancellation", "awaitVerticalDragOrCancellation-rnUCldI", "awaitVerticalPointerSlopOrCancellation", "awaitVerticalPointerSlopOrCancellation-gDDlDlE", "awaitVerticalTouchSlopOrCancellation", "awaitVerticalTouchSlopOrCancellation-jO51t88", "detectDragGestures", "Landroidx/compose/ui/input/pointer/PointerInputScope;", "onDragStart", "onDragEnd", "Lkotlin/Function0;", "onDragCancel", "onDrag", "dragAmount", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lkotlin/Function3;", "down", "slopTriggerChange", "overSlopOffset", "shouldAwaitTouchSlop", "orientationLock", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function0;Landroidx/compose/foundation/gestures/Orientation;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "detectDragGesturesAfterLongPress", "detectHorizontalDragGestures", "onHorizontalDrag", "detectVerticalDragGestures", "onVerticalDrag", "drag", "drag-jO51t88", "motionConsumed", "drag-VnAYq1g", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;JLkotlin/jvm/functions/Function1;Landroidx/compose/foundation/gestures/Orientation;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "horizontalDrag", "horizontalDrag-jO51t88", "isPointerUp", "Landroidx/compose/ui/input/pointer/PointerEvent;", "isPointerUp-DmW0f2w", "(Landroidx/compose/ui/input/pointer/PointerEvent;J)Z", "pointerSlop", "Landroidx/compose/ui/platform/ViewConfiguration;", "pointerSlop-E8SPZFQ", "(Landroidx/compose/ui/platform/ViewConfiguration;I)F", "verticalDrag", "verticalDrag-jO51t88", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class DragGestureDetectorKt {
    private static final float defaultTouchSlop;
    private static final float mouseSlop;
    private static final float mouseToTouchSlopRatio;

    public static final java.lang.Object m727awaitTouchSlopOrCancellationjO51t88(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r18, long r19, kotlin.jvm.functions.Function2<? super androidx.compose.p002ui.input.pointer.PointerInputChange, ? super androidx.compose.p002ui.geometry.Offset, kotlin.Unit> r21, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r22) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m727awaitTouchSlopOrCancellationjO51t88(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.jvm.functions.Function2, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object m733dragjO51t88(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r4, long r5, kotlin.jvm.functions.Function1<? super androidx.compose.p002ui.input.pointer.PointerInputChange, kotlin.Unit> r7, kotlin.coroutines.Continuation<? super java.lang.Boolean> r8) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m733dragjO51t88(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.jvm.functions.Function1, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object m720awaitDragOrCancellationrnUCldI(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r17, long r18, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r20) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m720awaitDragOrCancellationrnUCldI(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static Object detectDragGestures$default(PointerInputScope pointerInputScope, Function1 function1, Function0 function0, Function0 function2, Function2 function3, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            function1 = new Function1<Offset, Unit>() {
                public final void m738invokek4lQ0M(long j) {
                }

                public Object invoke(Object obj2) {
                    m738invokek4lQ0M(((Offset) obj2).getPackedValue());
                    return Unit.INSTANCE;
                }
            };
        }
        Function1 function4 = function1;
        if ((i & 2) != 0) {
            function0 = new Function0<Unit>() {
                public final void m739invoke() {
                }

                public Object invoke() {
                    m739invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        Function0 function5 = function0;
        if ((i & 4) != 0) {
            function2 = new Function0<Unit>() {
                public final void m740invoke() {
                }

                public Object invoke() {
                    m740invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        return detectDragGestures(pointerInputScope, function4, function5, function2, function3, continuation);
    }

    public static final Object detectDragGestures(PointerInputScope pointerInputScope, final Function1<? super Offset, Unit> function1, final Function0<Unit> function0, Function0<Unit> function2, Function2<? super PointerInputChange, ? super Offset, Unit> function3, Continuation<? super Unit> continuation) {
        Object objDetectDragGestures = detectDragGestures(pointerInputScope, new Function3<PointerInputChange, PointerInputChange, Offset, Unit>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                m741invoke0AR0LA0((PointerInputChange) obj, (PointerInputChange) obj2, ((Offset) obj3).getPackedValue());
                return Unit.INSTANCE;
            }

            public final void m741invoke0AR0LA0(PointerInputChange pointerInputChange, PointerInputChange pointerInputChange2, long j) {
                function1.invoke(Offset.m4335boximpl(pointerInputChange2.getPosition()));
            }
        }, new Function1<PointerInputChange, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((PointerInputChange) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(PointerInputChange pointerInputChange) {
                function0.invoke();
            }
        }, function2, new Function0<Boolean>() {
            public final Boolean m742invoke() {
                return true;
            }
        }, null, function3, continuation);
        return objDetectDragGestures == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDetectDragGestures : Unit.INSTANCE;
    }

    public static final Object detectDragGestures(PointerInputScope pointerInputScope, Function3<? super PointerInputChange, ? super PointerInputChange, ? super Offset, Unit> function3, Function1<? super PointerInputChange, Unit> function1, Function0<Unit> function0, Function0<Boolean> function2, Orientation orientation, Function2<? super PointerInputChange, ? super Offset, Unit> function4, Continuation<? super Unit> continuation) {
        Object objAwaitEachGesture = ForEachGestureKt.awaitEachGesture(pointerInputScope, new C04519(function2, new Ref.LongRef(), orientation, function3, function4, function0, function1, null), continuation);
        return objAwaitEachGesture == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAwaitEachGesture : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.DragGestureDetectorKt$detectDragGestures$9", f = "DragGestureDetector.kt", i = {0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4}, l = {247, 253, 972, 1014, 1025}, m = "invokeSuspend", n = {"$this$awaitEachGesture", "$this$awaitEachGesture", "initialDown", "awaitTouchSlop", "$this$awaitEachGesture", "down", "$this$awaitPointerSlopOrCancellation_u2dpn7EDYM$iv", "pointer$iv", "touchSlopDetector$iv", "touchSlop$iv", "$this$awaitEachGesture", "down", "$this$awaitPointerSlopOrCancellation_u2dpn7EDYM$iv", "pointer$iv", "touchSlopDetector$iv", "dragEvent$iv", "touchSlop$iv", "$this$drag_u2dVnAYq1g$iv", "orientation$iv", "$this$awaitDragOrUp_u2djO51t88$iv$iv", "pointer$iv$iv"}, s = {"L$0", "L$0", "L$1", "Z$0", "L$0", "L$1", "L$2", "L$4", "L$5", "F$0", "L$0", "L$1", "L$2", "L$4", "L$5", "L$6", "F$0", "L$0", "L$2", "L$3", "L$4"})
    static final class C04519 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        final Function2<PointerInputChange, Offset, Unit> $onDrag;
        final Function0<Unit> $onDragCancel;
        final Function1<PointerInputChange, Unit> $onDragEnd;
        final Function3<PointerInputChange, PointerInputChange, Offset, Unit> $onDragStart;
        final Orientation $orientationLock;
        final Ref.LongRef $overSlop;
        final Function0<Boolean> $shouldAwaitTouchSlop;
        float F$0;
        private Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        boolean Z$0;
        int label;

        C04519(Function0<Boolean> function0, Ref.LongRef longRef, Orientation orientation, Function3<? super PointerInputChange, ? super PointerInputChange, ? super Offset, Unit> function3, Function2<? super PointerInputChange, ? super Offset, Unit> function2, Function0<Unit> function1, Function1<? super PointerInputChange, Unit> function4, Continuation<? super C04519> continuation) {
            super(2, continuation);
            this.$shouldAwaitTouchSlop = function0;
            this.$overSlop = longRef;
            this.$orientationLock = orientation;
            this.$onDragStart = function3;
            this.$onDrag = function2;
            this.$onDragCancel = function1;
            this.$onDragEnd = function4;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04519 = new C04519(this.$shouldAwaitTouchSlop, this.$overSlop, this.$orientationLock, this.$onDragStart, this.$onDrag, this.$onDragCancel, this.$onDragEnd, continuation);
            c04519.L$0 = obj;
            return c04519;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final java.lang.Object invokeSuspend(java.lang.Object r22) {
            throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.C04519.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static Object detectDragGesturesAfterLongPress$default(PointerInputScope pointerInputScope, Function1 function1, Function0 function0, Function0 function2, Function2 function3, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            function1 = new Function1<Offset, Unit>() {
                public final void m743invokek4lQ0M(long j) {
                }

                public Object invoke(Object obj2) {
                    m743invokek4lQ0M(((Offset) obj2).getPackedValue());
                    return Unit.INSTANCE;
                }
            };
        }
        Function1 function4 = function1;
        if ((i & 2) != 0) {
            function0 = new Function0<Unit>() {
                public final void m744invoke() {
                }

                public Object invoke() {
                    m744invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        Function0 function5 = function0;
        if ((i & 4) != 0) {
            function2 = new Function0<Unit>() {
                public final void m745invoke() {
                }

                public Object invoke() {
                    m745invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        return detectDragGesturesAfterLongPress(pointerInputScope, function4, function5, function2, function3, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.DragGestureDetectorKt$detectDragGesturesAfterLongPress$5", f = "DragGestureDetector.kt", i = {0, 1, 2}, l = {323, 324, 329}, m = "invokeSuspend", n = {"$this$awaitEachGesture", "$this$awaitEachGesture", "$this$awaitEachGesture"}, s = {"L$0", "L$0", "L$0"})
    static final class C04555 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        final Function2<PointerInputChange, Offset, Unit> $onDrag;
        final Function0<Unit> $onDragCancel;
        final Function0<Unit> $onDragEnd;
        final Function1<Offset, Unit> $onDragStart;
        private Object L$0;
        int label;

        C04555(Function1<? super Offset, Unit> function1, Function0<Unit> function0, Function0<Unit> function2, Function2<? super PointerInputChange, ? super Offset, Unit> function3, Continuation<? super C04555> continuation) {
            super(2, continuation);
            this.$onDragStart = function1;
            this.$onDragEnd = function0;
            this.$onDragCancel = function2;
            this.$onDrag = function3;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04555 = new C04555(this.$onDragStart, this.$onDragEnd, this.$onDragCancel, this.$onDrag, continuation);
            c04555.L$0 = obj;
            return c04555;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            AwaitPointerEventScope awaitPointerEventScope;
            PointerInputChange pointerInputChange;
            AwaitPointerEventScope awaitPointerEventScope2;
            List<PointerInputChange> changes;
            int size;
            int i;
            PointerInputChange pointerInputChange2;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i2 = this.label;
            try {
                if (i2 == 0) {
                    ResultKt.throwOnFailure(obj);
                    awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                    this.L$0 = awaitPointerEventScope;
                    this.label = 1;
                    obj = TapGestureDetectorKt.awaitFirstDown$default(awaitPointerEventScope, false, null, (Continuation) this, 2, null);
                    if (obj == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i2 == 1) {
                        awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                    } else {
                        if (i2 == 2) {
                            awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                            ResultKt.throwOnFailure(obj);
                            pointerInputChange = (PointerInputChange) obj;
                            if (pointerInputChange != null) {
                                this.$onDragStart.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                                long id = pointerInputChange.getId();
                                final Function2<PointerInputChange, Offset, Unit> function2 = this.$onDrag;
                                this.L$0 = awaitPointerEventScope;
                                this.label = 3;
                                obj = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id, new Function1<PointerInputChange, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj2) {
                                        invoke((PointerInputChange) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(PointerInputChange pointerInputChange3) {
                                        function2.invoke(pointerInputChange3, Offset.m4335boximpl(PointerEventKt.positionChange(pointerInputChange3)));
                                        pointerInputChange3.consume();
                                    }
                                }, (Continuation) this);
                                if (obj == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                awaitPointerEventScope2 = awaitPointerEventScope;
                            }
                            return Unit.INSTANCE;
                        }
                        if (i2 != 3) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        awaitPointerEventScope2 = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                    }
                    if (((Boolean) obj).booleanValue()) {
                        changes = awaitPointerEventScope2.getCurrentEvent().getChanges();
                        size = changes.size();
                        for (i = 0; i < size; i++) {
                            pointerInputChange2 = changes.get(i);
                            if (PointerEventKt.changedToUp(pointerInputChange2)) {
                                pointerInputChange2.consume();
                            }
                        }
                        this.$onDragEnd.invoke();
                    } else {
                        this.$onDragCancel.invoke();
                    }
                    return Unit.INSTANCE;
                }
                this.L$0 = awaitPointerEventScope;
                this.label = 2;
                obj = DragGestureDetectorKt.m725awaitLongPressOrCancellationrnUCldI(awaitPointerEventScope, ((PointerInputChange) obj).getId(), (Continuation) this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
                pointerInputChange = (PointerInputChange) obj;
                if (pointerInputChange != null) {
                    this.$onDragStart.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                    long id2 = pointerInputChange.getId();
                    final Function2<? super PointerInputChange, ? super Offset, Unit> function3 = this.$onDrag;
                    this.L$0 = awaitPointerEventScope;
                    this.label = 3;
                    obj = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id2, new Function1<PointerInputChange, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj2) {
                            invoke((PointerInputChange) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PointerInputChange pointerInputChange3) {
                            function3.invoke(pointerInputChange3, Offset.m4335boximpl(PointerEventKt.positionChange(pointerInputChange3)));
                            pointerInputChange3.consume();
                        }
                    }, (Continuation) this);
                    if (obj == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    awaitPointerEventScope2 = awaitPointerEventScope;
                    if (((Boolean) obj).booleanValue()) {
                        changes = awaitPointerEventScope2.getCurrentEvent().getChanges();
                        size = changes.size();
                        while (i < size) {
                            pointerInputChange2 = changes.get(i);
                            if (PointerEventKt.changedToUp(pointerInputChange2)) {
                                pointerInputChange2.consume();
                            }
                        }
                        this.$onDragEnd.invoke();
                    } else {
                        this.$onDragCancel.invoke();
                    }
                }
                return Unit.INSTANCE;
            } catch (CancellationException e) {
                this.$onDragCancel.invoke();
                throw e;
            }
        }
    }

    public static final Object detectDragGesturesAfterLongPress(PointerInputScope pointerInputScope, Function1<? super Offset, Unit> function1, Function0<Unit> function0, Function0<Unit> function2, Function2<? super PointerInputChange, ? super Offset, Unit> function3, Continuation<? super Unit> continuation) {
        Object objAwaitEachGesture = ForEachGestureKt.awaitEachGesture(pointerInputScope, new C04555(function1, function0, function2, function3, null), continuation);
        return objAwaitEachGesture == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAwaitEachGesture : Unit.INSTANCE;
    }

    public static final java.lang.Object m730awaitVerticalTouchSlopOrCancellationjO51t88(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r18, long r19, kotlin.jvm.functions.Function2<? super androidx.compose.p002ui.input.pointer.PointerInputChange, ? super java.lang.Float, kotlin.Unit> r21, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r22) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m730awaitVerticalTouchSlopOrCancellationjO51t88(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.jvm.functions.Function2, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object m729awaitVerticalPointerSlopOrCancellationgDDlDlE(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r19, long r20, int r22, kotlin.jvm.functions.Function2<? super androidx.compose.p002ui.input.pointer.PointerInputChange, ? super java.lang.Float, kotlin.Unit> r23, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r24) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m729awaitVerticalPointerSlopOrCancellationgDDlDlE(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, int, kotlin.jvm.functions.Function2, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object m737verticalDragjO51t88(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r18, long r19, kotlin.jvm.functions.Function1<? super androidx.compose.p002ui.input.pointer.PointerInputChange, kotlin.Unit> r21, kotlin.coroutines.Continuation<? super java.lang.Boolean> r22) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m737verticalDragjO51t88(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.jvm.functions.Function1, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object m728awaitVerticalDragOrCancellationrnUCldI(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r17, long r18, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r20) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m728awaitVerticalDragOrCancellationrnUCldI(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static Object detectVerticalDragGestures$default(PointerInputScope pointerInputScope, Function1 function1, Function0 function0, Function0 function2, Function2 function3, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            function1 = new Function1<Offset, Unit>() {
                public final void m749invokek4lQ0M(long j) {
                }

                public Object invoke(Object obj2) {
                    m749invokek4lQ0M(((Offset) obj2).getPackedValue());
                    return Unit.INSTANCE;
                }
            };
        }
        Function1 function4 = function1;
        if ((i & 2) != 0) {
            function0 = new Function0<Unit>() {
                public final void m750invoke() {
                }

                public Object invoke() {
                    m750invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        Function0 function5 = function0;
        if ((i & 4) != 0) {
            function2 = new Function0<Unit>() {
                public final void m751invoke() {
                }

                public Object invoke() {
                    m751invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        return detectVerticalDragGestures(pointerInputScope, function4, function5, function2, function3, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.DragGestureDetectorKt$detectVerticalDragGestures$5", f = "DragGestureDetector.kt", i = {0, 1, 1}, l = {479, 481, 489}, m = "invokeSuspend", n = {"$this$awaitEachGesture", "$this$awaitEachGesture", "overSlop"}, s = {"L$0", "L$0", "L$1"})
    static final class C04635 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        final Function0<Unit> $onDragCancel;
        final Function0<Unit> $onDragEnd;
        final Function1<Offset, Unit> $onDragStart;
        final Function2<PointerInputChange, Float, Unit> $onVerticalDrag;
        private Object L$0;
        Object L$1;
        int label;

        C04635(Function1<? super Offset, Unit> function1, Function2<? super PointerInputChange, ? super Float, Unit> function2, Function0<Unit> function0, Function0<Unit> function3, Continuation<? super C04635> continuation) {
            super(2, continuation);
            this.$onDragStart = function1;
            this.$onVerticalDrag = function2;
            this.$onDragEnd = function0;
            this.$onDragCancel = function3;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04635 = new C04635(this.$onDragStart, this.$onVerticalDrag, this.$onDragEnd, this.$onDragCancel, continuation);
            c04635.L$0 = obj;
            return c04635;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            AwaitPointerEventScope awaitPointerEventScope;
            AwaitPointerEventScope awaitPointerEventScope2;
            Ref.FloatRef floatRef;
            PointerInputChange pointerInputChange;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                AwaitPointerEventScope awaitPointerEventScope3 = (AwaitPointerEventScope) this.L$0;
                this.L$0 = awaitPointerEventScope3;
                this.label = 1;
                Object objAwaitFirstDown$default = TapGestureDetectorKt.awaitFirstDown$default(awaitPointerEventScope3, false, null, (Continuation) this, 2, null);
                if (objAwaitFirstDown$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
                awaitPointerEventScope = awaitPointerEventScope3;
                obj = objAwaitFirstDown$default;
            } else {
                if (i == 1) {
                    awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i == 2) {
                        floatRef = (Ref.FloatRef) this.L$1;
                        awaitPointerEventScope2 = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        pointerInputChange = (PointerInputChange) obj;
                        if (pointerInputChange != null) {
                            this.$onDragStart.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                            this.$onVerticalDrag.invoke(pointerInputChange, Boxing.boxFloat(floatRef.element));
                            long id = pointerInputChange.getId();
                            final Function2<PointerInputChange, Float, Unit> function2 = this.$onVerticalDrag;
                            this.L$0 = null;
                            this.L$1 = null;
                            this.label = 3;
                            obj = DragGestureDetectorKt.m737verticalDragjO51t88(awaitPointerEventScope2, id, new Function1<PointerInputChange, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj2) {
                                    invoke((PointerInputChange) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(PointerInputChange pointerInputChange2) {
                                    function2.invoke(pointerInputChange2, Float.valueOf(Offset.m4347getYimpl(PointerEventKt.positionChange(pointerInputChange2))));
                                    pointerInputChange2.consume();
                                }
                            }, (Continuation) this);
                            if (obj == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        }
                        return Unit.INSTANCE;
                    }
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                if (((Boolean) obj).booleanValue()) {
                    this.$onDragEnd.invoke();
                } else {
                    this.$onDragCancel.invoke();
                }
                return Unit.INSTANCE;
            }
            PointerInputChange pointerInputChange2 = (PointerInputChange) obj;
            final Ref.FloatRef floatRef2 = new Ref.FloatRef();
            this.L$0 = awaitPointerEventScope;
            this.L$1 = floatRef2;
            this.label = 2;
            obj = DragGestureDetectorKt.m729awaitVerticalPointerSlopOrCancellationgDDlDlE(awaitPointerEventScope, pointerInputChange2.getId(), pointerInputChange2.getType(), new Function2<PointerInputChange, Float, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((PointerInputChange) obj2, ((Number) obj3).floatValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(PointerInputChange pointerInputChange3, float f) {
                    pointerInputChange3.consume();
                    floatRef2.element = f;
                }
            }, (Continuation) this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            awaitPointerEventScope2 = awaitPointerEventScope;
            floatRef = floatRef2;
            pointerInputChange = (PointerInputChange) obj;
            if (pointerInputChange != null) {
                this.$onDragStart.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                this.$onVerticalDrag.invoke(pointerInputChange, Boxing.boxFloat(floatRef.element));
                long id2 = pointerInputChange.getId();
                final Function2<? super PointerInputChange, ? super Float, Unit> function3 = this.$onVerticalDrag;
                this.L$0 = null;
                this.L$1 = null;
                this.label = 3;
                obj = DragGestureDetectorKt.m737verticalDragjO51t88(awaitPointerEventScope2, id2, new Function1<PointerInputChange, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj2) {
                        invoke((PointerInputChange) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(PointerInputChange pointerInputChange3) {
                        function3.invoke(pointerInputChange3, Float.valueOf(Offset.m4347getYimpl(PointerEventKt.positionChange(pointerInputChange3))));
                        pointerInputChange3.consume();
                    }
                }, (Continuation) this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
                if (((Boolean) obj).booleanValue()) {
                    this.$onDragEnd.invoke();
                } else {
                    this.$onDragCancel.invoke();
                }
            }
            return Unit.INSTANCE;
        }
    }

    public static final Object detectVerticalDragGestures(PointerInputScope pointerInputScope, Function1<? super Offset, Unit> function1, Function0<Unit> function0, Function0<Unit> function2, Function2<? super PointerInputChange, ? super Float, Unit> function3, Continuation<? super Unit> continuation) {
        Object objAwaitEachGesture = ForEachGestureKt.awaitEachGesture(pointerInputScope, new C04635(function1, function3, function0, function2, null), continuation);
        return objAwaitEachGesture == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAwaitEachGesture : Unit.INSTANCE;
    }

    public static final java.lang.Object m724awaitHorizontalTouchSlopOrCancellationjO51t88(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r18, long r19, kotlin.jvm.functions.Function2<? super androidx.compose.p002ui.input.pointer.PointerInputChange, ? super java.lang.Float, kotlin.Unit> r21, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r22) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m724awaitHorizontalTouchSlopOrCancellationjO51t88(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.jvm.functions.Function2, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object m723awaitHorizontalPointerSlopOrCancellationgDDlDlE(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r19, long r20, int r22, kotlin.jvm.functions.Function2<? super androidx.compose.p002ui.input.pointer.PointerInputChange, ? super java.lang.Float, kotlin.Unit> r23, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r24) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m723awaitHorizontalPointerSlopOrCancellationgDDlDlE(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, int, kotlin.jvm.functions.Function2, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object m734horizontalDragjO51t88(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r18, long r19, kotlin.jvm.functions.Function1<? super androidx.compose.p002ui.input.pointer.PointerInputChange, kotlin.Unit> r21, kotlin.coroutines.Continuation<? super java.lang.Boolean> r22) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m734horizontalDragjO51t88(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.jvm.functions.Function1, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object m722awaitHorizontalDragOrCancellationrnUCldI(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r17, long r18, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r20) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m722awaitHorizontalDragOrCancellationrnUCldI(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static Object detectHorizontalDragGestures$default(PointerInputScope pointerInputScope, Function1 function1, Function0 function0, Function0 function2, Function2 function3, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            function1 = new Function1<Offset, Unit>() {
                public final void m746invokek4lQ0M(long j) {
                }

                public Object invoke(Object obj2) {
                    m746invokek4lQ0M(((Offset) obj2).getPackedValue());
                    return Unit.INSTANCE;
                }
            };
        }
        Function1 function4 = function1;
        if ((i & 2) != 0) {
            function0 = new Function0<Unit>() {
                public final void m747invoke() {
                }

                public Object invoke() {
                    m747invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        Function0 function5 = function0;
        if ((i & 4) != 0) {
            function2 = new Function0<Unit>() {
                public final void m748invoke() {
                }

                public Object invoke() {
                    m748invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        return detectHorizontalDragGestures(pointerInputScope, function4, function5, function2, function3, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.DragGestureDetectorKt$detectHorizontalDragGestures$5", f = "DragGestureDetector.kt", i = {0, 1, 1}, l = {627, 629, 640}, m = "invokeSuspend", n = {"$this$awaitEachGesture", "$this$awaitEachGesture", "overSlop"}, s = {"L$0", "L$0", "L$1"})
    static final class C04595 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        final Function0<Unit> $onDragCancel;
        final Function0<Unit> $onDragEnd;
        final Function1<Offset, Unit> $onDragStart;
        final Function2<PointerInputChange, Float, Unit> $onHorizontalDrag;
        private Object L$0;
        Object L$1;
        int label;

        C04595(Function1<? super Offset, Unit> function1, Function2<? super PointerInputChange, ? super Float, Unit> function2, Function0<Unit> function0, Function0<Unit> function3, Continuation<? super C04595> continuation) {
            super(2, continuation);
            this.$onDragStart = function1;
            this.$onHorizontalDrag = function2;
            this.$onDragEnd = function0;
            this.$onDragCancel = function3;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04595 = new C04595(this.$onDragStart, this.$onHorizontalDrag, this.$onDragEnd, this.$onDragCancel, continuation);
            c04595.L$0 = obj;
            return c04595;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            AwaitPointerEventScope awaitPointerEventScope;
            AwaitPointerEventScope awaitPointerEventScope2;
            Ref.FloatRef floatRef;
            PointerInputChange pointerInputChange;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                AwaitPointerEventScope awaitPointerEventScope3 = (AwaitPointerEventScope) this.L$0;
                this.L$0 = awaitPointerEventScope3;
                this.label = 1;
                Object objAwaitFirstDown$default = TapGestureDetectorKt.awaitFirstDown$default(awaitPointerEventScope3, false, null, (Continuation) this, 2, null);
                if (objAwaitFirstDown$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
                awaitPointerEventScope = awaitPointerEventScope3;
                obj = objAwaitFirstDown$default;
            } else {
                if (i == 1) {
                    awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i == 2) {
                        floatRef = (Ref.FloatRef) this.L$1;
                        awaitPointerEventScope2 = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        pointerInputChange = (PointerInputChange) obj;
                        if (pointerInputChange != null) {
                            this.$onDragStart.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                            this.$onHorizontalDrag.invoke(pointerInputChange, Boxing.boxFloat(floatRef.element));
                            long id = pointerInputChange.getId();
                            final Function2<PointerInputChange, Float, Unit> function2 = this.$onHorizontalDrag;
                            this.L$0 = null;
                            this.L$1 = null;
                            this.label = 3;
                            obj = DragGestureDetectorKt.m734horizontalDragjO51t88(awaitPointerEventScope2, id, new Function1<PointerInputChange, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj2) {
                                    invoke((PointerInputChange) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(PointerInputChange pointerInputChange2) {
                                    function2.invoke(pointerInputChange2, Float.valueOf(Offset.m4346getXimpl(PointerEventKt.positionChange(pointerInputChange2))));
                                    pointerInputChange2.consume();
                                }
                            }, (Continuation) this);
                            if (obj == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        }
                        return Unit.INSTANCE;
                    }
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                if (((Boolean) obj).booleanValue()) {
                    this.$onDragEnd.invoke();
                } else {
                    this.$onDragCancel.invoke();
                }
                return Unit.INSTANCE;
            }
            PointerInputChange pointerInputChange2 = (PointerInputChange) obj;
            final Ref.FloatRef floatRef2 = new Ref.FloatRef();
            this.L$0 = awaitPointerEventScope;
            this.L$1 = floatRef2;
            this.label = 2;
            obj = DragGestureDetectorKt.m723awaitHorizontalPointerSlopOrCancellationgDDlDlE(awaitPointerEventScope, pointerInputChange2.getId(), pointerInputChange2.getType(), new Function2<PointerInputChange, Float, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((PointerInputChange) obj2, ((Number) obj3).floatValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(PointerInputChange pointerInputChange3, float f) {
                    pointerInputChange3.consume();
                    floatRef2.element = f;
                }
            }, (Continuation) this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            awaitPointerEventScope2 = awaitPointerEventScope;
            floatRef = floatRef2;
            pointerInputChange = (PointerInputChange) obj;
            if (pointerInputChange != null) {
                this.$onDragStart.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                this.$onHorizontalDrag.invoke(pointerInputChange, Boxing.boxFloat(floatRef.element));
                long id2 = pointerInputChange.getId();
                final Function2<? super PointerInputChange, ? super Float, Unit> function3 = this.$onHorizontalDrag;
                this.L$0 = null;
                this.L$1 = null;
                this.label = 3;
                obj = DragGestureDetectorKt.m734horizontalDragjO51t88(awaitPointerEventScope2, id2, new Function1<PointerInputChange, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj2) {
                        invoke((PointerInputChange) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(PointerInputChange pointerInputChange3) {
                        function3.invoke(pointerInputChange3, Float.valueOf(Offset.m4346getXimpl(PointerEventKt.positionChange(pointerInputChange3))));
                        pointerInputChange3.consume();
                    }
                }, (Continuation) this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
                if (((Boolean) obj).booleanValue()) {
                    this.$onDragEnd.invoke();
                } else {
                    this.$onDragCancel.invoke();
                }
            }
            return Unit.INSTANCE;
        }
    }

    public static final Object detectHorizontalDragGestures(PointerInputScope pointerInputScope, Function1<? super Offset, Unit> function1, Function0<Unit> function0, Function0<Unit> function2, Function2<? super PointerInputChange, ? super Float, Unit> function3, Continuation<? super Unit> continuation) {
        Object objAwaitEachGesture = ForEachGestureKt.awaitEachGesture(pointerInputScope, new C04595(function1, function3, function0, function2, null), continuation);
        return objAwaitEachGesture == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAwaitEachGesture : Unit.INSTANCE;
    }

    public static final java.lang.Object m731dragVnAYq1g(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r19, long r20, kotlin.jvm.functions.Function1<? super androidx.compose.p002ui.input.pointer.PointerInputChange, kotlin.Unit> r22, androidx.compose.foundation.gestures.Orientation r23, kotlin.jvm.functions.Function1<? super androidx.compose.p002ui.input.pointer.PointerInputChange, java.lang.Boolean> r24, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r25) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.DragGestureDetectorKt.m731dragVnAYq1g(androidx.compose.ui.input.pointer.AwaitPointerEventScope, long, kotlin.jvm.functions.Function1, androidx.compose.foundation.gestures.Orientation, kotlin.jvm.functions.Function1, kotlin.coroutines.Continuation):java.lang.Object");
    }

    private static final Object m732dragVnAYq1g$$forInline(AwaitPointerEventScope awaitPointerEventScope, long j, Function1<? super PointerInputChange, Unit> function1, Orientation orientation, Function1<? super PointerInputChange, Boolean> function2, Continuation<? super PointerInputChange> continuation) {
        PointerInputChange pointerInputChange;
        PointerInputChange pointerInputChange2;
        PointerInputChange pointerInputChange3;
        float fM4347getYimpl;
        long id = j;
        if (m735isPointerUpDmW0f2w(awaitPointerEventScope.getCurrentEvent(), id)) {
            return null;
        }
        while (true) {
            Ref.LongRef longRef = new Ref.LongRef();
            longRef.element = id;
            while (true) {
                PointerEvent pointerEvent = (PointerEvent) AwaitPointerEventScope.CC.awaitPointerEvent$default(awaitPointerEventScope, null, continuation, 1, null);
                List<PointerInputChange> changes = pointerEvent.getChanges();
                int size = changes.size();
                int i = 0;
                int i2 = 0;
                while (true) {
                    if (i2 >= size) {
                        pointerInputChange = null;
                        break;
                    }
                    pointerInputChange = changes.get(i2);
                    if (Boolean.valueOf(PointerId.m5828equalsimpl0(pointerInputChange.getId(), longRef.element)).booleanValue()) {
                        break;
                    }
                    i2++;
                }
                pointerInputChange2 = pointerInputChange;
                if (pointerInputChange2 == null) {
                    pointerInputChange2 = null;
                    break;
                }
                if (PointerEventKt.changedToUpIgnoreConsumed(pointerInputChange2)) {
                    List<PointerInputChange> changes2 = pointerEvent.getChanges();
                    int size2 = changes2.size();
                    while (true) {
                        if (i >= size2) {
                            pointerInputChange3 = null;
                            break;
                        }
                        pointerInputChange3 = changes2.get(i);
                        if (Boolean.valueOf(pointerInputChange3.getPressed()).booleanValue()) {
                            break;
                        }
                        i++;
                    }
                    PointerInputChange pointerInputChange4 = pointerInputChange3;
                    if (pointerInputChange4 == null) {
                        break;
                    }
                    longRef.element = pointerInputChange4.getId();
                } else {
                    long jPositionChangeIgnoreConsumed = PointerEventKt.positionChangeIgnoreConsumed(pointerInputChange2);
                    if (orientation == null) {
                        fM4347getYimpl = Offset.m4344getDistanceimpl(jPositionChangeIgnoreConsumed);
                    } else {
                        fM4347getYimpl = orientation == Orientation.Vertical ? Offset.m4347getYimpl(jPositionChangeIgnoreConsumed) : Offset.m4346getXimpl(jPositionChangeIgnoreConsumed);
                    }
                    if (Boolean.valueOf(1 ^ (fM4347getYimpl == 0.0f ? 1 : 0)).booleanValue()) {
                        break;
                    }
                }
            }
            if (pointerInputChange2 == null || ((Boolean) function2.invoke(pointerInputChange2)).booleanValue()) {
                return null;
            }
            if (PointerEventKt.changedToUpIgnoreConsumed(pointerInputChange2)) {
                return pointerInputChange2;
            }
            function1.invoke(pointerInputChange2);
            id = pointerInputChange2.getId();
        }
    }

    private static final Object m721awaitDragOrUpjO51t88(AwaitPointerEventScope awaitPointerEventScope, long j, Function1<? super PointerInputChange, Boolean> function1, Continuation<? super PointerInputChange> continuation) {
        PointerInputChange pointerInputChange;
        Ref.LongRef longRef = new Ref.LongRef();
        longRef.element = j;
        while (true) {
            PointerInputChange pointerInputChange2 = null;
            PointerEvent pointerEvent = (PointerEvent) AwaitPointerEventScope.CC.awaitPointerEvent$default(awaitPointerEventScope, null, continuation, 1, null);
            List<PointerInputChange> changes = pointerEvent.getChanges();
            int size = changes.size();
            int i = 0;
            while (true) {
                if (i >= size) {
                    pointerInputChange = null;
                    break;
                }
                pointerInputChange = changes.get(i);
                if (Boolean.valueOf(PointerId.m5828equalsimpl0(pointerInputChange.getId(), longRef.element)).booleanValue()) {
                    break;
                }
                i++;
            }
            PointerInputChange pointerInputChange3 = pointerInputChange;
            if (pointerInputChange3 == null) {
                return null;
            }
            if (PointerEventKt.changedToUpIgnoreConsumed(pointerInputChange3)) {
                List<PointerInputChange> changes2 = pointerEvent.getChanges();
                int size2 = changes2.size();
                for (int i2 = 0; i2 < size2; i2++) {
                    PointerInputChange pointerInputChange4 = changes2.get(i2);
                    if (Boolean.valueOf(pointerInputChange4.getPressed()).booleanValue()) {
                        pointerInputChange2 = pointerInputChange4;
                        break;
                    }
                }
                PointerInputChange pointerInputChange5 = pointerInputChange2;
                if (pointerInputChange5 == null) {
                    return pointerInputChange3;
                }
                longRef.element = pointerInputChange5.getId();
            } else if (((Boolean) function1.invoke(pointerInputChange3)).booleanValue()) {
                return pointerInputChange3;
            }
        }
    }

    private static final Object m726awaitPointerSlopOrCancellationpn7EDYM(AwaitPointerEventScope awaitPointerEventScope, long j, int i, Orientation orientation, Function2<? super PointerInputChange, ? super Offset, Unit> function2, Continuation<? super PointerInputChange> continuation) {
        PointerInputChange pointerInputChange;
        PointerInputChange pointerInputChange2;
        if (m735isPointerUpDmW0f2w(awaitPointerEventScope.getCurrentEvent(), j)) {
            return null;
        }
        float fM736pointerSlopE8SPZFQ = m736pointerSlopE8SPZFQ(awaitPointerEventScope.getViewConfiguration(), i);
        Ref.LongRef longRef = new Ref.LongRef();
        longRef.element = j;
        TouchSlopDetector touchSlopDetector = new TouchSlopDetector(orientation);
        while (true) {
            PointerEvent pointerEvent = (PointerEvent) AwaitPointerEventScope.CC.awaitPointerEvent$default(awaitPointerEventScope, null, continuation, 1, null);
            List<PointerInputChange> changes = pointerEvent.getChanges();
            int size = changes.size();
            int i2 = 0;
            int i3 = 0;
            while (true) {
                if (i3 >= size) {
                    pointerInputChange = null;
                    break;
                }
                pointerInputChange = changes.get(i3);
                if (Boolean.valueOf(PointerId.m5828equalsimpl0(pointerInputChange.getId(), longRef.element)).booleanValue()) {
                    break;
                }
                i3++;
            }
            PointerInputChange pointerInputChange3 = pointerInputChange;
            if (pointerInputChange3 == null || pointerInputChange3.isConsumed()) {
                return null;
            }
            if (PointerEventKt.changedToUpIgnoreConsumed(pointerInputChange3)) {
                List<PointerInputChange> changes2 = pointerEvent.getChanges();
                int size2 = changes2.size();
                while (true) {
                    if (i2 >= size2) {
                        pointerInputChange2 = null;
                        break;
                    }
                    pointerInputChange2 = changes2.get(i2);
                    if (Boolean.valueOf(pointerInputChange2.getPressed()).booleanValue()) {
                        break;
                    }
                    i2++;
                }
                PointerInputChange pointerInputChange4 = pointerInputChange2;
                if (pointerInputChange4 == null) {
                    return null;
                }
                longRef.element = pointerInputChange4.getId();
            } else {
                Offset offsetM853addPointerInputChangeGcwITfU = touchSlopDetector.m853addPointerInputChangeGcwITfU(pointerInputChange3, fM736pointerSlopE8SPZFQ);
                if (offsetM853addPointerInputChangeGcwITfU != null) {
                    function2.invoke(pointerInputChange3, offsetM853addPointerInputChangeGcwITfU);
                    if (pointerInputChange3.isConsumed()) {
                        return pointerInputChange3;
                    }
                    touchSlopDetector.reset();
                } else {
                    awaitPointerEventScope.awaitPointerEvent(PointerEventPass.Final, continuation);
                    if (pointerInputChange3.isConsumed()) {
                        break;
                    }
                }
            }
        }
        return null;
    }

    public static final Object m725awaitLongPressOrCancellationrnUCldI(AwaitPointerEventScope awaitPointerEventScope, long j, Continuation<? super PointerInputChange> continuation) {
        DragGestureDetectorKt$awaitLongPressOrCancellation$1 dragGestureDetectorKt$awaitLongPressOrCancellation$1;
        PointerInputChange pointerInputChange;
        PointerInputChange pointerInputChange2;
        Ref.ObjectRef objectRef;
        if (continuation instanceof DragGestureDetectorKt$awaitLongPressOrCancellation$1) {
            dragGestureDetectorKt$awaitLongPressOrCancellation$1 = (DragGestureDetectorKt$awaitLongPressOrCancellation$1) continuation;
            if ((dragGestureDetectorKt$awaitLongPressOrCancellation$1.label & Integer.MIN_VALUE) != 0) {
                dragGestureDetectorKt$awaitLongPressOrCancellation$1.label -= Integer.MIN_VALUE;
            } else {
                dragGestureDetectorKt$awaitLongPressOrCancellation$1 = new DragGestureDetectorKt$awaitLongPressOrCancellation$1(continuation);
            }
        } else {
            dragGestureDetectorKt$awaitLongPressOrCancellation$1 = new DragGestureDetectorKt$awaitLongPressOrCancellation$1(continuation);
        }
        Object obj = dragGestureDetectorKt$awaitLongPressOrCancellation$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = dragGestureDetectorKt$awaitLongPressOrCancellation$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (m735isPointerUpDmW0f2w(awaitPointerEventScope.getCurrentEvent(), j)) {
                return null;
            }
            List<PointerInputChange> changes = awaitPointerEventScope.getCurrentEvent().getChanges();
            int size = changes.size();
            int i2 = 0;
            while (true) {
                if (i2 >= size) {
                    pointerInputChange = null;
                    break;
                }
                pointerInputChange = changes.get(i2);
                if (PointerId.m5828equalsimpl0(pointerInputChange.getId(), j)) {
                    break;
                }
                i2++;
            }
            pointerInputChange2 = pointerInputChange;
            if (pointerInputChange2 == null) {
                return null;
            }
            Ref.ObjectRef objectRef2 = new Ref.ObjectRef();
            Ref.ObjectRef objectRef3 = new Ref.ObjectRef();
            objectRef3.element = pointerInputChange2;
            long longPressTimeoutMillis = awaitPointerEventScope.getViewConfiguration().getLongPressTimeoutMillis();
            try {
                DragGestureDetectorKt$awaitLongPressOrCancellation$2 dragGestureDetectorKt$awaitLongPressOrCancellation$2 = new DragGestureDetectorKt$awaitLongPressOrCancellation$2(objectRef3, objectRef2, null);
                dragGestureDetectorKt$awaitLongPressOrCancellation$1.L$0 = pointerInputChange2;
                dragGestureDetectorKt$awaitLongPressOrCancellation$1.L$1 = objectRef2;
                dragGestureDetectorKt$awaitLongPressOrCancellation$1.label = 1;
                if (awaitPointerEventScope.withTimeout(longPressTimeoutMillis, dragGestureDetectorKt$awaitLongPressOrCancellation$2, dragGestureDetectorKt$awaitLongPressOrCancellation$1) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return null;
            } catch (PointerEventTimeoutCancellationException unused) {
                objectRef = objectRef2;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            objectRef = (Ref.ObjectRef) dragGestureDetectorKt$awaitLongPressOrCancellation$1.L$1;
            pointerInputChange2 = (PointerInputChange) dragGestureDetectorKt$awaitLongPressOrCancellation$1.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                return null;
            } catch (PointerEventTimeoutCancellationException unused2) {
            }
        }
        PointerInputChange pointerInputChange3 = (PointerInputChange) objectRef.element;
        return pointerInputChange3 == null ? pointerInputChange2 : pointerInputChange3;
    }

    public static final boolean m735isPointerUpDmW0f2w(PointerEvent pointerEvent, long j) {
        PointerInputChange pointerInputChange;
        List<PointerInputChange> changes = pointerEvent.getChanges();
        int size = changes.size();
        boolean z = false;
        int i = 0;
        while (true) {
            if (i >= size) {
                pointerInputChange = null;
                break;
            }
            pointerInputChange = changes.get(i);
            if (PointerId.m5828equalsimpl0(pointerInputChange.getId(), j)) {
                break;
            }
            i++;
        }
        PointerInputChange pointerInputChange2 = pointerInputChange;
        if (pointerInputChange2 != null && pointerInputChange2.getPressed()) {
            z = true;
        }
        return true ^ z;
    }

    public static final float m736pointerSlopE8SPZFQ(ViewConfiguration viewConfiguration, int i) {
        return PointerType.m5919equalsimpl0(i, PointerType.INSTANCE.m5924getMouseT8wyACA()) ? viewConfiguration.getTouchSlop() * mouseToTouchSlopRatio : viewConfiguration.getTouchSlop();
    }

    static {
        float f = Dp.constructor-impl((float) 0.125d);
        mouseSlop = f;
        float f2 = Dp.constructor-impl(18);
        defaultTouchSlop = f2;
        mouseToTouchSlopRatio = f / f2;
    }
}
